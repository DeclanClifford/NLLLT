function[I]=vfil(xa,xb,xc)
% original by Professor N.Sandham at University of Southampton

% Inputs are the x,y and z co-ordinates of three points in space.
% The function works out the influence of the vortex line AB at a 
% control point C, returning zero if the denominator is less than
% 'small', so that self-influences are excluded.

small=1.0e-12;
ab=xb-xa;
ac=xc-xa;
bc=xc-xb;
cross=[ac(2)*bc(3)-ac(3)*bc(2); ac(3)*bc(1)-ac(1)*bc(3); ac(1)*bc(2)- ac(2)*bc(1)];
den=4.0*pi*(cross(1)^2+cross(2)^2+cross(3)^2);
absac=sqrt(ac(1)^2+ac(2)^2+ac(3)^2);
absbc=sqrt(bc(1)^2+bc(2)^2+bc(3)^2);
num=ab(1)*(ac(1)/absac-bc(1)/absbc)+ab(2)*(ac(2)/absac-bc(2)/absbc)+ab(3)*(ac(3)/absac-bc(3)/absbc);
if den<=small
 I=[0.0;0.0;0.0];
else
 I=num/den*cross;
end
