%% Laboratory 4 - Control Engineering I
%% CORRECTION IN GUILLEMIN-TRUXAL (ROOT LOCUS) METHOD
%% GOALS

% To highlight the advantages and disadvantages of the correction

% Controller design using the Guillemin-Truxal method

%% Problem
% For the process described by Hf(s) = Kf / (s*(Tf*s+1)), with Kf = 2,
% Tf = 5 sec and the performance indicators set [..] design the simplest
% controller possible using the dipole correction method. Demonstrate by
% plots that the imposed performance indicator set is met. What is
% happening when the process parameters (Kf and Tf) are changing?

% Kf = KfN +- 20%*KfN
% Tf = TfN +- 20%*TfN


%% 
% sigma <= 10%
% ts < 8 sec
% cv >=1.5
%deltawb  <=1.2

% Our function
Kf = 2;

Tf = 5;
Hf = tf(Kf, [Tf 1 0]);

raport = 1.05;

deltasigma = raport - 1 % 0.05 = 5%
sigmatotal = 0.10; % 10%

sigma2 = sigmatotal - deltasigma % 5 %
 
ts = 5;

zeta = abs(log(sigma2)/ sqrt(pi^2 + (log(sigma2))^2))
wn = 4/(ts*zeta)

deltawb = wn*sqrt(1-2*zeta^2 + sqrt(2-4*zeta^2+4*zeta^4)) % 0.98 <=1.2
cv = wn/2/zeta % cv >=1.5

cv_steluta = 1.7; % >=1.5
pc = deltasigma / (2*zeta/wn - 1/cv_steluta)
zc = pc/(1+deltasigma)


%Transfer function for order 2 
H0 = tf(wn^2, [1 2*zeta*wn wn^2])

%Transfer function Hoc including with zero zc and pole pc
Hoc = H0 * tf([1 zc], [1 pc])*tf(pc, zc)
step(Hoc); title('Step Response for Hoc');

%The controller (formula from lab)
Hr = minreal((1/Hf)*Hoc / (1-Hoc));
figure, step(Hr); title('Step Response for Hr Controller')

t=0:0.1:20;
figure, lsim(Hoc, t, t); title('Linear Simulation Results for Hoc');
%figure, lsim(Hr, t, t); title('Linear Simulation Results for Hr');

% Bode Diagrams 
figure, bode(H0) %at -3dB magnitude, we read the freq. = deltawb
%figure, bode(Hr) 
