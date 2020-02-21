/*CASO 1 DE LOGÍSTICA 2019-1*/

/*CONJUNTOS*/
set P_ENV;/*Proveedores de Envase = {Iber,Crow,Tre}*/
set P_CO2;/*Proveedores de CO2 = {Barr,Mani,Toca}*/
set P_JAR;/*Proveedores de Jarabe = {Prol,Dole,Provi}*/
set PE;/*Potenciales Plantas Embotelladoras = {Hip,Boya,Con}*/
set CD;/*Centros de Distribución = {Ita,Sinc,Iba}*/
set RES;/*Clientes Restaurantes = {CBC_Bog,CBC_Cal}*/
set MAY;/*Clientes Mayoristas= {CEDI_Bog,Oli_Mont,Oli_Barr,Jum_Buca}*/
set CLI;/*Clientes = {CBC_Bog,CBC_Cal,CEDI_Bog,Oli_Mont,Oli_Barr,Jum_Buca}*/
set TP;/*Tipo de Planta = {1,2}*/
set INSU;/*Insumos = {Env,Jar,CO2}*/
set MAT_PRIMA;/*Materias Primas = {Agua,Jar,CO2}*/
set ENV;/*Tipos de Envase = {Plas,Lat,Vid}*/
set TOL;/*Tolerancias de fórmula = {Mini,Id,Maxi}*/
set NODOS;/*Nodos de Distancia = {Iber,Crow,Tre,Barr,Mani,Toca,Prol,Dole,Provi,Hip,Boya,Con,Ita,Sinc,Iba,CBC_Bog,CBC_Cal,CEDI_Bog,Oli_Mont,Oli_Barr,Jum_Buca}*/

/*PARÁMETROS*/
param Of_Env{P_ENV,ENV};/*Capacidad de Oferta de Proveedor de Envases (Estibas)*/
param Of_TanCO2{P_CO2};/*Capacidad de Oferta de CO2 (Tanques de 600lt)*/
param Of_JAR{P_JAR};/*Capacidad de Oferta de Proveedor de Jarabe (Tanques de 500lt)*/
param Capac_PEMB{INSU,TP};/*Capacidad de recepción de cada tipo de planta*/
param Capac_CD{CD};/*Capacidad en Estibas totales de un Centro de Distribución(Unidades)*/
param Capac_ENV{ENV};/*Capacida de cada tipo de Envase (ml)*/
param Cant_CAJ_EST{ENV};/*Cantidad de cajas que caben en una Estiba (unidades)*/
param Cant_ENV_CAJ:=24;/*Cantidad de Envases que caben en una caja(unidades)*/
param Porc{MAT_PRIMA,TOL};/*Porcentaje de Materia Prima en la Gaseosa*/
param Costo_ENV{P_ENV,ENV};/*Costo de un envase ($/Estiba)*/
param Costo_TanCO2{P_CO2};/*Costo de un tanque de 600lt ($/Tanque 600lt)*/
param Costo_JAR{P_JAR};/*Costo de un tanque de 500lt ($/Tanque 500lt)*/
param Costo_AGUA{PE,TP};/*Costo de Litro de Agua($/lt)*/
param Costo_PROC{PE,TP};/*Costo de Procesamiento de un litro de gaseosa($/lt de gaseosa)*/
param Costo_F_PLAN{PE,TP};/*Costo fijo mensual de la planta($)*/
param Costo_PEN{PE};/*Costo de Penalización ppor no abrir la planta($)*/
param Costo_LIM_VID{PE};/*Costo de limpiar una botella en una planta($/botella)*/
param Costo_F_CD{CD};/*Costo fijo de mantener el Centro de Distribución($)*/
param Costo_PICK{CD,ENV};/*Costo de Picking de las cajas  de un producto($/Paquete de Gasesosa)*/
param DEMANDA{CLI,ENV};/*Demanda de cada cliente en cajas(unidades de cajas)*/
param Dev_RES{res in RES}:=round(0.8*DEMANDA[res,"Vid"]);/*Cantidad de botellas de vidrio devueltas por restaurantes (unidades)*/
param Dev_MAY{may in MAY}:=round(0.3*DEMANDA[may,"Vid"]);/*Cantidad de botellas de vidrio devueltas por mayoristas (unidades)*/
param Dist{NODOS,NODOS};/*Distancia entre nodos (km)*/

/*VARIABLES*/
/*Variables fundamentales*/
var x_PE{PE,TP}, binary;/*Si abro una planta de un tipo*/
var aux_PE{PE}, binary;/*Si uso una planta embotelladora*/
var x_CD{CD}, binary;/*Si abro un centro de distribucion*/

/*Proveedores de Envase*/
var z_ENV{P_ENV,PE},binary;
var y_ENV{P_ENV,PE},>=0,integer;/*Estibas*/
var w_ENV{P_ENV,PE,ENV},>=0,integer;/*Estibas*/

/*Proveedores de CO2*/
var z_CO2{P_CO2,PE},binary;
var y_CO2{P_CO2,PE},>=0,integer;/*Tanques*/

/*Proveedores de Jarabe*/
var z_JAR{P_JAR,PE},binary;
var y_JAR{P_JAR,PE},>=0,integer;/*Estibas*/

/*Plantas Embotelladoras*/
var Reci_EST_PE{PE,ENV},>=0;/*Estibas*/
var Reci_CAJ_PE{PE,ENV},>=0;/*Cajas,Canastas,Bandejas*/
var z_PE{PE,CD},binary;
var y_EST_PE{PE,CD},>=0,integer;
var y_CAJ_PE{PE,CD},>=0,integer;
var w_EST_PE{PE,CD,ENV},>=0,integer;/*Estibas*/
var w_CAJ_PE{PE,CD,ENV},>=0,integer;/*Cajas,Canastas,Bandejas*/
var Req_Prod{PE,ENV},>=0;
var Cant_AGUA{PE,ENV},>=0;
var Cant_CO2{PE,ENV},>=0;
var Cant_JAR{PE,ENV},>=0;

/*Centros de Distribución*/
var z_CD{CD,CLI},binary;
var w_CD{CD,CLI,ENV},>=0;
var Reci_EST_CD{CD,ENV},>=0;/*Estibas*/
var Reci_CAJ_CD{CD,ENV},>=0;/*Cajas,Canastas,Bandejas*/
var v_CAJ_CD{CD,PE},integer,>=0;
var v_EST_CD{CD,PE},integer,>=0;

/*Clientes*/
var v_CAJ_CLI{CLI,CD},integer,>=0;/*Cajas,Canastas,Bandejas*/

/*Variables Auxiliares*/
var aux_AGUA{PE,ENV,TP},>=0;
var aux_Req_Prod{PE,ENV,TP},>=0;
var aux_Vid{PE},>=0;

/*Clientes*/
var Costos_Envases;
var Costos_CO2;
var Costos_Jarabe;
var Costos_Agua;
var Costos_Procesamiento;
var Costos_Fijo_Planta;
var Costos_Penalizacion_Planta;
var Costos_Limpiar_Vidrio;
var Costos_Fijo_Centro;
var Costos_Picking_Centro;
var Costos_Transporte;
var Costos_Viaje;

/*Número de viaje*/
var NV1{P_ENV,PE},integer;
var NV2{P_CO2,PE},integer;
var NV3{P_JAR,PE},integer;
var NV4{PE,CD},integer;
var NV5{CD,CLI},integer;
var NV6{CD,CLI},integer;
var NV7{CD,CLI},integer;
var NV8{CLI,CD},integer;
var NV9{CD,PE},integer;


/*Costos de transporte*/
var CT1;
var CT2;
var CT3;
var CT4;
var CT5;
var CT6;
var CT7;
var CT8;
var CT9;


/*Costos de viaje*/
var CV1;
var CV2;
var CV3;
var CV4;
var CV5;
var CV6;
var CV7;
var CV8;
var CV9;


/*FUNCIÓN OBJETIVO*/
minimize FO:Costos_Envases+Costos_CO2+Costos_Jarabe+Costos_Agua+Costos_Procesamiento+Costos_Fijo_Planta+Costos_Penalizacion_Planta+
Costos_Limpiar_Vidrio+Costos_Fijo_Centro+Costos_Picking_Centro+Costos_Transporte+Costos_Viaje;

/*RESTRICCIONES*/

s.t. r1:Costos_Envases=sum{e in P_ENV,env in ENV,pe in PE}Costo_ENV[e,env]*w_ENV[e,pe,env];
s.t. r2:Costos_CO2=sum{c in P_CO2,pe in PE}Costo_TanCO2[c]*y_CO2[c,pe];
s.t. r3:Costos_Jarabe=sum{j in P_JAR,pe in PE}Costo_JAR[j]*y_JAR[j,pe];
s.t. r4:Costos_Agua=sum{pe in PE,env in ENV,tp in TP}Costo_AGUA[pe,tp]*aux_AGUA[pe,env,tp];
s.t. r5:Costos_Procesamiento=sum{pe in PE,env in ENV,tp in TP}Costo_PROC[pe,tp]*aux_Req_Prod[pe,env,tp];
s.t. r6:Costos_Fijo_Planta=sum{pe in PE,tp in TP}Costo_F_PLAN[pe,tp]*x_PE[pe,tp];
s.t. r7:Costos_Penalizacion_Planta=sum{pe in PE}Costo_PEN[pe]*aux_PE[pe];
s.t. r8:Costos_Limpiar_Vidrio=sum{pe in PE}Costo_LIM_VID[pe]*aux_Vid[pe];
s.t. r9:Costos_Fijo_Centro=sum{cd in CD}Costo_F_CD[cd]*x_CD[cd];
s.t. r10:Costos_Picking_Centro=sum{cd in CD,env in ENV,pe in PE}Costo_PICK[cd,env]*w_CAJ_PE[pe,cd,env];

s.t. r11:Costos_Transporte=CT1+CT2+CT3+CT4+CT5+CT6+CT7+CT8+CT9;

s.t. r12:CT1=sum{e in P_ENV,pe in PE}1250*Dist[e,pe]*y_ENV[e,pe];
s.t. r13:CT2=sum{c in P_CO2,pe in PE}3200*Dist[c,pe]*y_CO2[c,pe];
s.t. r14:CT3=sum{j in P_JAR,pe in PE}950*Dist[j,pe]*y_JAR[j,pe];
s.t. r15:CT4=sum{pe in PE,cd in CD}1700*Dist[pe,cd]*y_EST_PE[pe,cd];
s.t. r16:CT5=sum{cd in CD,cli in CLI}55*Dist[cd,cli]*w_CD[cd,cli,"Plas"];
s.t. r17:CT6=sum{cd in CD,cli in CLI}65*Dist[cd,cli]*w_CD[cd,cli,"Lat"];
s.t. r18:CT7=sum{cd in CD,cli in CLI}40*Dist[cd,cli]*w_CD[cd,cli,"Vid"];
s.t. r19:CT8=sum{cli in CLI,cd in CD}20*Dist[cli,cd]*v_CAJ_CLI[cli,cd];
s.t. r20:CT9=sum{cd in CD,pe in PE}(900/54)*Dist[cd,pe]*v_CAJ_CD[cd,pe];

s.t. r21:Costos_Viaje=CV1+CV2+CV3+CV4+CV5+CV6+CV7+CV8+CV9;

s.t. r22:CV1=sum{e in P_ENV,pe in PE}100*Dist[e,pe]*NV1[e,pe];
s.t. r23:CV2=sum{c in P_CO2,pe in PE}100*Dist[c,pe]*NV2[c,pe];
s.t. r24:CV3=sum{j in P_JAR,pe in PE}100*Dist[j,pe]*NV3[j,pe];
s.t. r25:CV4=sum{pe in PE,cd in CD}100*Dist[pe,cd]*NV4[pe,cd];
s.t. r26:CV5=sum{cd in CD,cli in CLI}180*Dist[cd,cli]*NV5[cd,cli];
s.t. r27:CV6=sum{cd in CD,cli in CLI}130*Dist[cd,cli]*NV6[cd,cli];
s.t. r28:CV7=sum{cd in CD,cli in CLI}135*Dist[cd,cli]*NV7[cd,cli];
s.t. r29:CV8=sum{cli in CLI,cd in CD}135*Dist[cli,cd]*NV8[cli,cd];
s.t. r30:CV9=sum{cd in CD,pe in PE}100*Dist[cd,pe]*NV9[cd,pe];

/*Número de Viajes*/
s.t. r78{e in P_ENV,pe in PE}:NV1[e,pe]>=y_ENV[e,pe]/10;
s.t. r79{c in P_CO2,pe in PE}:NV2[c,pe]>=y_CO2[c,pe]/1;
s.t. r80{j in P_JAR,pe in PE}:NV3[j,pe]>=y_JAR[j,pe]/4;
s.t. r81{pe in PE,cd in CD}:NV4[pe,cd]>=y_EST_PE[pe,cd]/10;
s.t. r82{cd in CD,cli in CLI}:NV5[cd,cli]>=w_CD[cd,cli,"Plas"]/90;
s.t. r83{cd in CD,cli in CLI}:NV6[cd,cli]>=w_CD[cd,cli,"Lat"]/110;
s.t. r84{cd in CD,cli in CLI}:NV7[cd,cli]>=w_CD[cd,cli,"Vid"]/76;
s.t. r85{cli in CLI,cd in CD}:NV8[cli,cd]>=v_CAJ_CLI[cli,cd]/76;
s.t. r86{cd in CD,pe in PE}:NV9[cd,pe]>=v_CAJ_CD[cd,pe]/540;


/*Restricciones fundamentales*/
s.t. res1{pe in PE}: sum{tp in TP}x_PE[pe,tp]<=1; 
s.t. res2{pe in PE}: aux_PE[pe]=sum{tp in TP}x_PE[pe,tp]; 

/*Restricciones proveedores de Envase*/
s.t. res3{e in P_ENV,pe in PE}: z_ENV[e,pe]<=sum{tp in TP}x_PE[pe,tp]; 
s.t. res4{e in P_ENV,pe in PE}: y_ENV[e,pe]<=10000*z_ENV[e,pe]; 
s.t. res5{e in P_ENV,pe in PE}: y_ENV[e,pe]=sum{env in ENV}w_ENV[e,pe,env]; 
s.t. res6{e in P_ENV}: sum{pe in PE}z_ENV[e,pe]<=3; 
s.t. res7{e in P_ENV,env in ENV}: sum{pe in PE}w_ENV[e,pe,env]<=Of_Env[e,env];

/*Restricciones proveedores de CO2*/
s.t. res8{c in P_CO2,pe in PE}: z_CO2[c,pe]<=sum{tp in TP}x_PE[pe,tp]; 
s.t. res9{c in P_CO2,pe in PE}: y_CO2[c,pe]<=10000*z_CO2[c,pe]; 
s.t. res10{c in P_CO2}: sum{pe in PE}z_CO2[c,pe]<=3; 
s.t. res11{c in P_CO2}: sum{pe in PE}y_CO2[c,pe]<=Of_TanCO2[c];

/*Restricciones proveedores de Jarabe*/
s.t. res12{j in P_JAR,pe in PE}: z_JAR[j,pe]<=sum{tp in TP}x_PE[pe,tp]; 
s.t. res13{j in P_JAR,pe in PE}: y_JAR[j,pe]<=10000*z_JAR[j,pe]; 
s.t. res14{j in P_JAR}: sum{pe in PE}z_JAR[j,pe]<=2; 
s.t. res15{j in P_JAR}: sum{pe in PE}y_JAR[j,pe]<=Of_JAR[j];

/*Plantas Embotelladoras Producción*/
s.t. res16{pe in PE,env in ENV:env="Plas" or env="Lat"}: Req_Prod[pe,env]=((sum{e in P_ENV}w_ENV[e,pe,env])*24*Cant_CAJ_EST[env]*Capac_ENV[env])/1000;
s.t. res17{pe in PE,env in ENV:env="Vid"}: Req_Prod[pe,env]=(((sum{e in P_ENV}w_ENV[e,pe,env])*24*Cant_CAJ_EST[env]*Capac_ENV[env])/1000)+((24*(sum{cd in CD}v_CAJ_CD[cd,pe]*Capac_ENV[env]))/1000);
s.t. res18{pe in PE,env in ENV}: Req_Prod[pe,env]=Cant_AGUA[pe,env]+Cant_CO2[pe,env]+Cant_JAR[pe,env];
s.t. res19{pe in PE,env in ENV}: Cant_AGUA[pe,env]>=0.85*Req_Prod[pe,env];
s.t. res20{pe in PE,env in ENV}: Cant_AGUA[pe,env]<=0.89*Req_Prod[pe,env];
s.t. res21{pe in PE,env in ENV}: Cant_CO2[pe,env]>=0.04*Req_Prod[pe,env];
s.t. res22{pe in PE,env in ENV}: Cant_CO2[pe,env]<=0.07*Req_Prod[pe,env];
s.t. res23{pe in PE,env in ENV}: Cant_JAR[pe,env]>=0.06*Req_Prod[pe,env];
s.t. res24{pe in PE,env in ENV}: Cant_JAR[pe,env]<=0.1*Req_Prod[pe,env];
s.t. res25{pe in PE}: sum{env in ENV}Cant_CO2[pe,env]<=600*sum{c in P_CO2}y_CO2[c,pe];
s.t. res26{pe in PE}: sum{env in ENV}Cant_JAR[pe,env]<=500*sum{j in P_JAR}y_JAR[j,pe];

/*Plantas Embotelladoras Abastecimiento*/
s.t. res27{pe in PE,env in ENV:env="Plas" or env="Lat"}:Reci_EST_PE[pe,env]=sum{e in P_ENV}w_ENV[e,pe,env];
s.t. res28{pe in PE,env in ENV:env="Plas" or env="Lat"}:Reci_CAJ_PE[pe,env]=(sum{e in P_ENV}w_ENV[e,pe,env])*Cant_CAJ_EST[env];
s.t. res29{pe in PE,env in ENV:env="Vid"}:Reci_EST_PE[pe,env]=sum{e in P_ENV}w_ENV[e,pe,env]+sum{cd in CD}v_EST_CD[cd,pe];
s.t. res30{pe in PE,env in ENV:env="Vid"}:Reci_CAJ_PE[pe,env]=(sum{e in P_ENV}w_ENV[e,pe,env])*Cant_CAJ_EST[env]+sum{cd in CD}v_CAJ_CD[cd,pe];
s.t. res31{pe in PE}: sum{env in ENV}Reci_EST_PE[pe,env]<=60*x_PE[pe,1]+100*x_PE[pe,2];
s.t. res32{pe in PE}: sum{c in P_CO2}y_CO2[c,pe]<=3*x_PE[pe,1]+5*x_PE[pe,2];
s.t. res33{pe in PE}: sum{j in P_JAR}y_JAR[j,pe]<=4*x_PE[pe,1]+7*x_PE[pe,2];
s.t. res34{pe in PE,cd in CD}: z_PE[pe,cd]<=sum{tp in TP}x_PE[pe,tp]; 
s.t. res35{pe in PE,cd in CD}: z_PE[pe,cd]<=x_CD[cd];
s.t. res36{pe in PE,cd in CD}: y_CAJ_PE[pe,cd]<=1000*z_PE[pe,cd];
s.t. res37{pe in PE,cd in CD}: y_CAJ_PE[pe,cd]=sum{env in ENV}w_CAJ_PE[pe,cd,env];
s.t. res38{pe in PE,cd in CD}: y_EST_PE[pe,cd]=sum{env in ENV}w_EST_PE[pe,cd,env];
s.t. res39{pe in PE,env in ENV}: Reci_CAJ_PE[pe,env]=sum{cd in CD}w_CAJ_PE[pe,cd,env];/*Log*/
s.t. res40{pe in PE,env in ENV,cd in CD}: w_EST_PE[pe,cd,env]>=w_CAJ_PE[pe,cd,env]/Cant_CAJ_EST[env];

/*Centros de Distribución*/
s.t. res41{cd in CD,env in ENV}: Reci_EST_CD[cd,env]=sum{pe in PE}w_EST_PE[pe,cd,env];
s.t. res42{cd in CD}: sum{env in ENV}Reci_EST_CD[cd,env]<=Capac_CD[cd];
s.t. res43{cd in CD,env in ENV}: Reci_CAJ_CD[cd,env]=sum{pe in PE}w_CAJ_PE[pe,cd,env];
s.t. res44{cd in CD,cli in CLI}: z_CD[cd,cli]<=x_CD[cd];
s.t. res45{cd in CD,cli in CLI,env in ENV}: w_CD[cd,cli,env]<=100000*z_CD[cd,cli];
s.t. res46{cd in CD,env in ENV}: sum{cli in CLI}w_CD[cd,cli,env]<=Reci_CAJ_CD[cd,env];
s.t. res47{cli in CLI}: sum{cd in CD}z_CD[cd,cli]=1;
s.t. res48{cli in CLI,env in ENV}: sum{cd in CD}w_CD[cd,cli,env]>=DEMANDA[cli,env];

/*Devoluciones*/
s.t. res49{res in RES,cd in CD}: v_CAJ_CLI[res,cd]=Dev_RES[res]*z_CD[cd,res];
s.t. res50{may in MAY,cd in CD}: v_CAJ_CLI[may,cd]=Dev_MAY[may]*z_CD[cd,may];
s.t. res51{cd in CD}: sum{cli in CLI}v_CAJ_CLI[cli,cd]=sum{pe in PE}v_CAJ_CD[cd,pe];
s.t. res52{cd in CD,pe in PE}: v_EST_CD[cd,pe]>=(v_CAJ_CD[cd,pe])/54;


/*Restricciones Auxiliares*/
s.t. res53{pe in PE,env in ENV,tp in TP}: aux_AGUA[pe,env,tp]>=Cant_AGUA[pe,env]-10000000000*(1-x_PE[pe,tp]);
s.t. res54{pe in PE,env in ENV,tp in TP}: aux_Req_Prod[pe,env,tp]>=Req_Prod[pe,env]-10000000000*(1-x_PE[pe,tp]);
s.t. res55{pe in PE}: aux_Vid[pe]=24*sum{cd in CD}v_CAJ_CD[cd,pe];

/*Restricciones del 30%*/
s.t. res56{pe in PE}: sum{e in P_ENV}w_ENV[e,pe,"Vid"]>=0.3*sum{e in P_ENV}y_ENV[e,pe];
s.t. res57{pe in PE}: sum{e in P_ENV}w_ENV[e,pe,"Plas"]>=0.3*sum{e in P_ENV}y_ENV[e,pe];
s.t. res58{pe in PE}: sum{e in P_ENV}w_ENV[e,pe,"Lat"]>=0.3*sum{e in P_ENV}y_ENV[e,pe];


solve;
data;
set P_ENV:= Iber  Crow  Tre;
set P_CO2:= Barr  Mani  Toca;
set P_JAR:= Prol  Dole  Provi;
set PE:= Hip  Boya  Con;
set CD:= Ita  Sinc  Iba;
set RES:= CBC_Bog  CBC_Cal;
set MAY:= CEDI_Bog  Oli_Mont  Oli_Barr  Jum_Buca;
set CLI:= CBC_Bog  CBC_Cal  CEDI_Bog  Oli_Mont  Oli_Barr  Jum_Buca;
set TP:= 1  2;
set INSU:= Env  Jar  CO2;
set MAT_PRIMA:= Agua  Jar  CO2;
set ENV:= Plas  Lat  Vid;
set TOL:= Mini  Id  Maxi;
set NODOS:= Prol  Dole  Provi  Barr  Mani  Toca  Iber  Crow  Tre  Hip  Boya  Con  Ita  Sinc  Iba  CBC_Bog  CBC_Cal  CEDI_Bog  Oli_Mont  Oli_Barr  Jum_Buca;

param Of_Env: Plas Lat Vid:=
 Iber 21 25 22
 Crow 26 20 26
 Tre 34 30 29;

param Of_TanCO2:=
Barr 6
Mani 7
Toca 6;

param Of_JAR:=
Prol 13
Dole 14
Provi 16;

param Costo_ENV: Plas Lat Vid:=
  Iber 24192 63000 34992
  Crow 30240 49500 30325
  Tre 28224 63000 34992;

param Costo_TanCO2:=
Barr 240.000
Mani 235.000
Toca 246.000;

param Costo_JAR:=
Prol 225.000
Dole 240.000
Provi 250.000;

param Costo_AGUA: 1 2:=
   Hip 253 332
   Boya 235 350
   Con 232 350;

param Costo_PROC: 1 2:=
   Hip 21 19
   Boya 30 20
   Con 26 18;

param Costo_F_PLAN: 1 2:=
   Hip 111264414 237719546
   Boya 120289496 244198879
   Con 108752494 237947970;

param Costo_PEN:=
Hip 1396860
Boya 1050652
Con 1467785;

param Porc: Mini Id Maxi:=
Agua 0.85 0.87 0.89
Jar 0.04 0.05 0.07
CO2 0.06 0.08 0.1;

param Capac_PEMB: 1 2:=
   Env 4 7
   Jar 60 100
   CO2 3 5;

param Capac_ENV:=
Plas 600
Lat 355
Vid 350;

param Cant_CAJ_EST:=
Plas 42
Lat 75
Vid 54;

param Costo_LIM_VID:=
Hip 23
Boya 21
Con 12;

param Costo_F_CD:=
Ita 86747732
Sinc 117217679
Iba 89253845;


param Costo_PICK: Plas Lat Vid:=
   Ita 30 25 27
   Sinc 22 27 18
   Iba 21 29 24;

param Capac_CD:=
Ita 88
Sinc 90
Iba 85;

param DEMANDA: Plas Lat Vid:=
   CBC_Bog 250 350 620
   CBC_Cal 210 300 515
   CEDI_Bog 485 600 290
   Oli_Mont 445 525 325
   Oli_Barr 450 650 260
   Jum_Buca 390 625 290;

param Dist: Prol Dole Provi Barr Mani Toca Iber Crow Tre Hip Boya Con Ita Sinc Iba CBC_Bog CBC_Cal CEDI_Bog Oli_Mont Oli_Barr Jum_Buca:=
Prol 0 408.71 432.88 307.39 204.39 442.57 407.16 447.39 815.94 402.34 420.04 592.24 10.29 469.93 411.99 423.26 753.37 424.87 426.49 711.33 391.07
Dole 381.42 0 473.15 389.46 268.76 67.75 13.52 73.23 844.91 415.21 177.03 326.69 391.07 819.16 183.47 38.3 474.76 36.69 775.71 965.61 460.27
Provi 421.65 468.32 0 677.53 260.71 494.07 463.49 498.89 387.85 774.09 603.51 329.92 413.6 888.36 281.64 450.62 6.76 453.84 935.03 1131.37 762.83
Barr 307.89 417.68 675.93 0 422.32 398.74 415.9 364.74 1057.26 130.54 285.48 601.75 316.92 626.73 421.35 409.85 670.17 411.26 626.39 610.35 119.04
Mani 199.35 271.57 257.49 422.88 0 316.34 277.56 321.15 640.5 518.24 425.22 428.94 191.84 666.18 193.67 300.74 252.92 300.1 623.43 908.65 506.89
Toca 444.56 66.73 503.73 397.37 318.38 0 60.92 8.23 877.2 355.8 110.57 358.37 453.59 881.23 217.83 45.83 492.35 47.21 838.27 972.89 392.31
Iber 393.75 11.13 458.66 417.97 278.87 54.14 0 59.14 832.77 433.57 163.24 313.17 417.39 846.93 170.72 22.73 453.72 22.94 803.7 992.32 415.32
Crow 448.94 66.35 508.55 364.46 322.39 6.72 65.01 0 882.17 347.68 115.74 363.93 457.83 885.34 221.54 50.04 496.78 51.36 842.93 939.54 361.59
Tre 799.87 840.06 384.63 1055.25 637.55 865.32 835.11 871.19 0 1150.92 975.67 516.4 791.65 1266.45 658.53 822.43 390.53 824.32 1312.55 1508.61 1497.65
Hip 404.45 410.34 772.49 131.52 519.65 354.68 405.6 347.16 1154.69 0 267.04 697.35 412.51 622.29 517.95 392.25 766.48 394.68 722.23 606.87 20.35
Boya 420.43 174.34 606.72 286.01 426.49 113.81 169.32 116.27 979.16 267.32 0 460.36 428.86 781.72 325.27 154.91 600.46 155.98 738.89 861.17 281.72
Con 546.78 323.54 315.43 601.35 385.22 349.56 318.77 354.39 517.27 696.66 458.22 0 538.28 1029.96 191.73 305.04 340.73 308.69 986.16 1176.17 685.28
Ita 10.51 417.89 424.87 315.75 195.45 450.67 415.76 456.84 805.19 411.49 428.54 578.98 0 478.38 420.54 432.9 428.59 433.12 435.41 720.37 400.67
Sinc 471.87 847.61 902.84 626.28 674.28 989.65 845.36 886.17 1284.44 621.48 782.58 1030.17 479.32 0 850.37 862.43 896.73 863.39 122.37 243.22 603.56
Iba 412.64 181.86 283.25 420.76 195.77 214.47 176.86 220.22 664.5 516.67 324.95 192.14 348.49 849.36 0 171.34 276.83 173.97 806.11 995.62 505.1
CBC_Bog 423.74 32.99 452.23 432.65 300.77 43.63 27.74 48.41 825.35 395.93 155.58 307.47 432.14 860.85 171.32 0 445.62 1.97 817.41 1007.42 409.58
CBC_Cal 416.72 469.93 7.24 673.18 254.21 488.56 457.87 493.35 417.34 767.13 597.77 342.47 407.81 883.86 275.93 445.02 0 447.52 928.42 1247.31 756.89
CEDI_Bog 427.64 34.76 450.62 415.79 303.24 47.77 30.56 53.24 823.35 398.36 157.43 305.13 435.61 863.24 169.52 3.46 444.74 0 820.52 1010.67 412.38
Oli_Mont 405.63 782.14 836.86 745.37 608.39 815.64 780.95 820.68 1219.25 700.28 717.98 965.13 414.33 121.53 785.43 796.75 831.52 798.58 0 363.74 689.79
Oli_Barr 714.53 992.97 1197.35 611.42 999.79 974.12 992.34 940.78 1634.79 606.19 862.19 1177.47 720.32 243.65 997.85 1008.44 1245.34 1009.35 359.71 0 586.71
Jum_Buca 391.84 453.84 759.61 118.37 506.15 367.89 419.15 361.76 1141.72 19.25 280.12 684.38 400.02 604.25 505.98 406.78 753.17 407.87 709.89 587.69 0;

end;