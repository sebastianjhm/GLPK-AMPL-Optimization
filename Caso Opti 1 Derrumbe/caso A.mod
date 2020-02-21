/*Caso #1*/
/*Conjuntos*/
set H; /*Fabricas de hierro donde 1: Produce calibre tipo A / 2: Produce calibre tipo B*/
set A; /*Acerias donde se produce el hierro donde 1: Bucaramanga / 2: Bucaramanga*/
set C; /*Ciudades 1:Bogota / 2; Cali / 3: Barq / 4:Medellin */
set P; /*Tipo de acero 1: Alto calibre / 2: Bajo calibre */

/*Parámetros*/
param Q{H}; /*Cantidad maxima de almacenamiento en las fabricas de hierro hEH en toneladas*/
param CC{H}; /*Costo de compra del hierro a las fabricas hEH en ($ / Toneladas) */
param CE{H,A}; /*Costo de envio del hierro de las fabricas hEH a las acerias aEA en $/toneladas */
param QQ{A}; /*Cantidad maxima de hierro que puede procesar la aceria aEA en toneladas*/
param CP{P,A}; /*Costo de procesar el tipo de acero pEP en la aceria AEA en $/Toneladas */
param D{P,C}; /*Demanda del tipo de acero pEP que pide la ciudad cEC en Toneladas*/
param CK{P,A,C}; /*Costo de envio del tipo de acero pEP, producido en la aceria aEA y hacia la ciudad cEC en $/toneladas*/

table TABLA IN "CSV" "MaximoHierro.csv": [Fabrica], Q~DispoMax;
table TABLA IN "CSV" "CostoCompraHierro.csv": [Fabrica], CC~CostoCompra;
table TABLA IN "CSV" "CostoEnvio.csv": [Fabrica, Aceria], CE~CostoEnvio;
table TABLA IN "CSV" "MaximoAceria.csv": [Aceria], QQ~MaximoAcerias;
table TABLA IN "CSV" "CostoProcesamiento.csv": [TipoAcero, Aceria], CP~CostoProceso;
table TABLA IN "CSV" "Demanda.csv": [TipoAcero, Ciudad], D~Demanda;
table TABLA IN "CSV" "CostoTrans.csv": [TipoAcero, Aceria, Ciudad], CK~CostoTrans;

display H,A,C,P,Q,CC,CE,QQ,CP,D,CK;

/*VD*/
var x{H,A,P}>=0; /*Cantidad de hierro producido en la fabrica hEH enviado a la aceria aEA para producir el tipo de acero pEP en toneladas*/
var y{P,A,C}>=0; /*Cantidad de tipo de acero pEP producido en la aceria aEA y que es enviado a la ciudad cEC en toneladas*/

/*FO*/
minimize Z: (sum{h in H,a in A,p in P}(CC[h]+CE[h,a])*x[h,a,p])+(sum{p in P,a in A,c in C}(CP[p,a]+CK[p,a,c])*y[p,a,c]);

/*Restricciones*/
s.t. dispo_maxfab{h in H}:sum{a in A,p in P}x[h,a,p]<=Q[h];
s.t. proporcion1{a in A}:2*x['MA',a,'AC']=x['MB',a,'AC'];
s.t. proporcion2{a in A}:3*x['MA',a,'BC']=x['MB',a,'BC'];
s.t. dispo_maxac{a in A}:sum{p in P,c in C}y[p,a,c]<=QQ[a];
s.t. demanda{p in P,c in C}:sum{a in A}y[p,a,c]>=D[p,c];
s.t. balance{a in A}:sum{h in H,p in P}x[h,a,p]-sum{p in P,c in C}y[p,a,c]=0;


solve;


table TABLA{h in H, a in A,p in P} OUT "CSV" "CantidadTotalMaterial.csv": h~Fabrica, a~Aceria, p~TipoAcero, x[h,a,p]~CantidadHierro, x[h,a,p]*CC[h]~CostoTotalCompra;
table TABLA{p in P, a in A,c in C} OUT "CSV" "CantidadTotalTipo.csv": p~TipoAcero, a~Aceria, c~Ciudad, y[p,a,c]~CantidadTipoAcero, y[p,a,c]*CP[p,a]~CostoTotalProduccion;


printf: "\nCANTIDAD TOTAL DE TIPO DE ACERO ENVIADO A CADA CIUDAD\n";
printf: "\n";
for{p in P, a in A, c in C}{
printf: "La cantidad total del tipo de acero " & p & "\n";
printf: "producida en la aceria de " & a & "\n";
printf: "enviado a la ciudad de" & c & " es: " & y[p,a,c] & ".\n" ;
printf: "\n";
}


data;

set H:= MA MB;
set A:= Buc Tun;
set C:= Bog Cali Barq Med;
set P:= AC BC;



end;
