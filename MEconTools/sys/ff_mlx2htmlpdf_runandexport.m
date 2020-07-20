%% FF_MLX2HTMLPDF_RUNANDEXPORT runs and exports MLX files
%    FF_MLX2HTMLPDF_RUNANDEXPORT() re-run MLX files, and store results to
%    html files in possibly different directories.
%
%    * ST_PROJ_FOLDER string folder to search in 
%    * CL_ST_SUBFOLDER cell array of strings of subfolders to search in
%    * ST_MLX_SEARCH_NAME mlx file name with wildcard to search for
%    * ST_OUT_FOLDER string folder name to save out to
%    * ST_PUB_FORMAT html or pdf format to output
%    * BL_RUN_MLX boolean if to rerun MLX file
%    * BL_RUN_MLX_ONLY boolean if only to run-execute MLX, but do not save
%    to HTML. ST_OUT_FOLDER and ST_PUB_FORMAT can be set to '' in this
%    case.
%
%    FF_MLX2HTMLPDF_RUNANDEXPORT(ST_PROJ_FOLDER, CL_ST_SUBFOLDER,
%    ST_MLX_SEARCH_NAME, ST_OUT_FOLDER) Specify what folder,
%    ST_PROJ_FOLDER, and subfolders, CL_ST_SUBFOLDER, to search in with
%    what string, ST_FILE_SEARCH_NAME, in file name. And save results to
%    which ST_OUT_FOLDER. By default output html and rerun mlx.
%
%    FF_MLX2HTMLPDF_RUNANDEXPORT(ST_PROJ_FOLDER, CL_ST_SUBFOLDER,
%    ST_MLX_SEARCH_NAME, ST_OUT_FOLDER, ST_PUB_FORMAT, BL_RUN_MLX) specify
%    format either html or pdf, and specify if to rerun MLX, BL_RUN_MLX.
%
%    FF_MLX2HTMLPDF_RUNANDEXPORT(ST_PROJ_FOLDER, CL_ST_SUBFOLDER,
%    ST_MLX_SEARCH_NAME, ST_OUT_FOLDER, ST_PUB_FORMAT, BL_RUN_MLX,
%    BL_RUN_MLX_ONLY) to run MLX in MLX folder only without saving to HTML.
%

function ff_mlx2htmlpdf_runandexport(varargin)

%% Default Parameters

% Input Folder
root = 'c:';
user = 'Users\fan\MEconTools\';
project = 'MEconTools\doc';
st_proj_folder = fullfile(root, user, project);

% Select possibly from multiple subfolders
cl_st_subfolder = {'generate/', 'graph/'};
st_mlx_search_name = '*.mlx';

% output folder
st_out_folder = 'C:\Users\fan\MEconTools\MEconTools\doc\sys\_test';

% Search 
st_pub_format = 'html';
bl_run_mlx = true;
bl_run_mlx_only = false;
bl_verbose = true;

cl_params = {st_proj_folder cl_st_subfolder ...
    st_mlx_search_name ...
    st_out_folder ... 
    st_pub_format ...
    bl_run_mlx bl_run_mlx_only ...
    bl_verbose};

%% Parse Parameters

[cl_params{1:length(varargin)}] = varargin{:};

st_proj_folder = cl_params{1};
cl_st_subfolder = cl_params{2};
st_mlx_search_name = cl_params{3};
st_out_folder = cl_params{4};
st_pub_format = cl_params{5};
bl_run_mlx = cl_params{6};
bl_run_mlx_only = cl_params{7};
bl_verbose = cl_params{8};

st_proj_folder = fullfile(st_proj_folder);
st_out_folder = fullfile(st_out_folder);

%% Add Path
% set up path components

addpath(genpath(st_proj_folder));

%% Search Files
% generate html publish document

[cl_st_file_names, cl_st_folder_names] = ...
    ff_find_files(st_proj_folder, cl_st_subfolder, st_mlx_search_name, false);

% %% Test Single Conversion
% cd C:/Users/fan/Math4Econ/matrix_application
% matlab.internal.liveeditor.openAndConvert('KL_borrowhire_firm.mlx', 'KL_borrowhire_firm.tex')

%% Publish Files
% generate html for each file

for it_file_ctr = 1:length(cl_st_file_names)

    % get file name and path
    st_mlx_search_name = cl_st_file_names{it_file_ctr};
    file_folder = cl_st_folder_names{it_file_ctr};
    
    % run MLX
    st_file_full_mlx = fullfile(file_folder, st_mlx_search_name);    
    if (bl_run_mlx)
        if (bl_verbose)
            tm_execute_timer = tic;
            disp(['execute:' st_mlx_search_name]); 
        end
        matlab.internal.liveeditor.executeAndSave(st_file_full_mlx);
        if (bl_verbose)
            tm_execute_end = toc(tm_execute_timer);
            disp(['finished execute:' st_file_full_mlx ...
                ', time=' num2str(tm_execute_end)])
        end
    end
    
    if (bl_run_mlx_only)
        if (bl_verbose)
            disp(['FF_MLX2HTMLPDF_RUNANDEXPORT finished MLX execute only'])
        end
    else
        % Generate .m file names    
        at_st_split_file_name = split(st_mlx_search_name, ".");
        st_file_name_m = strcat(at_st_split_file_name{1}, '_m.m');
        st_file_name_html = strcat(at_st_split_file_name{1}, '.html');
        st_file_name_pdf = strcat(at_st_split_file_name{1}, '.pdf');
        st_file_name_tex = strcat(at_st_split_file_name{1}, '.tex');

        % make directory
        [mkdir_status, mkdir_msg, mkdir_msgID] = mkdir(st_out_folder);
        if (bl_verbose)
            disp(['mkdir_msg:' mkdir_msg]);
        end

        % get full path to .m and .mlx
        st_file_full_m = fullfile(st_out_folder, st_file_name_m);
        st_file_full_html = fullfile(st_out_folder, st_file_name_html);
        st_file_full_pdf = fullfile(st_out_folder, st_file_name_pdf);
        st_file_full_tex = fullfile(st_out_folder, st_file_name_tex);
    %     disp(st_file_name_mlx);
    %     disp(st_file_name_m);
    %     disp(st_file_full_tex);

        if (strcmp(st_pub_format, 'html'))
            % convert from .mlx to .html
            if (bl_verbose); disp(['start:' st_file_name_html]); end
            matlab.internal.liveeditor.openAndConvert(st_file_full_mlx, st_file_full_html)
            if (bl_verbose); disp(['end:' st_file_full_html]); end
        elseif (strcmp(st_pub_format, 'pdf'))
            % convert from .mlx to .pdf
            if (bl_verbose); disp(['start:' st_file_name_pdf]); end
            matlab.internal.liveeditor.openAndConvert(st_file_full_mlx, st_file_full_pdf)
            if (bl_verbose); disp(['end:' st_file_full_pdf]); end
        end

    %     % convert from .mlx to .m
    %     matlab.internal.liveeditor.openAndConvert(st_file_full_mlx, st_file_full_m)
    %     % convert from .mlx to .tex
    %     matlab.internal.liveeditor.openAndConvert(st_file_full_mlx, st_file_full_tex)
    end
end
% delete(gcp('nocreate'));

end
