function[CL,CDi] = single_horseshoe_vortex_model(alpha, AR)

% function calculates lift and induced drag coefficients of a straight,
% rectangular planform wing of a user specified aspect ratio at a given
% angle of attack.

format short

maxiterations=500;                 % maximum number of iterations
tolerance=2.5e-12;                 % tolerance before breaking out of loop   
Vinf=1;                            % free stream velocity
cw=1;                              % wing chord
bw=AR*cw;                          % wing span
factbp=1/sqrt(2);                  % trailing vortex distance factor
large=1.0e6;                       % length of trailing vortices
bp=bw*factbp;                      % distance between trailing vortices

% coordinates of vortex segment and control point location on wing
xa=[0.0;-0.5*bp;0.0];
xb=[0.0;0.5*bp;0.0];
xc=0.5*(xa+xb);

% trailing vortices aligned with free stream
trvort=[large;0;large*sin(alpha)];
% trailing vortices fixed to lifting surface
%trvort=[large;0;0];

% wing aerofoil
aerofoil_details=[14*pi/180, 2*pi/180, -14*pi/180, 2*pi/180, 1, 0];
aerofoil=aerofoil_details;
            
% velocity relative to wing datum line
Q(:,1)=[Vinf*cos(alpha); 0.0; Vinf*sin(alpha)]; 

% iterative method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%% first iteration %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1;

% call sectional lift coefficient from known plot
Cl=clsectional(alpha, aerofoil);
% calculate circulation using sectional lift coefficient
gamma=Cl*Vinf*cw/(2*factbp);

% calculate inductions from trailing vortices
I=vfil(xa+trvort,xa,xc);
I=I+vfil(xb,xb+trvort,xc);

% calculate induced velocity (downwash)
wi=gamma*I(3);

% induced angle of attack calculation
if Q==0.0 % zero velocity condition
    alpha_i=0.0;                      
else      % non-zero velocity condition
    alpha_i=atan2(-wi,Vinf);      
end

% effective angle of attack calculation
alpha_e(i)=alpha - alpha_i;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%% second to INth iteration %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% number of iterations before entering loop
IN=5;
for i=2:IN
    
    % call sectional lift coefficient from known plot
    Cl=clsectional(alpha_e(i-1), aerofoil);
    % calculate circulation using sectional lift coefficient
    gamma=Cl*Vinf*cw/(2*factbp);

    % calculate inductions from trailing vortices
    I=vfil(xa+trvort,xa,xc);
    I=I+vfil(xb,xb+trvort,xc);

    % calculate induced velocity (downwash)
    wi=gamma*I(3);

    % induced angle of attack calculation
    if Q==0.0 % zero velocity condition
        alpha_i_new=0.0;                      
    else      % non-zero velocity condition
        alpha_i_new=atan2(-wi,Vinf);      
    end

    % effective angle of attack calculation
    alpha_e(i) = alpha - alpha_i_new;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%% iteration loop %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=IN+1;
while i < maxiterations
    
    % call sectional lift coefficient from known plot
    Cl=clsectional(alpha_e(i-1), aerofoil);
    % calculate circulation using sectional lift coefficient
    gamma=Cl*Vinf*cw/(2*factbp);

    % calculate inductions from trailing vortices
    I=vfil(xa+trvort,xa,xc);
    I=I+vfil(xb,xb+trvort,xc);

    % calculate induced velocity (downwash)
    wi=gamma*I(3);

    % induced angle of attack calculation
    if Q==0.0 % zero velocity condition
        alpha_i_new=0.0;                      
    else      % non-zero velocity condition
        alpha_i_new=atan2(-wi,Vinf);      
    end

    % generating new effective angle of attack
    alpha_e(i)=0.5*alpha_e(i-1)+0.5*(alpha-alpha_i_new);

    % break condition to prevent zero value denominator
    if alpha_e(i-1)<1e-100
        alpha_e_final=alpha_e(i);
        break

    % break condition if within specified tolerance
    elseif abs((alpha_e(i-IN)-alpha_e(i))/alpha_e(i-IN))<=(tolerance)
        alpha_e_final=alpha_e(i);
        break

    % break condition if exceeding maximum number of iterations   
    elseif i+1>maxiterations
        disp('DID NOT CONVERGE')
        return

    % next iteration
    else
        i=i+1;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%% calculating converged wing state %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% call sectional lift coefficient from known plot
Cl_final=clsectional(alpha_e_final, aerofoil);
% calculate circulation using sectional lift coefficient
gamma_final=Cl_final*Vinf*cw/(2*factbp);

% finding the local velocity vector u on each load element i
u=Q;
u=u+vfil(xa+[large;0;0],xa,xc)*gamma_final;
u=u+vfil(xb,xb+[large;0;0],xc)*gamma_final;

% u cross s gives the direction of the force
s=xb-xa;
Fx=(u(2)*s(3)-u(3)*s(2))*gamma_final;
Fz=(u(1)*s(2)-u(2)*s(1))*gamma_final;

% calculating lift and drag coefficients
CL=(Fz*cos(alpha)-Fx*sin(alpha))/(0.5*bw*cw);
CDi=(Fx*cos(alpha)+Fz*sin(alpha))/(0.5*bw*cw);
