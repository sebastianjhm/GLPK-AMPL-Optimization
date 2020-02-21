#CASO 2

#CONJUNTOS 
set I; #Materia a inscribir
set J; #Semestre
set REQ {i in I};

#SUBCONJUNTOS DE REQUISITOS POR CADA MATERIA



#PARÁMETRO
param C {i in I}; #Número de créditos en cada materia 

#TABLAS
table TABLA IN "CSV" "materias.csv": I <- [materias]; #tabla de materias a inscribir 
table TABLA IN "CSV" "semestres.csv": J <- [semestre]; #tabla de semestres
table TABLA IN "CSV" "creditos.csv":[materias], C~cred; #tabla de numero de créditos para cada materia




#VARIABLES
var x{i in I,j in J} binary ; #1 si se inscribe la materia I en el semestre J, o D.L.C.
var w {i in I, j in J} binary; #1 si cumple con los requisitos para ver la materia I en el semestre J, o D.L.C-
var y {j in J} binary; #1 si inscribe el semestre J, o D.L.C. 
var e {j in J} binary; #1 si el semesre J se esxtracredita, o D.L.C.
var z {j in J} binary; #1 si en el semestre J se cursaron mas de 120 creditos
var max ;

#F.O.
minimize Z: max;


#RESTRICCIONES

#solo puede ver una única vez esa materia
s.t. materia1 {i in I}: sum{j in J}x[i,j]=1;

#Si se vio al menos una materia en ese semestre, se está cursando el semestre
s.t. relacionvari1 {j in J}: y[j]>=(sum{i in I} x[i,j])/100; #fuerza a 1
s.t. relacionvari0 {j in J}: y[j]<=(sum{i in I}x[i,j]); #fuerza a 0

#Solo es posible cursar ética o fe y compromiso únicamente si solo se cuenta con más de 120 créditos aprobados
s.t. eticayfe0 {j in J}: z[j]<=((sum{l in J, i in I: l<j}x[i,l]*C[i])+79)/120; #fuerza a 0
s.t. eticayfe1 {j in J}: 1000*z[j]+120*(1-z[j])>=((sum{l in J, i in I: l<j}x[i,l]*C[i])+79);

#Requisitos para poder cursar la asignatura en el semestre en el que se encuentra 
s.t. requicitos1 {l in J, i in I}: (card(REQ[i]))*w[i,l]<=sum{j in J, m in REQ[i]}x[m,j]; #forzar 1
s.t. requicitos0 {l in J, i in I}: 1000*w[i,l]+(card(REQ[i])-1)*(1-w[i,l])>=sum{j in J,m in REQ[i]}x[m,j]; #forzar 0 

#si cumple con los requisitos anteriores entonces puede ver la materia
s.t. requicitos3 {i in I, l in J}: x[i,l]<= w[i,l]; #forzar 0

#si inscribe opti en ese semestre, entonces no inscribo inferencia
s.t. optiinfe {j in J}: x[2,j]<=1-x[6,j];

#si inscribe trabajo de grado, entonces NO inscribe práctica
s.t. trabapracti {j in J}: x[31,j]<=1-x[32,j];

#materias que desea ver juntas, simulación e ingepro
s.t. simuingepro {j in J}: x[7,j]=x[12,j];

#semestres que decide extracreditarse, máximo 2
s.t. extracredi: sum{j in J}e[j]<=2;
s.t. extracredi1 {j in J}: 21*e[j]<=sum{i in I}x[i,j]*C[i];
s.t. maxicredi {j in J}: 1000*e[j]+20*(1-e[j])>=sum{i in I}x[i,j]*C[i];

#máximo 20 o 21 créditos por semestre
s.t. res2{j in J}: sum{i in I}x[i,j]*C[i]<=20*(1-e[j])+21*e[j];

#Máximo
s.t. maximo {j in J}: max>= y[j]*j;
solve;

printf: "\n";
printf: "\n";
printf: "\n";
for{j in J}{
printf: "\Las materias que debe inscribir en semestre "&j&" son: \n";
	for {i in I: x[i,j]<>0}{
		printf: "Materia "&i&"\n";
}
printf: "\n";
}
data;

set REQ[1]:=; #Electricidad
set REQ[2]:=; #Inferencia
set REQ[3]:=1;#Factores
set REQ[4]:=1;#Máquinas
set REQ[5]:=9;#Sistemas de costeo
set REQ[6]:=;#Optimización
set REQ[7]:=9,2;#Simulación
set REQ[8]:=2,9;#Gestion de calidad
set REQ[9]:=3;#Procesos
set REQ[10]:=;#Principios de economia
set REQ[11]:=;#Diseño salarial
set REQ[12]:=9,2;#Ingepro
set REQ[13]:=10;#Ingeco
set REQ[14]:=;#Epistemología
set REQ[15]:=;#Fe y compromiso
set REQ[16]:=2,10;#Logistica de mercados
set REQ[17]:=6,16;#Logística
set REQ[18]:=6, 12;#Producción
set REQ[19]:=12,15,13,11,16;#Proyecto social
set REQ[20]:=;#Ética en la ing
set REQ[21]:=9;#Admon sistemas de info
set REQ[22]:=10,5,16;#Preparacion evaluacion de proyectos
set REQ[23]:=11;#Gerencia
set REQ[24]:=17;#Gestion de la cadena
set REQ[25]:=17;#Distribucion y transporte
set REQ[26]:=17;#Proyectos de mercadeo
set REQ[27]:=2,6;#Optimizacion de operaciones
set REQ[28]:=2;#Diseño de experimentos
set REQ[29]:=;#Estocásticos
set REQ[30]:=;#Teoria de juegos
set REQ[31]:=12,6;#Practica
set REQ[32]:=33;#Trabajo de grado
set REQ[33]:=12; #Proyecto de grado





end;
