// Stochastic Neoclassical Growth Model
// July, 2017
// The two // are the way to write comments in Dynare mod-files.

//----------------------------------------------------------------
// 1. & 2. Define the Endogenous and Exogenous Variables
//----------------------------------------------------------------

// 1. Endogenous variables of the model
var
c                       // Consumption 
k                       // Capital
z                       // Technology
;

// 2. Exogenous variables of the model
varexo 
epsilon
;


//----------------------------------------------------------------
// 3. Define the Parameters
//----------------------------------------------------------------
parameters
beta                    // Discount rate (quarterly rate)
delta                   // Depreciation of capital (quarterly rate)
alpha                   // Capital income share (=1-Labour income share)
gammac                  // Curvature of consumption in utility function
zbar                    // Technology in steady-state
rho                     // Autocorrelation of shock
sigma_epsilon           // Volatility of shock
;

//----------------------------------------------------------------
// 4. Set the Parameter Values
//----------------------------------------------------------------

load paramsfordynare;
set_param_value('beta',beta);
set_param_value('alpha',alpha);
set_param_value('delta',delta);
set_param_value('gammac',gammac);
set_param_value('rho',rho);
set_param_value('sigma_epsilon',sigma_epsilon);
zbar = 0;               // normalization


//----------------------------------------------------------------
// 5. Define the Model
//----------------------------------------------------------------
model;
c^(-gammac)=beta*(c(+1)^(-gammac))*(alpha*exp(z(+1))*(k^(alpha-1)) +1-delta);       // (intertemporal) Euler Equation
c+k=exp(z)*(k(-1)^(alpha))+(1-delta)*k(-1);                                             // Budget constraint
z=rho*z(-1)+epsilon;                                                                   // Technology process
end;

//----------------------------------------------------------------
// 6. Set the Exogenous Shock Processes
//----------------------------------------------------------------
shocks;
var epsilon = sigma_epsilon^2;
end;

//----------------------------------------------------------------
// 7. Set initial values (guesses) for steady-state
//----------------------------------------------------------------
initval;
c    =3.5; 
k    =50; 
z    =0;
end;

//----------------------------------------------------------------
// 8. Solve for the steady-state
//----------------------------------------------------------------
steady(solve_algo=2);
check;

//----------------------------------------------------------------
// 9. Solve the dynamic-stochastic model
//----------------------------------------------------------------
stoch_simul(periods=2000, order=2, irf=50);
// Creates a simulation of 2000 points, using 2nd order perturbation methods, and create impulse response functions of 50 periods
// Simulated data is then stored in oo_.endosimul (and oo_.exosimul), which you can find in the Matlab workspace.


