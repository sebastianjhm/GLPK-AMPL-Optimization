/*Valor mínimo de un vector*/

/*Conjuntos*/
set I:={1,2,3,4,5,6,7,8,9,10};

/*Parámatros*/
param Datos{I};

/*Variables*/
var x{I};/*Vector inicial*/
var menor;
var miu{I},binary;
var psi{I};
var alpha{I,I}, binary;
var y{I};
/*Sin función objetivo*/

/*Restricciones*/
s.t. res1{i in I}:x[i]=Datos[i];
s.t. res2{i in I,j in I}:1111*alpha[i,j]<=1111+(x[i]-x[j]);
s.t. res3{i in I,j in I}:1111*alpha[i,j]>=(x[i]-x[j]);
s.t. res4{i in I}: psi[i]=sum{j in I}alpha[i,j];
s.t. res5{i in I}: miu[i]<=psi[i];
s.t. res6{i in I}: 1111*miu[i]>=psi[i];
s.t. res7{i in I}: menor<=x[i]+1111*miu[i];
s.t. res8{i in I}: menor>=x[i]-1111*miu[i];

data;
param Datos:=
1	15
2	4
3	5
4	87
5	7
6	12
7	14
8	8
9	9
10	44;


end;