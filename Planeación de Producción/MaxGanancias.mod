/*CASO DE PRODUCCIÓN PERSECUCIÓN: HERRERA, RODRÍGUEZ, JARA, LDINO*/

/*CONJUNTOS*/
set I:={0,1,2,3,4,5,6};/*Periodos={Febrero, Marzo, Abril, Mayo, Junio, Julio,Agosto}*/
set T:={1,2,3,4,5,6};/*Periodos_Respuesta={Marzo, Abril, Mayo, Junio, Julio,Agosto}*/

/*PARÁMETROS */
param DEMANDA{T};/*Demanda en el periodo t in T*/
param DIAS_HAB{T};/*Dias hábiles de trabajo en el periodo t in T*/
param Kn{t in T}:=5*10*DIAS_HAB[t];/*Fuerza de trabajo de un operario en un mes en el periodo t in T*/

/*VARIABLES DE DESICIÓN*/
/*Variables del problema*/
var Req_Prod{T}>=0,integer;/*Requerimiento de producción en el periodo t in T*/
var H{T}>=0,integer;/*Número de trabajadores a contratar reales en el periodo t in T*/
var F{T}>=0,integer;/*Número de trabajadores a despedir reales en el periodo t in T*/
var W{I}>=0,integer;/*Número de reales en el periodo i in I*/
var W_Extras{T}>=0,integer;/*Número de trabajadores extra a contratar en el periodo t in T*/
var P_Antiguos{T}>=0,integer;/*Cantidad de producción de los trabajadores antiguos en el periodo t in T*/
var P_Contratados{T}>=0,integer;/*Cantidad de producción de los trabajadores contratados en el periodo t in T*/
var P_Extras{T}>=0,integer;/*Cantidad de producción de los trabajadores extra en el periodo t in T*/
var P_Total{T}>=0;/*Cantidad de producción total en el periodo t in T*/
var Desechados{T}>=0,integer;/*Cantidad de inventario desechado en el periodo t in T*/
var Faltantes{I},integer>=0;/*Cantidad de faltantes de demanda en el periodo t in T*/
var Inv_Final{I},integer>=0;/*Inventario final en el periodo i in I*/

/*Variables auxiliares*/
var ALPHA{T},binary;/*1 Si Conntrato;0 dlc*/
var BETA{T},binary;/*1 Si Despido>P_Total[t];0 dlc*/
var MIU{T},binary;/*1 Si Req_Prod[t]>P_Total[t];0 dlc*/
var EPSILON{T},binary;/*1 Si H_Real[t]<>0;0 dlc*/
var GAMMA{T},binary;/*1 Si P_Total[t]<8000;0 dlc*/
var Costo_Prod{T},integer>=0;
var SIGMA{T},binary;/*1 Si Inv_Final[t]<3000;0 dlc*/
var Costo_Alm{T},integer>=0;

/*Variables de costos*/
var Ganancias>=0;
var Costo_Mano_de_Obra>=0;
var Costo_de_Contratar>=0;
var Costo_fijo_de_Contratar>=0;
var Costo_de_Despedir>=0;
var Costo_de_produccion_Extras>=0;
var Costo_variable_de_produccion>=0;
var Costo_de_Faltantes>=0;
var Costo_de_Almacenamiento>=0;
var Costo_de_Cajas_Desechadas>=0;
var Costo_de_Subcontratacion>=0;
var Costos_Totales>=0;

/*FUNCIÓN OBJETIVO*/
maximize FO: Ganancias - Costos_Totales;


/*RESTRICCIONES*/
/*Costos*/
s.t. r0:Ganancias=sum{t in T}8100*P_Total[t];
s.t. r1:Costos_Totales=Costo_Mano_de_Obra + Costo_de_Contratar + Costo_fijo_de_Contratar + Costo_de_Despedir + Costo_de_produccion_Extras + Costo_variable_de_produccion + Costo_de_Faltantes + Costo_de_Almacenamiento + Costo_de_Cajas_Desechadas + Costo_de_Subcontratacion;

s.t. r2:Costo_Mano_de_Obra=sum{t in T}3000*10*DIAS_HAB[t]*W[t];
s.t. r3:Costo_de_Contratar=sum{t in T}500000*H[t];
s.t. r4:Costo_fijo_de_Contratar=sum{t in T}1245000*EPSILON[t];
s.t. r5:Costo_de_Despedir=sum{t in T}900000*F[t];
s.t. r6:Costo_de_produccion_Extras=sum{t in T}600*P_Extras[t];
s.t. r7:Costo_variable_de_produccion=sum{t in T}Costo_Prod[t];
s.t. r8:Costo_de_Faltantes=sum{t in T}4200*Faltantes[t];
s.t. r9:Costo_de_Almacenamiento=sum{t in T}Costo_Alm[t];
s.t. r10:Costo_de_Cajas_Desechadas=sum{t in T}3000*Desechados[t];
s.t. r11:Costo_de_Subcontratacion=7850*Faltantes[6];


/*Inicialización*/
s.t. res1:Inv_Final[0]=4200;
s.t. res2:W[0]=80;
s.t. res3:Faltantes[0]=0;

/*Requerimiento de producción, Desechados y W_Estimado*/
s.t. res4{t in T}:Desechados[t]>=0.1*Inv_Final[t-1];
s.t. res5{t in T}:Desechados[t]<=0.1*Inv_Final[t-1]+0.9999;
s.t. res6{t in T}:Req_Prod[t]=DEMANDA[t]-(Inv_Final[t-1]-Desechados[t])+Faltantes[t-1];

/*Mano de obra*/
s.t. res7{t in T}:W[t]=W[t-1]+H[t]-F[t];
s.t. res8{t in T}:W[t]<=110;
s.t. res9{t in T}:W[t]>=10;
s.t. res10{t in T}:F[t]<=0.2*W[t-1];
s.t. res12{t in T}:H[t]<=10000*ALPHA[t];
s.t. res13{t in T}:F[t]<=10000*BETA[t];
s.t. res14{t in T}:ALPHA[t]+BETA[t]<=1;

/*Trabajadores Extras*/
s.t. res15{t in T}:W_Extras[t]<=5;

/*Tasa de trabajo*/
s.t. res16{t in T}:P_Antiguos[t]=Kn[t]*(W[t]-H[t]);
s.t. res17{t in T}:P_Contratados[t]=Kn[t]*H[t]/2;
s.t. res18{t in T}:P_Extras[t]=Kn[t]*W_Extras[t];
s.t. res19{t in T}:P_Total[t]=P_Antiguos[t]+P_Contratados[t]+P_Extras[t];

/*Faltantes e Inventario final*/
s.t. res38{t in T}:100000*MIU[t]<=100000+(Req_Prod[t]-P_Total[t]);
s.t. res39{t in T}:100000*MIU[t]>=Req_Prod[t]-P_Total[t];
s.t. res40{t in T}:Faltantes[t]<=Req_Prod[t]-P_Total[t]+1000000*(1-MIU[t]);
s.t. res41{t in T}:Faltantes[t]<=0+1000000*(MIU[t]);
s.t. res42{t in T}:Faltantes[t]>=Req_Prod[t]-P_Total[t]-1000000*(1-MIU[t]);
s.t. res43{t in T}:Faltantes[t]>=0-1000000*(MIU[t]);

s.t. res46{t in T}:Inv_Final[t]<=P_Total[t]-Req_Prod[t]+1000000*(MIU[t]);
s.t. res47{t in T}:Inv_Final[t]<=0+1000000*(1-MIU[t]);
s.t. res48{t in T}:Inv_Final[t]>=P_Total[t]-Req_Prod[t]-1000000*(MIU[t]);
s.t. res49{t in T}:Inv_Final[t]>=0-1000000*(1-MIU[t]);

s.t. res4677{t in T}:Inv_Final[t]<=5000;

/*Costo fijo de Contratar*/
s.t. res50{t in T}:EPSILON[t]<=H[t];
s.t. res51{t in T}:10000*EPSILON[t]>=H[t];

/*Costo de produccion*/
s.t. res52{t in T}:100000*GAMMA[t]<=100000+(80000-P_Total[t]);
s.t. res53{t in T}:100000*GAMMA[t]>=80000-P_Total[t];
s.t. res54{t in T}:Costo_Prod[t]<=700*P_Total[t]+1000000000*(1-GAMMA[t]);
s.t. res55{t in T}:Costo_Prod[t]<=550*P_Total[t]+1000000000*(GAMMA[t]);
s.t. res56{t in T}:Costo_Prod[t]>=700*P_Total[t]-1000000000*(1-GAMMA[t]);
s.t. res57{t in T}:Costo_Prod[t]>=550*P_Total[t]-1000000000*(GAMMA[t]);

/*Costo de almacenamiento*/
s.t. res58{t in T}:100000*SIGMA[t]<=100000+(3000-Inv_Final[t]);
s.t. res59{t in T}:100000*SIGMA[t]>=3000-Inv_Final[t];
s.t. res60{t in T}:Costo_Alm[t]<=500*3000+650*(Inv_Final[t]-3000)+1000000000*(SIGMA[t]);
s.t. res61{t in T}:Costo_Alm[t]<=500*Inv_Final[t]+1000000000*(1-SIGMA[t]);
s.t. res62{t in T}:Costo_Alm[t]>=500*3000+650*(Inv_Final[t]-3000)-1000000000*(SIGMA[t]);
s.t. res63{t in T}:Costo_Alm[t]>=500*Inv_Final[t]-1000000000*(1-SIGMA[t]);
solve;


printf: "\n";
printf: "\n";
printf: "\-------------------------------------\n";
printf: "\       SOLUCIÓN DEL EJERCICIO\n";
printf: "\       ---------------------- \n";
printf: "\GANANCIAS TOTALES: "&FO&"\n";
printf: "\n";
printf: "Ganancias:"&Ganancias&"\n";
printf: "Costos totales:"&Costos_Totales&"\n";
printf: "\n";
printf: "\Costo de Mano de Obra: "&Costo_Mano_de_Obra&"\n";
printf: "\Costo de Contratar: "&Costo_de_Contratar&"\n";
printf: "\Costo fijo de Contratar: "&Costo_fijo_de_Contratar&"\n";
printf: "\Costo de Despedir: "&Costo_de_Despedir&"\n";
printf: "\Costo de produccion de Extras: "&Costo_de_produccion_Extras&"\n";
printf: "\Costo variable de produccion: "&Costo_variable_de_produccion&"\n";
printf: "\Costo de Faltantes: "&Costo_de_Faltantes&"\n";
printf: "\Costo de Almacenamiento: "&Costo_de_Almacenamiento&"\n";
printf: "\Costo de Cajas Desechadas: "&Costo_de_Cajas_Desechadas&"\n";
printf: "\Costo de Subcontratacion: "&Costo_de_Subcontratacion&"\n";
printf: "\n";

printf: "------- Periodo 0 -------\n";
printf: "Número de trabajadores:"&W[0]&"\n";
printf: "Inventario final:"&Inv_Final[0]&"\n";
printf: "Faltantes:"&Faltantes[0]&"\n";
printf: "\n";
for{t in T}{
printf: "------- Periodo "&t&" -------\n";
printf: "Requerimiento de producción:"&Req_Prod[t]&"\n";
printf: "Contratados:"&H[t]&"\n";
printf: "Despedidos:"&F[t]&"\n";
printf: "Trabajadores Extras:"&W_Extras[t]&"\n";
printf: "Número de trabajadores:"&W[t]&"\n";
printf: "Prod. Antiguos:"&P_Antiguos[t]&"\n";
printf: "Prod. Contratados:"&P_Contratados[t]&"\n";
printf: "Prod. Extras:"&P_Extras[t]&"\n";
printf: "Prod.Total:"&P_Total[t]&"\n";
printf: "Desechados:"&Desechados[t]&"\n";
printf: "Faltantes:"&Faltantes[t]&"\n";
printf: "Inventario Final:"&Inv_Final[t]&"\n";
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

data;

param DEMANDA:=
1 84300
2 84193
3 83977
4 82039
5 81524
6 82984;

param DIAS_HAB:=
1 25
2 25
3 17
4 21
5 17
6 20;


end;