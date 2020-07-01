%% FF_VFI_AZ_BISEC_VEC Dynamic Savings Problem Vectorized Continuous Exact
% *back to* <https://fanwangecon.github.io *Fan*>*'s* <https://fanwangecon.github.io/Math4Econ/ 
% *Intro Math for Econ*>*,*  <https://fanwangecon.github.io/M4Econ/ *Matlab Examples*>*, 
% or* <https://fanwangecon.github.io/CodeDynaAsset/ *Dynamic Asset*> *Repositories*
% 
% This is the example vignette for function: <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_bisec_vec.m 
% *ff_vfi_az_bisec_vec*> from the <https://fanwangecon.github.io/MEconTools/ *MEconTools 
% Package*>*.* This function solves the dynamic programming problem for a (a,z) 
% model. Households can save a, and face AR(1) shock z. The problem is solved 
% over the infinite horizon. This is a vectorized code, it is much faster for 
% larger state-space problems then looped code.
% 
% The code uses continuous choices, solved with bi(multi)section. The state-space 
% is on a grid, but choice grids are in terms of percentage of resources available, 
% which is individual specific, to save and solved exactly up to ((1/(2)^16)*100=0.001525878) 
% percentage of cash on hand. THe  <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_vec.m 
% *ff_vfi_az_vec*> from the <https://fanwangecon.github.io/MEconTools/ *MEconTools 
% Package*> solves the same problem using vectorized common grid code where the 
% choice set and state space share the same grid. 
% 
% This is the vectorized code, its speed is much faster than the looped code. 
% The function is designed to have small memory footprint and requires low computing 
% resources, yet is fast.
% 
% *Links to Four Code:*
% 
% Four Core Savings/Borrowing Dynamic Programming Solution Functions that are 
% functions in the <https://fanwangecon.github.io/MEconTools/ *MEconTools Package*>*.* 
% :
%% 
% * Common Choice and States Grid _*Loop*_: <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_loop.m 
% *ff_vfi_az_loop*>, slow should use for testing new models
% * Common Choice and States Grid _*Vectorized*_:  <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_vec.m 
% *ff_vfi_az_vec*>, fast good for many purposes
% * States Grid + Continuous Exact Savings as Share of Cash-on-Hand _*Loop*_:<https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_bisec_loop.m  
% *ff_vfi_az_bisec_loop*>, high precision even with small grid
% * States Grid + Continuous Exact Savings as Share of Cash-on-Hand _*Vectorized*_: 
% <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_bisec_vec.m 
% *ff_vfi_az_bisec_vec*>, precision and speed
%% Test FF_VFI_AZ_BISEC_VEC Defaults
% Call the function with defaults. By default, shows the asset policy function 
% summary. Model parameters can be changed by the mp_params.

%mp_params
mp_params = containers.Map('KeyType','char', 'ValueType','any');
mp_params('fl_crra') = 1.5;
mp_params('fl_beta') = 0.94;
% call function
ff_vfi_az_bisec_vec(mp_params);
%% Test FF_VFI_AZ_BISEC_VEC Speed Tests
% Call the function with defaults. By default, shows the asset policy function 
% summary. Model parameters can be changed by the mp_params.

mp_support = containers.Map('KeyType','char', 'ValueType','any');
mp_support('bl_timer') = true;
mp_support('ls_ffcmd') = {};
%% 
% A grid 50, shock grid 5:

mp_params = containers.Map('KeyType','char', 'ValueType','any');
mp_params('it_a_n') = 50;
mp_params('it_z_n') = 5;
ff_vfi_az_bisec_vec(mp_params, mp_support);
%% 
% A grid 750, shock grid 15:

mp_params = containers.Map('KeyType','char', 'ValueType','any');
mp_params('it_a_n') = 750;
mp_params('it_z_n') = 15;
ff_vfi_az_bisec_vec(mp_params, mp_support);
%% 
% A grid 600, shock grid 45:

mp_params = containers.Map('KeyType','char', 'ValueType','any');
mp_params('it_a_n') = 600;
mp_params('it_z_n') = 45;
ff_vfi_az_bisec_vec(mp_params, mp_support);
%% Test FF_VFI_AZ_BISEC_VEC Control Outputs
% Run the function first without any outputs;

mp_params = containers.Map('KeyType','char', 'ValueType','any');
mp_params('it_a_n') = 50;
mp_params('it_z_n') = 5;
mp_support = containers.Map('KeyType','char', 'ValueType','any');
mp_support('bl_timer') = false;
mp_support('bl_print_params') = false;
mp_support('bl_print_iterinfo') = false;
%% 
% Run the function and show policy function for savings choice. For ls_ffcmd, 
% ls_ffsna, ls_ffgrh, can include these: 'v', 'ap', 'c', 'y', 'coh', 'savefraccoh'. 
% These are value, aprime savings choice, consumption, income, cash on hand, and 
% savings fraction as cash-on-hand.

mp_support = containers.Map('KeyType','char', 'ValueType','any');
mp_support('bl_print_params') = false;
mp_support('bl_print_iterinfo') = false;
% ls_ffcmd: summary print which outcomes
mp_support('ls_ffcmd') = {};
% ls_ffsna: detail print which outcomes
mp_support('ls_ffsna') = {'savefraccoh'};
% ls_ffgrh: graphical print which outcomes
mp_support('ls_ffgrh') = {'savefraccoh'};
ff_vfi_az_bisec_vec(mp_params, mp_support);
%% 
% Run the function and show summaries for savings and fraction of coh saved:

mp_params('it_a_n') = 100;
mp_params('it_z_n') = 9;
mp_support('ls_ffcmd') = {'ap', 'savefraccoh'};
mp_support('ls_ffsna') = {};
mp_support('ls_ffgrh') = {};
mp_support('bl_vfi_store_all') = true; % store c(a,z), y(a,z)
ff_vfi_az_bisec_vec(mp_params, mp_support);
%% Test FF_VFI_AZ_BISEC_VEC Change Interest Rate and Discount
% Show only save fraction of cash on hand:

mp_support = containers.Map('KeyType','char', 'ValueType','any');
mp_support('bl_print_params') = false;
mp_support('bl_print_iterinfo') = false;
mp_support('ls_ffcmd') = {'savefraccoh'};
mp_support('ls_ffsna') = {};
mp_support('ls_ffgrh') = {};
mp_params = containers.Map('KeyType','char', 'ValueType','any');
mp_params('it_a_n') = 750;
mp_params('it_z_n') = 9;
mp_params('fl_a_max') = 50;
mp_params('st_grid_type') = 'grid_powerspace';
%% 
% Solve the model with several different interest rates and discount factor:

% Lower Savings Incentives
mp_params('fl_beta') = 0.80;
mp_params('fl_r') = 0.01;
ff_vfi_az_bisec_vec(mp_params, mp_support);
% Higher Savings Incentives
mp_params('fl_beta') = 0.95;
mp_params('fl_r') = 0.04;
ff_vfi_az_bisec_vec(mp_params, mp_support);
%% Test FF_VFI_AZ_BISEC_VEC Changing Risk Aversion
% Here, again, show fraction of coh saved in summary tabular form, but also 
% show it graphically.

mp_support = containers.Map('KeyType','char', 'ValueType','any');
mp_support('bl_print_params') = false;
mp_support('bl_print_iterinfo') = false;
mp_support('ls_ffcmd') = {'savefraccoh'};
mp_support('ls_ffsna') = {};
mp_support('ls_ffgrh') = {'savefraccoh'};
mp_params = containers.Map('KeyType','char', 'ValueType','any');
mp_params('it_a_n') = 750;
mp_params('it_z_n') = 9;
mp_params('fl_a_max') = 50;
mp_params('st_grid_type') = 'grid_powerspace';
%% 
% Solve the model with different risk aversion levels, higher preferences for 
% risk:

% Lower Risk Aversion
mp_params('fl_crra') = 0.5;
ff_vfi_az_bisec_vec(mp_params, mp_support);
%% 
% When risk aversion increases, at every state-space point, the household wants 
% to save more.

% Higher Risk Aversion
mp_params('fl_crra') = 5;
ff_vfi_az_bisec_vec(mp_params, mp_support);
%% Test FF_VFI_AZ_BISEC_VEC with Higher Uncertainty
% Increase the standard deviation of the Shock. 

mp_support = containers.Map('KeyType','char', 'ValueType','any');
mp_support('bl_print_params') = false;
mp_support('bl_print_iterinfo') = false;
mp_support('ls_ffcmd') = {'savefraccoh'};
mp_support('ls_ffsna') = {};
mp_support('ls_ffgrh') = {};
mp_params = containers.Map('KeyType','char', 'ValueType','any');
mp_params('it_a_n') = 750;
mp_params('it_z_n') = 9;
mp_params('fl_a_max') = 50;
mp_params('st_grid_type') = 'grid_powerspace';
%% 
% Lower standard deviation of shock:

% Lower Risk Aversion
mp_params('fl_shk_std') = 0.10;
ff_vfi_az_bisec_vec(mp_params, mp_support);
%% 
% Higher shock standard deviation: low shock high asset save more, high shock 
% more asset save less, high shock low asset save more:

% Higher Risk Aversion
mp_params('fl_shk_std') = 0.40;
ff_vfi_az_bisec_vec(mp_params, mp_support);