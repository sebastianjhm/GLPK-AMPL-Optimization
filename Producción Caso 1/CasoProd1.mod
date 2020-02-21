/*Conjuntos*/
set I:= {0,1,2,3,4,5,6};
set T:={1,2,3,4,5,6};

/*Parametros*/

param DIAS_HAB{T};/*Dias habiles en el mes p*/
param DEMANDA{T};/*Demanda del mes p*/
param Kn{t in T}:=20*DIAS_HAB[t];/*Fuerza de trabajo de un operario en un mes en el periodo t in T*/



/*Variables:*/
var W{I}>=0,integer;/*Número de trbajadores directos en el periodo i in I*/
var H{T}>=0,integer;/*Número de trabajadores a contratar en el periodo t in T*/
var F{T}>=0,integer;/*Número de trabajadores a despedir en el periodo t in T*/
var Inv_Final{I},integer>=0;/*Inventario final en el periodo i in I*/
var Faltantes{I},integer>=0;/*Cantidad de faltantes de demanda en el periodo t in T*/
var Req_Prod{T}>=0,integer;/*Requerimiento de producción en el periodo t in T*/
var P_Antiguos{T}>=0,integer;/*Cantidad de producción de los trabajadores antiguos en el periodo t in T*/
var P_Contratados{T}>=0,integer;/*Cantidad de producción de los trabajadores contratados en el periodo t in T*/
var P_Total{T}>=0;/*Cantidad de producción total en el periodo t in T*/
var Costo_Alm{T},integer>=0;
var Costo_Total_Periodo{T}>=0;/*Costo total del periodo t in T*/
var Ganancia_Periodo{T},>=0;/*Ganancia obtenida en un periodo t in T*/

/*Variables auxiliares*/
var MIU{T},binary;/*1 Si Req_Prod[t]>P_Total[t];0 dlc*/
var ALPHA{T},binary;/*1 Si Conntrato;0 dlc*/
var BETA{T},binary;/*1 Si Despido>P_Total[t];0 dlc*/
var SIGMA{T},binary;/*1 Si Inv_Final[t]<3000;0 dlc*/



/*Variables de costos*/
var Ganancias>=0;
var Costo_Mano_de_Obra>=0;
var Costo_de_Contratar>=0;
var Costo_de_Despedir>=0;
var Costo_de_Faltantes>=0;
var Costo_de_Almacenamiento>=0;
var Costo_de_Produccion>=0;
var Costos_Totales>=0;

/*Funcion Objetivo: */
maximize FO:  Ganancias - Costos_Totales;

/*Sujeto a:*/

s.t. r0:Ganancias=sum{t in T}Ganancia_Periodo[t];
s.t. r00{t in T}:Ganancia_Periodo[t]=10000*(DEMANDA[t]+Faltantes[t-1]-Faltantes[t]);


s.t. r1:Costos_Totales=Costo_Mano_de_Obra + Costo_de_Contratar + Costo_de_Despedir + Costo_de_Produccion + Costo_de_Faltantes + Costo_de_Almacenamiento;

s.t. r2:Costo_Mano_de_Obra=sum{t in T}1500000*(W[t]-H[t])+sum{t in T}900000*H[t];
s.t. r3:Costo_de_Contratar=sum{t in T}1200000*H[t];
s.t. r5:Costo_de_Despedir=sum{t in T}1500000*F[t];
s.t. r8:Costo_de_Faltantes=sum{t in T}6000*Faltantes[t];
s.t. r9:Costo_de_Almacenamiento=sum{t in T}Costo_Alm[t];
s.t. r7:Costo_de_Produccion=sum{t in T}2000*P_Total[t];

s.t. r12{t in T}:Costo_Total_Periodo[t]=(1500000*(W[t]-H[t])+900000*H[t])+(1200000*H[t])+(1500000*F[t])+(6000*Faltantes[t])+(Costo_Alm[t])+(2000*P_Total[t]);

/*Inicialización*/
s.t. res1:Inv_Final[0]=1500;
s.t. res2:W[0]=10;
s.t. res3:Faltantes[0]=0;

/*Requerimiento de producción*/
s.t. res4{t in T}:Req_Prod[t]=DEMANDA[t]-Inv_Final[t-1]+Faltantes[t-1];

/*Mano de obra*/
s.t. res7{t in T}:W[t]=W[t-1]+H[t]-F[t];
s.t. res8{t in T}:W[t]<=25;
s.t. res9{t in T}:W[t]>=5;
s.t. res12{t in T}:H[t]<=10000*ALPHA[t];
s.t. res13{t in T}:F[t]<=10000*BETA[t];
s.t. res14{t in T}:ALPHA[t]+BETA[t]<=1;

/*Tasa de trabajo*/
s.t. res16{t in T}:P_Antiguos[t]=Kn[t]*(W[t]-H[t]);
s.t. res17{t in T}:P_Contratados[t]=Kn[t]*H[t]*0.4;
s.t. res19{t in T}:P_Total[t]=P_Antiguos[t]+P_Contratados[t];

/*Faltantes e Inventario final*/
s.t. res20{t in T}:100000*MIU[t]<=100000+(Req_Prod[t]-P_Total[t]);
s.t. res21{t in T}:100000*MIU[t]>=Req_Prod[t]-P_Total[t];

s.t. res22{t in T}:Faltantes[t]<=Req_Prod[t]-P_Total[t]+1000000*(1-MIU[t]);
s.t. res23{t in T}:Faltantes[t]<=0+1000000*(MIU[t]);
s.t. res24{t in T}:Faltantes[t]>=Req_Prod[t]-P_Total[t]-1000000*(1-MIU[t]);
s.t. res25{t in T}:Faltantes[t]>=0-1000000*(MIU[t]);

s.t. res26{t in T}:Inv_Final[t]<=P_Total[t]-Req_Prod[t]+1000000*(MIU[t]);
s.t. res27{t in T}:Inv_Final[t]<=0+1000000*(1-MIU[t]);
s.t. res28{t in T}:Inv_Final[t]>=P_Total[t]-Req_Prod[t]-1000000*(MIU[t]);
s.t. res29{t in T}:Inv_Final[t]>=0-1000000*(1-MIU[t]);

s.t. res30{t in T}:Inv_Final[t]<=8500;

/*Costo de almacenamiento*/
s.t. res39{t in T}:100000*SIGMA[t]<=100000+(1500-Inv_Final[t]);
s.t. res40{t in T}:100000*SIGMA[t]>=1500-Inv_Final[t];
s.t. res41{t in T}:Costo_Alm[t]<=2000+1800*1500+1000*(Inv_Final[t]-1500)+1000000000*(SIGMA[t]);
s.t. res42{t in T}:Costo_Alm[t]<=1800*Inv_Final[t]+1000000000*(1-SIGMA[t]);
s.t. res43{t in T}:Costo_Alm[t]>=2000+1800*1500+1000*(Inv_Final[t]-1500)-1000000000*(SIGMA[t]);
s.t. res44{t in T}:Costo_Alm[t]>=1800*Inv_Final[t]-1000000000*(1-SIGMA[t]);

solve;


printf: "\n";
printf: "\n";
printf: "\-------------------------------------\n";
printf: "\       SOLUCIÓN DEL EJERCICIO\n";
printf: "\       ---------------------- \n";
printf: "\n";
printf: "\UTILIDAD DEL EJERCICIO: "&FO&"\n";
printf: "\n";
printf: "Ingresos:"&Ganancias&"\n";
printf: "Costos totales:"&Costos_Totales&"\n";
printf: "\n";
printf: "\Costo de Mano de Obra: "&Costo_Mano_de_Obra&"\n";
printf: "\Costo de Contratar: "&Costo_de_Contratar&"\n";
printf: "\Costo de Despedir: "&Costo_de_Despedir&"\n";
printf: "\Costo de produccion: "&Costo_de_Produccion&"\n";
printf: "\Costo de Faltantes: "&Costo_de_Faltantes&"\n";
printf: "\Costo de Almacenamiento: "&Costo_de_Almacenamiento&"\n";
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
printf: "Número de trabajadores:"&W[t]&"\n";
printf: "Prod. Antiguos:"&P_Antiguos[t]&"\n";
printf: "Prod. Contratados:"&P_Contratados[t]&"\n";
printf: "Prod.Total:"&P_Total[t]&"\n";
printf: "Faltantes:"&Faltantes[t]&"\n";
printf: "Inventario Final:"&Inv_Final[t]&"\n";
printf: "Ingreso del periodo:"&Ganancia_Periodo[t]&"\n";
printf: "Costo Total del periodo:"&Costo_Total_Periodo[t]&"\n";
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

param DIAS_HAB:=
1	23
2	19
3	22
4	20
5	23
6	20;

param DEMANDA:=
1	7843
2	7620
3	7676
4	5809
5	5405
6	5711;

end;
