%% FX_PERTURB_LOGN Perturb Parameter with Logn Scalar
% *back to* <https://fanwangecon.github.io *Fan*>*'s* <https://fanwangecon.github.io/Math4Econ/ 
% *Intro Math for Econ*>*,*  <https://fanwangecon.github.io/M4Econ/ *Matlab Examples*>*, 
% or* <https://fanwangecon.github.io/CodeDynaAsset/ *Dynamic Asset*> *Repositories*
% 
% This is the example vignette for function: <https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/generate/ff_perturb_logn.m 
% *ff_perturb_logn*> from the <https://fanwangecon.github.io/MEconTools/ *MEconTools 
% Package*>*.* This function randomly perturb some existing parameter. See <https://fanwangecon.github.io/R4Econ/statistics/random/htmlpdfr/fs_perturb_parameter.html 
% Randomly Perturb Some Parameter Value with Varying Magnitudes>.
%% Test FX_PERTURB_LOGN Defaults
% Call the function with defaults.

ff_perturb_logn();
%% Test FX_PERTURB_LOGN with Different Draws and How much to Perturb
% Call the function with defaults.

% Collect
mp_container_map = containers.Map('KeyType','char', 'ValueType','any');
% Loop over different scalars
param_original = 5;
ar_scaler_0t1 = linspace(0,1,11);
it_scalar_ctr = 0;
for scaler_0t1=ar_scaler_0t1
    it_scalar_ctr = it_scalar_ctr + 1;
    % Generate differently perturbed parameters
    ar_param_perturbed = NaN(1,5000);
    for it_rand_seed=1:5000
        param_perturbed = ff_perturb_logn(param_original, it_rand_seed, scaler_0t1);
        ar_param_perturbed(it_rand_seed) = param_perturbed;
    end
    % Collect
    mp_container_map(['PERTURB_SCALAR_' num2str(scaler_0t1)]) = ar_param_perturbed;
end
% Display
ff_container_map_display(mp_container_map);