%% FF_SAVEBORR_GRID Example for Generating Asset Grid
% *back to* <https://fanwangecon.github.io *Fan*>*'s* <https://fanwangecon.github.io/Math4Econ/ 
% *Intro Math for Econ*>*,*  <https://fanwangecon.github.io/M4Econ/ *Matlab Examples*>*, 
% or* <https://fanwangecon.github.io/MEconTools/ *MEconTools*> *Repositories*
% 
% This is the example vignette for function: <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/generate/ff_nonimg_posnegbd.m 
% *ff_nonimg_posnegbd*> from the <https://fanwangecon.github.io/MEconTools/ *MEconTools 
% Package*>*.* This function checks for valid domain for function that generates 
% real-valued outcomes, and identifies values along the domain that generates 
% positive and negative Values. 
%% Test FF_NONIMG_POSNEGBD Defaults
% Call the function with defaults.

ff_nonimg_posnegbd();
%% Test FF_NONIMG_POSNEGBD with Log(x)
% Testing the function with log(x) 

% Same min and max and grid points
[fl_x_min, fl_x_max, it_eval_points, it_eval_max_round, bl_loop] = deal(-5, 5, 10, 3, true);
[bl_verbose, bl_timer] = deal(true, true);
fc_eval = @(x) log(x);
% Solve
[ar_x_points_noimg, ar_obj_eval_noimg, aar_obj_eval_noimg] = ...
    ff_nonimg_posnegbd(fl_x_min, fl_x_max, fc_eval, it_eval_points, it_eval_max_round, bl_loop, ...
    bl_verbose, bl_timer);