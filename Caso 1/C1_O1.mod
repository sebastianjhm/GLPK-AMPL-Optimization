/*Declaracion de los conjuntos*/
set I; /* Tipos de computadores*/
set J; /* Puntos de venta*/
set K; /* Componentes de computador*/
set L; /* Plantas*/
set Q; /* Proveedores*/
set B; /* Bodegas*/
set S; /* Semanas*/

/*Declaracion de los parametros*/
param Comp {i in I, k in K}; /*Cantidad de componentes del tipo k para fabricari*/
param Costo{i in I, l in L}; /* Costo de fabricar el computador i en la planta l */
param Capac {i in I, l in L}; /* Coantidad máxima de fabricacion del computador i en la planta l */
param M{k in K, q in Q}; /* Coantidad máxima  de componentes k que puede fabricar el proveedor q */
param P{k in K, q in Q}; /* Precio del componente k al que vente el fabricante q */
param C1{l in L, j in J}; /* Costo de ir de la planta l al punto de venta j */
param C2{l in L, b in B}; /* Costo de ir de la planta l a la bodega b */
param C3{b in B, j in J}; /* Costo de ir de la bodega b al punto de venta j */
param LE{i in I, s in S}; /* Demanda de la Esmeralda del pc i en la semana s*/
param ED{i in I, s in S}; /* Demanda de El Dorado del pc i en la semana s */
param TE{i in I, s in S}; /* Demanda del Tquendama del pc i en la semana s */
param PV{i in I}; /* Precio de venta del pc i*/
param V{i in I}; /* Volumen del pc i*/
param CA{b in B}; /* costo de almacenamiento de la bodega b*/
param CMA{b in B}; /* capacidad máxima de almacenamiento de la bodega b*/

/*Declaracion de la variable*/
var x{i in I, k in K, q in Q, s in S }, >= 0; /* Cantidad del componente k para el pc i comprados al proveedor q en la semana s*/
var y{i in I, s in S }, >= 0; /* Cantidad a producir del pc i en la semana s*/
var z{i in I, l in L, s in S}, >= 0; /* Cantidad a producir del pc i en la planta l en la semana s*/
var d{i in I, l in L, j in J, s in S }, >= 0; /* Cantidad enviada del pc i desde la planta l al punto de venta j en la semana s*/
var w{i in I, l in L, b in B, s in S }, >= 0; /* Cantidad enviada del pc i desde la planta l al punto de venta j en la semana s*/
var t{i in I, b in B, j in J, s in S }, >= 0; /* Cantidad enviada del pc i desde la planta l al punto de venta j en la semana s*/
var bod{i in I, b in B, s in S }, >= 0; /* Cantidad que hay del pc i en la bodega b en la semana s*/
var h{i in I, j in J, s in S}, >= 0; /* Cantidad enviada del pc i hasta la planta j en la semana s*/

/*Funcion Objetivo*/
maximize Z: sum{i in I, j in J, s in S} h[i,j,s]*PV[i]-sum{i in I, l in L, s in S} z[i,l,s]*Costo[i,l]-sum{i in I, k in K, q in Q, s in S }x[i,k,q,s]*P[k,q]-sum{i in I, l in L, j in J, s in S }d[i,l,j,s]*C1[l,j]*V[i]-sum{i in I, l in L, b in B, s in S }w[i,l,b,s]*C2[l,b]*V[i]-sum{i in I, b in B, j in J, s in S }t[i,b,j,s]*C3[b,j]*V[i]-sum{i in I, b in B, s in S }bod[i,b,s]*CA[b]*V[i]; 


/*Restricciones*/
s.t. res1 {i in I, k in K, s in S }: sum{q in Q} x[i,k,q,s]=Comp[i,k]*y[i,s]; 
s.t. res2 {i in I, s in S }: y[i,s]=sum{l in L} z[i,l,s];
s.t. res3 {i in I, l in L, s in S }: z[i,l,s]<=Capac[i,l]; 
s.t. res4 {k in K, q in Q, s in S }: sum{i in I} x[i,k,q,s]<=M[k,q]; 
s.t. res5 {i in I, b in B, s in S: s>=2}: bod[i,b,s]=bod[i,b,s-1]+sum{l in L} w[i,l,b,s]-sum{j in J} t[i,b,j,s]; 
s.t. res6 {i in I, b in B}: bod[i,b,1]=sum{l in L} w[i,l,b,1]-sum{j in J}t[i,b,j,1]; 
s.t. res7 {b in B, s in S}: sum{i in I} bod[i,b,s]*V[i]<=CMA[b]; 
s.t. res8 {i in I,j in J, s in S}: h[i,j,s]=sum{b in B}t[i,b,j,s]+sum{l in L}d[i,l,j,s];
s.t. res9 {i in I,s  in S}: h[i,1,s]=LE[i,s];
s.t. res10 {i in I,s  in S}: h[i,2,s]=ED[i,s];
s.t. res11 {i in I,s  in S}: h[i,3,s]=TE[i,s];
s.t. res12 {i in I,l in L, s in S}: z[i,l,s]=sum{b in B}w[i,l,b,s]+sum{j in J}d[i,l,j,s];

data;
set I:= 1  2  3  4  5;
set J:= 1  2  3;
set K:= 1  2.1  2.2  3.1  3.2   4.1   4.2   4.3   5.1   5.2   5.3   6.1   6.2   6.3;
set L:= 1  2  3  4;
set Q:= 1  2  3  4  5  6  7  8;
set B:= 1  2  3;
set S:= 1   2   3   4   5   6   7   8   9   10   11   12;


param Comp :	1	2.1	2.2	3.1	3.2	4.1	4.2	4.3	5.1	5.2	5.3	6.1	6.2	6.3:=
			1	7	0	1	0	1	0	1	0	1	0	0	0	2	0
			2	8	0	1	0	2	0	0	1	0	1	0	0	0	2
			3	3	1	0	1	0	1	0	0	1	0	0	4	0	0
			4	6	0	1	1	1	0	0	1	0	0	1	0	1	2
			5	6	0	1	0	2	0	0	1	0	0	1	0	2	0;

param Costo :	1		2		3		4:=
			1	445945	405405	500000	432432
			2	30000	20000	35000	25000
			3	5000	4500	5000	4750
			4	62000	60000	64000	70000
			5	76000	72000	80000	74000;

param Capac :	1		2		3		4:=
			1	390		0		240		0
			2	80		0		30		0
			3	0		1000	1400	0
			4	0		0		800		590
			5	0		0		160		30;

param M:	1		2		3		4		5		6		7		8:=
		1	18000	8000	0		0		0		0		0		0
		2.1	0		0		0		3000	0		0		0		0
		2.2	0		0		0		3000	0		0		0		0
		3.1	0		0		4000	0		0		0		0		0
		3.2	0		0		4500	0		0		0		0		0
		4.1	0		0		0		3000	0		0		0		0
		4.2	0		0		0		810		0		0		0		0
		4.3	0		0		0		2600	0		0		0		0
		5.1	0		0		0		0		2000	900		1500	0
		5.2	0		0		0		0		200		300		200		0
		5.3	0		0		0		0		1400	1000	250		0
		6.1	0		0		0		0		0		0		0		12000
		6.2	0		0		0		0		0		0		0		4100
		6.3	0		0		0		0		0		0		0		3800;

param P:	1		2		3		4		5		6		7		8:=
		1	200000	170000	0		0		0		0		0		0
		2.1	0		0		0		400000	0		0		0		0
		2.2	0		0		0		600000	0		0		0		0
		3.1	0		0		350000	0		0		0		0		0
		3.2	0		0		300000	0		0		0		0		0
		4.1	0		0		0		150000	0		0		0		0
		4.2	0		0		0		200000	0		0		0		0
		4.3	0		0		0		550000	0		0		0		0
		5.1	0		0		0		0		80000	70000	100000	0
		5.2	0		0		0		0		100000	90000	120000	0
		5.3	0		0		0		0		100000	90000	120000	0
		6.1	0		0		0		0		0		0		0		50000
		6.2	0		0		0		0		0		0		0		70000
		6.3	0		0		0		0		0		0		0		80000;
 

param C1:	1	2	3:=
		1	100	200	350
		2	400	260	400
		3	190	700	200
		4	340	300	270;

param C2:	1	2	3:=
		1	100	300	150
		2	200	230	200
		3	350	200	230
		4	150	250	450;

param C3:	1	2	3:=
		1	50	70	100
		2	0	40	30
		3	40	30	0;

param LE:	1	2	3	4	5	6	7	8	9	10	11	12:=
		1	162	279	442	368	251	388	121	369	265	180	135	162
		2	25	18	25	40	43	37	40	1	47	20	20	38
		3	927	632	984	611	562	756	712	564	790	530	563	898
		4	541	474	507	359	355	383	365	565	559	510	511	457
		5	36	35	37	46	57	30	45	57	42	58	47	38;


param ED:	1	2	3	4	5	6	7	8	9	10	11	12:=
		1	95	108	104	57	109	69	149	145	90	99	141	65
		2	36	24	2	21	36	13	34	1	35	24	30	20
		3	500	829	736	984	1000	912	546	534	745	885	955	525
		4	200	411	502	455	500	352	535	473	338	546	481	302
		5	114	119	69	70	97	85	88	102	71	79	63	70;


param TE:	1	2	3	4	5	6	7	8	9	10	11	12:=
		1	206	210	216	239	217	234	235	215	232	229	247	245
		2	13	21	26	1	8	19	16	16	40	28	11	38
		3	879	529	732	607	991	709	836	900	798	965	539	733
		4	318	230	278	292	356	322	320	277	259	293	218	286
		5	15	13	47	42	47	13	95	52	68	78	40	94;

param PV:=
1	4620000
2	5062500
3	2117500
4	3840000
5	4907500;

param V:=
1	0.1
2	0.11
3	0.9
4	0.11
5	0.12;

param CA:=
1	30000
2	35000
3	25000;

param CMA:=
1	100
2	80
3	72;

end;


