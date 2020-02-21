/*Declaración de Conjuntos*/
set Proveedores_Externos;
set Proveedores_Internos;
set Aeropuerto;
set Laboratorios;
set Farmacias;
set Hospitales;
set EPS;
set Central_de_Mezcla;
set Operador;
set Camiones; 
set Tipos_de_medicamentos;
set Medicamento_Biologico;
set Principios_Activos;
set Excipiente;
set Zonas_CentroDistribucion;
set Tipo_Centro_Distribucion;
set Medicamento_Vencido; 

set A:=Tipos_de_medicamentos union Principios_Activos union Excipiente union Medicamento_Biologico union Medicamento_Vencido;
set B:=Proveedores_Externos union Proveedores_Internos;
set C:=Principios_Activos union Excipiente;
set D:=Tipos_de_medicamentos union Medicamento_Biologico;
set E:=EPS union Farmacias;
set F:=Tipos_de_medicamentos union Principios_Activos union Excipiente union Medicamento_Biologico;
set G:=Proveedores_Externos union Proveedores_Internos union Aeropuerto union Laboratorios union Farmacias union EPS union Hospitales union Central_de_Mezcla union Operador;

/*Declaración de Parámetros*/ 
param Distancias{G,G};
param Binario_Fabricacion_Laboratorio{Laboratorios,Tipos_de_medicamentos};
param Requerimiento_Laboratorios{C,Tipos_de_medicamentos,Laboratorios};
param Capacidad_Laboratorios{Laboratorios};
param Capacidad_Centro_Distribucion{Tipo_Centro_Distribucion,Zonas_CentroDistribucion};
param Capacidad_Camiones{Camiones};
param Capacidad_Recepcion_Operadores:=1500;
param Oferta_Proveedores{B,C};
param Oferta_Medicamentos_Biologicos:=1200;
param Demanda_Centrales_de_Mezcla{Central_de_Mezcla,C};
param Demanda_Hospitales{Hospitales,D};
param Demanda_EPSyFARMACIAS{E,Tipos_de_medicamentos};
param Costo_Empaquetamiento{Proveedores_Internos,F,Tipo_Centro_Distribucion};
param Costo_Destruccion{Operador};
param Costo_Penalizacion{Proveedores_Internos};
param Costo_Operacion{Proveedores_Internos,Tipo_Centro_Distribucion};
param Costo_Produccion{Laboratorios,Tipos_de_medicamentos};
param Costo_Transporte{Camiones,A};
param Costo_Viaje{Camiones};

table tabla IN "CSV" "Distancias.csv": [x,y], Distancias~z;
table tabla IN "CSV" "Binario_Fabricacion_Laboratorio.csv": [x,y], Binario_Fabricacion_Laboratorio~z;
table tabla IN "CSV" "Requerimiento_Laboratorios.csv": [x,y,z], Requerimiento_Laboratorios~w;
table tabla IN "CSV" "Capacidad_Laboratorios.csv": [x], Capacidad_Laboratorios~y;
table tabla IN "CSV" "Capacidad_Centro_Distribucion.csv": [x,y], Capacidad_Centro_Distribucion~z;
table tabla IN "CSV" "Capacidad_Camiones.csv": [x], Capacidad_Camiones~y;
table tabla IN "CSV" "Oferta_Proveedores.csv": [x,y], Oferta_Proveedores~z;
table tabla IN "CSV" "Demanda_Centrales_de_Mezcla.csv": [x,y], Demanda_Centrales_de_Mezcla~z;
table tabla IN "CSV" "Demanda_Hospitales.csv": [x,y], Demanda_Hospitales~z;
table tabla IN "CSV" "Demanda_EPSyFARMACIAS.csv": [x,y], Demanda_EPSyFARMACIAS~z;
table tabla IN "CSV" "Costo_Empaquetamiento.csv": [x,y,z], Costo_Empaquetamiento~w;
table tabla IN "CSV" "Costo_Destruccion.csv": [x], Costo_Destruccion~y;
table tabla IN "CSV" "Costo_Penalizacion.csv": [x], Costo_Penalizacion~y;
table tabla IN "CSV" "Costo_Operacion.csv": [x,y], Costo_Operacion~z;
table tabla IN "CSV" "Costo_Produccion.csv": [x,y], Costo_Produccion~z;
table tabla IN "CSV" "Costo_Transporte.csv": [x,y], Costo_Transporte~z;
table tabla IN "CSV" "Costo_Viaje.csv": [x], Costo_Viaje~y;

/*Declaración de Variables*/

var Cant_T_Operadores{Proveedores_Internos,Operador}>=0;
var Si_envio_Operadores{Proveedores_Internos,Operador}, binary;

var Num_Viajes_CM{Proveedores_Internos,Central_de_Mezcla}>=0, integer;
var Num_Viajes_LAB{Proveedores_Internos,Laboratorios}>=0, integer;
var Num_Viajes_Proveedores_Internos{B,Proveedores_Internos}>=0, integer;
var Num_Viajes_LAB_Proveedores_Internos{Laboratorios,Proveedores_Internos}>=0, integer;
var Num_Viajes_H{Proveedores_Internos,Hospitales}>=0, integer;
var Num_Viajes_ECF{Proveedores_Internos,E}>=0, integer;
var Num_Viajes_MedBio{Proveedores_Internos,Hospitales}>=0, integer;
var Num_Viajes_Aer{Proveedores_Internos}>=0, integer;
var Num_Viajes_EPSyFARM{E,Proveedores_Internos}>=0, integer;
var Num_Viajes_OP{Proveedores_Internos,Operador}>=0, integer;
var ABRIR{Tipo_Centro_Distribucion,Proveedores_Internos}, binary;
var SI_ABRO{Proveedores_Internos}, binary;

var Cant_T_EPSyFARM{Proveedores_Internos,E}>=0;
var Cant_Aux_EPSyFARM{Proveedores_Internos,Tipos_de_medicamentos,Tipo_Centro_Distribucion}>=0;
var Si_envio_EPSyFARM{Proveedores_Internos,E}, binary;
var Cant_EPSyFARM{Proveedores_Internos,E,Tipos_de_medicamentos}>=0;
var Cant_dev_EPSyFARM{E,Proveedores_Internos}>=0;

var Cant_T_Laboratorios{Proveedores_Internos,Laboratorios}>=0;
var Si_envio_Laboratorios{Proveedores_Internos,Laboratorios}, binary;
var Cant_Laboratorios{Proveedores_Internos,Laboratorios,C}>=0;
var Cant_dev_Laboratorios{Laboratorios,Proveedores_Internos,Tipos_de_medicamentos}>=0;
var Cant_dev_T_Laboratorios{Laboratorios,Proveedores_Internos}>=0;

var Cant_T_CentralesMezcla{Proveedores_Internos,Central_de_Mezcla}>=0;
var Cant_Aux_CentralesMezcla{Proveedores_Internos,C,Tipo_Centro_Distribucion}>=0;
var Si_envio_CentralesMezcla{Proveedores_Internos,Central_de_Mezcla}, binary;
var Cant_CentralesMezcla{Proveedores_Internos,Central_de_Mezcla,C}>=0;

var Cant_T_Proveedores{B,Proveedores_Internos}>=0;
var Si_envio_Proveedores{B,Proveedores_Internos}, binary;
var Cant_Proveedores{B,Proveedores_Internos,C}>=0;

var Cant_Aeropuerto{Proveedores_Internos}>=0;

var Cant_T_Hospitales{Proveedores_Internos,Hospitales}>=0;
var Cant_aux_Hospitales{Proveedores_Internos,D,Tipo_Centro_Distribucion}>=0;
var Si_envio_Hospitales{Proveedores_Internos,Hospitales}, binary;
var Cant_Hospitales{Proveedores_Internos,Hospitales,D}>=0;

var Costo_Total_Penalizacion,>=0;
var Costo_Total_Operacion,>=0;
var Costo_Total_Produccion,>=0;
var Costo_Total_Empaquetamiento,>=0;
var Costo_Total_Destruccion,>=0;
var Costo_Total_de_Transporte,>=0;
var Costo_Total_de_Viaje,>=0;

/*Función Objetivo*/
minimize FO:Costo_Total_Penalizacion+Costo_Total_Operacion+Costo_Total_Produccion+Costo_Total_Empaquetamiento+Costo_Total_Destruccion+Costo_Total_de_Transporte+Costo_Total_de_Viaje;


/*RESTRICCIONES*/
/*Costos*/
s.t. res1:Costo_Total_Penalizacion=sum{p in Proveedores_Internos}(1-SI_ABRO[p])*Costo_Penalizacion[p];

s.t. res2:Costo_Total_Operacion=sum{p in Proveedores_Internos,cd in Tipo_Centro_Distribucion}ABRIR[cd,p]*Costo_Operacion[p,cd];

s.t. res3:Costo_Total_Produccion=sum{p in Proveedores_Internos,tm in Tipos_de_medicamentos,lab  in Laboratorios}Costo_Produccion[lab,tm]*Cant_dev_Laboratorios[lab,p,tm];

s.t. res4:Costo_Total_Empaquetamiento=sum{p in Proveedores_Internos,c in  C,cd in Tipo_Centro_Distribucion}Costo_Empaquetamiento[p,c,cd]*Cant_Aux_CentralesMezcla[p,c,cd]+sum{p in Proveedores_Internos,tm in Tipos_de_medicamentos,cd in Tipo_Centro_Distribucion}Costo_Empaquetamiento[p,tm,cd]*Cant_Aux_EPSyFARM[p,tm,cd]+sum{p in Proveedores_Internos,d in D,cd in Tipo_Centro_Distribucion}Costo_Empaquetamiento[p,d,cd]*Cant_aux_Hospitales[p,d,cd];

s.t. res5:Costo_Total_Destruccion=sum{p in Proveedores_Internos,op in Operador}Cant_T_Operadores[p,op]*Costo_Destruccion[op];

s.t. res6:Costo_Total_de_Transporte=sum{p in Proveedores_Internos,cm in Central_de_Mezcla}Cant_T_CentralesMezcla[p,cm]*25*Distancias[p,cm]+sum{p in Proveedores_Internos,lab in Laboratorios}Cant_T_Laboratorios[p,lab]*25*Distancias[p,lab]+sum{p in Proveedores_Internos,b in B}Cant_T_Proveedores[b,p]*25*Distancias[b,p]+sum{p in Proveedores_Internos,lab in Laboratorios}Cant_dev_T_Laboratorios[lab,p]*35*Distancias[lab,p]+sum{p in Proveedores_Internos,h in Hospitales}Cant_T_Hospitales[p,h]*35*Distancias[p,h]+sum{p in Proveedores_Internos,e in E}Cant_T_EPSyFARM[p,e]*35*Distancias[p,e]+sum{p in Proveedores_Internos,h in Hospitales}Cant_Hospitales[p,h,"Medi_biologico"]*55*Distancias[p,h]+sum{p in Proveedores_Internos}Cant_Aeropuerto[p]*55*Distancias["Aeropuerto",p]+sum{p in Proveedores_Internos,e in E}Cant_dev_EPSyFARM[e,p]*20*Distancias[e,p]+sum{p in Proveedores_Internos,op in Operador}Cant_T_Operadores[p,op]*20*Distancias[p,op];

s.t. res7:Costo_Total_de_Viaje=sum{p in Proveedores_Internos,cm in Central_de_Mezcla}Num_Viajes_CM[p,cm]*25*Distancias[p,cm]+sum{p in Proveedores_Internos,lab in Laboratorios}Num_Viajes_LAB[p,lab]*25*Distancias[p,lab]+sum{p in Proveedores_Internos,b in B}Num_Viajes_Proveedores_Internos[b,p]*25*Distancias[b,p]+sum{p in Proveedores_Internos,lab in Laboratorios}Num_Viajes_LAB_Proveedores_Internos[lab,p]*35*Distancias[lab,p]+sum{p in Proveedores_Internos,h in Hospitales}Num_Viajes_H[p,h]*35*Distancias[p,h]+sum{p in Proveedores_Internos,e in E}Num_Viajes_ECF[p,e]*35*Distancias[p,e]+sum{p in Proveedores_Internos,h in Hospitales}Num_Viajes_MedBio[p,h]*55*Distancias[p,h]+sum{p in Proveedores_Internos}Num_Viajes_Aer[p]*55*Distancias["Aeropuerto",p]+sum{p in Proveedores_Internos,e in E}Num_Viajes_EPSyFARM[e,p]*20*Distancias[e,p]+sum{p in Proveedores_Internos,op in Operador}Num_Viajes_OP[p,op]*20*Distancias[p,op];


/*Restricciones de Equilibrio*/
s.t. res8{p in Proveedores_Internos}: sum{h in Hospitales,tm in Tipos_de_medicamentos}Cant_Hospitales[p,h,tm]+sum{tm in Tipos_de_medicamentos,e in E}Cant_EPSyFARM[p,e,tm]=sum{lab in Laboratorios,tm in Tipos_de_medicamentos}Cant_dev_Laboratorios[lab,p,tm];
s.t. res9{p in Proveedores_Internos}: sum{b in B,c in  C}Cant_Proveedores[b,p,c]=sum{c in  C,lab in Laboratorios}Cant_Laboratorios[p,lab,c]+sum{c in  C,cm in Central_de_Mezcla}Cant_CentralesMezcla[p,cm,c];
s.t. res10{p in Proveedores_Internos}: Cant_Aeropuerto[p]=sum{h in Hospitales}Cant_Hospitales[p,h,"Medi_biologico"];
s.t. res11{p in Proveedores_Internos}:sum{e in E}Cant_dev_EPSyFARM[e,p]=sum{op in Operador}Cant_T_Operadores[p,op];
s.t. res12{p in Proveedores_Internos,lab in Laboratorios,c in  C}: Cant_Laboratorios[p,lab,c]=sum{tm in Tipos_de_medicamentos}Requerimiento_Laboratorios[c,tm,lab]*Cant_dev_Laboratorios[lab,p,tm];
/*-------------------------------------------------------------------------------------------------------------------------*/
s.t. res13: sum{p in Proveedores_Internos,cd in Tipo_Centro_Distribucion}ABRIR[cd,p]>=1; 
s.t. res14{p in Proveedores_Internos}: sum{cd in Tipo_Centro_Distribucion}ABRIR[cd,p]<=1; 
s.t. res15{p in Proveedores_Internos}: SI_ABRO[p]=sum{cd in Tipo_Centro_Distribucion}ABRIR[cd,p]; 
/*--------------------------------------------------------------------------------------------------------------------------*/
s.t. res16{p in Proveedores_Internos,cm in Central_de_Mezcla}:Num_Viajes_CM[p,cm]>=Cant_T_CentralesMezcla[p,cm]/1200;
s.t. res17{p in Proveedores_Internos,lab in Laboratorios}:Num_Viajes_LAB[p,lab]>=Cant_T_Laboratorios[p,lab]/1200;
s.t. res18{p in Proveedores_Internos,b in B}:Num_Viajes_Proveedores_Internos[b,p]>=Cant_T_Proveedores[b,p]/1200;
s.t. res19{lab in Laboratorios,p in Proveedores_Internos}:Num_Viajes_LAB_Proveedores_Internos[lab,p]>=Cant_dev_T_Laboratorios[lab,p]/1200;
s.t. res20{p in Proveedores_Internos,h in Hospitales}:Num_Viajes_H[p,h]>=Cant_T_Hospitales[p,h]/1200;
s.t. res21{p in Proveedores_Internos,e in E}:Num_Viajes_ECF[p,e]>=Cant_T_EPSyFARM[p,e]/1200;
s.t. res22{p in Proveedores_Internos,h in Hospitales}:Num_Viajes_MedBio[p,h]>=Cant_Hospitales[p,h,"Medi_biologico"]/450;
s.t. res23{p in Proveedores_Internos}:Num_Viajes_Aer[p]>=Cant_Aeropuerto[p]/450;
s.t. res24{e in E,p in Proveedores_Internos}:Num_Viajes_EPSyFARM[e,p]>=Cant_dev_EPSyFARM[e,p]/200;
s.t. res25{p in Proveedores_Internos,op in Operador}:Num_Viajes_OP[p,op]>=Cant_T_Operadores[p,op]/200;
/*--------------------------------------------------------------------------------------------------------------------------------------------------------*/
s.t. res26{p in Proveedores_Internos,e in E}: Si_envio_EPSyFARM[p,e]<=sum{cd in Tipo_Centro_Distribucion}ABRIR[cd,p]; 
s.t. res27{p in Proveedores_Internos,e in E}: Cant_T_EPSyFARM[p,e]<=1000000*Si_envio_EPSyFARM[p,e]; 
s.t. res28{p in Proveedores_Internos,e in E}: sum{tm in Tipos_de_medicamentos}Cant_EPSyFARM[p,e,tm]=Cant_T_EPSyFARM[p,e]; 
s.t. res29{e in E}: sum{p in Proveedores_Internos}Si_envio_EPSyFARM[p,e]=1; 
s.t. res30{tm in Tipos_de_medicamentos,e in E}: sum{p in Proveedores_Internos}Cant_EPSyFARM[p,e,tm]>=Demanda_EPSyFARMACIAS[e,tm];
s.t. res31{p in Proveedores_Internos,e in E}: Cant_dev_EPSyFARM[e,p]=0.06*Cant_T_EPSyFARM[p,e];
s.t. res32{p in Proveedores_Internos,tm in Tipos_de_medicamentos,cd in Tipo_Centro_Distribucion}:Cant_Aux_EPSyFARM[p,tm,cd]<=1000000*ABRIR[cd,p];
s.t. res33{p in Proveedores_Internos,tm in Tipos_de_medicamentos}:sum{cd in Tipo_Centro_Distribucion}Cant_Aux_EPSyFARM[p,tm,cd]=sum{e in E}Cant_EPSyFARM[p,e,tm];
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
s.t. res34{p in Proveedores_Internos,lab in Laboratorios}: Si_envio_Laboratorios[p,lab]<=sum{cd in Tipo_Centro_Distribucion}ABRIR[cd,p];
s.t. res35{p in Proveedores_Internos,lab in Laboratorios}: Cant_T_Laboratorios[p,lab]<=1000000*Si_envio_Laboratorios[p,lab];
s.t. res36{lab in Laboratorios}: sum{p in Proveedores_Internos}Si_envio_Laboratorios[p,lab]>=1;
s.t. res37{p in Proveedores_Internos,lab in Laboratorios}: sum{c in  C}Cant_Laboratorios[p,lab,c]=Cant_T_Laboratorios[p,lab];
s.t. res38{p in Proveedores_Internos,lab in Laboratorios}: sum{c in  C}Cant_Laboratorios[p,lab,c]=sum{tm in Tipos_de_medicamentos}Cant_dev_Laboratorios[lab,p,tm];

s.t. res39{p in Proveedores_Internos,lab in Laboratorios,tm in Tipos_de_medicamentos}:Cant_dev_Laboratorios[lab,p,tm]<=1000000*Binario_Fabricacion_Laboratorio[lab,tm];

s.t. res40{lab in Laboratorios}: sum{p in Proveedores_Internos}Cant_T_Laboratorios[p,lab]<=Capacidad_Laboratorios[lab];
s.t. res{p in Proveedores_Internos,lab in Laboratorios}:Cant_dev_T_Laboratorios[lab,p]=sum{tm in Tipos_de_medicamentos}Cant_dev_Laboratorios[lab,p,tm];
/*-------------------------------------------------------------------------------------------------------------------------------------------------*/
s.t. res41{p in Proveedores_Internos,cm in Central_de_Mezcla}: Si_envio_CentralesMezcla[p,cm]<=sum{cd in Tipo_Centro_Distribucion}ABRIR[cd,p];
s.t. res42{p in Proveedores_Internos,cm in Central_de_Mezcla}: Cant_T_CentralesMezcla[p,cm]<=1000000*Si_envio_CentralesMezcla[p,cm]; 
s.t. res43{p in Proveedores_Internos,cm in Central_de_Mezcla}: sum{c in  C}Cant_CentralesMezcla[p,cm,c]=Cant_T_CentralesMezcla[p,cm]; 
s.t. res44{cm in Central_de_Mezcla}: sum{p in Proveedores_Internos}Si_envio_CentralesMezcla[p,cm]=1; 
s.t. res45{c in  C,cm in Central_de_Mezcla}: sum{p in Proveedores_Internos}Cant_CentralesMezcla[p,cm,c]>=Demanda_Centrales_de_Mezcla[cm,c];
s.t. res46{p in Proveedores_Internos,c in  C,cd in Tipo_Centro_Distribucion}:Cant_Aux_CentralesMezcla[p,c,cd]<=1000000*ABRIR[cd,p];
s.t. res47{p in Proveedores_Internos,c in  C}:sum{cd in Tipo_Centro_Distribucion}Cant_Aux_CentralesMezcla[p,c,cd]=sum{cm in Central_de_Mezcla}Cant_CentralesMezcla[p,cm,c];
/*---------------------------------------------------------------------------------------------------------------------------------------------------------*/
s.t. res48{b in B,p in Proveedores_Internos}: Si_envio_Proveedores[b,p]<=sum{cd in Tipo_Centro_Distribucion}ABRIR[cd,p];
s.t. res49{b in B,p in Proveedores_Internos}: Cant_T_Proveedores[b,p]<=1000000*Si_envio_Proveedores[b,p];
s.t. res50{b in B,p in Proveedores_Internos}: sum{c in  C}Cant_Proveedores[b,p,c]=Cant_T_Proveedores[b,p];
s.t. res51{q in Proveedores_Internos}: sum{p in Proveedores_Internos}Si_envio_Proveedores[q,p]<=1;
s.t. res52{b in B,c in  C}: sum{p in Proveedores_Internos}Cant_Proveedores[b,p,c]<=Oferta_Proveedores[b,c];

/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/
s.t. res53{p in Proveedores_Internos,h in Hospitales}: Si_envio_Hospitales[p,h]<=sum{cd in Tipo_Centro_Distribucion}ABRIR[cd,p]; 
s.t. res54{p in Proveedores_Internos,h in Hospitales}: Cant_T_Hospitales[p,h]<=1000000*Si_envio_Hospitales[p,h];
s.t. res55{p in Proveedores_Internos,h in Hospitales}: sum{d in D}Cant_Hospitales[p,h,d]=Cant_T_Hospitales[p,h]; 
s.t. res56{h in Hospitales}: sum{p in Proveedores_Internos}Si_envio_Hospitales[p,h]=1; 
s.t. res57{d in D,h in Hospitales}: sum{p in Proveedores_Internos}Cant_Hospitales[p,h,d]>=Demanda_Hospitales[h,d]; 
s.t. res58{p in Proveedores_Internos,d in D,cd in Tipo_Centro_Distribucion}:Cant_aux_Hospitales[p,d,cd]<=1000000*ABRIR[cd,p];
s.t. res59{p in Proveedores_Internos,d in D}:sum{cd in Tipo_Centro_Distribucion}Cant_aux_Hospitales[p,d,cd]=sum{h in Hospitales}Cant_Hospitales[p,h,d];
/*-------------------------------------------------------------------------------------------------------------------------------------------------------*/
s.t. res60: sum{p in Proveedores_Internos}Cant_Aeropuerto[p]<=Oferta_Medicamentos_Biologicos;
/*---------------------------------------------------------------------------------------------------------------------------------------------------------------*/
s.t. res61{p in Proveedores_Internos,op in Operador}:Si_envio_Operadores[p,op]<=sum{cd in Tipo_Centro_Distribucion}ABRIR[cd,p];
s.t. res62{p in Proveedores_Internos,op in Operador}:Cant_T_Operadores[p,op]<=1000000*Si_envio_Operadores[p,op];
s.t. res63{p in Proveedores_Internos}:sum{op in Operador}Si_envio_Operadores[p,op]<=1;
s.t. res64{op in Operador}:sum{p in Proveedores_Internos}Cant_T_Operadores[p,op]<=Capacidad_Recepcion_Operadores;
/*--------------------------------------------------------------------------------------------------------------------------------------*/
s.t. res65{p in Proveedores_Internos}: sum{b in B}Cant_T_Proveedores[b,p]<=sum{cd in Tipo_Centro_Distribucion}Capacidad_Centro_Distribucion[cd,"Zona_1"]*ABRIR[cd,p];
s.t. res66{p in Proveedores_Internos}: sum{tm in Tipos_de_medicamentos,lab in Laboratorios}Cant_dev_Laboratorios[lab,p,tm]+sum{e in E}Cant_dev_EPSyFARM[e,p]<=sum{cd in Tipo_Centro_Distribucion}Capacidad_Centro_Distribucion[cd,"Zona_2"]*ABRIR[cd,p];
s.t. res67{p in Proveedores_Internos}:Cant_Aeropuerto[p]<=sum{cd in Tipo_Centro_Distribucion}Capacidad_Centro_Distribucion[cd,"Zona_3"]*ABRIR[cd,p];




solve;
data;
set Proveedores_Externos:= Cartagena  Buenaventura;
set Proveedores_Internos:= Disinter  Quimifast  Alcampo  Reprefarco;
set Aeropuerto:=Aeropuerto;
set Laboratorios:= Yumbo  Cartago  Ibague;
set Farmacias:= Cafam  Disfarma  Cruz_Verde;
set Hospitales:= San_Francisco  San_Jose;
set EPS:= Salud_Vida  Audifarma;
set Central_de_Mezcla:= Envigado;
set Operador:=Punto_Azul;
set Camiones:= CamioNum_Viajes_A  Camion_B  Camion_C; 
set Tipos_de_medicamentos:= Comprimidos  Tabletas  Capsulas;
set Medicamento_Biologico:= Medi_biologico;
set Principios_Activos:= Analgesicos  Antibioticos  Anestesicos; 
set Excipiente:= Excipiente;
set Zonas_CentroDistribucion:= Zona_1  Zona_2  Zona_3;
set Tipo_Centro_Distribucion:= Tipo_1  Tipo_2;
set Medicamento_Vencido:= Medi_vencido; 

end;