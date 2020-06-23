%% FF_DISC_RAND_VAR_MASS2OUTCOMES Examples
% *back to* <https://fanwangecon.github.io *Fan*>*'s* <https://fanwangecon.github.io/Math4Econ/ 
% *Intro Math for Econ*>*,*  <https://fanwangecon.github.io/M4Econ/ *Matlab Examples*>*, 
% or* <https://fanwangecon.github.io/CodeDynaAsset/ *Dynamic Asset*> *Repositories*
% 
% This is the example vignette for function: <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/stats/ff_disc_rand_var_mass2outcomes.m 
% *ff_disc_rand_var_mass2outcomes*> from the <https://fanwangecon.github.io/MEconTools/ 
% *MEconTools Package*>*.* This function generates sorted discrete random variable 
% from state-space joint distribution.
%% Test FF_DISC_RAND_VAR_MASS2OUTCOMES Defaults
% Call the function with defaults.

ff_disc_rand_var_mass2outcomes();
%% Test FF_DISC_RAND_VAR_MASS2OUTCOMES Four States-Points
% Over some (a,z) states that is 2 by 2, matrix or vectorized inputs identical 
% results.

% Set Parameters
st_y_name = 'consumption';
% consumption matrix: c(a,z)
mt_c_of_s = [1,2;3,1];
% stationary mass over assets adn shocks: f(a,z)
mt_f_of_s = rand(size(mt_c_of_s));
mt_f_of_s = mt_f_of_s/sum(mt_f_of_s, 'all');
% Call Function
[ar_f_of_y, ar_y_unique_sorted] = ...
    ff_disc_rand_var_mass2outcomes(st_y_name, mt_c_of_s, mt_f_of_s);
% print
disp([ar_f_of_y ar_y_unique_sorted]);
%% 
% Same as before, but now inputs are single column:

% Call Function
[ar_f_of_y, ar_y_unique_sorted] = ...
    ff_disc_rand_var_mass2outcomes(st_y_name, mt_c_of_s(:), mt_f_of_s);
disp([ar_f_of_y ar_y_unique_sorted]);
%% Test FF_DISC_RAND_VAR_MASS2OUTCOMES Conditional Mass Outputs
% Same inputs as before, but now, also output additional conditional statistis, 
% f(y, a), where a is the row state variable for f(a,z). For conditional statistics, 
% must provide matrix based inputs.

% Set Parameters
st_y_name = 'consumption';
% consumption matrix: c(a,z)
mt_c_of_s = [1,2,0.5;
             3,1,2.0];
% stationary mass over assets adn shocks: f(a,z)
mt_f_of_s = rand(size(mt_c_of_s));
mt_f_of_s = mt_f_of_s/sum(mt_f_of_s, 'all');
% Call Function
[ar_f_of_y, ar_y_unique_sorted, mt_f_of_y_srow, mt_f_of_y_scol] = ...
    ff_disc_rand_var_mass2outcomes(st_y_name, mt_c_of_s, mt_f_of_s);
% print
disp([ar_f_of_y ar_y_unique_sorted]);
disp(mt_f_of_y_srow);
disp(mt_f_of_y_scol);