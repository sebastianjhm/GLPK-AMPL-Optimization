/*RESOLUCIÓN PROBLEMA SUDOKU*/

/*Conjuntos*/
set I:={1,2,3,4,5,6,7,8,9};
set A:={1,2,3};
set B:={4,5,6};
set C:={7,8,9};

/*Parámatros*/
param M{i in I,j in I};
param Bin{i in I,j in I}:= if M[i,j]=0 then 0 else 1;

/*Variables*/
var x{i in I,j in I}, integer;/*Número que se asigna a (i in I,j in I)*/

var z{i in I,j in I,k in I};
var w{i in I,j in I,k in I},binary;
var u{i in I,j in I,k in I};

var d{i in I,j in I,k in I};
var f{i in I,j in I,k in I},binary;
var e{i in I,j in I,k in I};

/*Sin función objetivo*/

/*Restricciones*/

s.t. res1{i in I}:sum{j in I}x[i,j]=45;/*En cada punto un número*/
s.t. res2{j in I}: sum{i in I}x[i,j]=45;/*En cada fila un número*/
/*En cuadro un número*/
s.t. res4: sum{a1 in A,a2 in A}x[a1,a2]=45; 
s.t. res5: sum{a in A,b in B}x[a,b]=45; 
s.t. res6: sum{a in A,c in C}x[a,c]=45; 
s.t. res7: sum{b in B,a in A}x[b,a]=45; 
s.t. res8: sum{b1 in B,b2 in B}x[b1,b2]=45; 
s.t. res9: sum{b in B,c in C}x[b,c]=45; 
s.t. res10: sum{c in C,a in C}x[c,a]=45; 
s.t. res11: sum{c in C,b in C}x[c,b]=45; 
s.t. res12: sum{c1 in C,c2 in C}x[c1,c2]=45; 
/*Datos iniciales*/
s.t. res13{i in I,j in I}: x[i,j]>=M[i,j]*Bin[i,j]+1*(1-Bin[i,j]);
s.t. res14{i in I,j in I}: x[i,j]<=M[i,j]*Bin[i,j]+9*(1-Bin[i,j]);

s.t. res15{i in I,j1 in I,j2 in I:j2<>j1}: z[i,j1,j2]=x[i,j1]-x[i,j2];

s.t. res16{i in I,j1 in I,j2 in I:j2<>j1}: 10*w[i,j1,j2]<=10+z[i,j1,j2];
s.t. res17{i in I,j1 in I,j2 in I:j2<>j1}: 10*w[i,j1,j2]>=z[i,j1,j2];


s.t. res18{i in I,j1 in I,j2 in I:j2<>j1}: u[i,j1,j2]<=-z[i,j1,j2]+100*w[i,j1,j2];
s.t. res19{i in I,j1 in I,j2 in I:j2<>j1}: u[i,j1,j2]>=-z[i,j1,j2]-100*w[i,j1,j2];
s.t. res20{i in I,j1 in I,j2 in I:j2<>j1}: u[i,j1,j2]<=z[i,j1,j2]+100*(1-w[i,j1,j2]);
s.t. res21{i in I,j1 in I,j2 in I:j2<>j1}: u[i,j1,j2]>=z[i,j1,j2]-100*(1-w[i,j1,j2]);

s.t. res22{i in I,j1 in I,j2 in I:j2<>j1}: u[i,j1,j2]>=1;


s.t. res23{j in I,i1 in I,i2 in I:i2<>i1}: d[i1,i2,j]=x[i1,j]-x[i2,j];

s.t. res24{j in I,i1 in I,i2 in I:i2<>i1}: 10*f[i1,i2,j]<=10+d[i1,i2,j];
s.t. res25{j in I,i1 in I,i2 in I:i2<>i1}: 10*f[i1,i2,j]>=d[i1,i2,j];


s.t. res26{j in I,i1 in I,i2 in I:i2<>i1}: e[i1,i2,j]<=-d[i1,i2,j]+100*f[i1,i2,j];
s.t. res27{j in I,i1 in I,i2 in I:i2<>i1}: e[i1,i2,j]>=-d[i1,i2,j]-100*f[i1,i2,j];
s.t. res28{j in I,i1 in I,i2 in I:i2<>i1}: e[i1,i2,j]<=d[i1,i2,j]+100*(1-f[i1,i2,j]);
s.t. res29{j in I,i1 in I,i2 in I:i2<>i1}: e[i1,i2,j]>=d[i1,i2,j]-100*(1-f[i1,i2,j]);

s.t. res30{j in I,i1 in I,i2 in I:i2<>i1}: e[i1,i2,j]>=1;
solve;
printf: "\n";
printf: "\n";
printf: "\-------------------------------------\n";
printf: "\       SUDOKU RESUELTO\n";
printf: "\       --------------- \n";
for{i in I}{
	for{{0}:i == 1} {
      printf "\  -------------------------\n";
   }
	for {j in I}{
	for{{0}:j == 1} {
      printf "\  |";
   }

	for {{0}: j == 1 or j == 4 or j == 7} {
		printf:x[i,j];
   } for {{0}: j == 2 or j == 3 or j == 5 or j == 6 or j == 8 or j == 9} {
		printf: "  "&x[i,j];
   }

	for{{0}:j == 3 or j == 6 or j == 9} {
      printf "\|";
   }
}
printf: "\n";
	for{{0}:i == 3 or i == 6 or i == 9} {
      printf "\  -------------------------\n";
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
param M:	1	2	3	4	5	6	7	8	9:=
		1	1	4	0	0	0	9	0	3	0
		2	0	2	6	0	0	3	0	0	0
		3	0	5	0	7	1	6	4	0	0
		4	0	1	0	2	0	0	8	0	0
		5	6	8	0	0	0	0	0	2	5
		6	0	0	3	0	0	8	0	9	0
		7	0	0	1	3	9	7	0	4	0
		8	0	0	0	8	0	0	9	5	0
		9	0	9	0	1	0	0	0	6	3;

end;


