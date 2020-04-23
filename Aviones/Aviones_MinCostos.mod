/*Conjuntos*/
set TIPO; /* Tipos de aviones = {ARPIA, KFIR, BRONCO, CESSNA, DOUGLAS,.......}*/
set ESTADO; /*Estado de los aviones = {ACC, ACL, AMI, AMR, APA, MMP, PLA}*/
set CIUDADES; /*Ciudades = {Bogota, Bqlla, Medellin, Bucaramanga, Cucuta, Cali, Cartagena, Santa Marta}*/
set MISION; /*Misión que puede cumplir el avión = {ATAQUE, CAZA, CONTRAINSURGENCIA, ENTRENAMIENTO, TANQUERO, TRANSPORTE, UTILITARIO, VIGILANCIA, VIP}*/

/*Parámetros*/
param Costo_Fijo{t in TIPO}; /* Costo anual del avión tipo t in TIPO*/
param Alpha{t in TIPO,m in MISION}; /*Parámetro binario: 1 si el avión tipo t in TIPO puede hacer la mision m in MISION */
param Cant_Ae{t in TIPO, e in ESTADO}; /*Cantidad de aviones del tipo t in TIPO que se encuentran en estado e in ESTADO */
param Dist_BOG{c in CIUDADES}; /*Distancia desde Bogotá a la ciudad c in CIUDADES*/
param Costo_Transp{t in TIPO}; /* Costo de transportar un avión del tipo t in T*/
param Dem{c in CIUDADES, m in MISION}; /*Demanda de la ciudad c in CIUDADES de aviones con misión m in MISION */
param Capac{c in CIUDADES, m in MISION}; /*Capacidad de almacenamiento de la ciudad c in CIUDADES de aviones con misión m in MISION */
param Dem_Corr{c in CIUDADES, m in MISION}; /*Demanda corregida de la ciudad c in CIUDADES de aviones con misión m in MISION */


table tabla IN "CSV" "Costo_Fijo.csv": [a], Costo_Fijo~b;
table tabla IN "CSV" "Alpha.csv": [a,b], Alpha~c;
table tabla IN "CSV" "Cant_Ae.csv": [a,b], Cant_Ae~c;
table tabla IN "CSV" "Dist_BOG.csv": [a], Dist_BOG~b;
table tabla IN "CSV" "Costo_Transp.csv": [a], Costo_Transp~b;
table tabla IN "CSV" "Dem.csv": [a,b], Dem~c;
table tabla IN "CSV" "Capac.csv": [a,b], Capac~c;
table tabla IN "CSV" "Dem_Corr.csv": [a,b], Dem_Corr~c;

/*Variables de desición*/
var x{t in TIPO,c in CIUDADES,m in MISION}, >= 0, integer; /* Cantidad de aeronaves enviadas a ciudad c in CIUDADES del tipo t in TIPO para la mision m in M*/
var dif, >=0;/* Máxima diferencia entre lo enviado una ciudad c in CIUDADES para mision m in M y su demanda*/
var f{c in CIUDADES,m in MISION}, >= 0;/* Faltante de envío a una ciudad c in CIUDADES para mision m in M*/


/*Funcion Objetivo*/
minimize Z: sum{t in TIPO,c in CIUDADES,m in MISION}Dist_BOG[c]*Costo_Transp[t]*x[t,c,m]+sum{t in TIPO}Costo_Fijo[t];

/*Restricciones*/
s.t. res1 {t in TIPO}: sum{m in MISION,c in CIUDADES} x[t,c,m]<= Cant_Ae[t,2]+Cant_Ae[t,7]+Cant_Ae[t,4]; 
s.t. res2 {t in TIPO}: sum{m in MISION,c in CIUDADES:c>=5} x[t,c,m]<= Cant_Ae[t,2]+Cant_Ae[t,7];
s.t. res3 {t in TIPO, c in CIUDADES, m in MISION}: x[t,c,m]<=10000*Alpha[t,m]; 
s.t. res5 {c in CIUDADES, m in MISION}: sum{t in TIPO} x[t,c,m]<=Capac[c,m]; 
s.t. res7 {c in CIUDADES, m in MISION}: sum{t in TIPO} x[t,c,m]>=Dem_Corr[c,m]; 


solve;
data;  
set TIPO:= 1   2   3   4   5   6   7   8   9   10   11   12  13  14  15  16  17  18  19  20  21  22  23  24  25  26; 
set ESTADO:= 1   2   3   4   5   6   7; 
set CIUDADES:= 1   2   3   4   5   6   7   8; 
set MISION:= 1   2   3   4   5   6   7   8  9; 

end;
