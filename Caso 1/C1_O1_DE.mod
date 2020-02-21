/*Declaracion de los conjuntos*/
set I; /* Tipos de computadores*/
set J; /* Puntos de venta*/
set K; /* Componentes de computador*/
set L; /* Plantas*/
set Q; /* Proveedores*/
set B; /* Bodegas*/
set S; /* Semanas*/


/*Declaracion de los parametros*/
param Comp {i in I, k in K}; /*Cantidad de componentes del tipo k para fabricari*/
param Costo{i in I, l in L}; /* Costo de fabricar el computador i en la planta l */
param Capac {i in I, l in L}; /* Coantidad máxima de fabricacion del computador i en la planta l */
param M{k in K, q in Q}; /* Coantidad máxima  de componentes k que puede fabricar el proveedor q */
param P{k in K, q in Q}; /* Precio del componente k al que vente el fabricante q */
param C1{l in L, j in J}; /* Costo de ir de la planta l al punto de venta j */
param C2{l in L, b in B}; /* Costo de ir de la planta l a la bodega b */
param C3{b in B, j in J}; /* Costo de ir de la bodega b al punto de venta j */
param LE{i in I, s in S}; /* Demanda de la Esmeralda del pc i en la semana s*/
param ED{i in I, s in S}; /* Demanda de El Dorado del pc i en la semana s */
param TE{i in I, s in S}; /* Demanda del Tquendama del pc i en la semana s */
param PV{i in I}; /* Precio de venta del pc i*/
param V{i in I}; /* Volumen del pc i*/
param CA{b in B}; /* costo de almacenamiento de la bodega b*/
param CMA{b in B}; /* capacidad máxima de almacenamiento de la bodega b*/

table tabla IN "CSV" "Comp.csv": [x,y], Comp~z;
table tabla IN "CSV" "Costo.csv": [x,y], Costo~z;
table tabla IN "CSV" "Capac.csv": [x,y], Capac~z;
table tabla IN "CSV" "M.csv": [x,y], M~z;
table tabla IN "CSV" "P.csv": [x,y], P~z;
table tabla IN "CSV" "C.csv": [x,y], C1~z;
table tabla IN "CSV" "C2.csv": [x,y], C2~z;
table tabla IN "CSV" "C3.csv": [x,y], C3~z;
table tabla IN "CSV" "LE.csv": [x,y], LE~z;
table tabla IN "CSV" "ED.csv": [x,y], ED~z;
table tabla IN "CSV" "TE.csv": [x,y], TE~z;
table tabla IN "CSV" "PV.csv": [x], PV~y;
table tabla IN "CSV" "V.csv": [x], V~y;
table tabla IN "CSV" "CA.csv": [x], CA~y;
table tabla IN "CSV" "CMA.csv": [x], CMA~y;

display Comp,Capac,Costo,M,P,C1,C2,C3,LE,ED,TE,PV,V,CA,CMA;
/*Declaracion de la variable*/
var x{i in I, k in K, q in Q, s in S }, >= 0; /* Cantidad del componente k para el pc i comprados al proveedor q en la semana s*/
var y{i in I, s in S }, >= 0; /* Cantidad a producir del pc i en la semana s*/
var z{i in I, l in L, s in S}, >= 0; /* Cantidad a producir del pc i en la planta l en la semana s*/
var d{i in I, l in L, j in J, s in S }, >= 0; /* Cantidad enviada del pc i desde la planta l al punto de venta j en la semana s*/
var w{i in I, l in L, b in B, s in S }, >= 0; /* Cantidad enviada del pc i desde la planta l al punto de venta j en la semana s*/
var t{i in I, b in B, j in J, s in S }, >= 0; /* Cantidad enviada del pc i desde la planta l al punto de venta j en la semana s*/
var bod{i in I, b in B, s in S }, >= 0; /* Cantidad que hay del pc i en la bodega b en la semana s*/
var h{i in I, j in J, s in S}, >= 0; /* Cantidad enviada del pc i hasta la planta j en la semana s*/

/*Funcion Objetivo*/
maximize Z: sum{i in I, j in J, s in S} h[i,j,s]*PV[i]-sum{i in I, l in L, s in S} z[i,l,s]*Costo[i,l]-sum{i in I, k in K, q in Q, s in S }x[i,k,q,s]*P[k,q]-sum{i in I, l in L, j in J, s in S }d[i,l,j,s]*C1[l,j]*V[i]-sum{i in I, l in L, b in B, s in S }w[i,l,b,s]*C2[l,b]*V[i]-sum{i in I, b in B, j in J, s in S }t[i,b,j,s]*C3[b,j]*V[i]-sum{i in I, b in B, s in S }bod[i,b,s]*CA[b]*V[i]; 


/*Restricciones*/
s.t. res1 {i in I, k in K, s in S }: sum{q in Q} x[i,k,q,s]=Comp[i,k]*y[i,s]; 
s.t. res2 {i in I, s in S }: y[i,s]=sum{l in L} z[i,l,s];
s.t. res3 {i in I, l in L, s in S }: z[i,l,s]<=Capac[i,l]; 
s.t. res4 {k in K, q in Q, s in S }: sum{i in I} x[i,k,q,s]<=M[k,q]; 
s.t. res5 {i in I, b in B, s in S: s>=2}: bod[i,b,s]=bod[i,b,s-1]+sum{l in L} w[i,l,b,s]-sum{j in J} t[i,b,j,s]; 
s.t. res6 {i in I, b in B}: bod[i,b,1]=sum{l in L} w[i,l,b,1]-sum{j in J}t[i,b,j,1]; 
s.t. res7 {b in B, s in S}: sum{i in I} bod[i,b,s]*V[i]<=CMA[b]; 
s.t. res8 {i in I,j in J, s in S}: h[i,j,s]=sum{b in B}t[i,b,j,s]+sum{l in L}d[i,l,j,s];
s.t. res9 {i in I,s  in S}: h[i,1,s]=LE[i,s];
s.t. res10 {i in I,s  in S}: h[i,2,s]=ED[i,s];
s.t. res11 {i in I,s  in S}: h[i,3,s]=TE[i,s];
s.t. res12 {i in I,l in L, s in S}: z[i,l,s]=sum{b in B}w[i,l,b,s]+sum{j in J}d[i,l,j,s];

solve;
data;
set I:= 1  2  3  4  5;
set J:= 1  2  3;
set K:= 1   2   3   4   5   6   7   8   9   10   11   12  13  14;
set L:= 1  2  3  4;
set Q:= 1  2  3  4  5  6  7  8;
set B:= 1  2  3;
set S:= 1   2   3   4   5   6   7   8   9   10   11   12;

end;


