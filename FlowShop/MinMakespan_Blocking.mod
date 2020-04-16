/*MINIMIZAR MAKESPAN CON BLOCKING EN FLOWSHOP*/

param num_trabajos:= 5;
param num_maquinas:= 4;

/*Conjuntos*/
set J:={1..num_trabajos};         /*Trabajos*/
set M:={1..num_maquinas};         /*Máquinas*/
set P:=J;                         /*Posiciones de cada trabajo*/

/*Parámatros*/

param TP{J,M};                   /*Tiempos de procesamiento del trabajo j in J en la máquina m in M*/

/*Variables*/
var x{J,P},binary;               /*1 Si la máquina j in J se asigna a la posición p in P*/
var T_Inicio{P,M};               /*Tiempo de inicio del trabajo en la posición p in P en la máquina m in M*/
var T_Final{P,M};                /*Tiempo final del trabajo en la posición p in P en la máquina m in M*/
var Makespan;                    /*Tiempo final del trabajo j in J en la máquina m in M*/

/*Función Objetivo*/
minimize FO:Makespan;

/*Restricciones*/
s.t. res1 {p in P}: sum{j in J} x[j,p] = 1;
s.t. res2 {j in J}: sum{p in P} x[j,p] = 1;

s.t. res3 {p in P, m in M}: T_Final[p,m] = T_Inicio[p,m] + sum{j in J} x[j,p]*TP[j,m];
s.t. res4 {p in P, m in M: m > 1}: T_Inicio[p,m] = T_Final[p,m-1];
s.t. res5 {p in P, m in M: p > 1}: T_Inicio[p,m] >= T_Final[p-1,m];
s.t. res6: T_Inicio[1,1] = 0;
s.t. res7: Makespan = T_Final[card(P),card(M)];

solve;

printf: "\n";
printf: "\n";
printf: "\-------------------------------------\n";
printf: "\       SOLUCIÓN DEL EJERCICIO\n";
printf: "\       ---------------------- \n";
printf: "\Makespan: "&Makespan&"\n";
printf: "\Secuencia: ";
for{p in P}{
	for {j in J:x[j,p]=1}{
		printf:j&"  ";
	}
}
printf: "\n";
printf: "\------------------------\n";
for{p in P}{
	printf: "Posición "&p&"\n";
	for {j in J:x[j,p]=1}{
		printf: "Trabajo: "&j&"\n";
	}
	for{m in M}{
		printf: "Inicio máquina "&m&": "&ceil(T_Inicio[p,m])&" --> Fin máquina "&m&": "&ceil(T_Final[p,m])&"\n";
	}
	printf: "\n";
}
printf: "\-------------------------------------\n";
printf: "\n";
printf: "\n";
printf: "\n";


data;

param TP:	1	2	3	4:=
		1	1	13	6	2
		2	10	12	18	18
		3	17	9	13	4
		4	12	17	2	6
		5	11	3	5	16;


end;