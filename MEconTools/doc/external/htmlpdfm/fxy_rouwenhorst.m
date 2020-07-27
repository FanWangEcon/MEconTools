%% FFY_ROUWENHORST AR1 Shock Discretization Example
% *back to* <https://fanwangecon.github.io *Fan*>*'s* <https://fanwangecon.github.io/Math4Econ/ 
% *Intro Math for Econ*>*,*  <https://fanwangecon.github.io/M4Econ/ *Matlab Examples*>*, 
% or* <https://fanwangecon.github.io/CodeDynaAsset/ *Dynamic Asset*> *Repositories*
% 
% This is the example vignette for function: <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/external/stats/ffy_rouwenhorst.m 
% *ffy_rouwenhorst*> from the <https://fanwangecon.github.io/MEconTools/ *MEconTools 
% Package*>*.* See also <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/external/stats/ffy_tauchen.m 
% *ffy_tauchen*> function from the <https://fanwangecon.github.io/MEconTools/ 
% *MEconTools Package*>*.* This function discretize a mean zero AR1 process, uses 
% Rouwenhorst (1995). See <https://fanwangecon.github.io/M4Econ/panel/timeseries/htmlpdfm/fs_autoregressive.html 
% AR 1 Example> for some details on how the AR1 process works. And See <https://doi.org/10.1016/j.red.2010.02.002 
% Kopecky and Suen (2010)>.
%% Test FFY_ROUWENHORST Defaults
% Call the function with defaults.

ffy_rouwenhorst();
%% Test FFY_ROUWENHORST Specify Parameters
% With a grid of 10 points, the Rwouenhorst bounds on standard deviations are 
% equall to Tauchen bounds of 3. With the not extremely persistent shock process 
% here, the Tauchen and Rouwenhorst Results are very similar.

[fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose] = ...
    deal(0.60, 0.10, 10, true);
ffy_rouwenhorst(fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose);
%% Test FFY_ROUWENHORST High Persistence, Low SD

[fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose] = ...
    deal(0.90, 0.02, 7, true);
[ar_z, mt_z_trans] = ffy_tauchen(fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose);
ar_z_stationary = mt_z_trans^1000;
ar_z_stationary = ar_z_stationary(1,:);
fl_labor_agg = ar_z_stationary*exp(ar_z);
ar_z = exp(ar_z')/fl_labor_agg;

%% Test FFY_ROUWENHORST Low Persistence, Low SD

[fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose] = ...
    deal(0.01, 0.01, 7, true);
ffy_rouwenhorst(fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose);
%% Test FFY_ROUWENHORST High Persistence, High SD

[fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose] = ...
    deal(0.99, 0.99, 7, true);
ffy_rouwenhorst(fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose);
%% Test FFY_ROUWENHORST Low Persistence, Low SD

[fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose] = ...
    deal(0.01, 0.01, 7, true);
ffy_rouwenhorst(fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose);