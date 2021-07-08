%% FF_NONIMG_POSNEGBD Finds Valid Domain For Function
%    Given a function, find valid-domain that generates real values. Valid
%    means non-NaN and non-imaginary.
%
%    * FL_X_MIN float lower value of domain to explore
%    * FL_X_MAX float higher value of domain to explore
%    * FC_EVAL function that evaluates the x values
%    * IT_EVAL_POINTS the number of points over which to evaluate the
%    function
%    * IT_EVAL_MAX_ROUND the number of times to exponentiate the
%    IT_EVAL_POINTS at most
%    * BL_LOOP boolean if true will loop over elements of the x array, not
%    all functions are set-up to evaluate all x points jointly
%
%    [AR_X_POINTS_NOIMG, AR_OBJ_EVAL_NOIMG] = FF_NONIMG_POSNEGBD(FL_X_MIN,
%    FL_X_MAX, FC_EVAL, IT_EVAL_POINTS, IT_EVAL_MAX_ROUND) specify min, max
%    and points, this will by default generate a power grid of points:
%    st_grid_type == grid_log10space.
%
%    see also FX_NONIMG_POSNEGBD
%

%%
function varargout = ff_nonimg_posnegbd(varargin)

if (~isempty(varargin))

    bl_verbose = false;
    bl_timer = false;

    if (length(varargin) == 7)
        [fl_x_min, fl_x_max, fc_eval, it_eval_points, it_eval_max_round, bl_loop] = varargin{:};
    elseif (length(varargin) == 8)
        [fl_x_min, fl_x_max, fc_eval, it_eval_points, it_eval_max_round, bl_loop, ...
            bl_verbose, bl_timer] = varargin{:};
    else
        error('Must specify 7 or 8 parameters.');
    end

else
    clc;
    close all;
    clear all;

    fl_x_min = -2;
    fl_x_max = 2;
    fc_eval = @(x) log(1./(x+1));

    fl_x_max = 1000;
    fc_eval = @(x) log(1./(exp(x)+1));

    it_eval_points = 100;
    it_eval_max_round = 3;
    bl_verbose = true;
    bl_timer = true;
    bl_loop = true;

end

%% Possible scenariors
% for current grid:
% 1. Finds sub-segment of real-valued monotonic function, with positive and negative points
% 2. Finds sub-segment of real-valued nonmonotonic function, with single switching point between positive and neg values
% 3. Finds sub-segment of real-values, only positive or negative values
% 4. Finds all non-NaN sub-segment
% 5. Finds zero
% 6. others
% 7. Failed to find any real numbers

bl_continue = true;
it_exit_condition = 6;
it_eval_round = 0;
while bl_continue

    it_eval_round = it_eval_round + 1;

    % Evaluate and check for NaN
    ar_x_points = linspace(fl_x_min, fl_x_max, it_eval_points^it_eval_round);
    ar_obj_eval = NaN(size(ar_x_points));
    if (bl_loop)
        for it_x_ctr=1:1:length(ar_x_points)
            ar_obj_eval(it_x_ctr) = fc_eval(ar_x_points(it_x_ctr));
        end
    else
        ar_obj_eval = fc_eval(ar_x_points);
    end

    % Select only non-NaN values
    ar_bl_real_compo = ((imag(ar_obj_eval)==0).*(~isnan(ar_obj_eval)).*(~isinf(ar_obj_eval))==1);
    ar_x_points_noimg = ar_x_points(ar_bl_real_compo);
    ar_obj_eval_noimg = ar_obj_eval(ar_bl_real_compo);

    % Are there both positive and negative values?
    bl_has_pos = (sum(ar_obj_eval_noimg>0)>=1);
    bl_has_neg = (sum(ar_obj_eval_noimg<0)>=1);
    bl_has_zero = (sum(ar_obj_eval_noimg==0)>=1);

    % Check if function is monotonic
    bl_has_increase = (sum(diff(ar_obj_eval_noimg)>0)>0);
    bl_has_decrease = (sum(diff(ar_obj_eval_noimg)<0)>0);
    bl_has_constant = (sum(diff(ar_obj_eval_noimg)==0)>0);

    % stop criteris
    if (bl_has_pos && bl_has_neg && (bl_has_increase + bl_has_decrease + bl_has_constant == 1))
        % Finds sub-segment of real-valued monotonic function, with positive and negative points
        bl_continue = false;
        it_exit_condition = 1;
    end
    if (it_eval_round == it_eval_max_round)
        bl_continue = false;
    end

end

if (sum(ar_bl_real_compo)==0)
    ar_x_points_noimg = ar_x_points;
    aar_obj_eval_noimg = ar_obj_eval;
    it_exit_condition = -99;
end

%% Print
if (bl_verbose)
    st_display = strjoin(...
        ["FF_NONIMG_POSNEGBD", ...
        ['it_exit_condition=' num2str(it_exit_condition)], ...
        ['bl_has_increase=' num2str(bl_has_increase)], ...
        ['bl_has_decrease=' num2str(bl_has_decrease)], ...
        ['bl_has_constant=' num2str(bl_has_constant)], ...
        ['bl_has_pos=' num2str(bl_has_pos)], ...
        ['bl_has_neg=' num2str(bl_has_neg)], ...
        ['bl_has_zero=' num2str(bl_has_zero)], ...
        ], ";");
    disp(st_display);
end

%% Graph
if (bl_verbose)
    figure();
    plot(ar_x_points_noimg, ar_obj_eval_noimg);
    title(['Real components of graphs, exit-condition=' num2str(it_exit_condition)]);
    xlabel('x, where f(x) is real');
    ylabel('f(x)');

    yline0 = yline(0);
    yline0.HandleVisibility = 'off';

    grid on;
    grid minor;
end

%% Return
varargout = cell(nargout,0);
for it_k = 1:nargout
    if (it_k==1)
        ob_out_cur = ar_x_points_noimg;
    elseif (it_k==2)
        ob_out_cur = ar_obj_eval_noimg;
    elseif (it_k==3)
        ob_out_cur = it_exit_condition;
    end
    varargout{it_k} = ob_out_cur;
end
end
