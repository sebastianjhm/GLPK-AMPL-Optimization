/*PROBLAEMA ASIGNACIÖN DE REFERENCIAS(Tesis: Fuentes, Herrera, Ladino, Lozano)*/

/*CONJUNTOS*/
set REFERENCIAS;
set RACKS;

/*PARÁMETROS*/
param Ancho_Caja{REFERENCIAS};/*Ancho de cajas en metros*/
param Tipo_Dist{REFERENCIAS};/*1 Si la referencia esta en un Rack normal. 0 Si esta en un Rack por Fila*/
param Espacios{REFERENCIAS};/*1 Si la referencia  necesita 2 Espacios. 0 Si necesita un espacio*/
param Tipo_Rack{RACKS};/*1 Si el rack es de 2 espacios. 0 Si el rack de un espacio*/

/*VARIABLES*/
var x{REFERENCIAS,RACKS},binary;/*1 Si asigno una referencia a un rack. 0 dlc*/
var y{RACKS},binary;/*1 Si el rack sera de hileras. 0 dlc */

/*FUNCIÓN OBJETIVO*/


/*RESTRICCIONES*/

/*Todas las referenicas tienen que estar en un rack */
s.t. res1{ref in REFERENCIAS}: sum{rack in RACKS}x[ref,rack] = 1;

/*Si el rack es en hileras tiene derecho a ocupar 7.5m de ancho, 2.5 por cada hilera. Si en normal solo tine derecho a 2.5 */
s.t. res2{rack in RACKS}: sum{ref in REFERENCIAS}x[ref,rack]*Ancho_Caja[ref] <=  2.5*(1-y[rack]) + 7.5*y[rack];

/*Si una referencia esta asignada a una distribucion por filas, entonces solo puede ir en un rack por fila */
s.t. res3{ref in REFERENCIAS,rack in RACKS}: (1-Tipo_Dist[ref])*x[ref,rack] <= y[rack];

/*Un rack solo puede ser escogido para filas si es de una hilera*/
s.t. res4{rack in RACKS}: y[rack] <= 1 - Tipo_Rack[rack];

/*Si una referencia necesita dos espacios, entonces solo puede ir en un rack de dos espacios*/
s.t. res5{ref in REFERENCIAS,rack in RACKS}: Espacios[ref]*x[ref,rack] <= Tipo_Rack[rack];

/*Si una referencia necesita un espacio, entonces solo puede ir en un rack de es un espacio */
s.t. res6{ref in REFERENCIAS,rack in RACKS}: (1 - Espacios[ref])*x[ref,rack] <= (1 - Tipo_Rack[rack]);

solve;

printf: "\n";
printf: "\n";
printf: "\-----------------------------------------\n";
printf: "\         SOLUCIÓN DEL EJERCICIO\n";
printf: "\        ------------------------ \n";

	for{ref in REFERENCIAS}{
		for {rack in RACKS:x[ref,rack]=1}{
			printf: "La refrencia "&ref&" en el rack "&rack&"\n";
		}
	}

printf: "\------------------------------------------\n";
printf: "\n";
printf: "\n";
data;

set REFERENCIAS:= 1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18;
set RACKS:= 1	2	3	4;

param Ancho_Caja:=
1	1.2
2	1.2
3	0.3
4	0.3
5	0.3
6	0.3
7	0.3
8	0.3
9	0.3
10	0.8
11	0.8
12	0.8
13	0.8
14	0.8
15	0.8
16	0.8
17	0.8
18	0.8;

param Tipo_Dist:=
1	1
2	1
3	1
4	1
5	1
6	1
7	1
8	1
9	1
10	0
11	0
12	0
13	0
14	0
15	0
16	0
17	0
18	0;

param Espacios:=
1	1
2	1
3	1
4	1
5	1
6	1
7	1
8	1
9	1
10	0
11	0
12	0
13	0
14	0
15	0
16	0
17	0
18	0;

param Tipo_Rack:=
1	1
2	1
3	0
4	0;
end;