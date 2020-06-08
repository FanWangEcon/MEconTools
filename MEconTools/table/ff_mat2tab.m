%% Convert Matlab Matrix to Table with Column Names

%%
function [tb_from_mat] = ff_mat2tab(varargin)
%% Matrix to Table
% ff_mat2tab(mt_data, ar_st_colnames)

%% Catch Error
optional_params_len = length(varargin);
if optional_params_len > 4
    error('ff_mat2tab:TooManyOptionalParameters', ...
          'allows at most 4 optional parameters');
end

%% Default Folder Parameters
% by default all go to Sandbox folder with sub folders by dates
mt_data = rand(3,5);
% String array requires double quotes, specify string array
% Convert string array at the end to cell array using cellstr
ar_st_colnames = ["col1"];
% Others
st_table_name = "Table Name";
it_table_ctr = 1021;
optional_params = {mt_data ar_st_colnames ...
                   st_table_name it_table_ctr};
if (optional_params_len == 0) 
    verbose = true;
end

%% Parse Parameters
% numvarargs is the number of varagin inputted
[optional_params{1:optional_params_len}] = varargin{:};
% cell2mat(optional_params(1)) works with array
mt_data = cell2mat(optional_params(1));
% The structure below works with cell array
ar_st_colnames = optional_params{2};

%% Create Table
tb_from_mat = array2table(mt_data);

%% Adjust Column Names
% if ar_st_colnames does not have sufficient column
[it_tb_row_cnt, it_tb_col_cnt] = size(tb_from_mat);
it_ar_st_colnames_cnt = length(ar_st_colnames);
if (it_ar_st_colnames_cnt < it_tb_col_cnt)
%     warning('Not enough column names specified');
%     warning(string(ar_st_colnames));
    ar_st_colnames_add = strcat('col', ...
        string((it_ar_st_colnames_cnt+1):1:it_tb_col_cnt));
    ar_st_colnames = [ar_st_colnames, ar_st_colnames_add];
elseif (it_ar_st_colnames_cnt > it_tb_col_cnt)
%     warning('Too many column names specified')
%     warning(string(ar_st_colnames));
    ar_st_colnames = ar_st_colnames(1:it_tb_col_cnt);
end

% it_mt_row_count = size(mt_data, 1);
% tb_from_mat.Properties.RowNames;
tb_from_mat.Properties.VariableNames = cellstr(ar_st_colnames);

if (verbose)
    disp(tb_from_mat);
end
end
