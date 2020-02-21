/*Indicadores*/

/*Conjuntos*/
set I:={0,1,2,3,4};
set R:={1,2,3,4};

/*Parámatros*/
param Datos{R};

/*Variables*/
var w{R};/*Vector inicial*/
var z{R,I,I};
var BETA{R,I,I},binary;
var A{R,I,I};

/*Sin función objetivo*/

/*Restricciones*/
s.t. res1{r in R}:w[r]=Datos[r];
s.t. res2{r in R,i in I,j in I:j<>i}:z[r,i,j]=1-((w[r])/(10*j+i));
s.t. res11{r in R,i in I}:z[r,i,i]=1;

s.t. res3{r in R,i in I,j in I}:1111*BETA[r,i,j]<=1111+z[r,i,j];
s.t. res4{r in R,i in I,j in I}:1111*BETA[r,i,j]>=z[r,i,j];
s.t. res5{r in R,i in I,j in I}:A[r,i,j]<=z[r,i,j]+1111*(1-BETA[r,i,j]);
s.t. res6{r in R,i in I,j in I}:A[r,i,j]>=z[r,i,j]-1111*(1-BETA[r,i,j]);
s.t. res7{r in R,i in I,j in I}:A[r,i,j]<=-z[r,i,j]+1111*(BETA[r,i,j]);
s.t. res8{r in R,i in I,j in I}:A[r,i,j]>=-z[r,i,j]-1111*(BETA[r,i,j]);
data;
param Datos:=
1	15
2	4
3	5
4	87;

end;