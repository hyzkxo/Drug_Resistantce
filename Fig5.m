%This code generates Fig. 5 in project, dosage impact in bolus injection.
%ODE function is defined in SysODE.m
%Baseline parameters are stored in get_parameters.m
clear all
close all
%params=[P1,P2,deltaC,deltaD,gammaC,gammaD,epsilonC,epsilonD,alphaC,...
%alphaD]
big_para=get_parameters();
params=big_para(1:end-1);
Vc=big_para(end);

%adjust font size you like
curr_fontsize=18;

%num_pts is number of dosages selected. u_lst is list of dosages.
%survival_lst is list of survival time
num_pts=40;
u_lst=linspace(0,16,num_pts);
survival_lst=zeros(num_pts,1);
for i=1:num_pts
[V,t]=give_V2(u_lst(i),params);
survival_lst(i)=cal_survival2(V,t,Vc);
end
h = tiledlayout(1,2, 'TileSpacing', 'compact', 'Padding', 'compact');

nexttile
hold on
for dose=0:4:16
    [V,t]=give_V2(dose,params);
    plot(t,V,LineWidth=2)
end
T_max=cal_survival2(V,t,Vc);
plot(t,ones(length(t),1).*Vc,color='blue',LineStyle='--',LineWidth=2)
hold off
xlabel('Time, t',Interpreter='latex')
ylim([0,Vc])
xlim([0,T_max])
ylabel('Tumor volume, $V(t)$',Interpreter='latex')
text(0.02, 1.02, 'A', 'FontSize', curr_fontsize, 'FontWeight', 'bold', ...
    'Units', 'normalized');
legend('$u_{max}=0$','$u_{max}=4$','$u_{max}=8$','$u_{max}=12$', ...
    '$u_{max}=16$','$V_{c}$',Interpreter='latex')
legend1=legend;
box(gca, 'on');
set(gca, 'FontSize', curr_fontsize);

nexttile
plot(u_lst,survival_lst)
set(gca, 'FontSize', curr_fontsize);
xlim([0,16])
xlabel('Maximum dosage, $u_{max}$',Interpreter='latex')
ylabel('Survival time, $t_{C}$',Interpreter='latex')
text(0.02, 1.02, 'B', 'FontSize', curr_fontsize, 'FontWeight', 'bold', ...
    'Units', 'normalized');
box(gca, 'on');

set(legend1, 'FontSize', curr_fontsize);
%simulate V based on u_max
function [V,t]=give_V2(u_max,params)
%Initial conditions and time span. IC=[[C_S(0),D_S(0),C_R(0),D_R(0)]]
IC=[0.009,0.09,0.0001,0.0009];
tspan=[0,100];
%dosage function u(t). generating function is defined at the end
%u_max is maximum dosage, OMEGA frequency 
OMEGA=25;
u=@(t) (square(2*pi*t*OMEGA, 1/u_max*100)+1)/2*u_max;

% Set the maximum step size
options = odeset('MaxStep', 0.01);
[t,y]=ode78(@(t,y) SysODE(t,y,u,params),tspan,IC,options);

V=y(:,1)+y(:,2)+y(:,3)+y(:,4);
end

%calculate survival time based on V
function survival_time=cal_survival2(V,t,Vc)
survival_time=0;
for i=1:length(t)
%if there is no V>0.8, ensure code doesn't fail
if i==length(t)
break
end

if V(i)<Vc && V(i+1)>=Vc
    survival_time=t(i);
end
end
end