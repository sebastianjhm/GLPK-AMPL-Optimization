/*RUTEO CONTINUO*/

/*Conjuntos*/
set I;
set R;

table tabla IN "CSV" "I.csv":  I<-[i];
table tabla IN "CSV" "R.csv":  R<-[r];

/*Parámatros*/
param Dist{I,I};
table tabla IN "CSV" "Dist.csv": [a,b], Dist~c;

/*Variables*/
var x{I,I},binary;/*Si voy del punto i in I al punto j in I*/
var u{I}>=1;

/*Función Objetivo*/
minimize FO:sum{i in I,j in I}Dist[i,j]*x[i,j];

/*Restricciones*/

s.t. res555{i in I}:sum{j in I}x[i,j]=1;
s.t. res777{j in I}:sum{i in I}x[i,j]=1;
s.t. res888{i in I}:x[i,i]=0;
s.t. res788{i in R,j in R:j<>i}:u[i]-u[j]+108*x[i,j]<=107;


solve;
printf: "\n";
printf: "\n";
printf: "\-------------------------------------\n";
printf: "\       SOLUCIÓN DEL EJERCICIO\n";
printf: "\       ---------------------- \n";
printf: "\Distancia Total: "&FO&"\n";
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

end;