/*Conjuntos*/
set NODOS; 
set PLANTAS;


/*Parametros*/
param CC {n1 in NODOS,n2 in NODOS}; /*Costo de construcción de la zona n1,n2*/
param D {n1 in NODOS,n2 in NODOS}; /*Demanda de la zona n1,n2*/
param DP1{n1 in NODOS,n2 in NODOS}:=sqrt(10)*sqrt((n2)^2+(n1-3.5)^2); /*Distancia en km de la planta 1 a la zona n1,n2*/
param DP2{n1 in NODOS,n2 in NODOS}:=sqrt(10)*sqrt((7-n2)^2+(n1-3.5)^2); /*Distancia en km de la planta 2 a la zona n1,n2*/
param Distancias{n1 in NODOS,n2 in NODOS,n3 in NODOS,n4 in NODOS}:=sqrt(10)*sqrt((n1-n3)^2+(n2-n4)^2); /*Distancia en km de la zona n1,n2 a la zona n2,n3 */
param Adyacente{n1 in NODOS,n2 in NODOS,n3 in NODOS,n4 in NODOS}:= if ((n1-n3)>=-1 and (n1-n3)<=1 and (n2-n4)>=-1 and(n2-n4)<=1) then 1 else 0;

table tabla IN "CSV" "DemandayCosto.csv": [Fila,Columna], CC~CostoConstruccion;
table tabla IN "CSV" "DemandayCosto.csv": [Fila,Columna], D~Demanda;


/*Variables de desición*/
var Abrir{n1 in NODOS,n2 in NODOS},  binary; /*1 si construyo CD en la zona n1,n2*/
var Enviar{n1 in NODOS,n2 in NODOS, p in PLANTAS}, binary;/*1 si envío de la planta p al CD en la zona n1,n2*/
var C_cli{n1 in NODOS,n2 in NODOS,n3 in NODOS,n4 in NODOS}, >= 0, integer; /*Número de bolsas de leche que  envío desde el CD en la zona n1,n2 al cliente en la zona n3,n4*/ 
var C_centro{n1 in NODOS,n2 in NODOS, p in PLANTAS}, integer, >= 0;  /*Número de bolsas de leche que  envío de la planta p al CD en la zona n1,n2 */ 
  
/*FO*/
minimize Z: sum{n1 in NODOS,n2 in NODOS } Abrir[n1,n2]*CC[n1,n2]+(5/10)*sum{n1 in NODOS,n2 in NODOS,n3 in NODOS,n4 in NODOS} C_cli[n1,n2,n3,n4]*Distancias[n1,n2,n3,n4]+(5/10)*sum{n1 in NODOS,n2 in NODOS} (C_centro[n1,n2,1]*DP1[n1,n2]+C_centro[n1,n2,2]*DP2[n1,n2]);

s.t. restriccion1 {n1 in NODOS,n2 in NODOS,n3 in NODOS,n4 in NODOS}: C_cli[n1,n2,n3,n4]<=9999*Abrir[n1,n2];
s.t. restriccion2 {n1 in NODOS,n2 in NODOS,n3 in NODOS,n4 in NODOS}:C_cli[n1,n2,n3,n4]<=Adyacente[n1,n2,n3,n4]*9999 ; 
s.t. restriccion3  {n1 in NODOS,n2 in NODOS, p in PLANTAS}: 9999*Enviar[n1,n2,p]>=C_centro[n1,n2,p];
s.t. restriccion4  {n1 in NODOS,n2 in NODOS, p in PLANTAS}: Enviar[n1,n2,p]<=C_centro[n1,n2,p];
s.t. restriccion5 {n3 in NODOS, n4 in NODOS}:sum{n1 in NODOS,n2 in NODOS}C_cli[n1,n2,n3,n4]=D[n3,n4] ; 
s.t. restriccion6 : sum{n1 in NODOS,n2 in NODOS,n3 in NODOS,n4 in NODOS} C_cli[n1,n2,n3,n4]=sum{n1 in NODOS,n2 in NODOS} D[n1,n2] ;
s.t. restriccion7 {n1 in NODOS,n2 in NODOS}: sum{n3 in NODOS, n4 in NODOS} C_cli[n1,n2,n3,n4]<= sum{p in PLANTAS} C_centro[n1,n2,p];
s.t. restriccion8 {n1 in NODOS,n2 in NODOS}:2* Abrir[n1,n2]>= Enviar[n1,n2,1]+ Enviar[n1,n2,2]; 
s.t. restriccion9 {n1 in NODOS,n2 in NODOS}: Abrir[n1,n2]<= Enviar[n1,n2,1]+ Enviar[n1,n2,2] ; 

solve;


printf: "\nCentros de distribución abiertos\n";
for{n1 in NODOS,n2 in NODOS: Abrir[n1,n2]<>0}{
		printf: "("&n1&","&n2&")\n";
}

printf: "\nCantidades desde (3,3) a clientes: \n";
for{n3 in NODOS, n4 in NODOS}{
		printf: "Cantidad a ("&n3&","&n4&"):" &C_cli[3,3,n3,n4]&"\n";
}



data;
set NODOS:= 1  2  3  4  5  6;
set PLANTAS:= 1  2  ;

end;
