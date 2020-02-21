/*PROYECTO DANIEL ROLANDO RODRÍGUEZ MAYORGA Y KERLY GALINDO MEDINA*/

/*Conjuntos*/
set I:={1,2,3,4};/*Lineas de producto: {Linea personal, Linea de paraguas, Linea de sombrillas, Linea de sombrillas para niños}*/
set M:={1,2,3,4,5,6,7};/*Materias primas: {Tela, cabezas, hilo, mango, recatón, sujetador, forro}*/
set S:={1,2,3,4};/*Semanas*/

/*Parametros*/
param Qmax{M};/*Cantidad  máxima de materia prima  m in M, disponible en la  semana  s in S*/
param Q{I,M};/*Cantidad de materia prima  m in M necesaria para fabricar un producto de la línea  i in I en la semana  s in S*/
param P:=30000000;/*Presupuesto al mes. = $30.000.000 = $7.500.000 a la semana*/
param d{I,S};/*Demanda de productos de la línea  i in I en la semana s in S*/
param C{I};/*Costo de producción de 1 unidad del producto de la línea  i in I en la semana s in S*/
param CA{I};/*Costo de mantener inventario de producto de la línea  i in I en la semana s in S*/
param CP{M};/*Costo de la materia prima m in M necesaria para fabricar un producto de la línea  i in I*/
param I_0{I};/*Inventario inicial del producto de la línea i in I*/
param QP{I};/*Capacidad máxima a producir del producto de la línea i in I en la semana s in S*/
param m{I};/*Cantidad de metros cúbicos que ocupa el producto de la línea i in I*/
param Qbodega:=20000;/*Capacidad de la bodega en metros cúbicos. Se usa para guardar los productos en inventario al final de cada semana s*/
param G{I};/*Precio máximo que un cliente está dispuesto a pagar por una unidad del producto de la línea i in I*/

/*Variables de desicion*/
var x{I,S},>=0;/*Cantidad de productos de la línea  i in I a producir en la semana s in S*/
var y{I,S},>=0;/*antidad de producto de la línea  i in I en inventario al final de la semana s in S*/

/*Funcion Objetivo*/
minimize Z:sum{i in I,s in S}C[i]*x[i,s]+sum{i in I,s in S}CA[i]*y[i,s]+sum{n in M,i in I,s in S}x[i,s]*CP[n];

/*Restricciones*/

s.t. restriccion1{i in I,s in S}: x[i,s]<=QP[i];
s.t. restriccion2{n in M,s in S}: sum{i in I}x[i,s]*Q[i,n]<=Qmax[n];
s.t. restriccion3{i in I,s in S}: x[i,s]>=d[i,s];

s.t. restriccion4{i in I}: y[i,1]=x[i,1]+I_0[i]-d[i,1];
s.t. restriccion5{i in I,s in S:s>1}: y[i,s]=y[i,s-1]+x[i,s]-d[i,s];

s.t. restriccion7{s in S}: sum{i in I}y[i,s]*m[i]<=Qbodega;


data;

param Qmax:=
1	9850
2	60150
3	9500
4	7600
5	9500
6	2000
7	3000;

param QP:=
1	600
2	700
3	550
4	800;

param C:=
1	17000
2	19000
3	22000
4	25000;

param CP:=
1	5520
2	3100
3	4000
4	500
5	2000
6	100
7	900;

param CA:=
1	2000
2	3000
3	2000
4	5000;

param G:=
1	30000
2	45000
3	25000
4	43000;

param m:=
1	0.03
2	0.03
3	0.05
4	0.08;

param d:	1	2	3	4:=
1	200	150	120	200
2	200	150	100	200
3	100	50	60	80
4	100	110	90	120;

param I_0:=
1	1000
2	500
3	2300
4	1200;

param Q:	1	2	3	4	5	6	7:=
1	1	1	2	1	1	1	1
2	1	1	3	1	1	1	1
3	1	1	1	1	1	1	1
4	1	1	1	1	1	1	1;

end;






