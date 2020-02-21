/*CASO 1 DE LOGÍSTICA 2018-3: SEBASTIÁN HERRERA, RICARDO JARA, MARÍA CAMILA RODRÍGUEZ*/

/*CONJUNTOS*/
set MI;/*Puertos de mercancía importada = {Car,Bue}*/
set PL;/*Proveedores locales = {Dis,Qui,Alc,Rep}*/
set CD;/*Tipos de centro de distribución = {1,2}*/
set PA;/*Principios activos = {Ana,Ant,Ane}*/
set LAB;/*Laboratorios farmacéuticos = { Yum,Car,Iba}*/
set TM;/*Tipos de medicamentos = {Com,Tab,Cap}*/
set CM;/*Centrales de mezcla = {Env}*/
set H;/*Hospitales = {SanF,UnivSJ,}*/
set EPS;/*EPS = {Sal,Aud}*/
set CCF;/*Cajas de compensación y farmacias  = {Caf,Dis,Cru,}*/
set OP;/*Operadores de disposición final = {Azu}*/
set CAM;/*Tipos de camión = {A,B,C}*/
set K;/*Zonas de almacenamiento de los centros de distribución = {PaE,Med,MedB}*/
set PUNTOS;/*Puntos geográficos de la red de distribución*/

set I;/*MI U PL*/
set J;/*PA U {Exci}*/
set Q;/*TM U J U {MedBio}*/
set R;/*TM U {MedBio}*/
set S;/*EPS U CCF*/
set U;/*Q U {MedVen}*/


/*PARÁMETROS*/
param Cost_Pen{pl in PL};/*Costo de penalización mensual por no realizar la apertura del centro de distribución en la   ubicación del proveedor local p in PL ($/mes) */
param Cost_OP{cd in CD,pl in PL};/*Costo de operación mensual del centro de distribución cd in CD en ubicación pl in PL ($/mes)*/
param Cost_Prod{tm in TM,lab in LAB};/*Costo de producción de 1 kg de medicamento tm in TM en el laboratorio lab in LAB ($/kg)*/
param SI_LAB_FAB{tm in TM,lab in LAB};/*1 si lab in LAB fabrica el tipo de medicamento tm in TM ;0 dlc*/        
param Cost_Emp{p in PL,q in Q,cd in CD};/*Costo de empacar un  kg de q in Q en la ubicación pl?PL donde se instalará el cento de    distribución cd in CD ($/kg y $/l)*/
param Cost_Dest{op in OP};/*Costo de destrucción de 1 kg de medicamento en el operador de disposición op in OP ($/kg)*/
param Cost_Trans{u in U, cam in CAM};/*Costo de transportar la mercancia tipo u in U en el camión tipo cam in CAM ($/(km*kg))*/ 
param Cost_Viaje{cam in CAM};/*Costo de transportar mercancia en el camión tipo cam in CAM ($/(km*viaje))*/
param Cap_Lab{lab in LAB};/*:Capacidad total de recepción de materia prima del laboratorio lab in LAB (kg)*/
param Cap_CD{cd in CD, k in K};/*Capacidad de almacenamiento del centro de distribución cd in CD en la zona k in K (kg y l)*/
param Cap_CAM{cam in CAM};/*Capacidad del camión tipo cam in CAM (kg y l)*/
param Of{i in I,j in J};/* Capacidad de oferta mensual del proveedor i in I de materia prima j in J (kg/mes)*/
param CapRecOp:=1500;/*Capacidad de recepción de medicamentos de los operadores*/
param OfMB:=1200;/*Capacidad de oferta mensual del proveedor de medicamentos biológicos*/
param Dem_CM{j in J, cm in CM};/*Demanda de la materia prima tipo j in J mensual de la central de mezcla cm in CM (kg)*/
param Dem_H{h in H,r in R};/*Demanda del medicamento tipo r in R mensual del hospital h in H (kg y l)*/
param Dem_EPS_CCF{tm in TM,s in S};/*Demanda el medicamento tm in TM mensual del cliente mayorista s in S  (kg) */
param Req_Med{j in J,tm in TM,lab in LAB};/*Requerimiento de tipo materia prima j in J para producir 1  kg de medicamento tm in TM en el laboratorio lab  in LAB (kg)*/
param Dist{p1 in PUNTOS,p2 in PUNTOS};/*Distancia del punto 1 al punto 2*/

table tabla IN "CSV" "Dist.csv": [a,b], Dist~c;


/*VARIABLES*/
/*Variables globales*/
var x{CD,PL}, binary;
var z_PUNTO{PL}, binary;

/*Centrales de mezcla*/
var y_CM{PL,CM}>=0;
var t_CM{PL,J,CD}>=0;
var z_CM{PL,CM}, binary;
var w_CM{PL,CM,J}>=0;

/*eps y ccf*/
var y_ECF{PL,S}>=0;
var t_ECF{PL,TM,CD}>=0;
var z_ECF{PL,S}, binary;
var w_ECF{PL,S,TM}>=0;
var v_ECF{S,PL}>=0;

/*Hospitales*/
var y_H{PL,H}>=0;
var t_H{PL,R,CD}>=0;
var z_H{PL,H}, binary;
var w_H{PL,H,R}>=0;

/*Laboratorios*/
var y_LAB{PL,LAB}>=0;
var z_LAB{PL,LAB}, binary;
var w_LAB{PL,LAB,J}>=0;
var v_LAB{LAB,PL,TM}>=0;

/*Operadores*/
var y_OP{PL,OP}>=0;
var z_OP{PL,OP}, binary;

/*Proovedores*/
var y_PL{I,PL}>=0;
var z_PL{I,PL}, binary;
var w_PL{I,PL,J}>=0;

/*Avión-Medicamentos Biológicos*/
var y_BIO{PL}>=0;

/*Número de viajes*/
var n_CM{PL,CM,J}>=0, integer;
var n_LAB{PL,LAB,J}>=0, integer;
var n_PL{I,PL,J}>=0, integer;
var n_LAB_PL{LAB,PL,TM}>=0, integer;
var n_H{PL,H,TM}>=0, integer;
var n_ECF{PL,S,TM}>=0, integer;
var n_MedBio{PL,H}>=0, integer;
var n_Aer{PL}>=0, integer;
var n_Dest_ECF{S,PL}>=0, integer;
var n_OP{PL,OP}>=0, integer;

/*Costos*/
var Costo_Penalizacion,>=0;
var Costo_Operacion,>=0;
var Costo_Produccion,>=0;
var Costo_Empaquetamiento,>=0;
var Costo_Destruccion,>=0;
var Costo_de_Transporte,>=0;
var Costo_de_Viaje,>=0;

/*FUNCIÓN OBJETIVO*/
minimize FO:Costo_Penalizacion+Costo_Operacion+Costo_Produccion+Costo_Empaquetamiento+Costo_Destruccion+Costo_de_Transporte+Costo_de_Viaje;


/*RESTRICCIONES*/
/*Restricciones globales*/
s.t. res1: sum{p in PL,cd in CD}x[cd,p]>=1; 
s.t. res2{p in PL}: sum{cd in CD}x[cd,p]<=1; 
s.t. res3{p in PL}: z_PUNTO[p]=sum{cd in CD}x[cd,p]; 

/*Restricciones Centrales de mezcla*/
s.t. res4{p in PL,cm in CM}: z_CM[p,cm]<=sum{cd in CD}x[cd,p];
s.t. res5{p in PL,cm in CM}: y_CM[p,cm]<=1000000*z_CM[p,cm]; 
s.t. res6{p in PL,cm in CM}: sum{j in J}w_CM[p,cm,j]=y_CM[p,cm]; 
s.t. res7{cm in CM}: sum{p in PL}z_CM[p,cm]=1; 
s.t. res8{j in J,cm in CM}: sum{p in PL}w_CM[p,cm,j]>=Dem_CM[j,cm];
s.t. res9{p in PL,j in J,cd in CD}:t_CM[p,j,cd]<=1000000*x[cd,p];
s.t. res10{p in PL,j in J}:sum{cd in CD}t_CM[p,j,cd]=sum{cm in CM}w_CM[p,cm,j];

/*Restricciones eps y ccf*/
s.t. res11{p in PL,s in S}: z_ECF[p,s]<=sum{cd in CD}x[cd,p]; 
s.t. res12{p in PL,s in S}: y_ECF[p,s]<=1000000*z_ECF[p,s]; 
s.t. res13{p in PL,s in S}: sum{tm in TM}w_ECF[p,s,tm]=y_ECF[p,s]; 
s.t. res14{s in S}: sum{p in PL}z_ECF[p,s]=1; 
s.t. res15{tm in TM,s in S}: sum{p in PL}w_ECF[p,s,tm]>=Dem_EPS_CCF[tm,s];
s.t. res16{p in PL,s in S}: v_ECF[s,p]=0.06*y_ECF[p,s];
s.t. res17{p in PL,tm in TM,cd in CD}:t_ECF[p,tm,cd]<=1000000*x[cd,p];
s.t. res18{p in PL,tm in TM}:sum{cd in CD}t_ECF[p,tm,cd]=sum{s in S}w_ECF[p,s,tm];

/*Restricciones Hospitales*/
s.t. res19{p in PL,h in H}: z_H[p,h]<=sum{cd in CD}x[cd,p]; 
s.t. res20{p in PL,h in H}: y_H[p,h]<=1000000*z_H[p,h];
s.t. res21{p in PL,h in H}: sum{r in R}w_H[p,h,r]=y_H[p,h]; 
s.t. res22{h in H}: sum{p in PL}z_H[p,h]=1; 
s.t. res23{r in R,h in H}: sum{p in PL}w_H[p,h,r]>=Dem_H[h,r]; 
s.t. res24{p in PL,r in R,cd in CD}:t_H[p,r,cd]<=1000000*x[cd,p];
s.t. res25{p in PL,r in R}:sum{cd in CD}t_H[p,r,cd]=sum{h in H}w_H[p,h,r];

/*Restricciones Laboratorios*/
s.t. res26{p in PL,lab in LAB}: z_LAB[p,lab]<=sum{cd in CD}x[cd,p];
s.t. res27{p in PL,lab in LAB}: y_LAB[p,lab]<=1000000*z_LAB[p,lab];
s.t. res28{lab in LAB}: sum{p in PL}z_LAB[p,lab]>=1;
s.t. res29{p in PL,lab in LAB}: sum{j in J}w_LAB[p,lab,j]=y_LAB[p,lab];
s.t. res30{p in PL,lab in LAB}: sum{j in J}w_LAB[p,lab,j]=sum{tm in TM}v_LAB[lab,p,tm];
s.t. res31{p in PL}: sum{h in H,tm in TM}w_H[p,h,tm]+sum{tm in TM,s in S}w_ECF[p,s,tm]=sum{lab in LAB,tm in TM}v_LAB[lab,p,tm];
s.t. res32{p in PL,lab in LAB,tm in TM}:v_LAB[lab,p,tm]<=1000000*SI_LAB_FAB[tm,lab];
s.t. res33{p in PL,lab in LAB,j in J}: w_LAB[p,lab,j]=sum{tm in TM}Req_Med[j,tm,lab]*v_LAB[lab,p,tm];
s.t. res34{lab in LAB}: sum{p in PL}y_LAB[p,lab]<=Cap_Lab[lab];

/*Restricciones Proovedores*/
s.t. res35{i in I,p in PL}: z_PL[i,p]<=sum{cd in CD}x[cd,p];
s.t. res36{i in I,p in PL}: y_PL[i,p]<=1000000*z_PL[i,p];
s.t. res37{i in I,p in PL}: sum{j in J}w_PL[i,p,j]=y_PL[i,p];
s.t. res38{pl in PL}: sum{p in PL}z_PL[pl,p]<=1;
s.t. res39{i in I,j in J}: sum{p in PL}w_PL[i,p,j]<=Of[i,j];
s.t. res40{p in PL}: sum{i in I,j in J}w_PL[i,p,j]=sum{j in J,lab in LAB}w_LAB[p,lab,j]+sum{j in J,cm in CM}w_CM[p,cm,j];

/*Restricciones Avión-Medicamentos Biológicos*/
s.t. res41: sum{p in PL}y_BIO[p]<=OfMB;
s.t. res42{p in PL}: y_BIO[p]=sum{h in H}w_H[p,h,"MedBio"];

/*Restricciones Operadores de disposición final*/
s.t. res43{p in PL,op in OP}:z_OP[p,op]<=sum{cd in CD}x[cd,p];
s.t. res44{p in PL,op in OP}:y_OP[p,op]<=1000000*z_OP[p,op];
s.t. res45{p in PL}:sum{op in OP}z_OP[p,op]<=1;
s.t. res46{op in OP}:sum{p in PL}y_OP[p,op]<=CapRecOp;
s.t. res47{p in PL}:sum{s in S}v_ECF[s,p]=sum{op in OP}y_OP[p,op];

/*Restricciones Capacidad Centro de Distribución*/
s.t. res48{p in PL}: sum{i in I}y_PL[i,p]<=sum{cd in CD}Cap_CD[cd,"PaE"]*x[cd,p];
s.t. res49{p in PL}: sum{tm in TM,lab in LAB}v_LAB[lab,p,tm]+sum{s in S}v_ECF[s,p]<=sum{cd in CD}Cap_CD[cd,"Med"]*x[cd,p];
s.t. res50{p in PL}:y_BIO[p]<=sum{cd in CD}Cap_CD[cd,"MedB"]*x[cd,p];

/*Restricciones de número de viajes*/
s.t. res51{p in PL,cm in CM,j in J}:n_CM[p,cm,j]>=w_CM[p,cm,j]/1200;
s.t. res52{p in PL,lab in LAB,j in J}:n_LAB[p,lab,j]>=w_LAB[p,lab,j]/1200;
s.t. res53{p in PL,i in I,j in J}:n_PL[i,p,j]>=w_PL[i,p,j]/1200;
s.t. res54{lab in LAB,p in PL,tm in TM}:n_LAB_PL[lab,p,tm]>=v_LAB[lab,p,tm]/1200;
s.t. res55{p in PL,h in H,tm in TM}:n_H[p,h,tm]>=w_H[p,h,tm]/1200;
s.t. res56{p in PL,s in S,tm in TM}:n_ECF[p,s,tm]>=w_ECF[p,s,tm]/1200;
s.t. res57{p in PL,h in H}:n_MedBio[p,h]>=w_H[p,h,"MedBio"]/450;
s.t. res58{p in PL}:n_Aer[p]>=y_BIO[p]/450;
s.t. res59{s in S,p in PL}:n_Dest_ECF[s,p]>=v_ECF[s,p]/200;
s.t. res60{p in PL,op in OP}:n_OP[p,op]>=y_OP[p,op]/200;

/*Restricciones Costos Función Onjetivo*/
s.t. res61:Costo_Penalizacion=sum{p in PL}(1-z_PUNTO[p])*Cost_Pen[p];
s.t. res62:Costo_Operacion=sum{p in PL,cd in CD}x[cd,p]*Cost_OP[cd,p];
s.t. res63:Costo_Produccion=sum{p in PL,tm in TM,lab  in LAB}Cost_Prod[tm,lab]*v_LAB[lab,p,tm];
s.t. res64:Costo_Empaquetamiento=sum{p in PL,j in J,cd in CD}Cost_Emp[p,j,cd]*t_CM[p,j,cd]+sum{p in PL,tm in TM,cd in CD}Cost_Emp[p,tm,cd]*t_ECF[p,tm,cd]+sum{p in PL,r in R,cd in CD}Cost_Emp[p,r,cd]*t_H[p,r,cd];
s.t. res65:Costo_Destruccion=sum{p in PL,op in OP}y_OP[p,op]*Cost_Dest[op];
s.t. res66:Costo_de_Transporte=sum{p in PL,cm in CM,j in J}w_CM[p,cm,j]*25*Dist[p,cm]+sum{p in PL,lab in LAB,j in J}w_LAB[p,lab,j]*25*Dist[p,lab]+sum{p in PL,i in I,j in J}w_PL[i,p,j]*25*Dist[i,p]+sum{p in PL,lab in LAB,tm in TM}v_LAB[lab,p,tm]*35*Dist[lab,p]+sum{p in PL,h in H,tm in TM}w_H[p,h,tm]*35*Dist[p,h]+sum{p in PL,s in S,tm in TM}w_ECF[p,s,tm]*35*Dist[p,s]+sum{p in PL,h in H}w_H[p,h,"MedBio"]*55*Dist[p,h]+sum{p in PL}y_BIO[p]*55*Dist["Aer",p]+sum{p in PL,s in S}v_ECF[s,p]*20*Dist[s,p]+sum{p in PL,op in OP}y_OP[p,op]*20*Dist[p,op];
s.t. res67:Costo_de_Viaje=sum{p in PL,cm in CM,j in J}n_CM[p,cm,j]*25*Dist[p,cm]+sum{p in PL,lab in LAB,j in J}n_LAB[p,lab,j]*25*Dist[p,lab]+sum{p in PL,i in I,j in J}n_PL[i,p,j]*25*Dist[i,p]+sum{p in PL,lab in LAB,tm in TM}n_LAB_PL[lab,p,tm]*35*Dist[lab,p]+sum{p in PL,h in H,tm in TM}n_H[p,h,tm]*35*Dist[p,h]+sum{p in PL,s in S,tm in TM}n_ECF[p,s,tm]*35*Dist[p,s]+sum{p in PL,h in H}n_MedBio[p,h]*55*Dist[p,h]+sum{p in PL}n_Aer[p]*55*Dist["Aer",p]+sum{p in PL,s in S}n_Dest_ECF[s,p]*20*Dist[s,p]+sum{p in PL,op in OP}n_OP[p,op]*20*Dist[p,op];

solve;
data;

set MI:= Cart  Bue;
set PL:= Dis  Qui  Alc  Rep  Pha  Far  Pas  Lab  Fab  Mul;
set CD:= 1  2;
set PA:= Ana  Ant  Ane;
set LAB:= Tun  Med  Yum  Car  Iba;
set TM:= Com  Tab  Cap;
set CM:= Env  Bog  Hui;
set H:= SanF  UnivSJ  JosM  RegD  UnivDN  Fed;
set EPS:= San  SurR  SurP  Com  Sal  Aud;
set CCF:= OliM  Caf  Disf  Cru  Col  OliB;
set OP:= Azu  Eco  Pro;
set CAM:= A  B  C;
set K:= PaE  Med  MedB;
set Puntos:=Cart  Bue  Dis  Qui  Alc  Rep  Pha  Far  Pas  Lab  Fab  Mul  Aer  Tun  Med  Yum  Car  Iba  OliM  Caf  Disf  Cru  Col  OliB  San  SurR  SurP  Com  Sal  Aud  SanF  UnivSJ  JosM  RegD  UnivDN  Fed  Env  Bog  Hui  Azu  Eco  Pro;

 
set I:= Cart  Bue  Dis  Qui  Alc  Rep  Pha  Far  Pas  Lab  Fab  Mul;
set J:= Ana  Ant  Ane   Exci;
set Q:= Com  Tab  Cap  Ana  Ant  Ane  Exci  MedBio;
set R:= Com  Tab  Cap  MedBio;
set S:= San  SurR  SurP  Com  Sal  Aud  OliM  Caf  Disf  Cru  Col  OliB;
set U:= Com  Tab  Cap  Ana  Ant  Ane  Exci  MedBio MedVen;

param Cost_Pen:=
Dis	12266295
Qui	10493878
Alc	12242672
Rep	11830958
Pha	14729899
Far	12580394
Pas	13013375
Lab	10361932
Fab	14180021
Mul	14803576;

param Cost_OP:	Dis	Qui	Alc	Rep	Pha	Far	Pas	Lab	Fab	Mul:=
1	121900300	112453287	124353698	134098734	115987374	119145087	129249851	117832418	125423971	122362165
2	231610570	179925259	223836656	241377721	185579798	214461157	206799762	223881594	213220751	208015681;

param Cost_Prod:	Tun	Med	Yum	Car	Iba:=
Com	850	1000000	880	900	730
Tab	960	750	1000000	780	680
Cap	1000000	820	670	690	975;

param Si_LAB_FAB:	Tun	Med	Yum	Car	Iba:=
Com	1	0	1	1	1
Tab	1	1	0	1	1
Cap	0	1	1	1	1;
 
param Req_Med:=
	[*,*,Tun]:	Com	Tab	Cap:=
		Exci	0.8	0.45	0
		Ana	0.2	0.35	0
		Ant	0	0.2	0
		Ane	0	0	0
	[*,*,Med]:	Com	Tab	Cap:=
		Exci	0	0.5	0.5
		Ana	0	0.3	0
		Ant	0	0.2	0.3
		Ane	0	0	0.2
	[*,*,Yum]:	Com	Tab	Cap:=
		Exci	0.55	0	0.6
		Ana	0.45	0	0
		Ant	0	0	0.25
		Ane	0	0	0.15
	[*,*,Car]:	Com	Tab	Cap:=
		Exci	0.6	0.7	0.6
		Ana	0.4	0.2	0
		Ant	0	0.1	0.3
		Ane	0	0	0.1
	[*,*,Iba]:	Com	Tab	Cap:=
		Exci	0.7	0.6	0.55
		Ana	0.3	0.3	0
		Ant	0	0.1	0.35
		Ane	0	0	0.1;

param Costo_Emp:=
	[*,*,1]:	Com  	Tab	Cap	Ana	Ant	Ane	Exci	MedBio:=
			Dis	250	250	280	210	210	210	210	600
			Qui	320	320	350	260	260	260	260	624
			Alc	210	210	260	252	252	252	252	507
			Rep	180	180	210	196	196	196	196	540
			Pha	190	190	230	140	140	140	140	560
			Far	205	205	250	175	175	175	175	611
			Pas	300	300	340	154	154	154	154	510
			Lab	225	225	270	169	169	169	169	532
			Fab	195	195	325	160	160	160	160	533
			Mul	265	265	300	260	260	260	260	498
	[*,*,2]:	Com  	Tab	Cap	Ana	Ant	Ane	Exci	MedBio:=
			Dis	175	175	224	150	150	150	150	500
			Qui	256	256	280	200	200	200	200	480
			Alc	147	147	208	210	210	210	210	390
			Rep	126	126	168	140	140	140	140	450
			Pha	152	152	161	100	100	100	100	400
			Far	144	144	175	135	135	135	135	470
			Pas	240	240	204	110	110	110	110	425
			Lab	158	158	189	130	130	130	130	380
			Fab	176	176	260	125	125	125	125	410
			Mul	165	165	180	200	200	200	200	415;

param Cost_Dest:=
Azu	2300
Eco	3200
Pro	2750;

param Cost_Trans:	A	B	C:=
			Com  	35	0	0
			Tab	35	0	0
			Cap	35	0	0
			Ana	25	0	0
			Ant	25	0	0
			Ane	25	0	0
			Exci	25	0	0
			MedBio	0	55	0
			MedVen	0	0	20;

param Costo_viaje:=
A	100
B	180
C	80;

param Cap_Lab:=
Tun	15000
Med	16000
Yum	12000
Car	13000
Iba	11000;


param Cap_CD:	PaE	Med	MedB:=
			1	15.000	12.000	800
			2	25.000	20.000	1.500;

param Cap_CAM:=
A	1200
B	450
C	200;


param Of:	Ana	Ant	Ane	Exci:=
Cart	5600	3200	0	0
Bue	6500	3300	0	0
Dis	4920	2160	1000	100
Qui	5928	2280	1030	120
Alc	4524	2520	1200	150
Rep	3840	2760	1340	160
Pha	5460	3480	920	95
Far	3540	2220	950	130
Pas	4212	3000	830	156
Lab	4836	2880	730	160
Fab	5382	2040	1200	230
Mul	5616	3360	1100	145;


param Dem_CM:	Env	Bog 	Hui:=
Ana	1300	1800	2300
Ant	1250	2400	1500
Ane	0	0	0
Exci	2500	2750	2100;


param Dem_H:	Com	Tab	Cap	MedBio:=
SanF	1100	410	600	150
UnivSJ	1200	680	470	200
JosM	890	560	450	350
RegD	1300	470	700	120
UnivDN	1400	100	350	100
Fed	800	340	200	280;

param Dem_EPS_CCF:	San	SurR	SurP	Com	Sal	Aud	OliM	Caf	Disf	Cru	Col	OliB:=
Com	2.100	3.200	2.400	3.450	2.800	1.850	2.100	3.200	2.400	3.450	2.800	1.850
Tab	650	320	430	570	280	150	1.300	640	860	1.140	3.100	2.200
Cap	100	85	190	210	145	180	200	170	380	420	290	360;


