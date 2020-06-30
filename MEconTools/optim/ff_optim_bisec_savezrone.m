%% FF_OPTIM_BISEC_SAVEZRONE Bisection Vectorized
%    Standard Vectorized Bisection given anonymous function that outputs
%    the derivative of the optimal savings function. The function assumes
%    that the lower and upper bounds starting points are the same for each
%    row of the input parameter matrix. Savings problem where agents save 0
%    to 100 percent of available resoures (including borrowing bounds in
%    resource).
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
%    [AR_OPTI_SAVEBORR_FRAC] = FF_OPTIM_BISEC_SAVEZRONE() default optimal
%    saving and borrowing fractions.
%
%    [AR_OPTI_SAVEBORR_FRAC, AR_OPTI_SAVEBORR_LEVEL] =
%    FF_OPTIM_BISEC_SAVEZRONE(FC_DERI_WTH_UNIROOT) given function handle
%    for savings borrowing function derivative with an array of outputs,
%    each representing a different set of state-space points, solve for
%    optimal savings levels and savings fractions.
%
%    [AR_OPTI_SAVEBORR_FRAC, AR_OPTI_SAVEBORR_LEVEL, TB_BISEC_INFO] =
%    FF_OPTIM_BISEC_SAVEZRONE(FC_DERI_WTH_UNIROOT) also output convergence
%    iteration information.
%
%    see also FX_OPTIM_BISEC_SAVEZRONE
%

%%
function varargout = ff_optim_bisec_savezrone(varargin)

if (~isempty(varargin))
    
    % NOT called interally with the testing function ffi_intertempora_max below
    bl_default_test = false;
    
    st_grid_type = 'grid_linspace';
    bl_verbose = false;
    bl_print_iter = false;
    
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
    bl_print_iter = true;
    
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
        
        rng(123);
        ar_z1 = exp(rand([8,1])*3-1.5); % 40 asset points
        ar_z2 = exp(rand([8,1])*3-1.5); % 7 shock points
        ar_r = (rand(8,1)*0.10)+1.0; % marriage and edu
        ar_beta = (rand(8,1)*0.18)+0.80; % number of kids 0 to 5 
        
        cl_ar_all = {ar_z1, ar_z2, ar_r, ar_beta};
        cl_mt_all = cl_ar_all;
        [cl_mt_all{:}] = ndgrid(cl_ar_all{:});
        mt_all_states = cell2mat(cellfun(@(m) m(:), cl_mt_all, 'uni', 0));
        ar_mesh_z1 = mt_all_states(:,1);
        ar_mesh_z2 = mt_all_states(:,2); 
        ar_mesh_r = mt_all_states(:,3); 
        ar_mesh_beta = mt_all_states(:,4);
        
        ar_z1 = mt_all_states(:,1);
        ar_z2 = mt_all_states(:,2); 
        ar_r = mt_all_states(:,3); 
        ar_beta = mt_all_states(:,4);        

        % 3. define function with the fixed matrix of input
        fc_deri_wth_uniroot = @(x) ffi_intertemporal_max(...
            x, ar_mesh_z1, ar_mesh_z2, ar_mesh_r, ar_mesh_beta);
%         fc_deri_wth_uniroot = @(x) ffi_intertemporal_max(x, ar_z1, ar_z2, ar_r, ar_beta);
        
    elseif(it_exam==2)
        
        % solve future value first over state-space, consider savings only.
        
        % Get Some Tauchenized Shock
        [fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose, it_std_bound] = ...
            deal(0.60, 0.10, 3, false, 3);
        [ar_disc_ar1, mt_disc_ar1_trans] = ...
            ffy_tauchen(fl_ar1_persistence, fl_shk_std, it_disc_points, bl_verbose, it_std_bound);
        
        % think of ar_saveborr_level and ar_z2 as asset and shocks
        % think of ar_r and ar_beta as some other state-space components
        ar_saveborr_level = linspace(0, 3, 5); % 40 asset points
        ar_z2 = exp(ar_disc_ar1); % 7 shock points
        ar_r = linspace(1.00, 1.05, 2); % marriage and edu
        ar_beta = linspace(0.80, 0.95, 3); % number of kids 0 to 5 
        
        cl_ar_all = {ar_saveborr_level, ar_z2, ar_r, ar_beta};
        cl_mt_all = cl_ar_all;
        [cl_mt_all{:}] = ndgrid(cl_ar_all{:});
        mt_all_states = cell2mat(cellfun(@(m) m(:), cl_mt_all, 'uni', 0));

        % Evalute future at state space components    
        ar_mesh_saveborr_level = mt_all_states(:,1);
        ar_mesh_z2 = mt_all_states(:,2); 
        ar_mesh_r = mt_all_states(:,3); 
        ar_mesh_beta = mt_all_states(:,4);
        ar_util_future = ffi_intertemporal_util_future(...
            ar_mesh_saveborr_level, ar_mesh_z2, ar_mesh_r, ar_mesh_beta);
        
        % Assume that r and beta are persistent, from period t perspective,
        % I want to be able to find future value, given r, beta, current z,
        % and asset choice. r and beta tell us something aobut which row of
        % ar_util_future we should be looking at, the savings choice        
        mn_util_future = reshape(ar_util_future, ...
            [length(ar_saveborr_level), length(ar_z2), ...
             length(ar_r), length(ar_beta)]);
         
%          % reshape value so that all states are rows, shocks are columns
%          mn_util_future_reshape = reshape(...
%              permute(mn_util_future, [1,3,4,2]), ...
%              [], length(ar_z2));
%          
%          same asset grid grid 
%          given a vector of asset points

          11;
    end
    
    % 4. given the percentage assset choice problem, all share same bounds
    fl_x_left_start = 10e-6;
    fl_x_right_start = 1-10e-6;
    
end

%% Set and Update Support Map
mp_bisec_ctrlinfo = containers.Map('KeyType','char', 'ValueType','any');
mp_bisec_ctrlinfo('st_cur_bisec_info') = 'savings bisection';
mp_bisec_ctrlinfo('it_bisect_min_iter') = 1;
mp_bisec_ctrlinfo('it_bisect_max_iter') = 10;
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
params_group = values(mp_bisec_ctrlinfo, {'it_bisect_min_iter', 'it_bisect_max_iter', 'fl_bisect_tol'});
[it_bisect_min_iter, it_bisect_max_iter, fl_bisect_tol] = params_group{:};
params_group = values(mp_bisec_ctrlinfo, {'fl_x_left_start', 'fl_x_right_start'});
[fl_x_left_start, fl_x_right_start] = params_group{:};

%% Evaluate At lower and Upper Savings Bounds
[ar_lower_fx, ~] = fc_deri_wth_uniroot(fl_x_left_start);
[ar_upper_fx, ~] = fc_deri_wth_uniroot(fl_x_right_start);
ar_lower_x = fl_x_left_start + zeros(size(ar_lower_fx));
ar_upper_x = fl_x_right_start + zeros(size(ar_upper_fx));
if (bl_verbose)
    tb_bisec_info = array2table([ar_lower_x, ar_upper_x, ar_lower_fx, ar_upper_fx]');
    tb_bisec_info.Properties.RowNames = ...
        matlab.lang.makeValidName(["a", "b", "f_a","f_b"]);
    ar_st_cates = ["init", "init", "init", "init"];
    tb_bisec_info = addvars(tb_bisec_info, ar_st_cates', 'Before', 1);
end

%% First Mid Point
it_ctr_bisec = 1;

ar_mid_x = (ar_lower_x + ar_upper_x)/2;
[ar_mid_fx, ~] = fc_deri_wth_uniroot(ar_mid_x);

if (bl_verbose)
    tb_p = array2table([ar_mid_fx, ar_mid_x]');
    ar_st_row_names = [...
        string(['it' num2str(it_ctr_bisec) '_fp']),...
        string(['it' num2str(it_ctr_bisec) '_p'])];
    tb_p.Properties.RowNames = matlab.lang.makeValidName(ar_st_row_names);
    ar_st_cates = ["fatx", "x"];
    tb_p = addvars(tb_p, ar_st_cates', 'Before', 1);
    tb_bisec_info = [tb_bisec_info; tb_p];
end

%% Iterate until Bounds Reached
it_ctr_bisec = 2;
while (it_ctr_bisec <= it_bisect_max_iter)
    
    % Update either lower or upper bounds
    f_ap = ar_lower_fx.*ar_mid_fx;
    ar_upper_x(f_ap<0) = ar_mid_x(f_ap<0);
    ar_lower_x(f_ap>=0) = ar_mid_x(f_ap>=0);
    
    % Update mide point
    ar_mid_x = (ar_lower_x + ar_upper_x)/2;
    
    % Evaluate mid-point
    [ar_mid_fx, ar_mid_saveborr_level] = fc_deri_wth_uniroot(ar_mid_x);
    
    if (bl_verbose)
        tb_p = array2table([ar_mid_fx, ar_mid_x]');
        ar_st_row_names = [...
            string(['it' num2str(it_ctr_bisec) '_fp']),...
            string(['it' num2str(it_ctr_bisec) '_p'])];
        tb_p.Properties.RowNames = matlab.lang.makeValidName(ar_st_row_names);
        ar_st_cates = ["fatx", "x"];
        tb_p = addvars(tb_p, ar_st_cates', 'Before', 1);
        tb_bisec_info = [tb_bisec_info; tb_p];
        if(it_ctr_bisec == it_bisect_max_iter)
            tb_p_lvl = array2table([ar_mid_saveborr_level]');
            ar_st_row_names = string(['it' num2str(it_ctr_bisec) '_level']);
            tb_p_lvl.Properties.RowNames = matlab.lang.makeValidName(ar_st_row_names);
            ar_st_cates = ["level"];
            tb_p_lvl = addvars(tb_p_lvl, ar_st_cates', 'Before', 1);
            tb_bisec_info = [tb_bisec_info; tb_p_lvl];
        end
    end
    
    % Iterate up
    it_ctr_bisec = it_ctr_bisec + 1;
end

%% print details
if (bl_verbose)
    
    print_string = [st_cur_bisec_info 'iteration=' num2str(it_ctr_bisec)];
    disp(['BISECT END' print_string]);
    
    % get exact solution
    if (bl_default_test)
        [ar_opti_saveborr_frac, ar_opti_saveborr_level] = ...
            ffi_intertemporal_max_solu(ar_z1, ar_z2, ar_r, ar_beta);
        tb_p_exact = array2table(...
            [ar_opti_saveborr_frac, ar_opti_saveborr_level,...
            abs(ar_opti_saveborr_frac-ar_mid_x),...
            abs(ar_opti_saveborr_level-ar_mid_saveborr_level)]');
        ar_st_row_names = string([...
            "exact solu saveborr frac",...
            "exact solu saveborr level",...
            "exact solu saveborr frac gap",...
            "exact solu saveborr level gap"]);
        tb_p_exact.Properties.RowNames = matlab.lang.makeValidName(ar_st_row_names);
        ar_st_cates = ["exact", "exact", "exact", "exact"];
        tb_p_exact = addvars(tb_p_exact, ar_st_cates', 'Before', 1);
        tb_bisec_info = [tb_bisec_info; tb_p_exact];
        
    end
    
    % add column names
    cl_col_names = ["vartype", strcat('paramgroup', string((2:size(tb_bisec_info,2))))];
    tb_bisec_info.Properties.VariableNames = cl_col_names;
    
    % print all info
%     disp(tb_bisec_info);
    % print all info
%     disp(tb_bisec_info(strcmp(tb_bisec_info.vartype, "x"), :));
    
    
%     if(bl_print_iter)
        mt_iter_print = tb_bisec_info{strcmp(tb_bisec_info.vartype, "x"), 2:end};
        mt_iter_print = mt_iter_print';
%         ar_col_grid = string(cellstr(...
%             [num2str(ar_z1, 'z1=%3.2f;'), num2str(ar_z2, 'z2=%3.2f;'),...
%              num2str(ar_r, 'r=%3.2f;'), num2str(ar_beta, 'beta=%3.2f')]...
%             ));    
        mp_support_graph = containers.Map('KeyType', 'char', 'ValueType', 'any');
        mp_support_graph('cl_st_graph_title') = {'Vectorized Savings Percentage Bisection'};
        mp_support_graph('cl_st_ytitle') = {'Optimal Savings Borrowing Fraction'};
        mp_support_graph('cl_st_xtitle') = {'Bisection Iterations'};
        mp_support_graph('st_legend_loc') = 'eastoutside';
        mp_support_graph('bl_graph_logy') = false; % do not log
        mp_support_graph('st_rowvar_name') = 'param group =';
        mp_support_graph('it_legend_select') = 10;
        mp_support_graph('st_rounding') = '3.0f'; % format shock legend        
        % Call function
        ff_graph_grid(mt_iter_print, [1:size(mt_iter_print,1)], [1:size(mt_iter_print,2)], mp_support_graph);
%     end
end


%% Return
varargout = cell(nargout,0);
for it_k = 1:nargout
    if (it_k==1)
        ob_out_cur = ar_opti_saveborr_frac;
    elseif (it_k==2)
        ob_out_cur = ar_opti_saveborr_level;
    elseif (it_k==3 && bl_verbose)
        ob_out_cur = tb_bisec_info;
    end
    varargout{it_k} = ob_out_cur;
end
end

%% Utility Function
%    see https://fanwangecon.github.io/Math4Econ/derivative_application/htmlpdfm/K_save_households.html
function [ar_util_today, ar_util_future] = ...
    ffi_intertemporal_util(ar_saveborr_frac, z1, z2, r, beta)
% utility function

ar_resource = (z1-z2./(1+r));
ar_saveborr_level = ar_saveborr_frac.*ar_resource;

% contemporarneous utility
ar_util_today = log(z1-ar_saveborr_level);

% future utility
ar_util_future = ffi_intertemporal_util_future(ar_saveborr_level, z2, r, beta);

% total utility 
ar_util_all = ar_util_today + ar_util_future;

end

%% Utilty Future
function [ar_util_future] = ...
    ffi_intertemporal_util_future(ar_saveborr_level, z2, r, beta)
% utility function

% future utility
ar_util_future = beta.*log(z2 + ar_saveborr_level.*(1+r));

end

%% Intertemporal Maximization with Log Util, no Shock, Two Periods, Endowments
%    see https://fanwangecon.github.io/Math4Econ/derivative_application/htmlpdfm/K_save_households.html
function [ar_deri_zero, ar_saveborr_level] = ...
    ffi_intertemporal_max(ar_saveborr_frac, z1, z2, r, beta)
% x is borrowing or savings fraction, save at most z1, borrow at most
% z2/(1+r), x is between 0 and 1, assume that mt_fc_inputs are inputs
% that will be providing different functional parameters as rows, each
% column is a different parameter. N by 1. x could by 1 by M.

%     z1 = mt_fc_inputs(:,1);
%     z2 = mt_fc_inputs(:,2);
%     r = mt_fc_inputs(:,3);
%     beta = mt_fc_inputs(:,4);

ar_saveborr_level = ar_saveborr_frac.*(z1-z2./(1+r));
ar_deri_zero = 1./(ar_saveborr_level-z1) + (beta.*(r+1))./(z2 + ar_saveborr_level.*(r+1));

end

%% Solution Intertemporal Maximization with Log Util, no Shock, Two Periods, Endowments
%    see https://fanwangecon.github.io/Math4Econ/derivative_application/htmlpdfm/K_save_households.html
function [ar_opti_saveborr_frac, ar_opti_saveborr_level] = ...
    ffi_intertemporal_max_solu(z1, z2, r, beta)
% x is borrowing or savings fraction, save at most z1, borrow at most
% z2/(1+r), x is between 0 and 1, assume that mt_fc_inputs are inputs
% that will be providing different functional parameters as rows, each
% column is a different parameter. N by 1. x could by 1 by M.

%     z1 = mt_fc_inputs(:,1);
%     z2 = mt_fc_inputs(:,2);
%     r = mt_fc_inputs(:,3);
%     beta = mt_fc_inputs(:,4);

ar_opti_saveborr_level = (z1.*beta.*(1+r) - z2)./((1+r).*(1+beta));
ar_opti_saveborr_frac = ar_opti_saveborr_level./(z1-z2./(1+r));

end