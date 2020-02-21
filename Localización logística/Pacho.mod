#Conjuntos
set I; #Conjunto de instalaciones
set J; #Conjunto de clientes

#Parámetros
param C{I,J};#Costo de ir desde la instalación i al cliente j
param F{I}; #Costo de apertura de la instalación i
param D{J}; #Demanda mensual del nodo j dividido por la capacidad del camión

#Variables de decisión
var x{I} binary; #Si se abre la instalación i, 0 DLC
var y{I,J} binary; # Si el punto de demanda j es atendido por la instalación i
var z{I,J} integer; # Número de viajes que realizo desde la instalacion i al cliente j

#Funcion objetivo
minimize Z: sum{i in I}F[i]*x[i] + sum{i in I, j in J}C[i,j]*z[i,j];

#Restricciones
s.t. rest1{i in I,j in J}:y[i,j]<=x[i];
s.t. rest2{j in J}: sum{i in I}y[i,j]=1;
s.t. rest4{i in I,j in J}:z[i,j]>=(D[j]*y[i,j]/10);

solve;
printf: "\n";
printf: "\n";
printf: "\-------------------------------------\n";
printf: "\           SOLUCIÓN DEL EJERCICIO\n";
printf: "\       ------------------------------- \n";
printf: "\n";
printf: "El costo total es: "&Z;
printf: "\n";
printf: "\n";
printf: "\Instalaciones a abrir:\n";
for{i in I:x[i]=1}{
		printf: "Instalación "&i;
		printf: "\n";
}
printf: "\n";
printf: "\Envío a clientes:\n";
for{i in I,j in J:y[i,j]=1}{
		printf: "La instalación "&i&" le envía al cliente "&j;
		printf: "\n";
}
printf: "\-------------------------------------\n";
printf: "\n";
printf: "\n";
printf: "\n";
printf: "\n";
printf: "\n";
printf: "\n";
printf: "\n";




#Datos
data;
set I:=1 2 3 4 5;
set J:=1 2 3 4 5;


param C:	1	2	3	4	5:=
		1	0	5	3	2	1
		2	5	0	8	4	3
		3	6	2	0	4	5
		4	2	7	5	0	3
		5	3	8	6	1	0;

param F:=
1	15
2	18
3	15
4	30
5	24;

param D:=
1	120
2	130
3	150
4	110
5	100;

end;