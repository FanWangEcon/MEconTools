%% FF_SAVEBORR_GRID Saving and Borrowing States/Choice Grid
%    Generate savings/borrowing states and choice grid given minimum,
%    maximum, and various other parameters. In the simplest case, generate
%    an even linspace savings grid from min to max. Or generate a grid with
%    denser points at the lower end with power function, log rule, etc. Or
%    generate a grid where the initial points are evenly spaced, but then
%    after some threshold, the points are nonlinearly spaced.
%
%    * ST_GRID_TYPE String which type of grid to generate: 'grid_linspace',
%    'grid_log10space', 'grid_powerspace', 'grid_evenlog'.
%    
%    Each type has type specific options set through key/value of
%    MP_GRID_CONTROL. 'grid_linspace': linspace; 'grid_log10space': log
%    space; 'grid_powerspace': power grid spacing; 'grid_evenlog': even
%    then log space.
%
%    mp_grid_control = containers.Map('KeyType', 'char', 'ValueType', 'any')
%    mp_grid_control('grid_log10space_x1') = first input of logspace();
%    mp_grid_control('grid_log10space_x2') = second input of logspace();
%    mp_grid_control('grid_powerspace_power') = 3;
%    mp_grid_control('grid_evenlog_threshold') = 1;
%
%    FF_SAVEBORR_GRID() generate a default savings grid, output grix is a
%    column array.
%
%    [AR_A_GRID] = FF_SAVEBORR_GRID(FL_A_MIN, FL_A_MAX, IT_A_POINTS)
%    specify min, max and points, this will by default generate a power
%    grid of points: st_grid_type == grid_log10space.
%
%    [AR_A_GRID] = FF_SAVEBORR_GRID(FL_A_MIN, FL_A_MAX, IT_A_POINTS,
%    ST_GRID_TYPE). Can change grid output type via ST_GRID_TYPE.
%
%    [AR_A_GRID] = FF_SAVEBORR_GRID(FL_A_MIN, FL_A_MAX, IT_A_POINTS,
%    ST_GRID_TYPE, MP_GRID_CONTROL). Modify default ST_GRID_TYPE specific
%    parameters via MP_GRID_CONTROL container map.
%
%    see also FX_SAVEBORR_GRID
%

%%
function varargout = ff_saveborr_grid(varargin)

if (~isempty(varargin))
    
    st_grid_type = 'grid_linspace';
    bl_verbose = false;
    
    if (length(varargin) == 3)
        [fl_a_min, fl_a_max, it_a_points] = varargin{:};
    elseif (length(varargin) == 4)
        [fl_a_min, fl_a_max, it_a_points, st_grid_type] = varargin{:};
    elseif (length(varargin) == 5)
        [fl_a_min, fl_a_max, it_a_points, ...
            st_grid_type, mp_grid_control_ext] = varargin{:};
    else
        error('Must specify three parameters.');
    end

else

    fl_a_min = 1;
    fl_a_max = 50;
    it_a_points = 25;
    bl_verbose = true;
    
%     st_grid_type = 'grid_linspace';
%     st_grid_type = 'grid_log10space';
    st_grid_type = 'grid_powerspace';
%     st_grid_type = 'grid_evenlog';
    
end

%% Set and Update Support Map
mp_grid_control = containers.Map('KeyType','char', 'ValueType','any');

% Options for st_grid_type == grid_linspace

% Options for st_grid_type == grid_log10space
mp_grid_control('grid_log10space_x1') = 0.3;
mp_grid_control('grid_log10space_x2') = 3;

% Options for st_grid_type == grid_powerspace
mp_grid_control('grid_powerspace_power') = 2.5;

% Options for st_grid_type == grid_evenlog
mp_grid_control('grid_evenlog_threshold') = 1;

% override default support_map values
if (length(varargin)==5)
    mp_grid_control = [mp_grid_control; mp_grid_control_ext];
end

%% Parse mp_grid_control
params_group = values(mp_grid_control, {'grid_log10space_x1', 'grid_log10space_x2'});
[grid_log10space_x1, grid_log10space_x2] = params_group{:};
params_group = values(mp_grid_control, {'grid_powerspace_power'});
[grid_powerspace_power] = params_group{:};
params_group = values(mp_grid_control, {'grid_evenlog_threshold'});
[grid_evenlog_threshold] = params_group{:};

%% Grid Generations
if (strcmp(st_grid_type, 'grid_linspace'))
    %% st_grid_type == grid_linspace
    
    ar_fl_saveborr = linspace(fl_a_min, fl_a_max, (it_a_points))';
    
elseif (strcmp(st_grid_type, 'grid_log10space'))
    %% st_grid_type == grid_log10space
    
    % generate logspace
    ar_fl_logspace = logspace(grid_log10space_x1, grid_log10space_x2, it_a_points)';
    
    % use logspace as ratio
    ar_fl_saveborr_ratio = (ar_fl_logspace -min(ar_fl_logspace))./(max(ar_fl_logspace) - min(ar_fl_logspace));
    
    % use ratio with min and max
    ar_fl_saveborr = ar_fl_saveborr_ratio.*(fl_a_max-fl_a_min) + fl_a_min;
    
elseif (strcmp(st_grid_type, 'grid_powerspace'))
    %% st_grid_type == grid_powerspace
    
    ar_fl_saveborr=zeros(it_a_points, 1);

    for i=1:(it_a_points)
        ar_fl_saveborr(i)= fl_a_min + (fl_a_max-fl_a_min)*((i-1)/(it_a_points-1))^grid_powerspace_power;
    end
                
elseif (strcmp(st_grid_type, 'grid_evenlog'))
    %% st_grid_type == grid_evenlog

    it_a_vec_n_log_cur = it_a_points;
    it_a_vec_n_actual = it_a_points + 99999999;

    while (it_a_vec_n_actual >= it_a_points+1)
        
        % After Threshold log space
        avec_log = logspace(...
            log10(grid_evenlog_threshold),...
            log10(fl_a_max), ...
            it_a_vec_n_log_cur);
        log_space_min_gap = avec_log(2) - avec_log(1);
        
        % Before Threshold equi-distance
        avec_lin = fl_a_min:log_space_min_gap:grid_evenlog_threshold;
        
        % combine
        ar_fl_saveborr = unique([avec_lin';avec_log']);
        
        % length check
        it_a_vec_n_actual = length(ar_fl_saveborr);
        it_a_vec_n_log_cur = it_a_vec_n_log_cur - 1;
    end
    
end

%% print details
if (bl_verbose)

    % gather all info
    mp_container_map = containers.Map('KeyType','char', 'ValueType','any');
    mp_container_map('ar_fl_saveborr') = ar_fl_saveborr;
    mp_container_map = [mp_container_map; mp_grid_control];
    
    % print
    ff_container_map_display(mp_container_map, 50, 50);

end


%% Return
varargout = cell(nargout,0);
for it_k = 1:nargout
    if (it_k==1)
        ob_out_cur = ar_fl_saveborr;
    end
    varargout{it_k} = ob_out_cur;
end
end
