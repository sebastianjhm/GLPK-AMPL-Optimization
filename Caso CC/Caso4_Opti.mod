/*CUARTO CASO OPTIMIZACIÓN*/

/*Conjuntos*/
set R:={1,2,3};/*Referencias*/
set C:={1,2,3,4,5,6,7,8,9,10};/*Ciudades*/
set B:={1,2,3,4,5,6,7};/*Bodegas*/
set T:={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24};/*Periodos*/
set P:={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18};/*Puntos de ventas*/
set BOT:={1,2,3};/*Botones*/
set TELAS:={1,2,3};/*Telas*/

/*Parámetros*/
param Q{B};/*Capacidad bodega*/
param S{R};/*Capacidad de producción de cada referencia en fabrica*/
param F{B};/*Costo de arrendar Bodega*/
param Trans_Bod{B,P};/*Costo de transportar desde la bodega al punto de venta*/
param Trans_Fab{B};/*Costo de transportar desde la fabrica a la bodega*/
param PL{R};/*Costo de produccion referencias*/
param d{R,P};/*Demanda por referencia y por punto de venta*/
param Prec_Bot{BOT};/*Precio Botones*/
param Prec_Tel{TELAS};/*Precio Telas*/

table tabla IN "CSV" "Capacidad_Bodega.csv": [a], Q~b;
table tabla IN "CSV" "Capacidad_Produccion.csv": [a], S~b;
table tabla IN "CSV" "Costo_Arrendar.csv": [a], F~b;
table tabla IN "CSV" "Costo_Bod_PVenta.csv": [a,b], Trans_Bod~c;
table tabla IN "CSV" "Costo_Fab_Bod.csv": [a], Trans_Fab~b;
table tabla IN "CSV" "Costo_Produccion.csv": [a], PL~b;
table tabla IN "CSV" "Demanda.csv": [a,b], d~c;
table tabla IN "CSV" "Precio_Botones.csv": [a], Prec_Bot~b;
table tabla IN "CSV" "Precio_Tela.csv": [a], Prec_Tel~b;

/*Variables*/
var x{R,T},>=0; /*cantidad que produzco de la referencia r en el periodo T*/
var y{B,T},binary;/*1 si arriendo la bodega en el periodo T*/
var M{B,R,T},>=0;/*cuanto le envio desde la fabrica a cada bodega de la referencia R*/
var w{B,P,R,T},>=0;/*cuanto envío desde la bodega B al punto de venta P de la referencia R en el periodo T*/
var U{B,P,T},>=0;
var Beta{B,P,T}, binary;/*1 si voy a enviar desde la bodega B al punto de venta P en el periodo T*/
var z_BOT{BOT,T},>=0;/*Variables*/  
var z_TELAS{TELAS,T},>=0;/*Variables*/ 

/*Función objetivo*/
minimize Z: sum{b in B,t in T}y[b,t]*F[b]+sum{b in B, t in T}y[b,t]*Trans_Fab[b]+sum{b in B,p in P,t in T}y[b,t]*Trans_Bod[b,p]+sum{r in R,t in T}PL[r]*x[r,t]+sum{bot in BOT,t in T}Prec_Bot[bot]*z_BOT[bot,t]+sum{tela in TELAS,t in T}Prec_Tel[tela]*z_TELAS[tela,t];


/*Restricciones*/
s.t. res1{r in R,b in B,t in T}:M[b,r,t]<=Q[b];
s.t. res2{r in R,t in T}:x[r,t]<=S[r];
s.t. res3{r in R, p in P, t in T}: sum{b in B}w[b,p,r,t]>=d[r,p];
s.t. res4{b in B,r in R,t in T}:sum{p in P}w[b,p,r,t]=M[b,r,t];
s.t. res5{r in R,t in T}:sum{b in B}M[b,r,t]=x[r,t];
s.t. res8{b in B, r in R,t in T}:M[b,r,t]<=100000*y[b,t];
s.t. res9{t in T}:z_BOT[1,t]=8*x[2,t];
s.t. res10{t in T}:z_BOT[2,t]=6*x[3,t];
s.t. res11{t in T}:z_BOT[3,t]=8*x[1,t];
s.t. res12{t in T}:z_TELAS[1,t]=3.1*x[2,t];
s.t. res13{t in T}:z_TELAS[2,t]=2.7*x[1,t];
s.t. res14{t in T}:z_TELAS[3,t]=2.1*x[3,t];
solve;

end;










