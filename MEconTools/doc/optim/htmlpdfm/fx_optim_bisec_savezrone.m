%% FF_OPTIM_BISEC_SAVEZRONE Derivative Bisection
% *back to* <https://fanwangecon.github.io *Fan*>*'s* <https://fanwangecon.github.io/Math4Econ/ 
% *Intro Math for Econ*>*,*  <https://fanwangecon.github.io/M4Econ/ *Matlab Examples*>*, 
% or* <https://fanwangecon.github.io/CodeDynaAsset/ *Dynamic Asset*> *Repositories*
% 
% This is the example vignette for function: <https://github.com/FanWangEcon//MEconTools/blob/master/MEconTools/optim/ff_optim_bisec_savezrone.m 
% *ff_optim_bisec_savezrone*> from the <https://fanwangecon.github.io/MEconTools/ 
% *MEconTools Package*>*.* This functions solves for optimal savings/borrowing 
% level given an anonymous function that provides the derivative of a intertemporal 
% savings problem. The function is solves over a grid of state-space elements 
% that are embeded in the anonymous function. By default, it iterates over 15 
% iterations with bisection.
% 
% The vectorized and looped bisection savings problem rely on this function 
% to solve for optimal savings choices:
%% 
% * States Grid + Continuous Exact Savings as Share of Cash-on-Hand _*Loop*_:<https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_bisec_loop.m  
% *ff_vfi_az_bisec_loop*>, high precision even with small grid
% * States Grid + Continuous Exact Savings as Share of Cash-on-Hand _*Vectorized*_: 
% <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_bisec_vec.m 
% *ff_vfi_az_bisec_vec*>, precision and speed
%% Test FF_OPTIM_BISEC_SAVEZRONE Defaults
% Call the function with defaults, this solves concurrently for many state-space 
% points' optimization problems:

ff_optim_bisec_savezrone();
%% Test FF_OPTIM_BISEC_SAVEZRONE One Individual
% Bisection for savings choice at one state:

% Generate the state-space and function
[fl_z1, fl_z2, fl_r, fl_beta] = deal(0.4730, 0.6252, 0.0839, 0.7365);
% ffi_intertemporal_max is a function in ff_optim_bisec_savezrone for testing
fc_deri_wth_uniroot = @(x) ffi_intertemporal_max(x, fl_z1, fl_z2, fl_r, fl_beta);
% Call Function
bl_verbose = true;
ff_optim_bisec_savezrone(fc_deri_wth_uniroot, bl_verbose);
%% Test FF_OPTIM_BISEC_SAVEZRONE Six Individual States
% Solve the two period intertemporal optimization problem with only 6 individual 
% states:

% Generate the state-space and function
ar_z1 = [1,2,3]';
ar_z2 = [3,2,1]';
ar_r = [1.05, 1.50, 1.30]';
ar_beta = [0.80, 0.95, 1.50]';
mt_fc_inputs = [ar_z1, ar_z2, ar_r, ar_beta];
% ffi_intertemporal_max is a function in ff_optim_bisec_savezrone for testing
fc_deri_wth_uniroot = @(x) ffi_intertemporal_max(x, ar_z1, ar_z2, ar_r, ar_beta);
% Call Function
bl_verbose = true;
ff_optim_bisec_savezrone(fc_deri_wth_uniroot, bl_verbose);
%% Test FF_OPTIM_BISEC_SAVEZRONE Speed
% Test Speed doing 6.25 million bisections for a savings problem:

% Generate the state-space and function
rng(123);
it_draws = 6250000; % must be even number
ar_z1 = exp(rand([it_draws,1])*3-1.5);
ar_z2 = exp(rand([it_draws,1])*3-1.5);
ar_r = (rand(it_draws,1)*10.0);
ar_beta = [rand(round(it_draws/2),1)*0.9+0.1; rand(round(it_draws/2),1)*0.9+1]; 
% ffi_intertemporal_max is a function in ff_optim_bisec_savezrone for testing
fc_deri_wth_uniroot = @(x) ffi_intertemporal_max(x, ar_z1, ar_z2, ar_r, ar_beta);
% Call Function
bl_verbose = false;
bl_timer = true;
[ar_opti_save_frac, ar_opti_save_level] = ff_optim_bisec_savezrone(fc_deri_wth_uniroot, bl_verbose, bl_timer);
mp_container_map = containers.Map('KeyType','char', 'ValueType','any');
mp_container_map('ar_opti_save_frac') = ar_opti_save_frac;
mp_container_map('ar_opti_save_level') = ar_opti_save_level;
mp_container_map('ar_opti_save_frac_notnan') = ar_opti_save_frac(~isnan(ar_opti_save_frac));
ff_container_map_display(mp_container_map);
figure();
histogram(ar_opti_save_frac(~isnan(ar_opti_save_frac)),100);
title('Distribution of Optimal Savings Fractions');
xlabel('Savings Fractions');
grid on;
%% Define Two Period Intertemporal FOC Log Utility No Shock
% See <https://fanwangecon.github.io/Math4Econ/derivative_application/htmlpdfm/K_save_households.html 
% Household’s Utility Maximization Problem and Two-Period Borrowing and Savings 
% Problem given Endowments>.

function [ar_deri_zero, ar_saveborr_level] = ffi_intertemporal_max(ar_saveborr_frac, z1, z2, r, beta)
    ar_saveborr_level = ar_saveborr_frac.*(z1+z2./(1+r)) - z2./(1+r);
    ar_deri_zero = 1./(ar_saveborr_level-z1) + (beta.*(r+1))./(z2 + ar_saveborr_level.*(r+1));
end