clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%% CL vs. alpha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% angles IN DEGREES
min_angle=0;
max_angle=90;
angle_step=0.25;
angle_list=min_angle:angle_step:max_angle;

% plotting lift coefficient vs angle of attack
a=min_angle;
i=1;
while a<(max_angle+angle_step)   
    [CLARinf(i)] = single_horseshoe_vortex_model(a*pi/180, 10000);
    [CLAR12(i)] = single_horseshoe_vortex_model(a*pi/180, 12);
    [CLAR6(i)] = single_horseshoe_vortex_model(a*pi/180, 6);
    [CLAR4(i)] = single_horseshoe_vortex_model(a*pi/180, 4);
    i = i+1;
    a=a+angle_step;
end

figure
plot(angle_list, CLARinf, angle_list, CLAR12, angle_list, CLAR6, angle_list, CLAR4, 'LineWidth', 5)
set(gca, 'FontSize', 30)
title('Lift Coefficient vs. Angle of Attack')
xlabel('Angle of Attack (Degrees)')
ylabel('Lift Coefficient')
legend('2D Data','AR=12','AR=6','AR=4')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%% lift curve slope vs. aspect ratio plot %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% angles IN DEGREES
min_angle=0;
max_angle=0.5;
angle_step=0.5;
angle_list=min_angle:angle_step:max_angle;

% aspect ratio range
min_AR=0;
max_AR=20;
AR_step=0.25;
AR_list = min_AR:AR_step:max_AR;

% plotting lift curve slope vs aspect ratio
k=min_AR;
q=1;
while k<(max_AR+AR_step)
    i=1;
    j=min_angle;
    while j < (max_angle+angle_step)   
        [CL1(i),CD1(i)] = single_horseshoe_vortex_model(j*pi/180, k);
        i = i+1;
        j=j+angle_step;    
    end
    NL_lift_curve_slope(q)=(CL1(2)-CL1(1))/((((min_angle*pi/180)+(angle_step*pi/180))-(min_angle*pi/180)));
    LLT(q) = 2*pi/(1+2*pi/(pi*k));
    helmbold(q) = (2*pi)/((1+(2/(k)^2))^0.5 + (2/(k)));
    k=k+AR_step;
    q=q+1;
end

figure
plot(AR_list, NL_lift_curve_slope, AR_list, LLT, '--', 'LineWidth', 7)
set(gca, 'FontSize', 30)
%title('Effect of Varying Aspect Ratio on the Lift Curve Slope')
xlabel('Aspect Ratio')
ylabel('Lift Curve Slope')
ylim([0,6])
legend('Nonlinear Aircraft Model', 'Classical Lifting Line Theory')
