/*Conjuntos*/
set I;/*Plantas*/
set J;/*Clientes*/

table tabla IN "CSV" "Plantas.csv": I<-[PLANTAS];
table tabla IN "CSV" "Clientes.csv": J<-[Clientes];

/*Variables de Decision*/
var x{i in I, j in J} binary;/*Atiendo al cliente j con la planta i(Fundamental)*/
var y{i in I} binary;/*Abro la planta i*/
var cant{i in I, j in J}>=0, integer;

/*Parámetros*/
param d {j in J};/*Demanda*/
param costo {i in I};/*Costo de apertura*/
param cap {i in I};/*Capacidad de procesamiento*/
param ca {i in I, j in J};/*Costo de asignación*/
param lim:= 3;
param porc:= 0.9;

table tabla IN "CSV" "Costosapertura.csv": [Plantas], costo~Costodeabrirplanta;
table tabla IN "CSV" "Costosasignacion.csv": [Planta,Cliente], ca~Costoasignar;
table tabla IN "CSV" "Tablacapacidades.csv": [Plantas], cap~Capacidadmaxima;
table tabla IN "CSV" "Tablademandas.csv": [Cliente], d~Demanda;


/*Función Objetivo*/
minimize total: sum{i in I,j in J} ca[i,j]*x[i,j] + sum{i in I} costo[i]*y[i];

/*Restricciones*/ 
s.t. Demandaatendida: sum{j in J} d[j] <= sum{i in I} cap[i]*y[i];
s.t. Porcentajeminimo{i in I}: sum{j in J} d[j]*x[i,j] >= porc*cap[i]*y[i]; 
s.t. Porcentajemaximo {i in I}: sum{j in J} d[j]*x[i,j] <= cap[i]*y[i];
s.t. Antencionclientes {j in J}: sum{i in I} x[i,j]=1;
s.t. Minclientes {i in I}: sum{j in J} x[i,j] >= lim*y[i];

solve;
end;


