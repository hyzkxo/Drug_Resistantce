%This code generates Fig. 3 in project, constant dosage.
%This code calculates relationship between dosage and survival time
%ODE function is defined in SysODE.m
%Baseline parameters are stored in get_parameters.m
clear all
close all

%adjust font size you like
curr_fontsize=18;

dose_lst=0:0.1:2;
time_lst=zeros(length(dose_lst),1);
for i=1:length(dose_lst)
[V,t,Vc]=give_V(dose_lst(i));
time_lst(i)=cal_survival(V,t,Vc);
end

h = tiledlayout(1,2, 'TileSpacing', 'compact', 'Padding', 'compact');

nexttile
hold on
for dose=0:0.5:2
    [V,t,Vc]=give_V(dose);
    plot(t,V,LineWidth=2)
end
T_max=cal_survival(V,t,Vc);
%plot part
plot(t,ones(length(t),1).*Vc,color='blue',LineStyle='--',LineWidth=2)
hold off
xlabel('Time, t',Interpreter='latex')
ylim([0,Vc])
xlim([0,T_max])
ylabel('Tumor volume, $V(t)$',Interpreter='latex')
text(0.02, 1.02, 'A', 'FontSize', curr_fontsize, 'FontWeight', 'bold', ...
    'Units', 'normalized');
legend('$u_{0}=0$','$u_{0}=0.5$','$u_{0}=1$','$u_{0}=1.5$','$u_{0}=2$', ...
    '$V_{c}$',Interpreter='latex')
legend1=legend;
box(gca, 'on');
set(gca, 'FontSize', curr_fontsize);

nexttile
plot(dose_lst,time_lst,LineWidth=2);
set(gca, 'FontSize', curr_fontsize);
xlim([0,2])
xlabel('Constant dosage, $u_{t}=u_{0}$',Interpreter='latex')
ylabel('Survival time, $t_{C}$',Interpreter='latex')
text(0.02, 1.02, 'B', 'FontSize', curr_fontsize, 'FontWeight', 'bold', ...
    'Units', 'normalized');
box(gca, 'on');

set(legend1, 'FontSize', curr_fontsize);

%this function calculate survial time based on dosage
function survival_time=cal_survival(V,t,Vc)
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

function [V,t,Vc]=give_V(dosage)
%params=[P1,P2,deltaC,deltaD,gammaC,gammaD,epsilonC,epsilonD,alphaC,...
%alphaD]
big_para=get_parameters();
params=big_para(1:end-1);
Vc=big_para(end);


%Initial conditions and time span. IC=[[C_S(0),D_S(0),C_R(0),D_R(0)]]
IC=[0.009,0.09,0.0001,0.0009];
tspan=[0,100];

%dosage function u(t)
u=@(t) dosage;

% Set the maximum step size
options = odeset('MaxStep', 0.01);
[t,y]=ode45(@(t,y) SysODE(t,y,u,params),tspan,IC,options);

V=y(:,1)+y(:,2)+y(:,3)+y(:,4);
end

