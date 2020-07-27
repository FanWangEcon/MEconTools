%% FF_MLX2HTMLPDF_RUNANDEXPORT Examples
% *back to* <https://fanwangecon.github.io *Fan*>*'s* <https://fanwangecon.github.io/Math4Econ/ 
% *Intro Math for Econ*>*,*  <https://fanwangecon.github.io/M4Econ/ *Matlab Examples*>*, 
% or* <https://fanwangecon.github.io/CodeDynaAsset/ *Dynamic Asset*> *Repositories*
% 
% This is the example vignette for function: <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/sys/ff_mlx2htmlpdf_runandexport.m 
% *ff_mlx2htmlpdf_runandexport*> from the <https://fanwangecon.github.io/MEconTools/ 
% *MEconTools Package*>*.* This file runs MLX files and converts it to HTML files.
%% Test FF_MLX2HTMLPDF_RUNANDEXPORT search for MLX files and Convert to HTML
% Finds MLX files, re-run, and save to HTML in possibly another folder.

st_proj_folder = 'C:\Users\fan\MEconTools\MEconTools\doc\';
cl_st_subfolder = {'generate','graph'};
st_out_folder = 'C:\Users\fan\MEconTools\MEconTools\doc\sys\_test';
st_mlx_search_name = '*.mlx';
st_pub_format = 'html';
bl_run_mlx = true;
bl_run_mlx_only = false;
bl_verbose = true;
ff_mlx2htmlpdf_runandexport(...
    st_proj_folder, cl_st_subfolder, ...
    st_mlx_search_name, st_out_folder, st_pub_format, ...
    bl_run_mlx, bl_run_mlx_only, ...
    bl_verbose);
%% Test FF_MLX2HTMLPDF_RUNANDEXPORT re-run MLX
% Finds MLX files, re-run, do NOT save HTML.

st_proj_folder = 'C:\Users\fan\MEconTools\MEconTools\doc\';
cl_st_subfolder = {'external'};
st_mlx_search_name = '*.mlx';
st_out_folder = '';
st_pub_format = '';
bl_run_mlx = true;
bl_run_mlx_only = true;
bl_verbose = true;
ff_mlx2htmlpdf_runandexport(...
    st_proj_folder, cl_st_subfolder, ...
    st_mlx_search_name, st_out_folder, st_pub_format, ...
    bl_run_mlx, bl_run_mlx_only, ...
    bl_verbose);
%% 
%