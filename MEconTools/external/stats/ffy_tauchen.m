%% FFY_TAUCHEN Tauchen (1986) AR1 Discretization
%
%    Mean Zero AR1 process. (edited from Jan Hannes Lang's code)
%
%    * FL_PERSISTENCE AR1 process persistence
%    * FL_SHOCK_STD AR1 standard deviation
%    * IT_DISC_POINTS number of points to discretize AR1 process to
%    * IT_STD_BOUND shock bounds on AR1 process
%
%    FFY_TAUCHEN() defaults
%
%    [AR_DISC_AR1, MT_DISC_AR1_TRANS] = FFY_TAUCHEN(FL_PERSISTENCE,
%    FL_SHOCK_STD, IT_DISC_POINTS) specify AR 1 parameters.
%
%    [AR_DISC_AR1, MT_DISC_AR1_TRANS] = FFY_TAUCHEN(FL_PERSISTENCE,
%    FL_SHOCK_STD, IT_DISC_POINTS, BL_VERBOSE) add bounds on shocks.
%
%    [AR_DISC_AR1, MT_DISC_AR1_TRANS] = FFY_TAUCHEN(FL_PERSISTENCE,
%    FL_SHOCK_STD, IT_DISC_POINTS, BL_VERBOSE, IT_STD_BOUND) control
%    verbose printing.
%
%    For more information, see <a href="matlab:web('https://fanwangecon.github.io/M4Econ/panel/timeseries/htmlpdfm/fs_autoregressive.html')">AR1 Process Example</a>.
%
%    see also FXY_TAUCHEN, FFY_ROUWENHORST, FXY_ROUWENHORST
%

%%
function [ar_disc_ar1, mt_disc_ar1_trans] = ffy_tauchen(varargin)

if (~isempty(varargin))
    
    bl_verbose = false;
    it_std_bound = 4;
    
    if (length(varargin) == 3)
        [fl_ar1_persistence, fl_shk_std, it_disc_points] = varargin{:};
    elseif (length(varargin) == 4)
        [fl_ar1_persistence, fl_shk_std, it_disc_points, ...
            bl_verbose] = varargin{:};
    elseif (length(varargin) == 5)
        [fl_ar1_persistence, fl_shk_std, it_disc_points, ...
            bl_verbose, it_std_bound] = varargin{:};
    else
        error('Must specify three parameters.');
    end
    
    if (it_disc_points<=1)
        error('Must discretize to more than 1 point.');
    end
    
else
    
    fl_ar1_persistence = 0.60;
    fl_shk_std = 0.20;
    it_disc_points = 5;
    it_std_bound = 4;
    bl_verbose = true;
    
end

fl_sig_ar1 = sqrt(fl_shk_std^2/(1-fl_ar1_persistence^2));

ar_disc_ar1 = zeros(it_disc_points,1);
mt_disc_ar1_trans = zeros(it_disc_points,it_disc_points);
ar_disc_ar1(1) = -it_std_bound*fl_sig_ar1;
ar_disc_ar1(it_disc_points) = it_std_bound*fl_sig_ar1;
fl_ar1_step = (ar_disc_ar1(it_disc_points)-ar_disc_ar1(1))/(it_disc_points-1);

for i=2:(it_disc_points-1)
    ar_disc_ar1(i) = ar_disc_ar1(i-1) + fl_ar1_step;
end

for it_j = 1:it_disc_points
    for it_k = 1:it_disc_points
        if it_k == 1
            mt_disc_ar1_trans(it_j, it_k) = ...
                cdf_normal((ar_disc_ar1(1) - fl_ar1_persistence*ar_disc_ar1(it_j) + fl_ar1_step/2) / fl_shk_std);
        elseif it_k == it_disc_points
            mt_disc_ar1_trans(it_j,it_k) = ...
                1 - cdf_normal(...
                (ar_disc_ar1(it_disc_points) ...
                - fl_ar1_persistence*ar_disc_ar1(it_j) ...
                - fl_ar1_step/2)...
                / fl_shk_std);
        else
            mt_disc_ar1_trans(it_j,it_k) = ...
                cdf_normal((ar_disc_ar1(it_k) - fl_ar1_persistence*ar_disc_ar1(it_j) + fl_ar1_step/2) / fl_shk_std) ...
                - cdf_normal((ar_disc_ar1(it_k) - fl_ar1_persistence*ar_disc_ar1(it_j) - fl_ar1_step/2) / fl_shk_std);
        end
    end
end


% print
if (bl_verbose)
    
    % gather all info
    mp_container_map = containers.Map('KeyType','char', 'ValueType','any');
    mp_container_map('fl_ar1_persistence') = fl_ar1_persistence;
    mp_container_map('fl_shk_std') = fl_shk_std;
    mp_container_map('it_std_bound') = it_std_bound;
    mp_container_map('fl_ar1_step') = fl_ar1_step;
    mp_container_map('ar_disc_ar1') = ar_disc_ar1;
    mp_container_map('mt_disc_ar1_trans') = mt_disc_ar1_trans;
    
    % print
    ff_container_map_display(mp_container_map, 50, 50);
    
end

end

function c = cdf_normal(x)
c = 0.5 * erfc(-x/sqrt(2));
end