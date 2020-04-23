/*PROBLAEMA RUTEO CONTINUO (Tesis: Fuentes, Herrera, Ladino, Lozano)*/
/*La siguinte formulación lineal matemática, intenta dar respuesta al problema de continuidad de la ruta que surge al plantarse el TSP. Para efectos de nuestro Trabajo de Grado, planteamos un primer conjunto NODOS, que contiene todos los puntos de la bodega y el conjunto ORDEN que es el conjunto que puntos que debe recorrer en operario en una orden de pedido. R es el con junto ORDEN pero si el nodo inicial 0. La restricción que soluciona el problema de cotinuidad es s.t. res4, si se elimina la solucin generada tendrá subciclos */

/*CONJUNTOS*/
set NODOS;
set ORDEN;
set R;

/*PARÁMETROS*/
param Distancia{NODOS,NODOS};

/*VARIABLES*/
var x{ORDEN,ORDEN},binary;/*1 Si voy de un punto a otro. 0 dlc*/
var aux{R};/*Variable auxiliar para restriccion*/

/*FUNCIÓN OBJETIVO*/
minimize FO:sum{i in ORDEN,j in ORDEN}(Distancia[i,j]*x[i,j]);

/*RESTRICCIONES*/
/*Las siguientes tres restricciones son las habituales en el TSP*/
s.t. res1{i in ORDEN}:sum{j in ORDEN}x[i,j]=1;
s.t. res2{j in ORDEN}:sum{i in ORDEN}x[i,j]=1;
s.t. res3{i in ORDEN}:x[i,i]=0;

/*La siguiente restricción es la que rompe los subciclos. Eliminarla para notar su funcionalidad. La explicación la hago otro día*/
s.t. res4{i in R,j in R:j<>i}:aux[i] - aux[j] + card(ORDEN)*x[i,j] <= card(ORDEN)-1;

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
for{i in ORDEN}{
	for {j in ORDEN:x[i,j]=1}{
		printf: "Del nodo "&i&" al nodo "&j&"\n";
}
}
printf: "\-------------------------------------\n";
printf: "\n";
printf: "\n";

data;

set NODOS:= 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18;
set ORDEN:= 0,4,6,1,15,18,9;
set R:= 4,6,1,15,18,9;

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

end;