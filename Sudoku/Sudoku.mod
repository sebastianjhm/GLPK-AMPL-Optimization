/*RESOLUCIÓN PROBLEMA SUDOKU*/

/*Conjuntos*/
set I;/*{1,2,3,4,5,6,7,8,9}*/
set A;/*{1,2,3}*/
set B;/*{4,5,6}*/
set C;/*{7,8,9}*/

table tabla IN "CSV" "I.csv":  I<-[i];
table tabla IN "CSV" "A.csv":  A<-[a];
table tabla IN "CSV" "B.csv":  B<-[b];
table tabla IN "CSV" "C.csv":  C<-[c];

/*Parámatros*/
param M{i in I,j in I,k in I};/*Parámetro Binario. 1 Si el valor inicial de tabla Sudoku en la posición (i in I,j in I) es k in I. 0 si no tiene valor*/ 
table tabla IN "CSV" "M.csv": [a,b,c], M~d;

/*Parámatros*/
var x{i in I,j in I,k in I}, binary;/*1 Si le asigno a la posición (i in I,j in I) de la tabla Sudoku el número k in I; 0 dlc*/
var y{i in I,j in I}, integer;/*Número que se asigna a (i in I,j in I)*/
var suma_diagonal;


/*Sin función objetivo*/

/*Restricciones*/


s.t. res1{i in I,j in I}:sum{k in I}x[i,j,k]=1;/*En cada punto un número*/
s.t. res2{i in I,k in I}: sum{j in I}x[i,j,k]=1;/*En cada fila un número*/
s.t. res3{j in I,k in I}: sum{i in I}x[i,j,k]=1;/*En cada columna un número*/
/*En cuadro un número*/
s.t. res4{k in I}: sum{a1 in A,a2 in A}x[a1,a2,k]=1; 
s.t. res5{k in I}: sum{a in A,b in B}x[a,b,k]=1; 
s.t. res6{k in I}: sum{a in A,c in C}x[a,c,k]=1; 
s.t. res7{k in I}: sum{b in B,a in A}x[b,a,k]=1; 
s.t. res8{k in I}: sum{b1 in B,b2 in B}x[b1,b2,k]=1; 
s.t. res9{k in I}: sum{b in B,c in C}x[b,c,k]=1; 
s.t. res10{k in I}: sum{c in C,a in C}x[c,a,k]=1; 
s.t. res11{k in I}: sum{c in C,b in C}x[c,b,k]=1; 
s.t. res12{k in I}: sum{c1 in C,c2 in C}x[c1,c2,k]=1; 
/*Datos iniciales*/
s.t. res13{i in I,j in I,k in I}: x[i,j,k]>=M[i,j,k];
/*Asignacion y*/
s.t. res14{i in I,j in I}: y[i,j]=sum{k in I}k*x[i,j,k]; 
/*Suma diagonal*/
s.t. res15: suma_diagonal=sum{i in I}y[i,i];

solve;
printf: "\n";
printf: "\n";
printf: "\-------------------------------------\n";
printf: "\       SUDOKU RESUELTO\n";
printf: "\       --------------- \n";
for{i in I}{
	for {j in I}{
		printf: "  "&y[i,j];
}
printf: "\n";
}
printf: "\-------------------------------------\n";
printf: "\n";
printf: "\SUMA DIAGONAL: "&suma_diagonal;
printf: "\n";
printf: "\n";
printf: "\n";
printf: "\n";
printf: "\n";
printf: "\n";

end;