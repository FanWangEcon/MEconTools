%% FF_FIND_FILES find files in folders with suffix
%    FF_FIND_FILES() finds file in folders and store them in a cell array.
%
%    * ST_PROJ_FOLDER string folder to search in 
%    * CL_ST_SUBFOLDER cell array of strings of subfolders to search in
%    * ST_FILE_SEARCH_NAME file name with wildcard to search for
%    * BL_VERBOSE boolean to print found names
%
%    [CL_ST_FILE_NAMES, CL_ST_FOLDER_NAMES] = FF_FIND_FILES() default
%    search testing. CL_ST_FILE_NAMES is a cell array of file names.
%    CL_ST_FOLDER_NAMES is a cell array of folders corresponding to each
%    file name element by element. 
%
%    [CL_ST_FILE_NAMES, CL_ST_FOLDER_NAMES] = FF_FIND_FILES(ST_PROJ_FOLDER,
%    CL_ST_SUBFOLDER, ST_FILE_SEARCH_NAME) Specify what folder,
%    ST_PROJ_FOLDER, and subfolders, CL_ST_SUBFOLDER, to search in with
%    what string, ST_FILE_SEARCH_NAME, in file name.
%
%    [CL_ST_FILE_NAMES, CL_ST_FOLDER_NAMES] = FF_FIND_FILES(ST_PROJ_FOLDER,
%    CL_ST_SUBFOLDER, ST_FILE_SEARCH_NAME, BL_VERBOSE)
%
%    See also FX_FIND_FILES

%%
function [cl_st_file_names, cl_st_folder_names] = ff_find_files(varargin)

%% Default Parameters
% assume CodeDynaAsset is on the root folder 

root = 'c:';
user = 'Users/fan';
project = 'CodeDynaAsset';
st_proj_folder = fullfile(root, user, project);

% subfolder = 'm_abz/test/ff_az_ds_vecsv/*/';
cl_st_subfolder = {'m_az/solve/', 'm_abz/solve/', 'm_ipwkz/solve/', 'm_ipwkbzr/solve/'};
st_file_search_name = '*vecsv.m';

% print found folders
bl_verbose = false;

cl_params = {st_proj_folder cl_st_subfolder st_file_search_name bl_verbose};

%% Parse Parameters

[cl_params{1:length(varargin)}] = varargin{:};

st_proj_folder = cl_params{1};
cl_st_subfolder = cl_params{2};
st_file_search_name = cl_params{3};
bl_verbose = cl_params{4};

%% Add Path
% set up path components

addpath(genpath(st_proj_folder));

%% Search Files
% generate html publish document

cl_st_file_names = [];
cl_st_folder_names = [];

it_file_ctr = 0;

for st_subfolder = cl_st_subfolder
    file_wildcard = fullfile(st_proj_folder, st_subfolder{1}, st_file_search_name);
    
    if (bl_verbose)    
        disp(file_wildcard);
    end
    
    sc_files = dir(file_wildcard);
    
    for it_ctr = 1:length(sc_files)
        it_file_ctr = it_file_ctr + 1;
        
        st_file_name = sc_files(it_ctr).name;
        st_folder_name = sc_files(it_ctr).folder;        
        
        if(bl_verbose)
            disp(st_file_name);
            disp(st_folder_name);
        end
        
        cl_st_file_names{it_file_ctr} = st_file_name;
        cl_st_folder_names{it_file_ctr} = st_folder_name;
        
    end
    
end

end

