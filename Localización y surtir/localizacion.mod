/*Conjuntos*/
set Puntos;/*Puntos de la cuadricula*/
set L;/*Plantas*/

/*Declaración Parámetros*/
param CostoConstruccion {x1 in Puntos,y1 in Puntos}; 
param Demanda {x1 in Puntos,y1 in Puntos}; 
param Distancia_P{x1 in Puntos,y1 in Puntos,l in L}:=sqrt(10*((7*(1-l)+y1)^2+(x1-3.5)^2)); /*Distancia desde la planta p al punto x1,y1*/
param Dist{x1 in Puntos,y1 in Puntos,x2 in Puntos,y2 in Puntos}:=sqrt(10*((x1-x2)^2+(y2-y1)^2)); /*Distancia desde el punto x1.y1 al punto x2,y2 */
param Alrededor{x1 in Puntos,y1 in Puntos,x2 in Puntos,y2 in Puntos}:= if (abs(x1-x2)<=1 and abs(y2-y1)<=1) then 1 else 0;/*Si puedo enviar de un punto a otro */
param M:=10000;/*gran M*/

/*Declaración Variables de desción*/
var Cantidad1{x1 in Puntos,y1 in Puntos,x2 in Puntos,y2 in Puntos},>=0,integer;
var Cantidad2{x1 in Puntos,y1 in Puntos,l in L},>=0, integer; 
var Construir{x1 in Puntos,y1 in Puntos}, binary; 
var surtir{x1 in Puntos,y1 in Puntos,l in L}, binary;

table tabla IN "CSV" "DemandayCosto.csv": [Fila,Columna], CostoConstruccion~CostoConstruccion;
table tabla IN "CSV" "DemandayCosto.csv": [Fila,Columna], Demanda~Demanda;

/*FO*/
minimize Z: sum{x1 in Puntos,y1 in Puntos} Construir[x1,y1]*CostoConstruccion[x1,y1]+5*sum{x1 in Puntos,y1 in Puntos,x2 in Puntos,y2 in Puntos} Cantidad1[x1,y1,x2,y2]*(1/10)*Dist[x1,y1,x2,y2]+5*sum{x1 in Puntos,y1 in Puntos,l in L} Cantidad2[x1,y1,l]*(1/10)*Distancia_P[x1,y1,l];

s.t. r1 {x1 in Puntos,y1 in Puntos,l in L}: M*surtir[x1,y1,l]>=Cantidad2[x1,y1,l];
s.t. r2 {x1 in Puntos,y1 in Puntos,l in L}: surtir[x1,y1,l]<=Cantidad2[x1,y1,l];
s.t. r3 {x2 in Puntos,y2 in Puntos}:sum{x1 in Puntos,y1 in Puntos}Cantidad1[x1,y1,x2,y2]=Demanda[x2,y2] ; 
s.t. r4 : sum{x1 in Puntos,y1 in Puntos,x2 in Puntos,y2 in Puntos} Cantidad1[x1,y1,x2,y2]=sum{x1 in Puntos,y1 in Puntos} Demanda[x1,y1] ;
s.t. r5 {x1 in Puntos,y1 in Puntos,x2 in Puntos,y2 in Puntos}:Cantidad1[x1,y1,x2,y2]<=Alrededor[x1,y1,x2,y2]*M ; 
s.t. r6 {x1 in Puntos,y1 in Puntos}: sum{x2 in Puntos,y2 in Puntos} Cantidad1[x1,y1,x2,y2]<= sum{l in L} Cantidad2[x1,y1,l];
s.t. r7 {x1 in Puntos,y1 in Puntos,x2 in Puntos,y2 in Puntos}: Cantidad1[x1,y1,x2,y2]<=M*Construir[x1,y1];
s.t. r8 {x1 in Puntos,y1 in Puntos}:2* Construir[x1,y1]>= sum{l in L}surtir[x1,y1,l]; 
s.t. r9 {x1 in Puntos,y1 in Puntos}: Construir[x1,y1]<= sum{l in L}surtir[x1,y1,l] ;
solve;

printf: "\nCentros de distribución construidos\n";
for{x1 in Puntos,y1 in Puntos: Construir[x1,y1]<>0}{
		printf: "("&x1&","&y1&")\n";
}

printf: "\nCantidad de (3,3) a: \n";
for{x2 in Puntos,y2 in Puntos}{
		printf: "("&x2&","&y2&"): " &Cantidad1[3,3,x2,y2]&"\n";
}

data;
set Puntos:= 1  2  3  4  5  6;
set L:= 1  2 ;

end;