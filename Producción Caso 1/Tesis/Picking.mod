/*PROBLAEMA PICKING (Tesis: Fuentes, Herrera, Ladino, Lozano)*/

/*CONJUNTOS*/
set NODOS;/*Nodos dentro de la Bodega*/
set REF;/*Referencias*/
set O;/*Número de Ordenes*/
set ORDENES{o in O};/*Conjunto de Ordenes*/
set R{o in O};/*Conjunto auxiliar a ORDENES{o in O}. Mismo conjunto pero sin el 0*/


/*PARÁMETROS*/
param Distancia{NODOS,NODOS};
param Nod_Ref{REF};/*En que nodo esta cada referencia*/

/*VARIABLES*/
var x{o in O,i in ORDENES[o],j in ORDENES[o]},binary;/*1 Si voy de un punto a otro. 0 dlc*/
var Dist_ORD{o in O};/*Distancia Total de cada orden*/
var aux{o in O, i in R[o]};/*Variable auxiliar para restriccion*/

/*FUNCIÓN OBJETIVO*/
minimize FO:sum{o in O,i in ORDENES[o],j in ORDENES[o]}(Distancia[Nod_Ref[i],Nod_Ref[j]]*x[o,i,j]);

/*RESTRICCIONES*/
s.t. res1{o in O,i in ORDENES[o]}:sum{j in ORDENES[o]}x[o,i,j]=1;
s.t. res2{o in O,j in ORDENES[o]}:sum{i in ORDENES[o]}x[o,i,j]=1;
s.t. res3{o in O,i in ORDENES[o]}:x[o,i,i]=0;

s.t. res4{o in O,i in R[o],j in R[o]:j<>i}:aux[o,i] - aux[o,j] + card(ORDENES[o])*x[o,i,j] <= card(ORDENES[o])-1;


s.t. res123{o in O}:Dist_ORD[o]=sum{i in ORDENES[o],j in ORDENES[o]}(Distancia[Nod_Ref[i],Nod_Ref[j]]*x[o,i,j]);

solve;
printf: "\n";
printf: "\n";
printf: "\-----------------------------------------\n";
printf: "\         SOLUCIÓN DEL EJERCICIO\n";
printf: "\        ------------------------ \n";
printf: "\Distancia Total: "&FO&"\n";
printf: "\n";
for{o in O}{
printf: "--------- ORDEN "&o&" -----------\n";
printf:"Distancia Rescorrida: "&Dist_ORD[o]&"\n";
printf: "\n";
printf:"Ruta:\n";
	for{i in ORDENES[o]}{
		for {j in ORDENES[o]:x[o,i,j]=1}{
			printf: "Del nodo "&i&" al nodo "&j&"\n";
		}
	}
printf: "\n";
printf: "\n";
}
printf: "\------------------------------------------\n";
printf: "\n";
printf: "\n";
data;

set NODOS:= 0	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18;
set O:= 1	2	3	4	5;
set REF:=0	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25	26	27	28	29	30	31	32	33	34	35	36	37	38	39	40;



set ORDENES[1]:=0,4,26,1,15,18,9,33,40,11; 
set ORDENES[2]:=0,1,7,5,15,17; 
set ORDENES[3]:=0,4,6,1;
set ORDENES[4]:=0,15,18,9;
set ORDENES[5]:=0,4,6,1,15,18,9,8;

set R[1]:=4,26,1,15,18,9,33,40,11; 
set R[2]:=1,7,5,15,17; 
set R[3]:=4,6,1;
set R[4]:=15,18,9;
set R[5]:=4,6,1,15,18,9,8;

param Distancia:	0	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18:=
0	0	30	33	35	28	44	49	29	48	32	37	43	22	40	27	39	43	29	38
1	30	0	43	43	43	44	48	29	28	22	44	49	29	45	42	45	31	22	38
2	33	43	0	45	47	30	50	45	40	33	21	30	38	32	40	39	32	35	43
3	35	43	45	0	45	33	46	29	47	41	32	41	45	44	43	33	43	34	42
4	28	43	47	45	0	37	32	31	28	35	21	44	21	42	43	25	33	38	41
5	44	44	30	33	37	0	44	32	31	32	29	21	21	41	29	35	42	20	43
6	49	48	50	46	32	44	0	46	20	49	38	44	37	42	45	50	35	29	27
7	29	29	45	29	31	32	46	0	29	50	36	34	29	25	42	43	25	24	37
8	48	28	40	47	28	31	20	29	0	38	38	26	32	43	47	31	28	30	35
9	32	22	33	41	35	32	49	50	38	0	30	38	35	22	26	35	22	43	37
10	37	44	21	32	21	29	38	36	38	30	0	48	42	27	31	36	50	39	28
11	43	49	30	41	44	21	44	34	26	38	48	0	33	49	37	40	28	49	32
12	22	29	38	45	21	21	37	29	32	35	42	33	0	45	31	21	39	45	30
13	40	45	32	44	42	41	42	25	43	22	27	49	45	0	26	40	29	37	50
14	27	42	40	43	43	29	45	42	47	26	31	37	31	26	0	47	46	38	36
15	39	45	39	33	25	35	50	43	31	35	36	40	21	40	47	0	29	25	38
16	43	31	32	43	33	42	35	25	28	22	50	28	39	29	46	29	0	47	34
17	29	22	35	34	38	20	29	24	30	43	39	49	45	37	38	25	47	0	20
18	38	38	43	42	41	43	27	37	35	37	28	32	30	50	36	38	34	20	0;

param Nod_Ref:=
0	0
1	4
2	15
3	4
4	9
5	18
6	9
7	14
8	10
9	17
10	16
11	11
12	18
13	15
14	4
15	7
16	18
17	18
18	11
19	17
20	18
21	15
22	3
23	4
24	1
25	18
26	11
27	18
28	7
29	2
30	5
31	8
32	8
33	11
34	10
35	4
36	2
37	3
38	9
39	14
40	11;


end;