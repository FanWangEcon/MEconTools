%% FF_SUMM_ND_ARRAY Group by and Summarize ND Array
%    Given an NDarray matrix with N1, N2, ..., ND dimensions. Generate
%    average and standard deviation for the 3rd dimension, grouping by the
%    other dimensions. In particular, show the 5th dimension as the column
%    groups, and the other variables generate combinations shown as rows.
%    The resulting summary statistics table contains mean and standard
%    deviation among other statistics over the policy or value contained in
%    the ND array.
%
%    * ST_TITLE string title of what is been generated, not a real title,
%    table does not have titles
%    * MN_POLVAL ND dimensional array to summary over. This is a value or
%    policy function generates over the state-space for example.
%    * BL_PRINT_TABLE boolean print table output
%    * CL_MP_DATASETDESC Cell Array of Container Maps, each map contains
%    keys: name, labval. name is a string with a short one word variable
%    name, labval is an array for what the values of this dimension are.
%    * IT_AGGD integer for how many dimensions to summarize over. If
%    it_aggd = 1, summarize over D1, group by others. If it_aggd = 2,
%    summarize over D1 and D2, group by others.
%    * BL_ROW boolean if to group by one category as rows. This groups by
%    the next dimension after IT_AGGD. summarize over D1 and D2, group by
%    others.
%    * AR_PERMUTE summarize always at the end over the first dimensions,
%    can resset the MN_POLVAL to switch out what the initial dimensions
%    are.
%
%    TB_ND_SUMMARY = FF_SUMM_ND_ARRAY() default test summary of 5D array.
%
%    TB_ND_SUMMARY = FF_SUMM_ND_ARRAY(ST_TITLE, MN_POLVAL, BL_PRINT_TABLE,
%    IT_AGGD, BL_ROW) given ND dimensional array, summarize the initial
%    IT_AGGD dimensions, if BL_ROW is true, group by the dimension higher
%    than IT_AGGD. If BL_ROW is false, now column groups, all remaining
%    dimensions are row group combinations.
%
%    TB_ND_SUMMARY = FF_SUMM_ND_ARRAY(ST_TITLE, MN_POLVAL, BL_PRINT_TABLE,
%    IT_AGGD, BL_ROW, CL_MP_DATASETDESC, AR_PERMUTE) summarizes over nd
%    dimensional array, decide which dimensions to summarize over, which
%    dimensions to use as row groups, and which dimension as column group.
%    To permute dimensions, must provide dimension details in
%    CL_MP_DATASETDESC.
%
%    See also FX_SUMM_ND_ARRAY
%

%%
function tb_nd_summary = ff_summ_nd_array(varargin)

%% Parse Main Inputs and Set Defaults
% use binomial as test case, z maps to binomial win prob, remember binom
% approximates normal.

if (~isempty(varargin))
    
    cl_mp_datasetdesc = false;
    it_aggd = 1;
    bl_row = true;
    ar_permute = false;
    
    if (length(varargin)==3)
        [st_title, mn_polval, bl_print_table] = varargin{:};
    elseif (length(varargin)==5)
        [st_title, mn_polval, bl_print_table, ...
            it_aggd, bl_row] = varargin{:};
    elseif (length(varargin)==6)
        [st_title, mn_polval, bl_print_table, ...
            it_aggd, bl_row, cl_mp_datasetdesc] = varargin{:};
    elseif (length(varargin)==7)
        [st_title, mn_polval, bl_print_table, ...
            it_aggd, bl_row, cl_mp_datasetdesc, ar_permute] = varargin{:};
    end
    
    % Generate cl_mp_datasetdesc and ar_permute
    ar_dim = size(mn_polval);
    if (length(varargin)<6)
        % set cl_mp_datasetdesc
        if (~cl_mp_datasetdesc)
            cl_mp_datasetdesc = {};
            for it_dim=1:1:length(ar_dim)
                it_curdim_length = ar_dim(it_dim);
                st_name = strcat(['vardim' num2str(it_dim) ]);
                ar_it_curdim_cate = 1:1:(it_curdim_length);
                cl_mp_datasetdesc{it_dim} = containers.Map({'name', 'labval'}, ...
                    {st_name, ar_it_curdim_cate});
            end
        end
    end
    
    % set ar_permute
    if (length(varargin)<7)
        if (~ar_permute)
            ar_permute = 1:1:length(ar_dim);
        end
    end
else
    
    st_title = "Summ over (a,z), condi age as cols, kids/marriage as rows";
    mn_polval = rand(4,10,5,4,2);
    
    cl_mp_datasetdesc = {};
    cl_mp_datasetdesc{1} = containers.Map({'name', 'labval'}, ...
        {'age', [18, 19, 20, 21]});
    cl_mp_datasetdesc{2} = containers.Map({'name', 'labval'}, ...
        {'savings', linspace(0,1,10)});
    cl_mp_datasetdesc{3} = containers.Map({'name', 'labval'}, ...
        {'shock', [-2,-1,0,1,2]});
    cl_mp_datasetdesc{4} = containers.Map({'name', 'labval'}, ...
        {'kids', [1,2,3,4]});
    cl_mp_datasetdesc{5} = containers.Map({'name', 'labval'}, ...
        {'marry', [0,1]});
    
    it_aggd = 2;
    bl_row = 1;
    ar_permute = [2,3,1,5,4];
    
    bl_print_table = true;
    ar_dim = size(mn_polval);
    
end

%% Resort Dimensions
mn_polval_resort = permute(mn_polval, ar_permute);
% Squeeze the first two dimensiosn as before
cln_mn_polval = squeeze(num2cell(mn_polval_resort, 1:(it_aggd+bl_row)));
cl_mn_polval = cln_mn_polval(:);

%% Generate Grouping Variables Possible Combinations
cl_ar_row_groups = {};
ar_group_names = [""];
for it_dim=(it_aggd+bl_row+1):1:length(ar_dim)
    it_var_idx = ar_permute(it_dim);
    mp_datasetdesc = cl_mp_datasetdesc{it_var_idx};
    ar_var_lab_val = mp_datasetdesc('labval');
    it_counter = it_dim-(it_aggd+bl_row+1)+1;
    ar_group_names(it_counter) = string(mp_datasetdesc('name'));
    cl_ar_row_groups{it_counter} = ar_var_lab_val;
end
cl_mt_row_groups_all = cl_ar_row_groups;
[cl_mt_row_groups_all{:}] = ndgrid(cl_ar_row_groups{:});
mt_row_groups_allcombo = cell2mat(cellfun(@(m) m(:), cl_mt_row_groups_all, 'uni', 0));


%% Summarize
if (bl_row)
    
    it_row_group = size(mn_polval_resort, (it_aggd+bl_row));
    mt_mean = zeros(length(cl_mn_polval), it_row_group);
    mt_std = zeros(length(cl_mn_polval), it_row_group);
    for it_mt=1:length(cl_mn_polval)
        mt_cur = cl_mn_polval{it_mt};
        if (it_aggd == 1)
            mt_mean(it_mt,:) = mean(mt_cur, 1);
            mt_std(it_mt,:) = std(mt_cur, [], 1);
        else
            mt_cur = reshape(mt_cur, [], it_row_group);
            mt_mean(it_mt,:) = mean(mt_cur, 1);
            mt_std(it_mt,:) = std(mt_cur, [], 1);
        end
    end
    
else
    
    % Over of matrix and summarize
    ar_mean = zeros(size(cl_mn_polval));
    ar_std = zeros(size(cl_mn_polval));
    ar_min = zeros(size(cl_mn_polval));
    ar_max = zeros(size(cl_mn_polval));
    for it_mt=1:length(cl_mn_polval)
        mt_cur = cl_mn_polval{it_mt};
        ar_mean(it_mt) = mean(mt_cur, 'all');
        ar_std(it_mt) = std(mt_cur, [], 'all');
        ar_min(it_mt) = min(mt_cur, [], 'all');
        ar_max(it_mt) = max(mt_cur, [], 'all');
    end
    
end

%% Construct Table
if (bl_row)
    % Constructe Table
    tb_nd_summary = array2table([(1:length(cl_mn_polval))', ...
        mt_row_groups_allcombo, mt_mean, mt_std]);
    % Column Names
    mp_datasetdesc = cl_mp_datasetdesc{ar_permute(it_aggd+bl_row)};
    ar_row_cate_lab_val = mp_datasetdesc('labval');
    st_row_cate_name = string(mp_datasetdesc('name'));
    cl_col_names_mn = strcat('mn_', st_row_cate_name, '_', string(ar_row_cate_lab_val));
    cl_col_names_sd = strcat('sd_', st_row_cate_name, '_', string(ar_row_cate_lab_val));
    tb_nd_summary.Properties.VariableNames = ...
        matlab.lang.makeValidName(["group", ar_group_names, cl_col_names_mn, cl_col_names_sd]);
else
    % Constructe Table
    tb_nd_summary = array2table([(1:length(cl_mn_polval))', ...
        mt_row_groups_allcombo, ar_mean, ar_std, ar_min, ar_max]);
    tb_nd_summary.Properties.VariableNames = ...
        matlab.lang.makeValidName(["group", ar_group_names,  "mean", "std", "min", "max"]);
end

%% Print
if (bl_print_table)
    disp(strjoin(["xxx " st_title " xxxxxxxxxxxxxxxxxxxxxxxxxxx"]));
    disp(tb_nd_summary);
end

end


