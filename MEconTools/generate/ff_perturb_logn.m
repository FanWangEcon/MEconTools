%% FF_PERTURB_LOGN Randomly Perturb Some Parameter Value with Varying Magnitudes
%    During estimation, we have some starting estimation parameter value.
%    We want to do multi-start estimation by perturbing initial starting
%    points. The perturbing process follows the rules specified below,
%    implemented in the function below.
%
%    Select from 0 to 1, 0 closest to the existing parameter value, 1 very
%    far from it. Log normal distribution with 1st quartile = 0.185, and mu
%    of normal = 0. The value from (1) correspond to a cumulative mass
%    point of this log normal distribution. Draw a value randomly from
%    standard normal Transform the randomly drawn value to current
%    parameter scale with inverse z-score, the resulting value is the
%    parameter of interest.
%
%    FF_PERTURB_LOGN() generates a default perturbed value.
%
%    [PARAM_PERTURBED] = FF_PERTURB_LOGN(PARAM_ORIGINAL, IT_RAND_SEED,
%    SCALER_0T1) specify parameter to be perturbed as PARAM_ORIGINAL,
%    IT_RAND_SEED as random perturb seed, and SCALER_0T1 as the magnitude
%    of how much to perturb, with 0 the least, and 1 the most.
%
%    See
%    <https://fanwangecon.github.io/R4Econ/statistics/random/htmlpdfr/fs_perturb_parameter.html
%    fs_perturb_parameter> for details
%
%    see also FX_PERTURB_LOGN
%

%%
function varargout = ff_perturb_logn(varargin)

if (~isempty(varargin))

    bl_verbose = false;
    scaler_0t1 = 0.1;
    fl_sdlog = 2.5;
    fl_min_quantile = 1e-3;

    if (length(varargin) == 2)
        [param_original, it_rand_seed] = varargin{:};
    elseif (length(varargin) == 3)
        [param_original, it_rand_seed, scaler_0t1] = varargin{:};
    elseif (length(varargin) == 5)
        [param_original, it_rand_seed, scaler_0t1, ...
            fl_sdlog, fl_min_quantile] = varargin{:};
    else
        error('Must specify 2, 3 or 5 parameters for FF_PERTURB_LOGN.');
    end

else

    clc;
    clear all;
    close all;

    bl_verbose = true;
    param_original = 5;
    it_rand_seed = 5;
    scaler_0t1 = 0.1;
    fl_sdlog = 2.5;
    fl_min_quantile = 1e-3;

end

%% Perturb parameter
% Identical procedure to https://fanwangecon.github.io/R4Econ/statistics/random/htmlpdfr/fs_perturb_parameter.html

% Normal draw
rng(it_rand_seed);
fl_draw_znorm = randn();

% logn value at quantile
scaler_0t1 = scaler_0t1*(1-fl_min_quantile*2) + fl_min_quantile;
logn_coef_of_var = logninv(1-scaler_0t1, 0, fl_sdlog);

% Coefficient of variation
ar_logn_sd = param_original/logn_coef_of_var;
% Invert z-score
param_perturbed = fl_draw_znorm * ar_logn_sd + param_original;

%% print details
if (bl_verbose)

    % gather all info
    mp_container_map = containers.Map('KeyType','char', 'ValueType','any');
    mp_container_map('fl_draw_znorm') = fl_draw_znorm;
    mp_container_map('scaler_0t1') = scaler_0t1;
    mp_container_map('logn_coef_of_var') = logn_coef_of_var;
    mp_container_map('ar_logn_sd') = ar_logn_sd;
    mp_container_map('param_perturbed') = param_perturbed;
    mp_container_map('param_original') = param_original;

    % print
    ff_container_map_display(mp_container_map);

end


%% Return
varargout = cell(nargout,0);
for it_k = 1:nargout
    if (it_k==1)
        ob_out_cur = param_perturbed;
    end
    varargout{it_k} = ob_out_cur;
end
end
