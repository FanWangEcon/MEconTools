%% FFY_TAUCHEN AR1 Shock Discretization Example
% *back to* <https://fanwangecon.github.io *Fan*>*'s* <https://fanwangecon.github.io/Math4Econ/ 
% *Intro Math for Econ*>*,*  <https://fanwangecon.github.io/M4Econ/ *Matlab Examples*>*, 
% or* <https://fanwangecon.github.io/CodeDynaAsset/ *Dynamic Asset*> *Repositories*
% 
% This is the example vignette for function: <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/external/stats/ffy_tauchen.m 
% *ffy_tauchen*> from the <https://fanwangecon.github.io/MEconTools/ *MEconTools 
% Package*>*.* : See also the <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/external/stats/ffy_rouwenhorst.m 
% *ffy_rouwenhorst*> function from the <https://fanwangecon.github.io/MEconTools/ 
% *MEconTools Package*>*.* This function discretize a mean zero AR1 process, uses 
% Tauchen (1986). See <https://fanwangecon.github.io/M4Econ/panel/timeseries/htmlpdfm/fs_autoregressive.html 
% AR 1 Example> for some details on how the AR1 process works. And See <https://doi.org/10.1016/j.red.2010.02.002 
% Kopecky and Suen (2010)>.
%% Test FFY_TAUCHEN Defaults
% Call the function with defaults. Default sd bounds arer plus and minus 4. 
% This is used in the following examples, unless otherwise specified as the 5th 
% parameter.

ffy_tauchen();
%% Test FFY_TAUCHEN Specify Parameters
% With a grid of 10 points, the sd bounds on Tauchen and Rouwenhorst are identical. 
% With the not extremely persistent shock process here, the Tauchen and Rouwenhorst 
% Results are very similar.

[fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose, it_std_bound] = ...
    deal(0.60, 0.10, 10, true, 3);
ffy_tauchen(fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose, it_std_bound);
%% Test FFY_TAUCHEN High Persistence, Low SD

[fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose] = ...
    deal(0.99, 0.01, 7, true);
ffy_tauchen(fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose);
%% Test FFY_TAUCHEN Low Persistence, Low SD

[fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose] = ...
    deal(0.01, 0.01, 7, true);
ffy_tauchen(fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose);
%% Test FFY_TAUCHEN High Persistence, High SD

[fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose] = ...
    deal(0.99, 0.99, 7, true);
ffy_tauchen(fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose);
%% Test FFY_TAUCHEN Low Persistence, Low SD

[fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose] = ...
    deal(0.01, 0.01, 7, true);
ffy_tauchen(fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose);