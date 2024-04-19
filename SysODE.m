%the dimensionless ODE system
function dydt=SysODE(t,y,u,params)
%convert array "params" to cell and assign parameters
C_para=num2cell(params);
[P1,P2,deltaC,deltaD,gammaCS,gammaDS,gammaCR,gammaDR,epsilonC,epsilonD,alphaC,...
    alphaD]=deal(C_para{:});
%order of four variables
C_y=num2cell(y);
[CS,DS,CR,DR]=deal(C_y{:});
V=CS+CR+DS+DR;

%ODE equation
dydt=zeros(4,1);
dydt(1)=(2*P1-1)*(1-V)*CS-(deltaC+gammaCS*u(t))*CS...
    -(epsilonC+alphaC*u(t))*CS;
dydt(2)=2*(1-P1)*(1-V)*CS-(deltaD+gammaDS*u(t))*DS...
    -(epsilonD+alphaD*u(t))*DS;
dydt(3)=(2*P2-1)*(1-V)*CR-(deltaC+gammaCR*u(t))*CR+(epsilonC+alphaC*u(t))*CS;
dydt(4)=2*(1-P2)*(1-V)*CR-(deltaD+gammaDR*u(t))*DR+(epsilonD+alphaD*u(t))*DS;
end