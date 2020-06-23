%% FF_SUMM_ND_ARRAY Examples
% *back to* <https://fanwangecon.github.io *Fan*>*'s* <https://fanwangecon.github.io/Math4Econ/ 
% *Intro Math for Econ*>*,*  <https://fanwangecon.github.io/M4Econ/ *Matlab Examples*>*, 
% or* <https://fanwangecon.github.io/CodeDynaAsset/ *Dynamic Asset*> *Repositories*
% 
% This is the example vignette for function: <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/summ/ff_summ_nd_array.m 
% *ff_summ_nd_array*> from the <https://fanwangecon.github.io/MEconTools/ *MEconTools 
% Package*>*.* This function summarizes policy and value functions over states.
%% Test FF_SUMM_ND_ARRAY Defaults
% Call the function with defaults.

ff_summ_nd_array();
%% Test FF_SUMM_ND_ARRAY with Random 2 Dimensional Matrix 
% Summarize over 6 dimensional array, iteratively change how many dimensions 
% to group over.
% 
% First, generate matrix:

st_title = "Random 2D dimensional Array Testing Summarizing";
rng(123)
mn_polval = rand(5,4);
bl_print_table = true;
ar_st_stats = ["mean"];
cl_mp_datasetdesc = {};
cl_mp_datasetdesc{1} = containers.Map({'name', 'labval'}, ...
    {'a', linspace(0,1,size(mn_polval,1))});
cl_mp_datasetdesc{2} = containers.Map({'name', 'labval'}, ...
    {'z', linspace(-1,1,size(mn_polval,2))});
disp(mn_polval);
%% 
% Second, show the entire matrix (no labels):

it_aggd = 0; 
bl_row = 1; 
ff_summ_nd_array(st_title, mn_polval, bl_print_table, ar_st_stats, it_aggd, bl_row);
%% 
% Third, rotate row and column, and now with labels:

it_aggd = 0; 
bl_row = 1; 
ar_permute = [2,1];
ff_summ_nd_array(st_title, mn_polval, bl_print_table, ar_st_stats, it_aggd, bl_row, ...
    cl_mp_datasetdesc, ar_permute);
%% 
% Fourth, dimension one as columns, average over dim 2:

it_aggd = 1; 
bl_row = 1; 
ff_summ_nd_array(st_title, mn_polval, bl_print_table, ar_st_stats, it_aggd, bl_row, ...
    cl_mp_datasetdesc);
%% 
% Fifth, dimension one as rows, average over dim 2:

it_aggd = 1; 
bl_row = 0; 
ff_summ_nd_array(st_title, mn_polval, bl_print_table, ar_st_stats, it_aggd, bl_row, ...
    cl_mp_datasetdesc);
%% 
% Sixth, dimension two as rows, average over dim 1:

ar_permute = [2,1];
it_aggd = 1; 
bl_row = 0; 
ff_summ_nd_array(st_title, mn_polval, bl_print_table, ar_st_stats, it_aggd, bl_row, ...
    cl_mp_datasetdesc, ar_permute);
%% Test FF_SUMM_ND_ARRAY with Random 6 Dimensional Matrix 
% Summarize over 6 dimensional array, iteratively change how many dimensions 
% to group over.
% 
% First, generate matrix:

st_title = "Random ND dimensional Array Testing Summarizing";
rng(123)
mn_polval = rand(8,7,6,5,4,3);
bl_print_table = true;
ar_st_stats = ["mean"];
%% 
% Second, summarize over the first four dimensions,  row group others:

it_aggd = 4; 
bl_row = 0; 
ff_summ_nd_array(st_title, mn_polval, bl_print_table, ar_st_stats, it_aggd, bl_row);
%% 
% Third, summarize over the first four dimensions, column group 5th, and row 
% group others:

it_aggd = 4; 
bl_row = 1; 
ff_summ_nd_array(st_title, mn_polval, bl_print_table, ar_st_stats, it_aggd, bl_row);
%% 
% Fourth, summarize over the first five dimensions, column group 6th, no row 
% groups:

it_aggd = 5;
bl_row = 1; 
ff_summ_nd_array(st_title, mn_polval, bl_print_table, ar_st_stats, it_aggd, bl_row);
%% 
% Fifth, summarize over all six dimensions, summary statistics over the entire 
% dataframe:

it_aggd = 6;
bl_row = 0; 
ff_summ_nd_array(st_title, mn_polval, bl_print_table, ar_st_stats, it_aggd, bl_row);
%% Test FF_SUMM_ND_ARRAY with Random 7 Dimensional Matrix with All Parameters
% Given a random seven dimensional matrix, average over the 2nd, 4th and 5th 
% dimensionals. Show as row groups the 3, 6 and 7th dimensions, and row groups 
% the 1st dimension. 

st_title = "avg VALUE 2+4+5th dims. groups 3+6+7th dims, and row groups the 1st dim.";
rng(123)
mn_polval = rand(3,10,2,10,10,2,3);
ar_permute = [2,4,5,1,3,6,7];
bl_print_table = true;
ar_st_stats = ["mean", "coefvari"];
it_aggd = 3; % mean over 3 dims
bl_row = 1; % one var for row group
cl_mp_datasetdesc = {};
cl_mp_datasetdesc{1} = containers.Map({'name', 'labval'}, ...
    {'age', [18, 19, 20]});
cl_mp_datasetdesc{2} = containers.Map({'name', 'labval'}, ...
    {'savings', linspace(0,1,10)});
cl_mp_datasetdesc{3} = containers.Map({'name', 'labval'}, ...
    {'borrsave', [-1,+1]});
cl_mp_datasetdesc{4} = containers.Map({'name', 'labval'}, ...
    {'shocka', linspace(-5,5,10)});
cl_mp_datasetdesc{5} = containers.Map({'name', 'labval'}, ...
    {'shockb', linspace(-5,5,10)});
cl_mp_datasetdesc{6} = containers.Map({'name', 'labval'}, ...
    {'marry', [0,1]});
cl_mp_datasetdesc{7} = containers.Map({'name', 'labval'}, ...
    {'region', [1,2,3]});
% call function
ff_summ_nd_array(st_title, mn_polval, bl_print_table, ar_st_stats, it_aggd, bl_row, cl_mp_datasetdesc, ar_permute);
%%