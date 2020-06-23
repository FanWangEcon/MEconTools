%% FF_CONTAINER_MAP_DISPLAY Examples
% *back to* <https://fanwangecon.github.io *Fan*>*'s* <https://fanwangecon.github.io/Math4Econ/ 
% *Intro Math for Econ*>*,*  <https://fanwangecon.github.io/M4Econ/ *Matlab Examples*>*, 
% or* <https://fanwangecon.github.io/CodeDynaAsset/ *Dynamic Asset*> *Repositories*
% 
% This is the example vignette for function: <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/tools/ff_container_map_display.m 
% *ff_container_map_display*> from the <https://fanwangecon.github.io/MEconTools/ 
% *MEconTools Package*>*.* This function summarizes statistics of matrixes stored 
% in a container map, as well as scalar, string, function and other values stored 
% in container maps.
%% Test FF_CONTAINER_MAP_DISPLAY Defaults
% Call the function with defaults.

ff_container_map_display();
%% Test FF_CONTAINER_MAP_DISPLAY summarize Matrix Only
% Three large matrixes, show summaries

% Create Container
mp_container_map = containers.Map('KeyType','char', 'ValueType','any');
rng(123);
mp_container_map('mat_1') = rand(100,100);
mp_container_map('mat_2') = rand(100,100)*2 + 1;
mp_container_map('mat_2_boolean') = (rand(100,100) > 0.5);
% Will only print 
ff_container_map_display(mp_container_map);
%% Test FF_CONTAINER_MAP_DISPLAY Show Matrix Subset
% A container map with three small matrixes, print only only 2 rows and 3 columns.

% Create Container
mp_container_map = containers.Map('KeyType','char', 'ValueType','any');
rng(789);
mp_container_map('mat_1') = rand(3,4);
mp_container_map('mat_2') = rand(50,53);
mp_container_map('mat_2_boolean') = (rand(50,53) > 0.5);
% Will only print 
ff_container_map_display(mp_container_map, 2, 3);