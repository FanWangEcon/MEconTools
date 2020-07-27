%% FF_FIND_FILES Examples
% *back to* <https://fanwangecon.github.io *Fan*>*'s* <https://fanwangecon.github.io/Math4Econ/ 
% *Intro Math for Econ*>*,*  <https://fanwangecon.github.io/M4Econ/ *Matlab Examples*>*, 
% or* <https://fanwangecon.github.io/CodeDynaAsset/ *Dynamic Asset*> *Repositories*
% 
% This is the example vignette for function: <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/sys/ff_find_files.m 
% *ff_find_files*> from the <https://fanwangecon.github.io/MEconTools/ *MEconTools 
% Package*>*.* This function finds files in subfolders of folders.
%% Test FF_FIND_FILES Defaults
% Call the function with defaults.

[cl_st_file_names, cl_st_folder_names] = ff_find_files();
disp(cl_st_file_names);
disp(cl_st_folder_names);
%% Test FF_FIND_FILES search for files in subfolders
% Search for .mlx files in two subfolders:

st_proj_folder = 'C:\Users\fan\MEconTools\MEconTools\doc\';
cl_st_subfolder = {'generate','vfi'};
st_file_search_name = '*.mlx';
bl_verbose = true;
[cl_st_file_names, cl_st_folder_names] = ff_find_files(...
    st_proj_folder, cl_st_subfolder, st_file_search_name, bl_verbose);
%% 
%