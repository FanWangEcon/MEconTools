%% FF_DISC_RAND_VAR_STATS Examples
% *back to* <https://fanwangecon.github.io *Fan*>*'s* <https://fanwangecon.github.io/Math4Econ/ 
% *Intro Math for Econ*>*,*  <https://fanwangecon.github.io/M4Econ/ *Matlab Examples*>*, 
% or* <https://fanwangecon.github.io/CodeDynaAsset/ *Dynamic Asset*> *Repositories*
% 
% This is the example vignette for function: <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/stats/ff_disc_rand_var_stats.m 
% *ff_disc_rand_var_stats*> from the <https://fanwangecon.github.io/MEconTools/ 
% *MEconTools Package*>*.* This function summarizes statistics of matrixes stored 
% in a container map, as well as scalar, string, function and other values stored 
% in container maps.
%% Test FF_DISC_RAND_VAR_STATS Defaults
% Call the function with defaults.

ff_disc_rand_var_stats();
%% Test FF_DISC_RAND_VAR_STATS 0 and 1 Random Variable
% The simplest discrete random variable has two values, zero or one. The probability 
% of zero is 30 percent, and 70 percent is the probability of one. 

% Parameters
% 1. specify the random variable
st_var_name = 'bernoulli';
ar_choice_unique_sorted = [0, 1];
ar_choice_prob = [0.3, 0.7];
% 2. percentiles of interest
ar_fl_percentiles = [0.1 5 25 50 75 95 99.9];
% 3. print resutls
bl_display_drvstats = true;
% Call Function
[ds_stats_map] = ff_disc_rand_var_stats(st_var_name, ...
    ar_choice_unique_sorted, ar_choice_prob, ...
    ar_fl_percentiles, bl_display_drvstats);
%% Test FF_DISC_RAND_VAR_STATS with Poisson
% <https://fanwangecon.github.io/Stat4Econ/probability_discrete/htmlpdfr/poisson.html 
% Poisson random variable>, with mean equals to ten, summarize over umsymmetric 
% percentiles. Note that the poisson random variable has no upper bound.

% Parameters
% 1. specify the random variable
st_var_name = 'poisson';
mu = 10;
ar_choice_unique_sorted = 0:1:50;
ar_choice_prob = poisspdf(ar_choice_unique_sorted, mu);
% 2. percentiles of interest, unsymmetric
ar_fl_percentiles = [0.1 5 10 25 50 90 95 99 99.9 99.99 99.999 99.9999];
% 3. print resutls
bl_display_drvstats = true;
% Call Function
[ds_stats_map] = ff_disc_rand_var_stats(st_var_name, ...
    ar_choice_unique_sorted, ar_choice_prob, ...
    ar_fl_percentiles, bl_display_drvstats);
% Print out full Stored Matrix
% Note that the outputs are single row arrays.
ff_container_map_display(ds_stats_map, 100, 100)