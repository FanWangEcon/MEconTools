%% FF_OPTIM_MLSEC_SAVEZRONE Bisection Vectorized
%    Vectorized Multi-section (multiple points bisection concurrently)
%    given anonymous function that outputs the derivative of the optimal
%    savings function. The function assumes that the lower and upper bounds
%    starting points are the same for each row of the input parameter
%    matrix. Savings problem where agents save 0 to 100 percent of
%    available resoures (including borrowing bounds in resource).
%
%    * FC_DERI_WTH_UNIROOT anonymous function handle, given an array of asset
%    choice fractions, savings given resource availability (including
%    borrowing bounds), compute derivative value.
%
%    Each type has type specific options set through key/value of
%    MP_GRID_CONTROL. 'grid_linspace': linspace; 'grid_log10space': log
%    space; 'grid_powerspace': power grid spacing; 'grid_evenlog': even
%    then log space.
%
%    mp_bisec_ctrlinfo = containers.Map('KeyType','char', 'ValueType','any');
%    mp_bisec_ctrlinfo('st_cur_bisec_info') = 'savings bisection';
%    mp_bisec_ctrlinfo('it_bisect_min_iter') = 1;
%    mp_bisec_ctrlinfo('it_bisect_max_iter') = 10;
%    mp_bisec_ctrlinfo('fl_bisect_tol') = 10e-6;
%
%    [AR_OPTI_SAVE_FRAC] = FF_OPTIM_MUSEC_SAVEZRONE() default optimal
%    saving and borrowing fractions.
%
%    [AR_OPTI_SAVE_FRAC, AR_OPTI_SAVE_LEVEL] =
%    FF_OPTIM_MUSEC_SAVEZRONE(FC_DERI_WTH_UNIROOT) given function handle
%    for savings borrowing function derivative with an array of outputs,
%    each representing a different set of state-space points, solve for
%    optimal savings levels and savings fractions.
%
%    [AR_OPTI_SAVE_FRAC, AR_OPTI_SAVE_LEVEL, AR_OPTI_FOC_OBJ] =
%    FF_OPTIM_MUSEC_SAVEZRONE(FC_DERI_WTH_UNIROOT) also output FOC
%    objective.
%
%    [AR_OPTI_SAVE_FRAC, AR_OPTI_SAVE_LEVEL, AR_OPTI_FOC_OBJ,
%    TB_BISEC_INFO] = FF_OPTIM_MUSEC_SAVEZRONE(FC_DERI_WTH_UNIROOT) also
%    output convergence iteration information.
%
%    see also FX_OPTIM_BISEC_SAVEZRONE
%

%%
function varargout = ff_optim_mlsec_savezrone(varargin)

if (~isempty(varargin))
    
    % NOT called interally with the testing function ffi_intertempora_max below
    bl_default_test = false;
    
    st_grid_type = 'grid_linspace';
    bl_verbose = false;
    
    if (length(varargin) == 1)
        [fc_deri_wth_uniroot] = varargin{:};
    elseif (length(varargin) == 2)
        [fc_deri_wth_uniroot, bl_verbose] = varargin{:};
    else
        error('Must specify three parameters.');
    end
    
else
    close all;
    
    % called interall with the testing function ffi_intertempora_max below
    bl_default_test = true;
    
    % print more
    bl_verbose = true;
    
    % 1. ffi_intertemporal_max at the end of this function is two period
    % intertemporal utility maximization problem where the choice is
    % savings or borrowing. The problem has natural bounds, 0 and 1, which
    % represent minimum and maximum percentage of resource saved or
    % borrowed. See:
    % https://fanwangecon.github.io/Math4Econ/derivative_application/htmlpdfm/K_save_households.html
    
    it_exam = 1;
    if(it_exam==1)
        
        % 2. Solve concurrently for combinations of z1, z2, r, and beta values
        ar_z1 = [1,1,2,2,3,3]';
        ar_z2 = [3,3,2,2,1,1]';
        ar_r = 1.10 + zeros(size(ar_z1));
        ar_beta = [0.80, 0.95, 0.80, 0.95, 0.80, 0.95]';
        % mt_fc_inputs = [ar_z1, ar_z2, ar_r, ar_beta];
        
    elseif(it_exam==2)
        
        rng(123);
        ar_z1 = exp(rand([8,1])*3-1.5); % 40 asset points
        ar_z2 = exp(rand([8,1])*3-1.5); % 7 shock points
        ar_r = (rand(8,1)*0.10)+1.0; % marriage and edu
        ar_beta = (rand(8,1)*0.18)+0.80; % number of kids 0 to 5
        
        cl_ar_all = {ar_z1, ar_z2, ar_r, ar_beta};
        cl_mt_all = cl_ar_all;
        [cl_mt_all{:}] = ndgrid(cl_ar_all{:});
        mt_all_states = cell2mat(cellfun(@(m) m(:), cl_mt_all, 'uni', 0));
        
        ar_z1 = mt_all_states(:,1);
        ar_z2 = mt_all_states(:,2);
        ar_r = mt_all_states(:,3);
        ar_beta = mt_all_states(:,4);
        
    end
    
    % 3. define function with the fixed matrix of input
    fc_deri_wth_uniroot = @(x) ffi_intertemporal_max(...
        x, ar_z1, ar_z2, ar_r, ar_beta);
    
end

%% Set and Update Support Map
mp_bisec_ctrlinfo = containers.Map('KeyType','char', 'ValueType','any');
mp_bisec_ctrlinfo('st_cur_bisec_info') = 'savings bisection';
% it_mlsect_jnt_pnts = 3 is bisection
mp_bisec_ctrlinfo('it_mlsect_jnt_pnts') = 10;
mp_bisec_ctrlinfo('it_mlsect_min_iter') = 1;
mp_bisec_ctrlinfo('it_mlsect_max_iter') = 4;
mp_bisec_ctrlinfo('fl_bisect_tol') = 10e-6;
mp_bisec_ctrlinfo('fl_x_left_start') = 10e-6;
mp_bisec_ctrlinfo('fl_x_right_start') = 1-10e-6;

% override default support_map values
if (length(varargin)==5)
    mp_bisec_ctrlinfo = [mp_bisec_ctrlinfo; mp_grid_control_ext];
end

%% Parse mp_grid_control
params_group = values(mp_bisec_ctrlinfo, {'st_cur_bisec_info'});
[st_cur_bisec_info] = params_group{:};
params_group = values(mp_bisec_ctrlinfo, {'it_mlsect_jnt_pnts', 'it_mlsect_min_iter', 'it_mlsect_max_iter'});
[it_mlsect_jnt_pnts, it_mlsect_min_iter, it_mlsect_max_iter] = params_group{:};
params_group = values(mp_bisec_ctrlinfo, {'fl_x_left_start', 'fl_x_right_start'});
[fl_x_left_start, fl_x_right_start] = params_group{:};

%% Get output dimension and initial lower and upper points
[ar_lower_fx, ~] = fc_deri_wth_uniroot(fl_x_left_start);
it_out_rows = size(ar_lower_fx,1);
ar_lower_x = fl_x_left_start + zeros(it_out_rows, 1);
ar_upper_x = fl_x_right_start + zeros(it_out_rows, 1);

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
        it_mlsect_jnt_seg = it_mlsect_jnt_pnts - 2;
        ar_it_incre = (1:it_mlsect_jnt_seg);
    end
    mt_fl_x_points = ar_lower_x_cur + ((ar_upper_x_cur-ar_lower_x_cur)./(it_mlsect_jnt_seg))*ar_it_incre;
    
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
    ar_gap = (ar_upper_x_bd - ar_lower_x_bd)/it_mlsect_jnt_seg;
    ar_lower_x_cur = (ar_lower_x_bd + ar_gap)';
    ar_upper_x_cur = (ar_upper_x_bd - ar_gap)';
end
ar_opti_foc_obj = (ar_upper_fx_bd + ar_lower_fx_bd)/2;
ar_opti_save_frac = (ar_upper_x_bd+ar_lower_x_bd)/2;

%% Get Levels
if (nargout>=2)
    mt_saveborr_level_nolast = mt_saveborr_level(:,1:(end-1));
    ar_lower_level_bd = mt_saveborr_level_nolast(...
        sub2ind(size(mt_saveborr_level_nolast), [1:it_out_rows], (ar_shift_idx+1)'));
    ar_upper_level_bd = mt_saveborr_level(...
        sub2ind(size(mt_saveborr_level), [1:it_out_rows], (ar_shift_idx+1)'));
    ar_opti_save_level = (ar_upper_level_bd + ar_lower_level_bd)/2;    
end

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
        ob_out_cur = tb_bisec_info;
    end
    varargout{it_k} = ob_out_cur;
end
end

%% Intertemporal Maximization with Log Util, no Shock, Two Periods, Endowments
%    see https://fanwangecon.github.io/Math4Econ/derivative_application/htmlpdfm/K_save_households.html
function [ar_deri_zero, ar_saveborr_level] = ...
    ffi_intertemporal_max(ar_saveborr_frac, z1, z2, r, beta)

ar_saveborr_level = ar_saveborr_frac.*(z1-z2./(1+r));
ar_deri_zero = 1./(ar_saveborr_level-z1) + (beta.*(r+1))./(z2 + ar_saveborr_level.*(r+1));

end

%% Solution Intertemporal Maximization with Log Util, no Shock, Two Periods, Endowments
%    see https://fanwangecon.github.io/Math4Econ/derivative_application/htmlpdfm/K_save_households.html
function [ar_opti_saveborr_frac, ar_opti_saveborr_level] = ...
    ffi_intertemporal_max_solu(z1, z2, r, beta)

ar_opti_saveborr_level = (z1.*beta.*(1+r) - z2)./((1+r).*(1+beta));
ar_opti_saveborr_frac = ar_opti_saveborr_level./(z1-z2./(1+r));

end