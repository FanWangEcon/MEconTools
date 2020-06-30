%% FF_VFI_AZ_VEC (vectorized) solves the Savings and Shock Dynamic Programming Problem
%    Vectorized faster solution for solving the dynamic programming problem
%    with fixed assets grid using value function iteration. Obtains policy
%    and value functions. Shock is AR(1). This function is vectorized, and
%    generally fairly efficient in memory usage. 
%
%    * MP_PARAMS controls model preference, prices, shock and asset grid
%    parameters.
%    * MP_SUPPORT controls convergence criterion, printing and summary
%    controls
%
%    mp_params = containers.Map('KeyType','char', 'ValueType','any');
%    mp_params('fl_crra') = 1.5;
%    mp_params('fl_beta') = 0.95;
%    mp_params('fl_w') = 1.05;
%    mp_params('fl_r') = 0.03;
%    mp_params('fl_a_min') = 0;
%    mp_params('fl_a_max') = 50;
%    mp_params('it_a_n') = 25;
%    mp_params('st_grid_type') = 'grid_powerspace';
%    mp_params('fl_z_persist') = 0.60;
%    mp_params('fl_shk_std') = 0.10;
%    mp_params('it_z_n') = 5;
%    mp_params('st_grid_type') = 'grid_powerspace';
%
%    mp_support = containers.Map('KeyType','char', 'ValueType','any');
%    mp_support('fl_lowestc') = -10e10;
%    mp_support('it_maxiter_val') = 500;
%    mp_support('fl_tol_val') = 10e-5;
%    % printer various information
%    mp_support('bl_timer') = true;
%    mp_support('bl_print_params') = false; 
%    mp_support('bl_print_iterinfo') = false; 
%    % These names must match keys of mp_solu: v, ap, c, y
%    % what outcomes to store in the mp_solu for export
%    mp_support('ls_slout') = {'v', 'ap', 'c', 'y', 'coh'}; 
%    % outcome for ff_container_map_display
%    mp_support('ls_ffcmd') = {'ap'}; 
%    % outcome for ff_summ_nd_array
%    mp_support('ls_ffsna') = {}; 
%    % outcome for ff_graph_grid
%    mp_support('ls_ffgrh') = {}; 
%    % outcome for ff_summ_nd_array
%    mp_support('ffsna_opt_it_row_n_keep') = 10;
%    % outcome for ff_summ_nd_array
%    mp_support('ffsna_opt_it_col_n_keep') = 9; 
%
%    [MP_VALPOL_OUT, FLAG] = FF_VFI_AZ_VEC() default savings and shock
%    model simulation
%
%    [MP_VALPOL_OUT, FLAG] = FF_VFI_AZ_VEC(MP_PARAMS) change model
%    parameters through MP_PARAMS
%
%    [MP_VALPOL_OUT, FLAG] = FF_VFI_AZ_VEC(MP_PARAMS, MP_SUPPORT) change
%    various printing, storaging, graphing, convergence etc controls
%    through MP_SUPPORT
%
%    [MP_VALPOL_OUT, FLAG] = FF_VFI_AZ_VEC(MP_PARAMS, MP_SUPPORT,
%    MP_SUPPORT_GRAPH) also changing graphing options, see the
%    FF_GRAPH_GRID function for what key value paris can be specified.
%
%    see also FX_VFI_AZ_VEC, FF_VFI_AZ_LOOP, FF_GRAPH_GRID
%

%%
function [mp_valpol_out, flag] = ff_vfi_az_vec(varargin)

%% Set Default and Parse Inputs
if (~isempty(varargin))
    
    if (length(varargin) == 1)
        [mp_params_ext] = varargin{:};
    elseif (length(varargin) == 2)
        [mp_params_ext, mp_support_ext] = varargin{:};
    elseif (length(varargin) == 3)
        [mp_params_ext, mp_support_ext, mp_support_graph_ext] = varargin{:};
    end
    
else
    close all
    
    mp_support_ext = containers.Map('KeyType','char', 'ValueType','any');
    mp_support_ext('bl_timer') = true;
    mp_support_ext('bl_print_params') = true; 
    mp_support_ext('bl_print_iterinfo') = true;     
    mp_support_ext('ls_ffcmd') = {'v', 'ap', 'c', 'y', 'coh', 'savefraccoh'};
    mp_support_ext('ls_ffsna') = {'ap'};
    mp_support_ext('ls_ffgrh') = {'v', 'ap', 'c', 'y', 'savefraccoh'};
    mp_support_ext('ls_store') = {'v', 'ap', 'c', 'y', 'coh'};
    mp_support_ext('ffsna_opt_it_row_n_keep') = 10;
    mp_support_ext('ffsna_opt_it_col_n_keep') = 9;

end

%% Default Model Parameters
% support_map
mp_params = containers.Map('KeyType','char', 'ValueType','any');
mp_params('fl_crra') = 1.5;
mp_params('fl_beta') = 0.94;

mp_params('fl_w') = 1.28;
mp_params('fl_r') = 0.025;

mp_params('fl_a_min') = 0;
mp_params('fl_a_max') = 50;
mp_params('it_a_n') = 300;
mp_params('st_grid_type') = 'grid_linspace';

mp_params('fl_z_persist') = 0.80;
mp_params('fl_shk_std') = 0.20;
mp_params('it_z_n') = 7;

% override default support_map values
if (length(varargin)>=1)
    mp_params = [mp_params; mp_params_ext];
end

%% Parse mp_params
params_group = values(mp_params, {'fl_crra', 'fl_beta'});
[fl_crra, fl_beta] = params_group{:};
params_group = values(mp_params, {'fl_w', 'fl_r'});
[fl_w, fl_r] = params_group{:};
params_group = values(mp_params, {'fl_a_min', 'fl_a_max', 'it_a_n', 'st_grid_type'});
[fl_a_min, fl_a_max, it_a_n, st_grid_type] = params_group{:};
params_group = values(mp_params, {'fl_z_persist', 'fl_shk_std', 'it_z_n'});
[fl_z_persist, fl_shk_std, it_z_n] = params_group{:};

%% Generate A and Z Grids
% Same min and max and grid points
[ar_a] = ff_saveborr_grid(fl_a_min, fl_a_max, it_a_n, st_grid_type);
ar_a = ar_a';

% shock vector and transition, normalize mean exp(shk) to 1
[ar_z, mt_z_trans] = ffy_rouwenhorst(fl_z_persist, fl_shk_std, it_z_n, false);
ar_z = exp(ar_z');
% normalize mean of exp to 1, fl_shk_std does not shift mean.
ar_z_stationary = mt_z_trans^1000;
ar_z_stationary = ar_z_stationary(1,:);
fl_labor_agg = ar_z_stationary*exp(ar_z');
ar_z = exp(ar_z)/fl_labor_agg;

%% Default Support Parameters
% support_map
mp_support = containers.Map('KeyType','char', 'ValueType','any');

% Model Control
mp_support('fl_lowestc') = -10e10;

% Iteration Control
mp_support('it_maxiter_val') = 500;
mp_support('fl_tol_val') = 10e-5;

% printer various information
mp_support('bl_timer') = true;
mp_support('bl_print_params') = false; 
mp_support('bl_print_iterinfo') = false; 

% These names must match keys of mp_solu: v, ap, c, y
% what outcomes to store in the mp_solu for export
mp_support('ls_slout') = {'v', 'ap', 'c', 'y', 'coh'}; 
% outcome for ff_container_map_display
mp_support('ls_ffcmd') = {'ap'}; 
% outcome for ff_summ_nd_array
mp_support('ls_ffsna') = {}; 
% outcome for ff_graph_grid
mp_support('ls_ffgrh') = {}; 
% outcome for ff_summ_nd_array
mp_support('ffsna_opt_it_row_n_keep') = 10;
% outcome for ff_summ_nd_array
mp_support('ffsna_opt_it_col_n_keep') = 9; 

% override default support_map values
if (length(varargin)>=2 || isempty(varargin))
    mp_support = [mp_support; mp_support_ext];
end

% Parse mp_support
params_group = values(mp_support, {'fl_lowestc'});
[fl_lowestc] = params_group{:};
params_group = values(mp_support, {'it_maxiter_val', 'fl_tol_val'});
[it_maxiter_val, fl_tol_val] = params_group{:};
params_group = values(mp_support, {'bl_timer', 'bl_print_params', 'bl_print_iterinfo'});
[bl_timer, bl_print_params, bl_print_iterinfo] = params_group{:};
params_group = values(mp_support, ...
    {'ls_slout', 'ls_ffcmd', 'ls_ffsna', 'ls_ffgrh',...
    'ffsna_opt_it_row_n_keep', 'ffsna_opt_it_col_n_keep'});
[ls_slout, ls_ffcmd, ls_ffsna, ls_ffgrh,...
    ffsna_opt_it_row_n_keep, ffsna_opt_it_col_n_keep] = params_group{:};

%% Whether Additional Outcomes Should be Stored
% when state space are large, might not be a good idea to store all
% possible model output matrixes, but could be controlled with these if
% things should be outputed. If bl_store_more = true, will output store all
% additional possible outcomes if bl_vfi_store_all = true. Internally,
% which output becomes tabular or graphical controled by ls_ffcmd,
% ls_ffsna, and ls_ffgrh.

% If to store additional outcomes
cl_more = {'c', 'y'};
ar_find_slout = cell2mat(cellfun(@(m) find(strcmp(ls_slout, m)), cl_more, 'UniformOutput', false));
ar_find_ffcmd = cell2mat(cellfun(@(m) find(strcmp(ls_ffcmd, m)), cl_more, 'UniformOutput', false));
ar_find_ffsna = cell2mat(cellfun(@(m) find(strcmp(ls_ffsna, m)), cl_more, 'UniformOutput', false));
ar_find_ffgrh = cell2mat(cellfun(@(m) find(strcmp(ls_ffgrh, m)), cl_more, 'UniformOutput', false));
if (length(ar_find_slout) + length(ar_find_ffcmd) + length(ar_find_ffsna) + length(ar_find_ffgrh) >1)
    bl_store_more = true;
end

%% Initialize Matrix
mt_val_cur = zeros(length(ar_a),length(ar_z));
mt_val_lst = mt_val_cur;
mt_aprime_cur = zeros(length(ar_a),length(ar_z));
mt_aprime_lst = mt_aprime_cur;
mt_aprime_idx = zeros(length(ar_a),length(ar_z));
ar_val_diff_norm = zeros([it_maxiter_val, 1]);
ar_pol_diff_norm = zeros([it_maxiter_val, 1]);
mt_pol_perc_change = zeros([it_maxiter_val, length(ar_z)]);

if (bl_store_more)
    mt_c = zeros(length(ar_a),length(ar_z));
    mt_y = zeros(length(ar_a),length(ar_z));
    mt_coh = zeros(length(ar_a),length(ar_z));
end

%% Define Functions
f_util_log = @(c) log(c);
f_util_crra = @(c) (((c).^(1-fl_crra)-1)./(1-fl_crra));
f_y = @(z, b) (z*fl_w + b.*(fl_r));
f_coh = @(z, b) (z*fl_w + b.*(1+fl_r));
f_cons = @(z, b, bprime) (f_coh(z, b) - bprime);

%% Iterate and Dynamically Solve
if (bl_timer)
    tic
end

% initialize
fl_diff = 1;
it_iter = 0;

% After converge, one more iteration to store results
bl_continue = true;
bl_converged = false;

while bl_continue
    
    % loop 1: over exogenous states
    % incorporating these shocks into vectorization has high memory burden
    % but insignificant speed gains. Keeping this loop allows for large
    % number of shocks without overwhelming memory
    for it_z_ctr = 1:length(ar_z)
        
        % Current Shock
        fl_z = ar_z(it_z_ctr);
        
        % Consumption and u(c) only need to be evaluated once
        if (it_iter == 0)
            
            % Consumption: fl_z = 1 by 1, ar_a = 1 by N, ar_a' = N by 1
            % mt_c is N by N: matrix broadcasting, expand to matrix from arrays
            mt_c_a_ap = f_cons(fl_z, ar_a, ar_a');
            
            % EVAL current utility: N by N, f_util defined earlier
            % slightly faster to explicitly write function
            if (fl_crra == 1)
                mt_utility = f_util_log(mt_c_a_ap);
            else
                % slightly faster if write function here directly, but
                % speed gain is very small, more important to have single
                % location control of functions.
                mt_utility = f_util_crra(mt_c_a_ap);
            end
            
            % Eliminate Complex Numbers
            mt_it_c_valid_idx = (mt_c_a_ap <= 0);
            mt_utility(mt_it_c_valid_idx) = fl_lowestc;
            
            % Store in cells
            cl_u_c_store{it_z_ctr} = mt_utility;
            cl_c_valid_idx{it_z_ctr} = mt_it_c_valid_idx;
            
        end
        
        % f(z'|z), 1 by Z
        ar_z_trans_condi = mt_z_trans(it_z_ctr,:);
        
        % EVAL EV((A',K'),Z'|Z) = V((A',K'),Z') x p(z'|z)', (N by Z) x (Z by 1) = N by 1
        % Note: transpose ar_z_trans_condi from 1 by Z to Z by 1
        % Note: matrix multiply not dot multiply
        mt_evzp_condi_z = mt_val_lst * ar_z_trans_condi';
        
        % EVAL add on future utility, N by N + N by 1, broadcast again
        mt_utility = cl_u_c_store{it_z_ctr} + fl_beta*mt_evzp_condi_z;
        
        % Index update
        % using the method below is much faster than index replace
        % see <https://fanwangecon.github.io/M4Econ/support/speed/index/fs_subscript.html fs_subscript>
        mt_it_c_valid_idx = cl_c_valid_idx{it_z_ctr};
        mt_utility = mt_utility.*(~mt_it_c_valid_idx) + (fl_lowestc)*(mt_it_c_valid_idx);
        
        % Optimization: remember matlab is column major, rows must be
        % choices, columns must be states
        % <https://en.wikipedia.org/wiki/Row-_and_column-major_order COLUMN-MAJOR>
        % mt_utility is N by N, rows are choices, cols are states.
        [ar_opti_val1_z, ar_opti_idx_z] = max(mt_utility);
        mt_val_cur(:,it_z_ctr) = ar_opti_val1_z';
        mt_aprime_cur(:,it_z_ctr) = ar_a(ar_opti_idx_z);
    
        % Save Additional Results
        if bl_converged
            mt_aprime_idx(:,it_z_ctr) = ar_opti_idx_z;
            if (bl_store_more)
                mt_c(:,it_z_ctr) = f_cons(fl_z, ar_a, ar_a(ar_opti_idx_z));
                mt_y(:,it_z_ctr) = f_y(fl_z, ar_a);
                mt_coh(:,it_z_ctr) = f_coh(fl_z, ar_a);
            end            
        end
    end    
    
    % Continuation Conditions:
    it_iter = it_iter + 1;
    fl_diff = norm(mt_val_cur-mt_val_lst);
    diff_pol = norm(mt_aprime_cur-mt_aprime_lst);
    
    % Difference across iterations
    if (bl_print_iterinfo)
        ar_val_diff_norm(it_iter) = fl_diff;
        ar_pol_diff_norm(it_iter) = diff_pol;
        mt_pol_perc_change(it_iter, :) = sum((mt_aprime_cur ~= mt_aprime_lst))/(length(ar_a));
    end
    
    % Update
    mt_val_lst = mt_val_cur;
    mt_aprime_lst = mt_aprime_cur;
    
    % Update Continue Criterion
    if bl_converged
        bl_continue = false;
    elseif(fl_diff <= fl_tol_val || it_iter >= it_maxiter_val)
        bl_converged = true;
    end
    
end


%% Convergence Results
it_iter_last = it_iter;
if fl_diff <= fl_tol_val && it_iter<=it_maxiter_val
    mt_val_cur = mt_val_lst;
    mt_aprime = mt_aprime_lst;
    flag = 1;
else
    mt_val_cur = zeros(size(mt_val_cur));
    mt_aprime = zeros(size(mt_val_cur));
    flag = 0;
end

if (bl_timer)
    toc
end

%% Results for Printing, and Graphing
mp_print_graph = containers.Map('KeyType','char', 'ValueType','any');
mp_print_graph('v') = mt_val_cur;
mp_print_graph('ap') = mt_aprime;
if (bl_store_more)
    mp_print_graph('c') = mt_c;
    mp_print_graph('y') = mt_y;
    mp_print_graph('coh') = mt_coh;
    mp_print_graph('savefraccoh') = mt_aprime./mt_coh;
end

%% Print Parameter Information
if (bl_print_params)    
    ff_container_map_display(mp_params);
    ff_container_map_display(mp_support);    
end

%% Show Value Function Convergence Information
if (bl_print_iterinfo)
    
    it_z_select = unique(round(linspace(1,length(ar_z), 7)));
    ar_z_select = ar_z(it_z_select);
    tb_valpol_alliter = array2table([ar_val_diff_norm(1:it_iter_last)';...
                                     ar_pol_diff_norm(1:it_iter_last)';...
                                     mt_pol_perc_change(1:it_iter_last,it_z_select)']');
    ar_st_col_zs = matlab.lang.makeValidName(strcat('z=', string(ar_z_select)));                                 
    cl_col_names = ['valgap', 'polgap', ar_st_col_zs];
    cl_row_names = strcat('iter=', string(1:it_iter_last));
    tb_valpol_alliter.Properties.VariableNames = cl_col_names;    
    tb_valpol_alliter.Properties.RowNames = cl_row_names;
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp('Value Function Iteration Per Iteration Changes');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp('valgap = norm(mt_val - mt_val_cur): value function difference across iterations');
    disp('polgap = norm(mt_pol_a - mt_pol_a_cur): policy function difference across iterations');
    disp(['z1 = z1 perc change: sum((mt_pol_a ~= mt_pol_a_cur))/(it_a_n): percentage of state space'...
          ' points conditional on shock where the policy function is changing across iterations']);
        disp(tb_valpol_alliter);
    
end

%% ls_ffcmd summary
if (~isempty(ls_ffcmd))    
    mp_ffcmd = containers.Map(ls_ffcmd, values(mp_print_graph, ls_ffcmd));
    ff_container_map_display(mp_ffcmd, ffsna_opt_it_row_n_keep, ffsna_opt_it_col_n_keep);    
end

%% ls_ffsna summarize full
if (~isempty(ls_ffsna))
    
    % container map subseting
    mp_ffsna = containers.Map(ls_ffsna, values(mp_print_graph, ls_ffsna));
    
    % ff_summ_nd_array parameters
    it_aggd = 0;
    bl_row = 1;
    ar_permute = [2,1];
    ar_st_stats = ["mean"];
    bl_print_table = true;
    cl_mp_datasetdesc = {};
    cl_mp_datasetdesc{1} = containers.Map({'name', 'labval'}, {'a', ar_a});
    cl_mp_datasetdesc{2} = containers.Map({'name', 'labval'}, {'z', ar_z});
    
    % summarize 
    param_map_keys = keys(mp_ffsna);
    param_map_vals = values(mp_ffsna);
    for i = 1:length(mp_ffsna)
        st_mt_name = param_map_keys{i};
        mt_cur = param_map_vals{i};
        st_title = ['ff_vfi_az_vec, outcome=' st_mt_name];        
        ff_summ_nd_array(st_title, mt_cur, ...
            bl_print_table, ar_st_stats, it_aggd, bl_row, ...
            cl_mp_datasetdesc, ar_permute);        
    end
    
end

%% ls_ffgrh graph
if (~isempty(ls_ffgrh))

    % container map subseting
    mp_ffgrh = containers.Map(ls_ffgrh, values(mp_print_graph, ls_ffgrh));
    
    % container map settings
    mp_support_graph = containers.Map('KeyType', 'char', 'ValueType', 'any');
    mp_support_graph('cl_st_xtitle') = {'savings states, a'};
    mp_support_graph('st_legend_loc') = 'best';
    mp_support_graph('bl_graph_logy') = true; % do not log
    mp_support_graph('st_rowvar_name') = 'shock=';
    mp_support_graph('it_legend_select') = 5; % how many shock legends to show
    mp_support_graph('st_rounding') = '6.2f'; % format shock legend
    mp_support_graph('cl_colors') = 'jet'; % any predefined matlab colormap
    
    % Overide graph options here with external parameters
    if (length(varargin)>=3)
        mp_support_graph = [mp_support_graph; mp_support_graph_ext];
    end
    
    % summarize 
    param_map_keys = keys(mp_ffgrh);
    param_map_vals = values(mp_ffgrh);
    for i = 1:length(mp_ffgrh)
        % Get matrix and key
        st_mt_name = param_map_keys{i};
        mt_cur = param_map_vals{i};
        
        % Update Title and Y label
        mp_support_graph('cl_st_graph_title') = {[st_mt_name '(a,z), savings state =x, shock state = color']};
        mp_support_graph('cl_st_ytitle') = {[st_mt_name '(a,z)']};
        
        % Call function
        ff_graph_grid(mt_cur', ar_z, ar_a, mp_support_graph);
    end
    
end

%% Store Results for Output
mp_valpol_out = containers.Map(ls_slout, values(mp_print_graph, ls_slout));

end
