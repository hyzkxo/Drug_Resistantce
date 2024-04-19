%Baseline parameters 
function result=get_parameters()
P1=0.65;
P2=0.68;
deltaC=0.03;
deltaD=0.04;
gammaCS=0.04;
gammaDS=0.08;
gammaCR=0.02;
gammaDR=0.03;
epsilonC=1e-6;
epsilonD=2e-6;
alphaC=2e-3;
alphaD=3e-3;
Vc=0.8;
result=[P1,P2,deltaC,deltaD,gammaCS,gammaDS,gammaCR,gammaDR,epsilonC,epsilonD,alphaC,...
    alphaD,Vc];
end