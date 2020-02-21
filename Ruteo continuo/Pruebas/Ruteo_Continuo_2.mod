/*RUTEO CONTINUO*/

/*Conjuntos*/
set I:={0,1,2,3,4,5};
set R:={1,2,3,4,5};

/*Parámatros*/
param Dist{I,I};

/*Variables*/
var x{I,I},binary;/*Si voy del punto i in I al punto j in I*/
var y{I,I},binary;/*Si visito en punto i in I en la posición j in I*/
var w{R};/*Indicador de la ruta r in R. 10 por el nodo de llegada mas el nodo de partida*/
var z{R,I,I};/*Indicador. 0 si la ruta r in R va de i in I a j in I*/
var BETA{R,I,I},binary;/*1 si z[r,i,j]>0; 0 de lo contrario*/
var A{R,I,I};/*valor absoluto de z[r,i,j]*/
var ALPHA{R,R,I,I},binary;/*1 Si A[r1,i,j]>A{r2,i,j].0 dlc */
var PSI{R,I,I};/*Número A[r2,i,j] mayores a A{r1,i,j]*/
var MIU{R,I,I},binary;/*1 Si no es el menor A[r,i,j]. 0 dlc*/
var MENOR{I,I};/*Número menor*/
var M{I,I};/*Número menor*/
var aux{I,I},binary;

/*Función Objetivo*/
minimize FO:sum{i in I,j in I}Dist[i,j]*x[i,j];

/*Restricciones*/
s.t. res1:y[0,0]=1;
s.t. res2:y[3,1]=1;
s.t. res3:y[2,2]=1;
s.t. res4:y[4,3]=1;
s.t. res5:y[5,4]=1;
s.t. res6:y[1,5]=1;

s.t. res881:sum{k in I}k*x[0,k]=sum{k in I}k*y[k,1];



s.t. res111{i in I}:sum{j in I}y[i,j]=1;
s.t. res222{j in I}:sum{i in I}y[i,j]=1;
s.t. res444:sum{k in I}k*x[k,0]=sum{k in I}k*y[k,5];
s.t. res555{i in I}:sum{j in I}x[i,j]=1;
s.t. res777{j in I}:sum{i in I}x[i,j]=1;

s.t. res7{r in R}:w[r]=10*sum{k in I}k*y[k,r]+sum{k in I}k*y[k,r-1];
s.t. res8{r in R,i in I,j in I:j<>i}:z[r,i,j]=1-((w[r])/(10*j+i));
s.t. res9{r in R,i in I}:z[r,i,i]=1;

s.t. res10{r in R,i in I,j in I}:100*BETA[r,i,j]<=100+z[r,i,j];
s.t. res11{r in R,i in I,j in I}:100*BETA[r,i,j]>=z[r,i,j];
s.t. res12{r in R,i in I,j in I}:A[r,i,j]<=z[r,i,j]+1000*(1-BETA[r,i,j]);
s.t. res13{r in R,i in I,j in I}:A[r,i,j]>=z[r,i,j]-1000*(1-BETA[r,i,j]);
s.t. res14{r in R,i in I,j in I}:A[r,i,j]<=-z[r,i,j]+1000*(BETA[r,i,j]);
s.t. res15{r in R,i in I,j in I}:A[r,i,j]>=-z[r,i,j]-1000*(BETA[r,i,j]);

s.t. res16{i in I,j in I,r1 in R,r2 in R:r2<>r1}:100*ALPHA[r1,r2,i,j]<=100+(A[r1,i,j]-A[r2,i,j]);
s.t. res17{i in I,j in I,r1 in R,r2 in R:r2<>r1}:100*ALPHA[r1,r2,i,j]>=A[r1,i,j]-A[r2,i,j];
s.t. res333{r in R,i in I,j in I}:ALPHA[r,r,i,j]=0;
s.t. res18{r1 in R,i in I,j in I}:PSI[r1,i,j]=sum{r2 in R}ALPHA[r1,r2,i,j];
s.t. res19{r in R,i in I,j in I}:MIU[r,i,j]<=PSI[r,i,j];
s.t. res20{r in R,i in I,j in I}:100*MIU[r,i,j]>=PSI[r,i,j];
s.t. res21{r in R,i in I,j in I}:MENOR[i,j]<=A[r,i,j]+100*MIU[r,i,j];
s.t. res22{r in R,i in I,j in I}:MENOR[i,j]>=A[r,i,j]-100*MIU[r,i,j];

s.t. res23{i in I,j in I}:100*M[i,j]=MENOR[i,j];
s.t. res24{i in I,j in I:j<>i}:aux[i,j]<=10000*M[i,j];
s.t. res25{i in I,j in I:j<>i}:aux[i,j]>=M[i,j];

s.t. res27{i in I}:aux[i,i]=1;
s.t. res28{i in I,j in I:j<>0}:x[i,j]=1-aux[i,j];

solve;
printf: "\n";
printf: "\n";
printf: "\-------------------------------------\n";
printf: "\       SOLUCIÓN DEL EJERCICIO\n";
printf: "\       ---------------------- \n";
printf: "\Distancia Total: "&FO&"\n";
printf: "\n";
printf: "\Posiciones del recorrido\n";
printf: "\------------------------\n";
for{j in I}{
	for {i in I:y[i,j]=1}{
		printf: "En la posición "&j&" el nodo:"&i;
}
printf: "\n";
}
printf: "\n";
printf: "\De que nodo a que nodo\n";
printf: "\------------------------\n";
for{i in I}{
	for {j in I:x[i,j]=1}{
		printf: "Del nodo "&i&" al nodo "&j&"\n";
}
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

param Dist:	0	1	2	3	4	5:=
		0	0	8	7	4	18	9
		1	8	0	5	3	2	1
		2	7	5	0	8	4	3
		3	4	6	2	0	4	5
		4	18	2	7	5	0	3
		5	9	3	8	6	1	0;

end;