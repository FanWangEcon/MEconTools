%% FFY_ROUWENHORST Rouwenhorst (1995) AR1 Discretization
% 
%    Mean Zero AR1 process.
%
%    * FL_PERSISTENCE AR1 process persistence
%    * FL_SHOCK_STD AR1 standard deviation
%    * IT_DISC_POINTS number of points to discretize AR1 process to
%    * IT_STD_BOUND shock bounds on AR1 process
%
%    FFY_ROUWENHORST() defaults
%
%    [AR_DISC_AR1, MT_DISC_AR1_TRANS] = FFY_ROUWENHORST(FL_PERSISTENCE,
%    FL_SHOCK_STD, IT_DISC_POINTS) specify AR 1 parameters.
%
%    [AR_DISC_AR1, MT_DISC_AR1_TRANS] = FFY_ROUWENHORST(FL_PERSISTENCE,
%    FL_SHOCK_STD, IT_DISC_POINTS, BL_VERBOSE) add bounds on shocks.
%
%    [AR_DISC_AR1, MT_DISC_AR1_TRANS] = FFY_ROUWENHORST(FL_PERSISTENCE,
%    FL_SHOCK_STD, IT_DISC_POINTS, BL_VERBOSE, IT_STD_BOUND) control
%    verbose printing. 
%
%    For more information, see <a href="matlab:web('https://fanwangecon.github.io/M4Econ/panel/timeseries/htmlpdfm/fs_autoregressive.html')">AR1 Process Example</a>.
%
%    see also FXY_ROUWENHORST, FFY_TAUCHEN, FXY_TAUCHEN
%

%%
function [ar_disc_ar1, mt_disc_ar1_trans] = ffy_rouwenhorst(varargin)

if (~isempty(varargin))
    
    bl_verbose = false;
    it_std_bound = 0;
    
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
    it_std_bound = 0;
    bl_verbose = true;
    
end

% standard deviation of the AR1 process
fl_sig_ar1 = sqrt(fl_shk_std^2/(1-fl_ar1_persistence^2));

% bounds
if (it_std_bound==0)
    fl_ar1_end = sqrt(it_disc_points-1)*fl_sig_ar1;
else
    fl_ar1_end = abs(it_std_bound)*fl_sig_ar1;
end

% grid
fl_ar1_beg = -fl_ar1_end;
fl_ar1_step = (fl_ar1_end-fl_ar1_beg)/(it_disc_points-1); % Could have used the command linspace
if it_disc_points == 1
    ar_disc_ar1 = 0;
else
    ar_disc_ar1 = (fl_ar1_beg:fl_ar1_step:fl_ar1_end)';
end

% get mass
fl_p0 = 0.5*(1+fl_ar1_persistence);
fl_q0 = fl_p0;
mt_disc_ar1_trans = ffy_rouwenhorst_mkv_recursive(fl_p0,fl_q0,it_disc_points);

% print
if (bl_verbose)
    
    % gather all info
    mp_container_map = containers.Map('KeyType','char', 'ValueType','any');
    mp_container_map('fl_ar1_persistence') = fl_ar1_persistence;
    mp_container_map('fl_shk_std') = fl_shk_std;
    mp_container_map('it_std_bound') = it_std_bound;
    mp_container_map('fl_sig_ar1') = fl_sig_ar1;
    mp_container_map('fl_ar1_end') = fl_ar1_end;
    mp_container_map('fl_ar1_beg') = fl_ar1_beg;
    mp_container_map('fl_ar1_step') = fl_ar1_step;
    mp_container_map('ar_disc_ar1') = ar_disc_ar1;
    mp_container_map('fl_p0') = fl_p0;
    mp_container_map('fl_q0') = fl_q0;
    mp_container_map('mt_disc_ar1_trans') = mt_disc_ar1_trans;
    
    % print
    ff_container_map_display(mp_container_map, 50, 50);

end

end