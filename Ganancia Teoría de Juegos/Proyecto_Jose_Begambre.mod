var x1>=0;
var x2>=0;
var x3>=0;
var v;

maximize Z:v;

/*Restricciones*/
s.t. res1: v-3*x1+2*x2+5*x3<=0; 
s.t. res2: v+x1-4*x2+6*x3<=0; 
s.t. res3: v+3*x1+x2-2*x3<=0; 
s.t. res4: x1+x2+x3=1; 

end;