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

/*Parámetros*/
param BIN{CD,LAB};
param DEM{CLI,TM};
param CAPAC_PROD{LAB,TM};

/*Variables*/
var x{CD,CLI},binary;
var w;

/*Función objetivo*/
maximize Z:sum{cd in CD, cli in CLI}x[cd,cli]; 

/*Restricciones*/ 
s.t. res1{cd in CD,tm in TM}:sum{cli in CLI}x[cd,cli]*DEM[cli,tm]<=sum{lab in LAB}CAPAC_PROD[lab,tm]*BIN[cd,lab];
s.t. res2{cd in CD,tm in TM}:w>=(sum{lab in LAB}CAPAC_PROD[lab,tm]*BIN[cd,lab])-(sum{cli in CLI}x[cd,cli]*DEM[cli,tm]);
s.t. res3{cli in CLI}:sum{cd in CD}x[cd,cli]<=1;


solve;

printf: "\n";
printf: "\n";
printf: "\n";
for{j in CD}{
printf: "\."&j&" son: \n";
	for {i in CLI: x[j,i]<>0}{
		printf: "Materia "&i&"\n";
}
printf: "\n";
}
data;


set CD:=Disin	Quimi	Phar;
set FAR:=CV1	CV2	CV3	Oli1	Oli2	Oli3	Disf	Audi;
set CC:=Caf1	Caf2	Caf3	Col1	Col2	Col3	Comp1	Comp2	Comp3;
set EPS:=Sura1	Sura2	San1	San2	SV1	SV2	SV3;
set H:=San_F	San_J	JMH	Duit	Nar	Ller	Urib	Med	Padu;
set TM:= Com  Tab  Cap;
set LAB:=Alc	Occ	Car	Lib	Cal	Fab	Mul	Sab	Boy	Med	Yum	Cart	Iba;

set CLI:=CV1	CV2	CV3	Oli1	Oli2	Oli3	Disf	Audi	Caf1	Caf2	Caf3	Col1	Col2	Col3	Comp1	Comp2	Comp3	Sura1	Sura2	San1	San2	SV1	SV2	SV3	San_F	San_J	JMH	Duit	Nar	Ller	Urib	Med	Padu;

param BIN:	Alc	Occ	Car	Lib	Cal	Fab	Mul	Sab	Boy	Med	Yum	Cart	Iba:=
Disin	0	0	1	1	1	0	0	0	0	1	0	0	0
Quimi	0	1	0	0	0	1	0	0	0	0	1	1	0
Phar	1	0	0	0	0	0	1	1	1	0	0	0	1;

param DEM:	Com	Tab	Cap:=
CV1	52.9	71	99.4
CV2	76.9	79.8	100.7
CV3	73	75.4	53.9
Oli1	63.2	85.6	52.8
Oli2	67.3	80.9	86.9
Oli3	82.1	95.1	94.4
Disf	96.3	84.1	80.6
Audi	64.3	85.1	68.2
Caf1	88.6	78.9	58.8
Caf2	51.2	64.2	71.9
Caf3	58.8	57.3	92.8
Col1	70.6	51.9	76.3
Col2	72.9	80.6	58.2
Col3	68.6	77.8	98.1
Comp1	71.2	62.9	83
Comp2	87.2	72.2	96.6
Comp3	90.1	92.3	77.7
Sura1	61.2	81.6	59.4
Sura2	68.9	68.7	79.3
San1	63.4	74.5	98.5
San2	80.1	52.7	79.6
SV1	54.2	70.3	69.2
SV2	99.9	68.4	78.1
SV3	93.5	90.2	74
San_F	81.8	91.1	60.9
San_J	76.8	78.3	96.6
JMH	64.3	61.6	77.5
Duit	92.3	62.8	61.8
Nar	61.8	92.8	69
Ller	50.8	68.9	89.8
Urib	81.6	75.7	71.5
Med	68.8	72.9	74.1
Padu	69.8	80.1	74.1;

param CAPAC_PROD:	Com	Tab	Cap:=
Alc	203	208	222
Occ	230	226	239
Car	186	165	184
Lib	169	210	193
Cal	210	213	249
Fab	184	227	126
Mul	162	137	230
Sab	186	182	148
Boy	205	139	125
Med	212	162	247
Yum	199	229	249
Cart	160	223	219
Iba	162	230	178;

end;