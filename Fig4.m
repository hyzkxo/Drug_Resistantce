%This code generates Fig. 4 in project, bolus injection.
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

%Initial conditions and time span. IC=[[C_S(0),D_S(0),C_R(0),D_R(0)]]
IC=[0.009,0.09,0.0001,0.0009];
tspan=[0,67.8];

%dosage function u(t). generating function is defined at the end
%u_max is maximum dosage, OMEGA frequency 
u_max=12;
OMEGA=25;
u=@(t) (square(2*pi*t*OMEGA, 1/u_max*100)+1)/2*u_max;

% Set the maximum step size
options = odeset('MaxStep', 0.01);
[t,y]=ode45(@(t,y) SysODE(t,y,u,params),tspan,IC,options);

V=y(:,1)+y(:,2)+y(:,3)+y(:,4);

h = tiledlayout(2,2, 'TileSpacing', 'compact', 'Padding', 'compact');

nexttile
T=linspace(0,0.2,1000);
plot(T,u(T),linewidth=2)
xlabel('Time, $t$',Interpreter='latex')
ylabel('Effective dosage, $u(t)$',Interpreter='latex')
ylim([0,u_max])
xlim([0,0.2])
set(gca, 'FontSize', curr_fontsize);
text(0.02, 1.05, 'A', 'FontSize', curr_fontsize, 'FontWeight', 'bold', ...
    'Units', 'normalized');

nexttile
p=(y(:,1)+y(:,3))./V;
plot(t, p,linewidth=2);
xlim(tspan)
ylim([min(p)-0.01,max(p)+0.01])
xlabel('Time, $t$',Interpreter='latex')
ylabel('Portion of CSCs, $p(t)$',Interpreter='latex');
set(gca, 'FontSize', curr_fontsize);
text(0.02, 1.05, 'B', 'FontSize', curr_fontsize, 'FontWeight', 'bold', ...
    'Units', 'normalized');

nexttile
hold on
plot(t,y(:,3),linewidth=2,color='red')
plot(t,y(:,4),linewidth=2,color='green')
hold off
ylim([0,0.001+max(max(y(:,3)),max(y(:,4)))])
xlim(tspan)
xlabel('Time, $t$',Interpreter='latex')
ylabel('Cell population',Interpreter='latex')
legend('$C_{R}$','$D_{R}$',Interpreter='latex')
legend1=legend;
set(gca, 'FontSize', curr_fontsize);
box(gca, 'on');
text(0.02, 1.05, 'C', 'FontSize', curr_fontsize, 'FontWeight', 'bold', ...
    'Units', 'normalized');

nexttile
hold on
plot(t,y(:,1),linewidth=2,color='black')
plot(t,y(:,2),linewidth=2,color='magenta')
plot(t,V,linewidth=2,color='cyan')
plot(t,ones(length(t),1).*Vc,color='blue',LineStyle='--')
hold off
ylim([0,0.03+max(V)])
xlim(tspan)
xlabel('Time, $t$',Interpreter='latex')
ylabel('Cell population',Interpreter='latex')
legend('$C_{S}$','$D_{S}$','$V$','$V_{c}$',Interpreter='latex')
legend2=legend;
set(gca, 'FontSize', curr_fontsize);
box(gca, 'on');
text(0.02, 1.05, 'D', 'FontSize', curr_fontsize, 'FontWeight', 'bold', ...
    'Units', 'normalized');

set(legend1, 'FontSize', curr_fontsize);
set(legend2, 'FontSize', curr_fontsize);

