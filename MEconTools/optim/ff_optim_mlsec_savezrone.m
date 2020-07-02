%% FF_OPTIM_MLSEC_SAVEZRONE Bi(Multi)section Vectorized
%    Vectorized Multi-section (multiple points bisection concurrently)
%    given anonymous function that outputs the derivative of the optimal
%    savings function. The function assumes that the lower and upper bounds
%    starting points are the same for each row of the input parameter
%    matrix. Savings problem where agents save 0 to 100 percent of
%    available resoures (including borrowing bounds in resource).
%
%    This function might be slower than bisection
%    (FF_OPTIM_BISEC_SAVEZRONE). This is a testing of concept. The solution
%    concept is really only useful when within each iteration, each
%    solution requires significant computing time, and is parallized. In
%    that setting, the increase in total points where we evaluate the model
%    does not reduce computing speed, but we gain from the reductions in
%    iterations.
%
%    * FC_DERI_WTH_UNIROOT anonymous function handle, given an array of asset
%    choice fractions, savings given resource availability (including
%    borrowing bounds), compute derivative value.
%
%    * MP_MLSEC_CTRLINFO map with number of iterations and number of points
%    to solve for at each iteration. if it_mlsect_jnt_pnts = 10,
%    it_mlsect_max_iter = 4, this means there will be four iterations, and
%    at each iteration, 10 zoomed in additional points will be evaluated
%    at. What is the total precision?
%    (fl_x_right_start-fl_x_left_start)/(10*11*12*14), given that the bound
%    is approximately 1, the precision is 0.00005827505. 10*11*12*13 =
%    17160.
%
%    mp_mlsec_ctrlinfo = containers.Map('KeyType','char', 'ValueType','any');
%    % within each multisection iteration, points to solve at
%    mp_mlsec_ctrlinfo('it_mlsect_jnt_pnts') = 10;
%    % number of iterations
%    mp_mlsec_ctrlinfo('it_mlsect_max_iter') = 4;
%    % starting savings share, common for all
%    mp_mlsec_ctrlinfo('fl_x_left_start') = 10e-6;
%    % max savings share, common for all
%    mp_mlsec_ctrlinfo('fl_x_right_start') = 1-10e-6;
%
%    [AR_OPTI_SAVE_FRAC] = FF_OPTIM_MLSEC_SAVEZRONE() default optimal
%    saving and borrowing fractions.
%
%    [AR_OPTI_SAVE_FRAC] = FF_OPTIM_MLSEC_SAVEZRONE(FC_DERI_WTH_UNIROOT,
%    BL_VERBOSE, BL_TIMER, MP_MLSEC_CTRLINFO) decide if to print verbose,
%    verbose print will generate graphical and tabular outputs, control
%    timer, and change iteration number of points per iteration via
%    mp_bisec_ctrlinfo_ext.
%
%    [AR_OPTI_SAVE_FRAC, AR_OPTI_SAVE_LEVEL] =
%    FF_OPTIM_MLSEC_SAVEZRONE(FC_DERI_WTH_UNIROOT) given function handle
%    for savings borrowing function derivative with an array of outputs,
%    each representing a different set of state-space points, solve for
%    optimal savings levels and savings fractions.
%
%    [AR_OPTI_SAVE_FRAC, AR_OPTI_SAVE_LEVEL, AR_OPTI_FOC_OBJ] =
%    FF_OPTIM_MLSEC_SAVEZRONE(FC_DERI_WTH_UNIROOT) also output FOC
%    objective.
%
%    [AR_OPTI_SAVE_FRAC, AR_OPTI_SAVE_LEVEL, AR_OPTI_FOC_OBJ,
%    TB_MLSEC_INFO] = FF_OPTIM_MLSEC_SAVEZRONE(FC_DERI_WTH_UNIROOT) also
%    output convergence iteration information.
%
%    see also FX_OPTIM_MLSEC_SAVEZRONE, FF_OPTIM_MLSEC_SAVEZRONE
%

%%
function varargout = ff_optim_mlsec_savezrone(varargin)

if (~isempty(varargin))
    
    % NOT called interally with the testing function ffi_intertempora_max below
    bl_verbose = false;
    bl_timer = false;
    
    if (length(varargin) == 1)
        [fc_deri_wth_uniroot] = varargin{:};
    elseif (length(varargin) == 2)
        [fc_deri_wth_uniroot, bl_verbose] = varargin{:};
    elseif (length(varargin) == 3)
        [fc_deri_wth_uniroot, bl_verbose, bl_timer] = varargin{:};
    elseif (length(varargin) == 4)
        [fc_deri_wth_uniroot, bl_verbose, bl_timer, mp_mlsec_ctrlinfo_ext] = varargin{:};        
    end
    
else
    close all;
    
    % called interall with the testing function ffi_intertempora_max below
    bl_verbose = true;
    bl_timer = true;
    
    % 1. ffi_intertemporal_max at the end of this function is two period
    % intertemporal utility maximization problem where the choice is
    % savings or borrowing. The problem has natural bounds, 0 and 1, which
    % represent minimum and maximum percentage of resource saved or
    % borrowed. See:
    % https://fanwangecon.github.io/Math4Econ/derivative_application/htmlpdfm/K_save_households.html
    
    it_exam = 2;
    if(it_exam==1)
        
        % 2. Solve concurrently for combinations of z1, z2, r, and beta values
        ar_z1 = [1,1,2,2,3,3]';
        ar_z2 = [3,3,2,2,1,1]';
        ar_r = 1.10 + zeros(size(ar_z1));
        ar_beta = [0.80, 0.95, 0.80, 0.95, 0.80, 0.95]';
        % mt_fc_inputs = [ar_z1, ar_z2, ar_r, ar_beta];               
        
    elseif(it_exam==2)
        
        rng(123);
        it_draws = 8; % must be even number
        ar_z1 = exp(rand([it_draws,1])*3-1.5);
        ar_z2 = exp(rand([it_draws,1])*3-1.5);
        ar_r = (rand(it_draws,1)*10.0);
        ar_beta = [rand(round(it_draws/2),1)*1; rand(round(it_draws/2),1)*1+1]; 
       
    elseif(it_exam==3)
        
        % run many check speed
        rng(123);
        it_draws = 6250000; % must be even number
        bl_verbose = false;
        bl_timer = false;
        
        ar_z1 = exp(rand([it_draws,1])*3-1.5);
        ar_z2 = exp(rand([it_draws,1])*3-1.5);
        ar_r = (rand(it_draws,1)*10.0);
        ar_beta = [rand(round(it_draws/2),1)*1; rand(round(it_draws/2),1)*1+1]; 
        
    elseif(it_exam==4)
        
        [ar_z1, ar_z2, ar_r, ar_beta] = deal(0.4730, 0.6252, 0.0839, 0.7365);
        
    end
    
    % 3. define function with the fixed matrix of input
    fc_deri_wth_uniroot = @(x) ffi_intertemporal_max(...
        x, ar_z1, ar_z2, ar_r, ar_beta);
    
end

%% Set and Update Support Map
mp_mlsec_ctrlinfo = containers.Map('KeyType','char', 'ValueType','any');
% within each multisection iteration, points to solve at
mp_mlsec_ctrlinfo('it_mlsect_jnt_pnts') = 10;
% number of iterations
mp_mlsec_ctrlinfo('it_mlsect_max_iter') = 4;
% starting savings share, common for all
mp_mlsec_ctrlinfo('fl_x_left_start') = 10e-6;
% max savings share, common for all
mp_mlsec_ctrlinfo('fl_x_right_start') = 1-10e-6;

% override default support_map values
if (length(varargin)>=4)
    mp_mlsec_ctrlinfo = [mp_mlsec_ctrlinfo; mp_mlsec_ctrlinfo_ext];
end

%% Parse mp_grid_control
params_group = values(mp_mlsec_ctrlinfo, {'it_mlsect_jnt_pnts', 'it_mlsect_max_iter'});
[it_mlsect_jnt_pnts, it_mlsect_max_iter] = params_group{:};
params_group = values(mp_mlsec_ctrlinfo, {'fl_x_left_start', 'fl_x_right_start'});
[fl_x_left_start, fl_x_right_start] = params_group{:};

%% Timer Start
if (bl_timer)
    tic;
end

%% Get output dimension and initial lower and upper points
[ar_lower_fx, ~] = fc_deri_wth_uniroot(fl_x_left_start);
it_out_rows = size(ar_lower_fx,1);
ar_lower_x = fl_x_left_start + zeros(it_out_rows, 1);
ar_upper_x = fl_x_right_start + zeros(it_out_rows, 1);

if(bl_verbose)    
    % core info
    tb_x_points = array2table(ar_lower_x');
    cl_row_names_a = strcat('point=', string((1:size(tb_x_points,1))));
    cl_row_names_a = string(cl_row_names_a);
    tb_x_points = addvars(tb_x_points, cl_row_names_a, 'Before', 1);    
    % Parameter Information Table that Shares Row Names as Simu Results
    tb_param_info = array2table([0]);
    tb_param_info.Properties.VariableNames = {'iter'};
    % Combine Parameter Information and Simulation Contents
    tb_mlsec_info = [tb_param_info, tb_x_points];    
end

%% Iterate and Evaluate

% current lower and upper arrays
ar_lower_x_cur = ar_lower_x;
ar_upper_x_cur = ar_upper_x;

for it_multi_section_iter=1:it_mlsect_max_iter
    
    % current savings percentages:
    if (it_multi_section_iter == 1)
        it_mlsect_jnt_seg = it_mlsect_jnt_pnts - 1;
        ar_it_incre = (0:it_mlsect_jnt_seg);
    else
        it_mlsect_jnt_seg = it_mlsect_jnt_pnts + 1;
        ar_it_incre = (1:(it_mlsect_jnt_seg-1));
    end
    mt_fl_x_points = ar_lower_x_cur + ((ar_upper_x_cur-ar_lower_x_cur)./(it_mlsect_jnt_seg))*ar_it_incre;
    
    % keep track of iteration points
    if(bl_verbose)
        % core info
        tb_x_points = array2table(mt_fl_x_points');
        cl_row_names_a = strcat('point=', string((1:size(tb_x_points,1))));
        cl_row_names_a = string(cl_row_names_a');
        tb_x_points = addvars(tb_x_points, cl_row_names_a, 'Before', 1);
        % Parameter Information Table that Shares Row Names as Simu Results
        mt_param_info = zeros([size(tb_x_points,1),1]) + it_multi_section_iter;
        tb_param_info = array2table(mt_param_info);
        tb_param_info.Properties.VariableNames = {'iter'};
        % Combine Parameter Information and Simulation Contents
        tb_mlsec_info_new = [tb_param_info, tb_x_points];
        % Stack up
        tb_mlsec_info = [tb_mlsec_info; tb_mlsec_info_new];
    end
    
    % evaluate at new points:
    [mt_fx, mt_saveborr_level] = fc_deri_wth_uniroot(mt_fl_x_points);
    
    if (it_multi_section_iter ~= 1)
        % append last bounds
        mt_fl_x_points = [ar_lower_x_cur, mt_fl_x_points, ar_upper_x_cur];
        mt_fx = [ar_lower_fx_bd', mt_fx, ar_upper_fx_bd'];
    else
        % keep initial
        ar_lower_fx_init = mt_fx(:,1);
        ar_upper_fx_init = mt_fx(:,end);
    end
    
    % Identify points of change
    mt_shift_point_isone = (diff((mt_fx>0)')'~=0);
    [~, ar_shift_idx] = max(mt_shift_point_isone,[],2);
        
    % Generate New Bounds
    mt_fl_x_points_nolast = mt_fl_x_points(:,1:(end-1));
    mt_fx_nolast = mt_fx(:,1:(end-1));
    
    ar_lower_x_bd = mt_fl_x_points_nolast(...
        sub2ind(size(mt_shift_point_isone), [1:it_out_rows], ar_shift_idx'));
    ar_lower_fx_bd = mt_fx_nolast(...
        sub2ind(size(mt_shift_point_isone), [1:it_out_rows], ar_shift_idx'));
    
    ar_upper_x_bd = mt_fl_x_points(...
        sub2ind(size(mt_fl_x_points), [1:it_out_rows], (ar_shift_idx+1)'));
    ar_upper_fx_bd = mt_fx(...
        sub2ind(size(mt_fl_x_points), [1:it_out_rows], (ar_shift_idx+1)'));
    
    % raise gap
%     ar_gap = (ar_upper_x_bd - ar_lower_x_bd)/it_mlsect_jnt_seg;
%     ar_lower_x_cur = (ar_lower_x_bd + ar_gap)';
%     ar_upper_x_cur = (ar_upper_x_bd - ar_gap)';
    ar_lower_x_cur = ar_lower_x_bd';
    ar_upper_x_cur = ar_upper_x_bd';
end
ar_opti_foc_obj = (ar_upper_fx_bd + ar_lower_fx_bd)/2;
ar_opti_save_frac = (ar_upper_x_bd+ar_lower_x_bd)/2;

%% Get Levels
% if (nargout>=2)
[mt_fx, ar_opti_save_level] = fc_deri_wth_uniroot(ar_opti_save_frac');   
% end

%% Return
if(isscalar(ar_opti_save_frac))
    if (ar_lower_fx_init*ar_upper_fx_init > 0)
        ar_opti_save_frac = NaN;
        ar_opti_save_level = NaN;
        ar_opti_foc_obj = NaN;
    end
else
    ar_nosolu = (ar_lower_fx_init.*ar_upper_fx_init);
    ar_opti_save_frac(ar_nosolu>0) = NaN;
    ar_opti_save_level(ar_nosolu>0) = NaN;
    ar_opti_foc_obj(ar_nosolu>0) = NaN;
end
    
% Show iteration points
if(bl_verbose)
    disp(tb_mlsec_info);
    % prepare for graph
    mt_mlsec_info = tb_mlsec_info{:, [1,3:end]};
    mt_mlsec_fracs = mt_mlsec_info(:,2:end);
    mp_support_graph = containers.Map('KeyType', 'char', 'ValueType', 'any');
    mp_support_graph('cl_st_graph_title') = ...
        {['Iteration Multi-Section' ...
        ', pnts-per-iter=' num2str(it_mlsect_jnt_pnts) ...
        ', nbr-of-iters=' num2str(it_mlsect_max_iter)]};
    mp_support_graph('cl_st_ytitle') = {'Fraction of Savings'};
    mp_support_graph('cl_st_xtitle') = {'Different State-Space points'};
    mp_support_graph('st_legend_loc') = 'eastoutside';
    mp_support_graph('bl_graph_logy') = false; % do not log
    mp_support_graph('st_rowvar_name') = 'solve-point=';
    mp_support_graph('it_legend_select') = 15; % how many shock legends to show
    mp_support_graph('st_rounding') = '6.0f'; % format shock legend
    % Call function
    ff_graph_grid(mt_mlsec_fracs, 1:size(mt_mlsec_fracs,1), 1:it_out_rows, mp_support_graph); 
end


%% Timer End
if (bl_timer)
    toc;
end

%% print details
if (bl_verbose)
    mp_container_map = containers.Map('KeyType','char', 'ValueType','any');
    mp_container_map('ar_opti_save_frac') = ar_opti_save_frac';
    mp_container_map('ar_opti_foc_obj') = ar_opti_foc_obj';
    if (nargout>=2)
        mp_container_map('ar_opti_save_level') = ar_opti_save_level';
    end
    ff_container_map_display(mp_container_map, 10, 10);    
end

%% Return
varargout = cell(nargout,0);
for it_k = 1:nargout
    if (it_k==1)
        ob_out_cur = reshape(ar_opti_save_frac, [], 1);
    elseif (it_k==2)
        ob_out_cur = reshape(ar_opti_save_level, [], 1);
    elseif (it_k==3)
        ob_out_cur = reshape(ar_opti_foc_obj, [], 1);
    elseif (it_k==4 && bl_verbose)
        ob_out_cur = tb_mlsec_info;
    end
    varargout{it_k} = ob_out_cur;
end
end

%% Intertemporal Maximization with Log Util, no Shock, Two Periods, Endowments
%    see https://fanwangecon.github.io/Math4Econ/derivative_application/htmlpdfm/K_save_households.html
function [ar_deri_zero, ar_saveborr_level] = ...
    ffi_intertemporal_max(ar_saveborr_frac, z1, z2, r, beta)

ar_saveborr_level = ar_saveborr_frac.*(z1+z2./(1+r)) - z2./(1+r);
ar_deri_zero = 1./(ar_saveborr_level-z1) + (beta.*(r+1))./(z2 + ar_saveborr_level.*(r+1));

end

%% Solution Intertemporal Maximization with Log Util, no Shock, Two Periods, Endowments
%    see https://fanwangecon.github.io/Math4Econ/derivative_application/htmlpdfm/K_save_households.html
function [ar_opti_saveborr_frac, ar_opti_saveborr_level] = ...
    ffi_intertemporal_max_solu(z1, z2, r, beta)

ar_opti_saveborr_level = (z1.*beta.*(1+r) - z2)./((1+r).*(1+beta));
ar_opti_saveborr_frac = (ar_opti_saveborr_level + z2./(1+r))./(z1+z2./(1+r));

end