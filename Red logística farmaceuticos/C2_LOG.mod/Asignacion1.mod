/*CASO 2 DE LOGÍSTICA 2018-3: SEBASTIÁN HERRERA, RICARDO JARA, MARÍA CAMILA RODRÍGUEZ*/

/*Conjuntos*/ 
set CD;
set LAB;
set FAR;
set EPS;
set H;
set CC;
set TM;
set CLI;
set TODOS;
set I;

/*Parámetros*/
param BIN{CD,LAB};
param DEM{CLI,TM};
param CAPAC_PROD{LAB,TM};
param DIST{TODOS,TODOS};

param D{I};

table tabla IN "CSV" "DIST.csv": [a,b], DIST~c;

/*Variables*/
var Sim{I,I};

/*Función objetivo*/
minimize Z:sum{i in I,j in I}Sim[i,j]*DIST[i,j];


/*Restricciones*/ 
s.t. res1{j in I}:sum{i in I}Sim[i,j]=1;
s.t. res2{i in I}:sum{j in I}Sim[i,j]=1;

display DIST;

solve;

data;

set I:= Quimi	CV2	CV3	Oli1	Col2	Col3	Comp1	Comp3	Sura1	Sura2	San1;

set CD:=Disin	Quimi	Phar;
set FAR:=CV1	CV2	CV3	Oli1	Oli2	Oli3	Disf	Audi;
set CC:=Caf1	Caf2	Caf3	Col1	Col2	Col3	Comp1	Comp2	Comp3;
set EPS:=Sura1	Sura2	San1	San2	SV1	SV2	SV3;
set H:=San_F	San_J	JMH	Duit	Nar	Ller	Urib	Mede	Padu;
set TM:= Com  Tab  Cap;
set LAB:=Alc	Occ	Car	Lib	Cal	Fab	Mul	Sab	Boy	Med	Yum	Cart	Iba;
set CLI:=CV1	CV2	CV3	Oli1	Oli2	Oli3	Disf	Audi	Caf1	Caf2	Caf3	Col1	Col2	Col3	Comp1	Comp2	Comp3	Sura1	Sura2	San1	San2	SV1	SV2	SV3	San_F	San_J	JMH	Duit	Nar	Ller	Urib	Med	Padu;
set TODOS:=Disin	Quimi	Phar	Alc	Occ	Car	Lib	Cal	Fab	Mul	Sab	Boy	Med	Yum	Cart	Iba	CV1	CV2	CV3	Oli1	Oli2	Oli3	Disf	Audi	Caf1	Caf2	Caf3	Col1	Col2	Col3	Comp1	Comp2	Comp3	Sura1	Sura2	San1	San2	SV1	SV2	SV3	San_F	San_J	JMH	Duit	Nar	Ller	Urib	Mede	Padu;

param D:=
Quimi	0
CV2	76.9
CV3	73
Oli1	63.2
Col2	72.9
Col3	68.6
Comp1	71.2
Comp3	90.1
Sura1	61.2
Sura2	68.9
San1	63.4;



end;