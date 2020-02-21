/*PROBLAEMA ASIGNACIÖN DE REFERENCIAS(Tesis: Fuentes, Herrera, Ladino, Lozano)*/

/*CONJUNTOS*/
set REFERENCIAS;
set RACKS;

/*PARÁMETROS*/
param Ancho_Caja{REFERENCIAS};/*Ancho de cajas en metros*/
param Espacios{REFERENCIAS};/*1 Si la referencia  necesita 2 Espacios. 0 Si necesita un espacio*/
param Tipo_Rack{RACKS};/*1 Si el rack es de 2 espacios. 0 Si el rack de un espacio*/
param Utilizar{RACKS};/*1 Si el rack se puede utilizar. O DLC*/
param Demanda{REFERENCIAS};/*Demanda de la referencia*/
param Frecuencia{REFERENCIAS};/*Frecuencia de pedido de la referencia*/
param Costo{RACKS};/*Costo por ubicar un producto en un rack*/
param Estiba{REFERENCIAS};/*1 Si la referencia es de tipo estiba. 0 Si esta en un Rack por Fila*/
param Mercado{REFERENCIAS};/*1 Si la referencia es de tipo mercado. 0 Si esta en un Rack por Fila*/
param Hileras{REFERENCIAS};/*1 Si la referencia esta en filas. 0 Si esta en un Rack por Fila*/

/*VARIABLES*/
var X{REFERENCIAS,RACKS},binary;/*1 Si asigno una referencia a un rack. 0 dlc*/
var R{RACKS},binary;/*1 Si el rack sera de estibas. 0 dlc */
var S{RACKS},binary;/*1 Si el rack sera de mercado. 0 dlc */
var T{RACKS},binary;/*1 Si el rack sera de hileras. 0 dlc */

/*FUNCIÓN OBJETIVO*/

minimize Z: sum {rack in RACKS, ref in REFERENCIAS} X[ref,rack]*Demanda[ref]*Frecuencia[ref]*Costo[rack];

/*RESTRICCIONES*/

/*Una posición solo se puede asignar a un tipo*/
s.t. res0{rack in RACKS}: R[rack]+S[rack]+T[rack]=1;

/*Todas las referenicas tienen que estar en un rack */
s.t. res1{ref in REFERENCIAS}: sum{rack in RACKS} X[ref,rack] = 1;

/*El ancho permitido depende del tipo de rack. (2.5 si es de estibas, 2.5 si es de mercado, 7.5 si es de hileras*/
s.t. res2{rack in RACKS}: sum{ref in REFERENCIAS} X[ref,rack]*Ancho_Caja[ref] <=  2.5*R[rack] + 2.5*S[rack] + 7.5*T[rack];

/*Un producto de estibas solo puede ir en un lugar de estibas*/
s.t. res3{ref in REFERENCIAS,rack in RACKS}: Estiba[ref]*X[ref,rack] <= R[rack];

/*Un producto de mercado solo puede ir en un lugar de mercado*/
s.t. res4{ref in REFERENCIAS,rack in RACKS}: Mercado[ref]*X[ref,rack] <= S[rack];

/*Un producto de estibas solo puede ir en un lugar de estibas*/
s.t. res5{ref in REFERENCIAS,rack in RACKS}: Hileras[ref]*X[ref,rack] <= T[rack];

/*Si una referencia necesita dos espacios, entonces solo puede ir en un rack de dos espacios*/
s.t. res6{ref in REFERENCIAS,rack in RACKS}: Espacios[ref]*X[ref,rack] <= Tipo_Rack[rack];

/*Una referencia sólo puede ser asignada en un lugar donde se pueda utilizar*/
s.t. res7{rack in RACKS,ref in REFERENCIAS}: X[ref,rack]<=Utilizar[rack];


solve;

printf: "\n";
printf: "\n";
printf: "\-----------------------------------------\n";
printf: "\         SOLUCIÓN DEL EJERCICIO\n";
printf: "\        ------------------------ \n";

	for{ref in REFERENCIAS}{
		for {rack in RACKS:X[ref,rack]=1}{
			printf: "La refrencia "&ref&" en el rack "&rack&"\n";
		}
	}

printf: "\------------------------------------------\n";
printf: "\n";
printf: "\n";
data;

set REFERENCIAS:= 1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18;
set RACKS:= 1	2	3	4	5	6	7	8;

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
3	1
4	0
5	1
6	0
7	0
8	0;

param Utilizar:=
1	1
2	1
3	1
4	1
5	1
6	1
7	1
8	1;

param Demanda:=
1	25
2	25
3	25
4	25
5	15
6	15
7	15
8	15
9	15
10	15
11	15
12	15
13	10
14	10
15	5
16	5
17	1
18	1;

param Frecuencia:=
1	4
2	6
3	4
4	8
5	7
6	8
7	4
8	5
9	6
10	6
11	6
12	6
13	1
14	5
15	1
16	6
17	6
18	4;

param Costo:=
1	8
2	1
3	3
4	5
5	4
6	2
7	4
8	7;

param Estiba:=
1	0
2	0
3	0
4	0
5	0
6	0
7	0
8	0
9	0
10	0
11	0
12	0
13	0
14	1
15	1
16	1
17	1
18	1;

param Mercado:=
1	1
2	1
3	1
4	1
5	1
6	0
7	0
8	0
9	0
10	0
11	0
12	0
13	0
14	0
15	0
16	0
17	0
18	0;

param Hileras:=
1	0
2	0
3	0
4	0
5	0
6	1
7	1
8	1
9	1
10	1
11	1
12	1
13	1
14	0
15	0
16	0
17	0
18	0;
end;
