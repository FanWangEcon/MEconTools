%% FF_VFI_AZ_MZOOM_LOOP Savings Loop Exact (VALUE) Examples
% *back to* <https://fanwangecon.github.io *Fan*>*'s* <https://fanwangecon.github.io/Math4Econ/ 
% *Intro Math for Econ*>*,*  <https://fanwangecon.github.io/M4Econ/ *Matlab Examples*>*, 
% or* <https://fanwangecon.github.io/CodeDynaAsset/ *Dynamic Asset*> *Repositories*
% 
% This is the example vignette for function:<https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_mzoom_loop.m  
% *ff_vfi_az_mzoom_loop*> from the <https://fanwangecon.github.io/MEconTools/ 
% *MEconTools Package*>*.* This function solves the dynamic programming problem 
% for a (a,z) model. The state-space is on a grid, but choice grids are in terms 
% of *percentage of resources* to save and solved exactly. 
% 
% This is a *looped* code for *continuous* choices, solved with the <https://fanwangecon.github.io/MEconTools/MEconTools/doc/optim/htmlpdfm/fx_optim_mzoom_savezrone.html 
% *mzoom*> algorithm. In contrast to the <https://fanwangecon.github.io/MEconTools/MEconTools/doc/optim/htmlpdfm/fx_optim_bisec_savezrone.html 
% *bisection*> based solution, this is slower, but this does not rely on first 
% order conditions.
% 
% *Links to Other Code:*
% 
% Core Savings/Borrowing Dynamic Programming Solution Functions that are functions 
% in the <https://fanwangecon.github.io/MEconTools/ *MEconTools Package*>*.* :
%% 
% * Common Choice and States Grid _*Loop*_: <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_loop.m 
% *ff_vfi_az_loop*>
% * Common Choice and States Grid _*Vectorized*_:  <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_vec.m 
% *ff_vfi_az_vec*>
% * States Grid + Continuous Exact Savings as Share of Cash-on-Hand, rely on 
% FOC, _*Loop*_:<https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_bisec_loop.m  
% *ff_vfi_az_bisec_loop*>
% * States Grid + Continuous Exact Savings as Share of Cash-on-Hand, rely on 
% FOC _*Vectorized*_: <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_bisec_vec.m 
% *ff_vfi_az_bisec_vec*>
% * States Grid + Continuous Exact Savings as Share of Cash-on-Hand, VALUE comparison, 
% _*Loop*_:<https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_mzoom_loop.m  
% *ff_vfi_az_mzoom_loop*>
% * States Grid + Continuous Exact Savings as Share of Cash-on-Hand, VALUE comparison, 
% _*Vectorized*_: <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_mzoom_vec.m 
% *ff_vfi_az_mzoom_vec*>
%% Test FF_VFI_AZ_MZOOM_LOOP Defaults
% Call the function with defaults. By default, shows the asset policy function 
% summary. Model parameters can be changed by the mp_params.

%mp_params
mp_params = containers.Map('KeyType','char', 'ValueType','any');
mp_params('fl_crra') = 1.5;
mp_params('fl_beta') = 0.94;
% call function
ff_vfi_az_mzoom_loop(mp_params);
%% Test FF_VFI_AZ_MZOOM_LOOP Speed Tests
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
ff_vfi_az_mzoom_loop(mp_params, mp_support);
%% 
% A grid 750, shock grid 15:

mp_params = containers.Map('KeyType','char', 'ValueType','any');
mp_params('it_a_n') = 750;
mp_params('it_z_n') = 15;
ff_vfi_az_mzoom_loop(mp_params, mp_support);
%% 
% A grid 600, shock grid 45:

mp_params = containers.Map('KeyType','char', 'ValueType','any');
mp_params('it_a_n') = 600;
mp_params('it_z_n') = 45;
ff_vfi_az_mzoom_loop(mp_params, mp_support);
%% Test FF_VFI_AZ_MZOOM_LOOP Control Outputs
% Run the function first without any outputs, but only the timer.

mp_params = containers.Map('KeyType','char', 'ValueType','any');
mp_params('it_a_n') = 50;
mp_params('it_z_n') = 5;
mp_support = containers.Map('KeyType','char', 'ValueType','any');
mp_support('bl_timer') = true;
mp_support('bl_print_params') = false;
mp_support('bl_print_iterinfo') = false;
mp_support('ls_ffcmd') = {};
ff_vfi_az_mzoom_loop(mp_params, mp_support);
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
ff_vfi_az_mzoom_loop(mp_params, mp_support);
%% 
% Run the function and show summaries for savings and fraction of coh saved:

%mp_params
mp_params = containers.Map('KeyType','char', 'ValueType','any');
% mp_params('fl_crra') = 1.5;
% mp_params('fl_beta') = 0.94;
mp_params('it_a_n') = 100;
mp_params('it_z_n') = 9;
mp_support = containers.Map('KeyType','char', 'ValueType','any');
mp_support('bl_print_params') = false;
mp_support('bl_print_iterinfo') = false;
% ls_ffcmd: summary print which outcomes
mp_support('ls_ffcmd') = {};
% ls_ffsna: detail print which outcomes
mp_support('ls_ffsna') = {'savefraccoh'};
% ls_ffgrh: graphical print which outcomes
mp_support('ls_ffgrh') = {'savefraccoh'};
% call function
ff_vfi_az_mzoom_loop(mp_params, mp_support);
%% Test FF_VFI_AZ_MZOOM_LOOP Change Interest Rate and Discount
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
ff_vfi_az_mzoom_loop(mp_params, mp_support);
% Higher Savings Incentives
mp_params('fl_beta') = 0.95;
mp_params('fl_r') = 0.04;
ff_vfi_az_mzoom_loop(mp_params, mp_support);
%% Test FF_VFI_AZ_MZOOM_LOOP Changing Risk Aversion
% Here, again, show fraction of coh saved in summary tabular form, but also 
% show it graphically.

mp_support = containers.Map('KeyType','char', 'ValueType','any');
mp_support('bl_print_params') = false;
mp_support('bl_print_iterinfo') = false;
mp_support('ls_ffcmd') = {'savefraccoh'};
mp_support('ls_ffsna') = {};
mp_support('ls_ffgrh') = {'savefraccoh'};
mp_params = containers.Map('KeyType','char', 'ValueType','any');
mp_params('it_a_n') = 100;
mp_params('it_z_n') = 7;
mp_params('fl_a_max') = 50;
mp_params('st_grid_type') = 'grid_powerspace';
%% 
% Solve the model with different risk aversion levels, higher preferences for 
% risk:

% Lower Risk Aversion
mp_params('fl_crra') = 0.5;
ff_vfi_az_mzoom_loop(mp_params, mp_support);
%% 
% When risk aversion increases, at every state-space point, the household wants 
% to save more.

% Higher Risk Aversion
mp_params('fl_crra') = 5;
ff_vfi_az_mzoom_loop(mp_params, mp_support);
%% Test FF_VFI_AZ_MZOOM_LOOP with Higher Uncertainty
% Increase the standard deviation of the Shock. 

mp_support = containers.Map('KeyType','char', 'ValueType','any');
mp_support('bl_print_params') = false;
mp_support('bl_print_iterinfo') = false;
mp_support('ls_ffcmd') = {'savefraccoh'};
mp_support('ls_ffsna') = {};
mp_support('ls_ffgrh') = {};
mp_params = containers.Map('KeyType','char', 'ValueType','any');
mp_params('it_a_n') = 150;
mp_params('it_z_n') = 15;
mp_params('fl_a_max') = 50;
mp_params('st_grid_type') = 'grid_powerspace';
%% 
% Lower standard deviation of shock:

% Lower Risk Aversion
mp_params('fl_shk_std') = 0.10;
ff_vfi_az_mzoom_loop(mp_params, mp_support);
%% 
% Higher shock standard deviation: low shock high asset save more, high shock 
% more asset save less, high shock low asset save more:

% Higher Risk Aversion
mp_params('fl_shk_std') = 0.40;
ff_vfi_az_mzoom_loop(mp_params, mp_support);