%% FF_DS_AZ_CTS_VEC (Vectorized Continuous Choice) Dynamic Savings Distribution
%    Vectorized distributional solution for continuous asset choices. When For
%    the AZ model, dynamic savings with Shocks. Mostly vectorized distributional
%    solution for continuous or discrete asset choices. This is the
%    vectorized version of FF_DS_AZ_CTS_LOOP.
%
%    Vectorization from matrix multiplication to generate P(z',a'|z,a)
%    matrix for a particular z,a. Rows are a', and columns are z'.
%
%    * MP_PARAMS controls model preference, prices, shock and asset grid
%    parameters.
%    * MP_SUPPORT controls convergence criterion, printing and summary
%    controls
%
%    [MP_DIST_OUT, MP_VALPOL, FLAG] = FF_DS_AZ_CTS_LOOP() default savings
%    and shock model distributional simulation.
%
%    [MP_DIST_OUT, MP_VALPOL, FLAG] = FF_DS_AZ_CTS_LOOP(MP_PARAMS) change
%    model parameters through MP_PARAMS
%
%    [MP_DIST_OUT, MP_VALPOL, FLAG] = FF_DS_AZ_CTS_LOOP(MP_PARAMS,
%    MP_SUPPORT) change various printing, storaging, graphing, convergence
%    etc controls through MP_SUPPORT
%
%    [MP_DIST_OUT, MP_VALPOL, FLAG] = FF_VFI_AZ_LOOP(MP_PARAMS, MP_SUPPORT,
%    MP_SUPPORT_GRAPH) also changing graphing options, see the
%    FF_GRAPH_GRID function for what key value paris can be specified.
%
%    [MP_DIST_OUT, MP_VALPOL, FLAG] = FF_VFI_AZ_LOOP(MP_PARAMS, MP_SUPPORT,
%    MP_SUPPORT_GRAPH, MP_VALPOL) Solve the distributional problem given
%    provided MP_VALPOL which is the map that is the output of VFI. This
%    should generally not be called, the function should solve for value
%    and policy function given new parameters.
%
%    see also FX_DS_AZ_CTS_VEC, FF_DS_AZ_CTS_LOOP, FF_DS_AZ_LOOP,
%    FF_GRAPH_GRID
%

%%
function [mp_dist_out, mp_valpol, flag] = ff_ds_az_cts_vec(varargin)

%% Set Default and Parse Inputs
if (~isempty(varargin))
    
    if (length(varargin) == 1)
        [mp_params_ext] = varargin{:};
    elseif (length(varargin) == 2)
        [mp_params_ext, mp_support_ext] = varargin{:};
    elseif (length(varargin) == 3)
        [mp_params_ext, mp_support_ext, mp_support_graph_ext] = varargin{:};
    elseif (length(varargin) == 4)
        [mp_params_ext, mp_support_ext, mp_support_graph_ext, mp_valpol] = varargin{:};
    end
    
else
    clc;
    close all;
    
    mp_params_ext = containers.Map('KeyType','char', 'ValueType','any');
    mp_params_ext('solu_method') = 'bisec_vec';
    %     mp_params_ext('solu_method') = 'mzoom_vec';
    %     mp_params_ext('solu_method') = 'vec';
    
    mp_support_ext = containers.Map('KeyType','char', 'ValueType','any');
    
    mp_support_ext('bl_timer') = true;
    mp_support_ext('bl_print_params') = false;
    mp_support_ext('bl_print_iterinfo') = false;
    mp_support_ext('bl_show_stats_table') = true;
    
    %savings, fz, mass over shocks
    mp_support_ext('ls_dsout') = {'faz', 'fa', 'fz'};
    % Solution outcomes for statistics: must include ap for distribution
    mp_support_ext('ls_slout') = {'ap', 'v', 'c', 'y', 'coh', 'savefraccoh'};
    % outcome for ff_container_map_display
    mp_support_ext('ls_ddcmd') = {'faz', 'fa', 'fz'};
    % which distributional outcomes to graph
    mp_support_ext('ls_ddgrh') = {'faz', 'fa', 'fz'};
    mp_support_ext('ddcmd_opt_it_row_n_keep') = 75;
    mp_support_ext('ddcmd_opt_it_col_n_keep') = 9;
    
    %     %savings, fz, mass over shocks
    %     mp_support_ext('ls_dsout') = {'faz', 'fa', 'fz'};
    %     % Solution outcomes for statistics: must include ap for distribution
    %     mp_support_ext('ls_slout') = {'ap', 'v', 'c', 'y', 'coh', 'savefraccoh'};
    %     % outcome for ff_container_map_display
    %     mp_support_ext('ls_ddcmd') = {'faz', 'fa', 'fz'};
    %     % which distributional outcomes to graph: faz or fa allowed
    %     mp_support_ext('ls_ddgrh') = {};
    %     mp_support_ext('ddcmd_opt_it_row_n_keep') = 10;
    %     mp_support_ext('ddcmd_opt_it_col_n_keep') = 9;
    %
    %     mp_support_ext('ls_ffcmd') = {'v', 'ap', 'c', 'y', 'coh', 'savefraccoh'};
    %     mp_support_ext('ls_ffsna') = {'ap'};
    %     mp_support_ext('ls_ffgrh') = {};
    %     mp_support_ext('ls_store') = {'v', 'ap', 'c', 'y', 'coh'};
    %
end

%% Default Model Parameters
% Parameters for both VFI and Dist
mp_params = containers.Map('KeyType','char', 'ValueType','any');
mp_params('solu_method') = 'bisec_vec';

mp_params('fl_crra') = 1.5;
mp_params('fl_beta') = 0.95;

mp_params('fl_w') = 1.40;
mp_params('fl_r') = 0.04;

mp_params('fl_a_min') = 0;
mp_params('fl_a_max') = 50;
mp_params('it_a_n') = 200;
mp_params('st_grid_type') = 'grid_powerspace';

mp_params('fl_z_persist') = 0.80;
mp_params('fl_shk_std') = 0.20;
mp_params('it_z_n') = 15;

% override default support_map values
if (length(varargin)>=1 || isempty(varargin))
    mp_params = [mp_params; mp_params_ext];
end

%% Parse mp_params
params_group = values(mp_params, {'solu_method'});
[solu_method] = params_group{:};
params_group = values(mp_params, {'fl_a_min', 'fl_a_max', 'it_a_n', 'st_grid_type'});
[fl_a_min, fl_a_max, it_a_n, st_grid_type] = params_group{:};
params_group = values(mp_params, {'fl_z_persist', 'fl_shk_std', 'it_z_n'});
[fl_z_persist, fl_shk_std, it_z_n] = params_group{:};

%% Generate A and Z Grids
% Same min and max and grid points
[ar_a] = ff_saveborr_grid(fl_a_min, fl_a_max, it_a_n, st_grid_type);
ar_a = ar_a';

% shock vector and transition, normalize mean exp(shk) to 1
[ar_z, mt_z_trans] = ffy_rouwenhorst(fl_z_persist, fl_shk_std, it_z_n);
% normalize mean of exp to 1, fl_shk_std does not shift mean.
ar_z_stationary = mt_z_trans^1000;
ar_z_stationary = ar_z_stationary(1,:);
fl_labor_agg = ar_z_stationary*exp(ar_z);
ar_z = exp(ar_z')/fl_labor_agg;

%% Default Support Parameters
% support_map
mp_support = containers.Map('KeyType','char', 'ValueType','any');

% Iteration Control
mp_support('it_maxiter_ds') = 500;
mp_support('fl_tol_ds') = 1e-5;

% printer various information
mp_support('bl_timer') = true;
mp_support('bl_print_params') = false;
mp_support('bl_print_iterinfo') = false;
% final stats table
mp_support('bl_show_stats_table') = true;

% These names must match keys of mp_solu:
%savings, fz, mass over shocks
mp_support('ls_dsout') = {'faz', 'fa'};
% Solution outcomes for statistics: must include ap for distribution
mp_support('ls_stout') = {'ap', 'v', 'c', 'y', 'coh', 'savefraccoh'};
% outcome for ff_container_map_display
mp_support('ls_ddcmd') = {'faz', 'fa', 'fz'};
% present which distribution: only faz is allowed
mp_support('ls_ddsna') = {};
% which distributional outcomes to graph: faz or fa allowed
mp_support('ls_ddgrh') = {'fa'};
mp_support('ddcmd_opt_it_row_n_keep') = 10;
mp_support('ddcmd_opt_it_col_n_keep') = 9;

% override default support_map values
if (length(varargin)>=2 || isempty(varargin))
    mp_support = [mp_support; mp_support_ext];
end

% Parse mp_support
params_group = values(mp_support, {'it_maxiter_ds', 'fl_tol_ds'});
[it_maxiter_ds, fl_tol_ds] = params_group{:};
params_group = values(mp_support, {'bl_timer', 'bl_print_iterinfo', 'bl_show_stats_table'});
[bl_timer, bl_print_iterinfo, bl_show_stats_table] = params_group{:};
params_group = values(mp_support, {'ls_stout', 'ls_dsout', 'ls_ddcmd', 'ls_ddsna', 'ls_ddgrh', ...
    'ddcmd_opt_it_row_n_keep', 'ddcmd_opt_it_col_n_keep'});
[ls_stout, ls_dsout, ls_ddcmd, ls_ddsna, ls_ddgrh, ...
    ddcmd_opt_it_row_n_keep, ddcmd_opt_it_col_n_keep] = params_group{:};

%% Solve the Value Function

if (length(varargin) ~= 4)
    
    mp_support('ls_slout') = mp_support('ls_stout');
    
    if (strcmp(solu_method, 'bisec_loop'))
        [mp_valpol] = ff_vfi_az_bisec_loop(mp_params, mp_support);
    elseif (strcmp(solu_method, 'bisec_vec'))
        [mp_valpol] = ff_vfi_az_bisec_vec(mp_params, mp_support);
    elseif (strcmp(solu_method, 'mzoom_loop'))
        [mp_valpol] = ff_vfi_az_mzoom_loop(mp_params, mp_support);
    elseif (strcmp(solu_method, 'mzoom_vec'))
        [mp_valpol] = ff_vfi_az_mzoom_vec(mp_params, mp_support);
    elseif (strcmp(solu_method, 'loop'))
        [mp_valpol] = ff_vfi_az_loop(mp_params, mp_support);
    elseif (strcmp(solu_method, 'vec'))
        [mp_valpol] = ff_vfi_az_vec(mp_params, mp_support);
    end
    
end

mt_aprime = mp_valpol('ap');

%% Initialize Matrix
mt_dist_az_init = ones(length(ar_a),it_z_n)/length(ar_a)/it_z_n;
mt_dist_az_cur = mt_dist_az_init;
mt_dist_az_zeros = zeros(length(ar_a),it_z_n);

ar_dist_diff_norm = zeros([it_maxiter_ds, 1]);
mt_dist_perc_change = zeros([it_maxiter_ds, it_z_n]);

%% Start Timer
if (bl_timer)
    tm_start_tic = tic;
end


%% Match Asset Choices and Asset Grid Index
% find the closest lower and higher index a grid point to aprime choice,
% aprime choice might be continuous or be already on the a grid

% ar_a is 1 by it_a_n
% mt_prime(:) is it_a_n x it_z_n by 1

% find lower index
ar_it_ap_near_lower_idx  = sum(ar_a <= mt_aprime(:), 2);
ar_it_ap_near_lower_idx(ar_it_ap_near_lower_idx == length(ar_a)) = length(ar_a);

% find higher index
ar_it_ap_near_higher_idx  = sum(ar_a <= mt_aprime(:), 2) + 1;
ar_it_ap_near_higher_idx(ar_it_ap_near_higher_idx >= length(ar_a)) = length(ar_a);

% choice is on grid
[ar_it_ap_exact_row_idx, ar_it_ap_exact_idx] = find(ar_a == mt_aprime(:));
ar_it_ap_near_lower_idx(ar_it_ap_exact_row_idx) = ar_it_ap_exact_idx;
ar_it_ap_near_higher_idx(ar_it_ap_exact_row_idx) = ar_it_ap_exact_idx;

% reshape to apindex matrix
mt_it_ap_near_lower_idx = reshape(ar_it_ap_near_lower_idx, size(mt_aprime));
mt_it_ap_near_higher_idx = reshape(ar_it_ap_near_higher_idx, size(mt_aprime));
mt_fl_ap_near_lower = reshape(ar_a(mt_it_ap_near_lower_idx(:)), size(mt_aprime));
mt_fl_ap_near_higher = reshape(ar_a(mt_it_ap_near_higher_idx(:)), size(mt_aprime));

% distance to lowe and higher index
mt_fl_lower_idx_share = 1 - (mt_aprime - mt_fl_ap_near_lower)./(mt_fl_ap_near_higher - mt_fl_ap_near_lower);
mt_fl_lower_idx_share(mt_it_ap_near_higher_idx == mt_it_ap_near_lower_idx) = 0;

%% Iterate and Get Distribution
% initialize
it_iter = 0;

% After converge, one more iteration to store results
bl_continue = true;
bl_converged = false;

% Loop 0, continuous VFI iteration until convergence
while bl_continue
    it_iter = it_iter + 1;
    
    % initialize empty
    mt_dist_az = mt_dist_az_zeros;
    
    % loop 1: over exogenous states
    for it_z_i = 1:it_z_n
        
        % current probablity at f(:,z) for all a
        ar_cur_za_prob = mt_dist_az_cur(:, it_z_i);
        
        % Proportion of Current Mass to send to the left closest
        ar_aprime_lower_share = mt_fl_lower_idx_share(:, it_z_i);
        ar_aprime_higher_share = 1 - ar_aprime_lower_share;        
        
        % f(z'|z) transition for all z'
        ar_ztoz_trans = mt_z_trans(it_z_i, :);
        
        % f(a',z'|a,z)*f(a,z) generate matrix, for all a',z'
        mt_zfromza_lower = (ar_aprime_lower_share.*ar_cur_za_prob)*ar_ztoz_trans;
        mt_zfromza_higher = (ar_aprime_higher_share.*ar_cur_za_prob)*ar_ztoz_trans;
        
        % Lower and higher arrays
        for it_a_j = 1:length(ar_a)
            it_aprime_lower = mt_it_ap_near_lower_idx(it_a_j, it_z_i);
            it_aprime_higher = mt_it_ap_near_higher_idx(it_a_j, it_z_i);
            mt_dist_az(it_aprime_lower, :) = mt_dist_az(it_aprime_lower, :) + mt_zfromza_lower(it_a_j, :);
            mt_dist_az(it_aprime_higher, :) = mt_dist_az(it_aprime_higher, :) + mt_zfromza_higher(it_a_j, :);
        end
        
    end
    
    % Difference across iterations
    fl_diff = norm(mt_dist_az-mt_dist_az_cur);
    if (bl_print_iterinfo)
        ar_dist_diff_norm(it_iter) = fl_diff;
        mt_dist_perc_change(it_iter, :) = sum((abs(mt_dist_az - mt_dist_az_cur) > fl_tol_ds))/(it_a_n);
    end
    
    % Update
    mt_dist_az_cur = mt_dist_az;
    
    % Update Continue Criterion
    if bl_converged
        bl_continue = false;
    elseif(fl_diff <= fl_tol_ds || it_iter >= it_maxiter_ds)
        bl_converged = true;
        if (fl_diff <= fl_tol_ds)
            flag = 1;
        else
            flag = 2;
        end
    end
    
    % Print Iteration Record
    if(bl_print_iterinfo)
        disp(['FF_DS_AZ_CTS_LOOP, it_iter:' num2str(it_iter) ...
            ', fl_diff:' num2str(fl_diff)]);
    end
    
end

%% Timer Stop
if (bl_timer)
    tm_total = toc(tm_start_tic);
    disp(['FF_DS_AZ_CTS_LOOP finished. Distribution took = ' num2str(tm_total)])
end

%% Results for Printing, and Graphing
mp_print_graph = containers.Map('KeyType','char', 'ValueType','any');
mp_print_graph('faz') = mt_dist_az;
mp_print_graph('fa') = sum(mt_dist_az,2);
mp_print_graph('fz') = sum(mt_dist_az,1)';

%% Show Value Function Convergence Information
if (bl_print_iterinfo)
    
    it_z_select = unique(round(linspace(1,length(ar_z), 7)));
    ar_z_select = ar_z(it_z_select);
    tb_dist_alliter = array2table([ar_dist_diff_norm(1:it_iter)';...
        mt_dist_perc_change(1:it_iter,it_z_select)']');
    ar_st_col_zs = matlab.lang.makeValidName(strcat('z=', string(ar_z_select)));
    cl_col_names = ['distgap', ar_st_col_zs];
    cl_row_names = strcat('iter=', string(1:it_iter));
    tb_dist_alliter.Properties.VariableNames = cl_col_names;
    tb_dist_alliter.Properties.RowNames = cl_row_names;
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp('Value Function Iteration Per Iteration Changes');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp('distgap = norm(mt_dist_az - mt_dist_az_cur): distributional function difference across iterations');
    disp(['z1 = z1 perc change: sum((abs(mt_dist_az - mt_dist_az_cur) > fl_tol_ds))/(it_a_n);: percentage of state space'...
        ' points conditional on shock where the distribution mass is changing larger than fl_tol_ds across iterations']);
    disp(tb_dist_alliter);
    
end

%% ls_ddcmd summary

if (~isempty(ls_ddcmd))
    mp_ddcmd = containers.Map(ls_ddcmd, values(mp_print_graph, ls_ddcmd));
    ff_container_map_display(mp_ddcmd, ddcmd_opt_it_row_n_keep, ddcmd_opt_it_col_n_keep);
end

%% ls_ddsna summarize full
if (~isempty(ls_ddsna))
    
    % container map subseting
    mp_ddsna = containers.Map(ls_ddsna, values(mp_print_graph, ls_ddsna));
    
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
    param_map_keys = keys(mp_ddsna);
    param_map_vals = values(mp_ddsna);
    for i = 1:length(mp_ddsna)
        st_mt_name = param_map_keys{i};
        mt_cur = param_map_vals{i};
        st_title = ['FF_DS_AZ_CTS_LOOP, outcome=' st_mt_name];
        ff_summ_nd_array(st_title, mt_cur, ...
            bl_print_table, ar_st_stats, it_aggd, bl_row, ...
            cl_mp_datasetdesc, ar_permute);
    end
    
end

%% ls_ffgrh graph
if (~isempty(ls_ddgrh))
    
    % container map subseting
    mp_ddgrh = containers.Map(ls_ddgrh, values(mp_print_graph, ls_ddgrh));
    
    % container map settings
    mp_support_graph = containers.Map('KeyType', 'char', 'ValueType', 'any');
    mp_support_graph('cl_st_xtitle') = {'savings states, a'};
    mp_support_graph('st_legend_loc') = 'best';
    mp_support_graph('bl_graph_logy') = true; % do not log
    mp_support_graph('st_rowvar_name') = 'shock=';
    mp_support_graph('it_legend_select') = 11; % how many shock legends to show
    mp_support_graph('st_rounding') = '6.2f'; % format shock legend
    
    % Overide graph options here with external parameters
    if (length(varargin)>=3)
        mp_support_graph = [mp_support_graph; mp_support_graph_ext];
    end
    
    % summarize
    param_map_keys = keys(mp_ddgrh);
    param_map_vals = values(mp_ddgrh);
    for i = 1:length(mp_ddgrh)
        % Get matrix and key
        st_mt_name = param_map_keys{i};
        mt_cur = param_map_vals{i};
        
        if (strcmp(st_mt_name, 'faz'))
            
            % Color
            mp_support_graph('cl_colors') = 'copper'; % any predefined matlab colormap
            % Update Title and Y label
            mp_support_graph('cl_st_graph_title') = {['Joint Stationary Discrete Probability: f(a,z), savings=x, shock=color']};
            mp_support_graph('cl_st_ytitle') = {['f(a,z) joint mass']};
            mp_support_graph('cl_st_xtitle') = {'savings states, a'};
            % Call function
            ff_graph_grid(mt_cur', ar_z, ar_a, mp_support_graph);
            
            % Show F(a,z) as Scatter Size
            % Color
            mp_support_graph('cl_colors') = 'black'; % any predefined matlab colormap
            % Update Title and Y label
            mp_support_graph('cl_st_graph_title') = {['F(a,z), Prob Mass at State-Space as Scatter Size']};
            mp_support_graph('cl_st_ytitle') = {'shock states, z'};
            mp_support_graph('cl_st_xtitle') = {'savings states, a'};
            mp_support_graph('st_rowvar_name') = 'z =';
            mp_support_graph('bl_graph_logy') = false;
            % Call function distributional
            ff_graph_grid(mt_cur', ar_z, ar_a, mp_support_graph, 'dist');
            
        elseif (strcmp(st_mt_name, 'fa'))
            
            % Color
            mp_support_graph('cl_colors') = 'lines'; % any predefined matlab colormap
            % Update Title and Y label
            mp_support_graph('cl_st_graph_title') = {['Marginal Stationary Probability: f(a), savings=x']};
            mp_support_graph('cl_st_ytitle') = {['f(a) marginal mass']};
            mp_support_graph('cl_st_xtitle') = {'savings states, a'};
            % Call function
            ff_graph_grid(mt_cur', ["shock"], ar_a, mp_support_graph);
            
        elseif (strcmp(st_mt_name, 'fz'))
            
            % Color
            mp_support_graph('cl_colors') = 'gray'; % any predefined matlab colormap
            % Update Title and Y label
            mp_support_graph('cl_st_graph_title') = {['Exogenous Stationary Marginal Probability: f(z), shock=x']};
            mp_support_graph('cl_st_ytitle') = {['f(z) marginal mass']};
            mp_support_graph('cl_st_xtitle') = {'shock states, z'};
            % Call function
            ff_graph_grid(mt_cur', ["f(z)"], ar_z, mp_support_graph);
            
        end
    end
    
end

%% Store Results for Output
mp_dist_out = containers.Map(ls_dsout, values(mp_print_graph, ls_dsout));

%% Distributional Statistics
if (~isempty(ls_stout))
    
    % container map subseting
    mp_slout = containers.Map(ls_stout, values(mp_valpol, ls_stout));
    
    mp_cl_ar_xyz_of_s = containers.Map('KeyType','char', 'ValueType','any');
    
    param_map_keys = keys(mp_slout);
    param_map_vals = values(mp_slout);
    for i = 1:length(mp_slout)
        st_mt_name = param_map_keys{i};
        mt_cur = param_map_vals{i};
        
        mp_cl_ar_xyz_of_s(st_mt_name) = {mt_cur(:), zeros(1)};
    end
    
    % Add Names to list
    mp_cl_ar_xyz_of_s('ar_st_y_name') = string(ls_stout);
    
    % controls
    mp_support_simustats = containers.Map('KeyType','char', 'ValueType','any');
    mp_support_simustats('ar_fl_percentiles') = [0.01 0.1 1 5 10 20 25 30 40 50 60 70 75 80 90 95 99 99.9 99.99];
    mp_support_simustats('bl_display_final') = bl_show_stats_table;
    mp_support_simustats('bl_display_detail') = false;
    mp_support_simustats('bl_display_drvm2outcomes') = false;
    mp_support_simustats('bl_display_drvstats') = false;
    mp_support_simustats('bl_display_drvm2covcor') = false;
    mp_support_simustats = [mp_support_simustats; mp_support];
    
    % Call Function
    mp_cl_mt_xyz_of_s = ff_simu_stats(mt_dist_az(:), mp_cl_ar_xyz_of_s, mp_support_simustats);
    mp_dist_out('mp_cl_mt_xyz_of_s') = mp_cl_mt_xyz_of_s;
end

end
