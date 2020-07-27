%% Re-execute MLX files, Do not Generate HTML

git_repo = 'C:\Users\fan\MEconTools\MEconTools';
git_repo_vig_main = fullfile(git_repo, 'doc');

dropbox_htmlout = '';
dorpbox_htmlout_vig_main = '';
st_pub_format = '';

st_mlx_search_name = '*.mlx';
% st_mlx_search_name = 'snwx_v_planner_densemore.mlx';
bl_run_mlx = true;
bl_run_mlx_only = true;
bl_verbose = true;

% ls_st_to_run = {'vfi', 'ds', 'generate', 'graph', 'optim', 'stats', 'summ', 'sys', 'tools'};
ls_st_to_run = {'ds'};

%% Run vfi Vignette
st_proj_folder = git_repo_vig_main;
cl_st_subfolder = ls_st_to_run;
st_out_folder = fullfile(dropbox_htmlout, dorpbox_htmlout_vig_main);
ff_mlx2htmlpdf_runandexport(...
    st_proj_folder, cl_st_subfolder, ...
    st_mlx_search_name, st_out_folder, st_pub_format, ...
    bl_run_mlx, bl_run_mlx_only, ...
    bl_verbose);