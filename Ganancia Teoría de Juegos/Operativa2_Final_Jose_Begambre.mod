var x1>=0;
var x2>=0;
var x3>=0;
var x4>=0;
var x5>=0;
var x6>=0;
var x7>=0;
var x8>=0;
var x9>=0;
var x10>=0;
var v;

maximize Z:v;

/*Restricciones*/
s.t. res1: v-(-8*x1-3*x2+0*x3-6*x4+3*x5-2*x6-4*x7-10*x8+0*x9+0*x10)<=0; 
s.t. res2: v-(0*x1+1*x2-3*x3-9*x4-2*x5+2*x6+3*x7-8*x8+-1*x9-6*x10)<=0; 
s.t. res3: v-(-9*x1-8*x2-1*x3+3*x4-2*x5+2*x6+0*x7+2*x8-8*x9-4*x10)<=0; 
s.t. res4: x1+x2+x3+x4+x5+x6+x7+x8+x9+x10=1; 

end;




