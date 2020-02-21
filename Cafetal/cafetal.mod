/*Conjuntos*/
set I; /*Cafetales*/
set J; /* Hermanos*/
set C; /* Cooperativa*/
set K; /* Días*/


/*Parámetros*/
param A {j in J}; /*Capacidad de recolección del hermano I*/
param B:=12000; /*Costo de procesar un kg*/
param E{i in I}; /*Capacidad de producción de I*/
param F:=2000; /*Costo de merma por un kg*/
param P {i in I}; /*Porcentaje de merma del cafatlal I*/
param H{i in I,j in J}; /*1 si el hermano J puede cosechae en el cafetal I*/
param L{c in C,k in K}; /*Precio de compra del café de la cooperativa C en el día K*/
param M{j in J, c in C}; /*Cantidad límite que vende el hermano J a la cooperativa C*/
param N {c in C}; /*Capacidad del costal en la cooperativa c in C*/
param O :=500; /*Costo de costal*/


/*Variables*/
var x{i in I,j in J,k in K},>=0;/*Cantidad de café en g cosechado I por el hermano J en el día K*/
var y{j in J,c in C,k in K},>=0;/*Cantidad de café vendido en g por el hemano J a la cooperatva C en el día K*/
var z{c in C},>=0,integer;/*Cantidad de costales usados para la cooperativa C*/


/*Funcion Objetivo*/
maximize Z: sum{j in J,c in C,k in K} y[j,c,k]*L[c,k]-sum{i in I,j in J,k in K} x[i,j,k]*(B/1000)-sum{i in I,j in J,k in K} x[i,j,k]*(F/1000)*(P[i]/100)-sum{c in C} z[c]*O; 


/*Restricciones*/ 
s.t. res1{j in J,k in K}:sum{i in I} x[i,j,k]<=A[j];
s.t. res2{i in I}:sum{j in J,k in K} x[i,j,k]<=E[i] ; 
s.t. res3{i in I,j in J,k in K}: x[i,j,k]<=10000000*H[i,j] ;
s.t. res4{j in J,k in K}: sum{c in C} y[j,c,k]<=sum{i in I} x[i,j,k]*(1-(P[i]/100)); 
s.t. res5{j in J,c in C,k in K}: y[j,c,k]<=M[j,c]; 
s.t. res6{c in C}:z[c]*N[c]=sum{j in J,k in K} y[j,c,k];

s.t. res7{j in J,a in J:a<>j}: (sum{i in I,k in K} x[i,j,k])/A[j]=(sum{i in I,k in K} x[i,a,k])/A[a];

s.t. res8:sum{j in J,k in K} y[j,1,k]<=0.8*sum{j in J,k in K} y[j,2,k];

data;

set I:= 1  2  3  4  5 ;/*Catuai,Arabiga, Caturra, Bourbón, Pache*/
set J:= 1  2  3  4  5;/*José, Pedro, Felipe, Martín, Santiago*/
set C:= 1  2;/*Grano Fino, Kaldai*/
set K:= 1  2  3  4  5  6  7;

param A := 
1	20000
2	35000
3	19000
4	26000
5	30000;

param E := 
1	200000
2	250000
3	180000
4	260000
5	100000;

param P := 
1	2.2
2	3
3	2.3
4	2.6
5	2.3;

param H :	1		2		3		4		5:= 
		1	1		1		1		1		1
		2	1		1		1		1		0
		3	1		1		1		1		0
		4	0		1		0		1		1
		5	1		0		0		1		1;

param L:	1		2		3		4		5		6		7:= 
		1	6000		7000		6000		9000		6000		7000		8000
		2	8000		6000		7000		8000		5000		9000		8000;

param M :	1		2:= 
		1	15000		30000
		2	25000		30000
		3	30000		15000
		4	10000		30000
		5	40000		25000;

param N := 
1	10000
2	12000;
end;
