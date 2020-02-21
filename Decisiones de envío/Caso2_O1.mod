/*Conjuntos*/
set I;/*Filas y Columnas*/
set P;/*Plantas*/


/*Declaracion de los parametros*/
param Costo_const {i in I,j in I}; /*Costo de construír en el punto i,j*/
param Demanda {i in I,j in I}; /*Demanda en el punto i,j*/
param Dist_Planta1{i in I,j in I}:=sqrt((j*sqrt(10))^2+(abs(i-3.5)*sqrt(10))^2); /*Distancia de la planta 1 al punto i,j*/
param Dist_Planta2{i in I,j in I}:=sqrt(((7-j)*sqrt(10))^2+(abs(i-3.5)*sqrt(10))^2); /*Distancia de la planta 2 al punto i,j */
param Dist{i in I,j in I,h in I,k in I}:=sqrt(((h-i)*sqrt(10))^2+((k-j)*sqrt(10))^2); /*Distancia de la planta 2 al punto i,j */
param A{i in I,j in I,h in I,k in I}:= if (abs(i-h)<=1 and abs(j-k)<=1) then 1 else 0;

table tabla IN "CSV" "Costo.csv": [Fila,Columna], Costo_const~CostoConstruccion;
table tabla IN "CSV" "Demanda.csv": [Fila,Columna], Demanda~Demanda;


/*Declaracion de la variable*/
var M{i in I,j in I },  binary; /*Si decido abrir un centro de distribucióon en el punto i,j*/
var x{i in I,j in I,p in P}, binary;/*Si decido enviarle desde la planta p al centro de distribución en el punto i,j*/
var z{i in I,j in I,h in I,k in I}, >= 0, integer; /*Cantidad de bolsas a enviar desde el centro de distribución i,j a la tienda h,k*/
var y{i in I,j in I, p in P}, integer, >= 0; /*Cantidad de bolsas a enviar desde la planta p al centro de distribución en el punto i,j*/
  
/*Funcion Objetivo*/
minimize Z: sum{i in I,j in I } M[i,j]*Costo_const[i,j]+(5/10)*sum{i in I,j in I,h in I,k in I} z[i,j,h,k]*Dist[i,j,h,k]+(5/10)*sum{i in I,j in I} y[i,j,1]*Dist_Planta1[i,j]+(5/10)*sum{i in I,j in I} y[i,j,2]*Dist_Planta2[i,j];

/*Restricciones*/ 
s.t. res1 {i in I,j in I,h in I,k in I}:z[i,j,h,k]<=A[i,j,h,k]*10000 ; 
s.t. res2 {h in I,k in I}:sum{i in I,j in I}z[i,j,h,k]=Demanda[h,k] ; 
s.t. res3 {i in I,j in I}:2* M[i,j]>= x[i,j,1]+ x[i,j,2]; 
s.t. res4 {i in I,j in I}: M[i,j]<= x[i,j,1]+ x[i,j,2] ; 
s.t. res5 : sum{i in I,j in I,h in I,k in I} z[i,j,h,k]=sum{i in I,j in I} Demanda[i,j] ;
s.t. res6 {i in I,j in I,p in P}: 10000*x[i,j,p]>=y[i,j,p];
s.t. res7 {i in I,j in I,p in P}: x[i,j,p]<=y[i,j,p];
s.t. res8 {i in I,j in I}: sum{h in I,k in I} z[i,j,h,k]<= sum{p in P} y[i,j,p];
s.t. res9 {i in I,j in I,h in I,k in I}: z[i,j,h,k]<=10000*M[i,j];

solve;


printf: "\nLUGARES DONDE HAY QUE ABRIR CENTRO DE DISTRIBUCIÓN\n";
for{i in I,j in I: M[i,j]<>0}{
		printf: "("&i&","&j&")\n";
}

printf: "\nCANTIDADES A ENVIAR DESDE (3,3)\n";
for{h in I,k in I}{
		printf: "Cantidad de (3,3) a ("&h&","&k&"):" &z[3,3,h,k]&"\n";
}



data;
set I:= 1  2  3  4  5  6;
set P:= 1  2  ;



end;
