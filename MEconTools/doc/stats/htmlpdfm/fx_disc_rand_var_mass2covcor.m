%% FF_DISC_RAND_VAR_MASS2COVCOR Examples
% *back to* <https://fanwangecon.github.io *Fan*>*'s* <https://fanwangecon.github.io/Math4Econ/ 
% *Intro Math for Econ*>*,*  <https://fanwangecon.github.io/M4Econ/ *Matlab Examples*>*, 
% or* <https://fanwangecon.github.io/CodeDynaAsset/ *Dynamic Asset*> *Repositories*
% 
% This is the example vignette for function: <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/stats/ff_disc_rand_var_mass2covcor.m 
% *ff_disc_rand_var_mass2covcor*> from the <https://fanwangecon.github.io/MEconTools/ 
% *MEconTools Package*>*.* This function calculates covariance and correlation 
% based for two discrete random variables. 
%% Test FF_DISC_RAND_VAR_MASS2COVCOR Defaults
% Call the function with defaults.

ff_disc_rand_var_mass2covcor();
%% Test FF_DISC_RAND_VAR_MASS2COVCOR Four States-Points
% Over some (a,z) states that is 2 by 2, c matrix, and y matrix, find correlation. 
% Positively related.

% Set Parameters
mt_c_of_s = [1,2;3,1];
mt_y_of_s = [2,10;5,1.1];
rng(123);
mt_f_of_s = rand(size(mt_c_of_s));
mt_f_of_s = mt_f_of_s/sum(mt_f_of_s, 'all');
bl_display_drvm2covcor = false;
% Call Function
[fl_cov_xy, fl_cor_xy] = ff_disc_rand_var_mass2covcor(...
    mt_c_of_s, mt_y_of_s, mt_f_of_s, bl_display_drvm2covcor);
display(['cov=' num2str(fl_cov_xy) ',cor=', num2str(fl_cor_xy)]);
%% 
% Same as before, but now inputs are single column:

% Call Function
[fl_cov_xy, fl_cor_xy] = ff_disc_rand_var_mass2covcor(...
    mt_c_of_s(:), mt_y_of_s(:), mt_f_of_s(:), bl_display_drvm2covcor);
display(['cov=' num2str(fl_cov_xy) ',cor=', num2str(fl_cor_xy)]);
%% Test FF_DISC_RAND_VAR_MASS2COVCOR Two Random Vectors
% <https://fanwangecon.github.io/Stat4Econ/probability_discrete/htmlpdfr/poisson.html 
% G>enerate two random vectors, with random or even mass, correlation should be 
% zero:

% Set Parameters
rng(4567);
mt_c_of_s = rand([20,1])*100;
mt_y_of_s = rand([20,1])*100;
mt_f_of_s = rand(size(mt_c_of_s));
mt_f_of_s = mt_f_of_s/sum(mt_f_of_s, 'all');
bl_display_drvm2covcor = false;
% Call Function
[fl_cov_xy, fl_cor_xy] = ff_disc_rand_var_mass2covcor(...
    mt_c_of_s, mt_y_of_s, mt_f_of_s, bl_display_drvm2covcor);
display(['cov=' num2str(fl_cov_xy) ',cor=', num2str(fl_cor_xy)]);
%% Test FF_DISC_RAND_VAR_MASS2COVCOR Provide Mean and SD
% Same as above, but now provide means and sd for x andy directly. The results 
% are the same as when mean and sd are calculated inside the function.

% Set Parameters
rng(4567);
mt_c_of_s = rand([20,1])*100;
mt_y_of_s = rand([20,1])*100;
mt_f_of_s = rand(size(mt_c_of_s));
mt_f_of_s = mt_f_of_s/sum(mt_f_of_s, 'all');
fl_c_mean = sum(mt_f_of_s.*mt_c_of_s);
fl_c_sd = sqrt(sum(mt_f_of_s.*(mt_c_of_s-fl_c_mean).^2));
fl_y_mean = sum(mt_f_of_s.*mt_y_of_s);
fl_y_sd = sqrt(sum(mt_f_of_s.*(mt_y_of_s-fl_y_mean).^2));
bl_display_drvm2covcor = false;
% Call Function
[fl_cov_xy, fl_cor_xy] = ff_disc_rand_var_mass2covcor(...
    mt_c_of_s, mt_y_of_s, mt_f_of_s, ...
    fl_c_mean, fl_c_sd, ...
    fl_y_mean, fl_y_sd, bl_display_drvm2covcor);
display(['cov=' num2str(fl_cov_xy) ',cor=', num2str(fl_cor_xy)]);