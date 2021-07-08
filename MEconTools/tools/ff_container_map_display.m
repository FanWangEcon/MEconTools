%% FF_CONTAINER_MAP_DISPLAY organizes and prints container map key/values
%    FF_CONTAINER_MAP_DISPLAY() summarizes the contents of a map container
%    by data types. Includes, scalar, array, matrix, string, functions,
%    tensors (3-tuples), tesseracts (4-tuples)
%
%    * MP_CONTAINER_MAP container map with string, scalar, matrix, function
%    values and associated key names
%    * IT_ROW_N_KEEP integer the number of rows to print out from matrix
%    * IT_COL_N_KEEP integer the number of columns to print out from matrix
%
%    FF_CONTAINER_MAP_DISPLAY() prints out information from a default
%    container that includes string, scalar, boolean, matrix of scalars and
%    matrix of booleans.
%
%    FF_CONTAINER_MAP_DISPLAY(MP_CONTAINER_MAP) prints out information from
%    the MP_CONTAINER_MAP provided. If there are matrixes inside, will only
%    print out matrix summary statistics, not matrix subset cell values.
%
%    FF_CONTAINER_MAP_DISPLAY(MP_CONTAINER_MAP, IT_ROW_N_KEEP,
%    IT_COL_N_KEEP) prints out also matrix subsets, keeping IT_COL_N_KEEP
%    number of columns and IT_ROW_N_KEEP number of rows at most. The top
%    and bottom, and left-most and right-most cells will be selected.
%
%    See also FX_CONTAINER_MAP_DISPLAY

%%
function ff_container_map_display(varargin)

%% Parse Main Inputs and Set Defaults

% Defaults
it_col_n_keep = 7;
it_row_n_keep = 10;

% Parse inputs
if (~isempty(varargin))

    if (length(varargin) == 1)
        [mp_container_map] = varargin{:};
        bl_print_matrix_detail = false;
    elseif (length(varargin) == 3)
        [mp_container_map, it_row_n_keep, it_col_n_keep] = varargin{:};
        if (it_row_n_keep == 0 || it_col_n_keep == 0)
            bl_print_matrix_detail = false;
        else
            bl_print_matrix_detail = true;
        end
    end

else

    mp_container_map = containers.Map('KeyType','char', 'ValueType','any');
    rng(123);
    mp_container_map('mat_1') = rand(3,4);
    mp_container_map('mat_2') = rand(50,53);
    mp_container_map('mat_2_boolean') = (rand(50,53) > 0.5);
    mp_container_map('mat_3') = rand(2,2);
    mp_container_map('mat_4') = rand(1,1);
    mp_container_map('list_string_1') = ["col1", "col2", "col3", "col4"];
    mp_container_map('list_string_2') = ["row1", "row2", "row3", "row4"];
    mp_container_map('string_1') = "Table Name";
    mp_container_map('string_int_1') = 1021;
    mp_container_map('string_float_1') = 1021.13;
    mp_container_map('boolean_1') = true;
    mp_container_map('tensor_1') = rand(2,4,2);
    mp_container_map('tensor_2') = rand(3,5,5);
    mp_container_map('tensor_3') = rand(1,4,1);
    mp_container_map('tesseract_1') = rand(3,4,2,3);
    mp_container_map('tesseract_2') = rand(2,1,5,2);
    mp_container_map('tesseract_bl_3') = (rand(1,1,5,2) > 0.5);
    mp_container_map('empty') = [];

    mp_container_map('func1') = @(x) 1 + 2 + x;
    mp_container_map('func2') = @(x,y) x*1 + sqrt(y);

    bl_print_matrix_detail = true;

end

%% Start Display

% disp('----------------------------------------');
% disp('----------------------------------------');
% disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
% disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
% disp('Begin: Show all key and value pairs from container');
if (~isempty(varargin))
    st_containerinput = ['CONTAINER NAME: ' inputname(1)];
else
    st_containerinput = '';
end
% disp('----------------------------------------');
% disp(mp_container_map);
% disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
% disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
% disp('----------------------------------------');
% disp('----------------------------------------');

%% Get All Keys and Values
param_map_keys = keys(mp_container_map);
param_map_vals = values(mp_container_map);

it_mat_ctr = 0;
it_scalar_ctr = 0;
it_string_ctr = 0;
it_function_ctr = 0;

%% Loop over Keys and Value Pairs
for i = 1:length(mp_container_map)

    %% Access current Key and Value
    st_cur_key = param_map_keys{i};
    na_cur_val = param_map_vals{i};
    it_ndims = ndims(na_cur_val);
    it_numel = numel(na_cur_val);

    try
        if (length(na_cur_val)>1)
            if(iscell(na_cur_val) && (isstring(na_cur_val{1}) || ischar(na_cur_val{1})))
                na_cur_val = string(na_cur_val);
            elseif(iscell(na_cur_val))
                na_cur_val = na_cur_val{1};
            end
            if(istable(na_cur_val))
                na_cur_val = table2array(na_cur_val);
            end
        end
    catch
        disp('Could not display this data type');
    end

    %% Various Types of Values
    if (( ismatrix(na_cur_val) && (isnumeric(na_cur_val) || islogical(na_cur_val)) ) ...
            || (it_ndims >= 3  && (isnumeric(na_cur_val) || islogical(na_cur_val)) ) )
        %% C. If Value is Matrix, Scalar or Boolean
        % Get Size
        [it_row_n, it_col_n] = size(na_cur_val);

        if ( it_numel == 0)
            %% C1. Store Scalar Values and Boolean in Arrays
            it_scalar_ctr = it_scalar_ctr + 1;
            row_scalar_names{it_scalar_ctr} = st_cur_key;
            ar_scalar_val(it_scalar_ctr) = NaN;
            ar_scalar_i(it_scalar_ctr) = i;

        elseif ( it_numel == 1)
            %% C1. Store Scalar Values and Boolean in Arrays
            it_scalar_ctr = it_scalar_ctr + 1;
            row_scalar_names{it_scalar_ctr} = st_cur_key;
            ar_scalar_val(it_scalar_ctr) = real(na_cur_val);
            ar_scalar_i(it_scalar_ctr) = i;

            % st_display = strjoin(['pos =' num2str(i) '; key =' string(st_cur_key) '; val =' string(na_cur_val)]);
            %             disp(st_display);

        else
            %% C2. Store Numeric Matrix Stats and Size Info
            it_mat_ctr = it_mat_ctr + 1;
            row_mat_names{it_mat_ctr} = st_cur_key;

            [fl_mean, fl_std, fl_min, fl_max] = ff_container_map_display_mat_stats(na_cur_val);

            ar_dimn(it_mat_ctr) = ndims(na_cur_val);
            ar_lengthall(it_mat_ctr) = numel(na_cur_val);
            ar_rows_n(it_mat_ctr) = it_row_n;
            ar_cols_n(it_mat_ctr) = it_col_n;
            ar_sum(it_mat_ctr) = fl_mean*numel(na_cur_val);
            ar_mean(it_mat_ctr) = fl_mean;
            ar_std(it_mat_ctr) = fl_std;
            ar_cv(it_mat_ctr) = fl_std/fl_mean;
            ar_min(it_mat_ctr) = fl_min;
            ar_max(it_mat_ctr) = fl_max;
            ar_mat_i(it_mat_ctr) = i;

            %             st_display = strjoin(['pos =' num2str(i) '; key =' string(st_cur_key) ...
            %                 ';rown=' num2str(it_row_n) ',coln=' num2str(it_col_n)]);
            %             disp(st_display);

            %             st_display = strjoin([string(st_cur_key) ...
            %                 ':mu=' num2str(fl_mean) ',sd=' num2str(fl_std) ...
            %                 ',min=' num2str(fl_min) ',max=' num2str(fl_max)]);
            %             disp(st_display);

            if (bl_print_matrix_detail)
                [ar_it_cols, ar_it_rows] = ff_row_col_subset(it_col_n, it_col_n_keep, it_row_n, it_row_n_keep);
                cl_st_full_rows = cellstr([num2str((1:it_row_n)', 'r%d')]);
                cl_st_full_cols = cellstr([num2str((1:it_col_n)', 'c%d')]);
                tb_data_subset = array2table(na_cur_val(ar_it_rows, ar_it_cols));
                cl_row_names = strcat(cl_st_full_rows(ar_it_rows));
                cl_col_names = strcat(cl_st_full_cols(ar_it_cols));
                tb_data_subset.Properties.VariableNames = matlab.lang.makeValidName(cl_col_names);
                tb_data_subset.Properties.RowNames = matlab.lang.makeValidName(cl_row_names);
                cl_tb_data_subset{it_mat_ctr} = tb_data_subset;
            end
        end
    elseif(isa(na_cur_val, 'function_handle'))
        %% D. If Value is a Function Handl
        it_function_ctr = it_function_ctr + 1;
        row_function_names{it_function_ctr} = st_cur_key;
        ar_function_i(it_function_ctr) = i;
        ar_function_value(it_function_ctr) = string(func2str(na_cur_val));

        %         st_display = strjoin(['pos =' num2str(i) '; key =' string(st_cur_key) '; val =' func2str(na_cur_val)]);
        %         disp(st_display);

    elseif(isa(na_cur_val, 'string') || isa(na_cur_val, 'char'))
        %% E. String
        it_string_ctr = it_string_ctr + 1;
        row_string_names{it_string_ctr} = st_cur_key;
        ar_string_i(it_string_ctr) = i;
        if (isstring(na_cur_val))
            ar_string_val(it_string_ctr) = strjoin(na_cur_val, ';');
        else
            ar_string_val(it_string_ctr) = string(na_cur_val);
        end

        %         st_display = strjoin(['pos =' num2str(i) '; key =' string(st_cur_key) '; val =' string(na_cur_val)]);
        %         disp(st_display);

    else
        %% F. Other Types
        st_display = strjoin(['pos =' num2str(i) '; key =' string(st_cur_key)]);
        disp(st_display);
        disp(na_cur_val);
    end

end

if (it_mat_ctr >= 1)
    %% Overall Matrix Results
    disp('----------------------------------------');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp([st_containerinput ' ND Array (Matrix etc)'] )
    %     disp('Matrix in Container and Sizes and Basic Statistics');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');

    tb_rowcols_tab = array2table([(1:it_mat_ctr)', ar_mat_i', ...
        ar_dimn', ar_lengthall', ar_rows_n', ar_cols_n', ...
        ar_sum', ar_mean', ar_std', ar_cv', ar_min', ar_max']);
    tb_rowcols_tab.Properties.VariableNames = matlab.lang.makeValidName(["i", "idx", ...
        "ndim", "numel", "row n", "col n", ...
        "sum", "mean", "std", "coefvari", "min", "max"]);
    tb_rowcols_tab.Properties.RowNames = matlab.lang.makeValidName(row_mat_names);
    disp(tb_rowcols_tab);

    if (bl_print_matrix_detail)
        % Show matrix details:
        for i=1:length(cl_tb_data_subset)
            disp(strcat('xxx TABLE: ', row_mat_names{i}, ' xxxxxxxxxxxxxxxxxx'));
            disp(cl_tb_data_subset{i})
        end
    end
end

if (it_scalar_ctr >= 1)
    %% Overall Scalar Results
    disp('----------------------------------------');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp([st_containerinput ' Scalars'] )
    %     disp('Scalars in Container and Sizes and Basic Statistics');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');

    tb_rowcols_tab = array2table([(1:it_scalar_ctr)', ar_scalar_i', ar_scalar_val']);
    tb_rowcols_tab.Properties.VariableNames = matlab.lang.makeValidName(["i", "idx", "value"]);
    tb_rowcols_tab.Properties.RowNames = matlab.lang.makeValidName(row_scalar_names);
    disp(tb_rowcols_tab);
end

if (it_string_ctr >= 1)
    %% Overall String Results
    disp('----------------------------------------');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp([st_containerinput ' String'] )
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');

    tb_rowcols_tab = array2table([(1:it_string_ctr)', ar_string_i', ar_string_val']);
    tb_rowcols_tab.Properties.VariableNames = matlab.lang.makeValidName(["i", "idx", "string"]);
    tb_rowcols_tab.Properties.RowNames = matlab.lang.makeValidName(row_string_names);
    disp(tb_rowcols_tab);
end

if (it_function_ctr >= 1)
    %% Overall Function Results
    disp('----------------------------------------');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp([st_containerinput ' Functions'] )
    %     disp('Scalars in Container and Sizes and Basic Statistics');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');

    tb_rowcols_tab = array2table([(1:it_function_ctr)', ar_function_i', ar_function_value']);
    tb_rowcols_tab.Properties.VariableNames = matlab.lang.makeValidName(["i", "idx", "function string"]);
    tb_rowcols_tab.Properties.RowNames = matlab.lang.makeValidName(row_function_names);
    disp(tb_rowcols_tab);
end

end

%% Matrix Statistics
function [fl_mean, fl_std, fl_min, fl_max] = ff_container_map_display_mat_stats(mt_numeric)

fl_mean = mean(mt_numeric, 'all');
fl_std = std(mt_numeric, [], 'all');
fl_min = min(mt_numeric, [], 'all');
fl_max = max(mt_numeric, [], 'all');

end
