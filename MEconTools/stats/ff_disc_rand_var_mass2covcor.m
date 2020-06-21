%% FF_DISC_RAND_VAR_MASS2COVCOR Corr and Cov given X(s), Y(s) and f(s)
%    Given probability mass function f(s), X(s), and Y(s), compute the
%    covariance and correlation betwen X and Y.
%    
%    * MT_X_OF_S matrix or array of x values at each s point
%    * MT_Y_OF_S matrix or array of y values at each s point
%    * MT_F_OF_S matrix or array probability mass at each s point
%    * FL_X_MEAN float x mean
%    * FL_X_SD float x standard deviation
%    * FL_Y_MEAN float y mean
%    * FL_Y_SD flat y standard deviation
%
%    [FL_COV_XY, FL_COR_XY] = FF_DISC_RAND_VAR_MASS2COVCOR() default
%    dataframe test correlation and covariance
%
%    [FL_COV_XY, FL_COR_XY] = FF_DISC_RAND_VAR_MASS2COVCOR(MT_X_OF_S,
%    MT_Y_OF_S, MT_F_OF_S) calculates correlation and covariance based on a
%    multi-column of single column matrix of x values, and matrix of y
%    values corresponding to state-space points s, and the probability mass
%    over s.
%
%    [FL_COV_XY, FL_COR_XY] = FF_DISC_RAND_VAR_MASS2COVCOR(MT_X_OF_S,
%    MT_Y_OF_S, MT_F_OF_S, BL_DISPLAY_DRVM2COVCOR) calculates var and sd
%    with or without printing verbose info.
%
%    [FL_COV_XY, FL_COR_XY] = FF_DISC_RAND_VAR_MASS2COVCOR(MT_X_OF_S,
%    MT_Y_OF_S, MT_F_OF_S, FL_X_MEAN, FL_X_SD, FL_Y_MEAN, FL_Y_SD,
%    BL_DISPLAY_DRVM2COVCOR) computes cov and cor with already calculated x
%    and y means and standard deviations to avoid recomputing.
%    
%    See also FX_DISC_RAND_VAR_MASS2COVCOR
%


%%
function [fl_cov_xy, fl_cor_xy] = ff_disc_rand_var_mass2covcor(varargin)
%% FF_DISC_RAND_VAR_MASS2COVCOR find cov(x,y) given X(a,z), Y(a,z) and f(a,z)
% Having computed elsewhere E(X), E(Y), and SD(X), SD(Y), and given X(a,z)
% and Y(a,z), which are the optimal choices along the endogenous state
% space grid a, and the exogenous state space grid z, and given also
% f(a,z), the probability mass function over (a,z), we compute covariance
% and correlation between outcomes X and Y.
%
% * Covariance
%
% $$\mathrm{Cov}\left(x,y\right) = \sum_{a} \sum_{z} f(a,z) \cdot \left( x(a,z) - \mu_x \right) \cdot \left( y(a,z) - \mu_y \right)$$
%
% * Correlation
%
% $$\rho_{x,y} = \frac{\mathrm{Cov}\left(x,y\right)}{\sigma_x \cdot \sigma_y}$$
%

%% Parse Main Inputs and Set Defaults

if (~isempty(varargin))
    
    if (length(varargin) == 3 || length(varargin) == 4)
        
        if (length(varargin) == 3)
            [mt_x_of_s, mt_y_of_s, mt_f_of_s] = varargin{:};
            bl_display_drvm2covcor = false;
        else
            [mt_x_of_s, mt_y_of_s, mt_f_of_s, ...
                bl_display_drvm2covcor] = varargin{:};
        end
        
        % X-mean
        st_x = 'x_outcome';
        [ar_f_of_x, ar_x_sorted, ~, ~] = ...
            ff_disc_rand_var_mass2outcomes(st_x, mt_x_of_s, mt_f_of_s);        
        [ds_stats_x_map] = ff_disc_rand_var_stats(st_x, ar_x_sorted', ar_f_of_x');
        fl_x_mean = ds_stats_x_map('fl_choice_mean');
        fl_x_sd = ds_stats_x_map('fl_choice_sd');
        
        % Y-mean
        st_y = 'y_outcome';
        [ar_f_of_y, ar_y_sorted, ~, ~] = ...
            ff_disc_rand_var_mass2outcomes(st_y, mt_y_of_s, mt_f_of_s);        
        [ds_stats_y_map] = ff_disc_rand_var_stats(st_y, ar_y_sorted', ar_f_of_y');
        fl_y_mean = ds_stats_y_map('fl_choice_mean');
        fl_y_sd = ds_stats_y_map('fl_choice_sd');
        
    elseif (length(varargin) == 7 || length(varargin) == 8)
                
        if (length(varargin) == 3)
            [mt_x_of_s, mt_y_of_s, mt_f_of_s, ...
                fl_x_mean, fl_x_sd, ...
                fl_y_mean, fl_y_sd] = varargin{:};
        else
            [mt_x_of_s, mt_y_of_s, mt_f_of_s, ...
                fl_x_mean, fl_x_sd, ...
                fl_y_mean, fl_y_sd, bl_display_drvm2covcor] = varargin{:};
        end
        
    end   

else
    
    it_states = 6;
    it_shocks = 5;
    fl_binom_n = it_states-1;
    ar_binom_p = (1:(it_shocks))./(it_shocks+2);
    ar_binom_x = (0:1:(it_states-1)) - 3;

    % f(z)
    ar_binom_p_prob = binopdf(0:(it_shocks-1), it_shocks-1, 0.5);
    % f(a,z), mass for a, z
    mt_f_of_s = zeros([it_states, it_shocks]);
    for it_z=1:it_shocks
        % f(a|z)
        f_a_condi_z = binopdf(ar_binom_x - min(ar_binom_x), fl_binom_n, ar_binom_p(it_z));
        % f(z)
        f_z = ar_binom_p_prob(it_z);
        % f(a,z)=f(a|z)*f(z)
        mt_f_of_s(:, it_z) = f_a_condi_z*f_z;
    end

    % x(a,z), some non-smooth structure
    rng(123);
    mt_x_of_s = ar_binom_x' - 0.01*ar_binom_x'.^2  + ar_binom_p - 0.5*ar_binom_p.^2 + rand([it_states, it_shocks]);
    mt_x_of_s = round(mt_x_of_s*3);

    % y(a,z), some non-smooth structure
    rng(456);
    mt_y_of_s = 10 -(mt_x_of_s) + 15*(rand([it_states, it_shocks])-0.5);

    % Obtain mean and sd
    st_x = 'x_outcome';
    [ar_f_of_x, ar_x_sorted, ~, ~] = ...
        ff_disc_rand_var_mass2outcomes(st_x, mt_x_of_s, mt_f_of_s);
    [ds_stats_x_map] = ff_disc_rand_var_stats(st_x, ar_x_sorted', ar_f_of_x');
    fl_x_mean = ds_stats_x_map('fl_choice_mean');
    fl_x_sd = ds_stats_x_map('fl_choice_sd');

    st_x = 'y_outcome';
    [ar_f_of_y, ar_y_sorted, ~, ~] = ...
        ff_disc_rand_var_mass2outcomes(st_x, mt_y_of_s, mt_f_of_s);
    [ds_stats_y_map] = ff_disc_rand_var_stats(st_x, ar_y_sorted', ar_f_of_y');
    fl_y_mean = ds_stats_y_map('fl_choice_mean');
    fl_y_sd = ds_stats_y_map('fl_choice_sd');

    % display
    bl_display_drvm2covcor = true;
end

%% 1. Compute Covariance

mt_x_devi_from_mean = (mt_x_of_s - fl_x_mean);
mt_y_devi_from_mean = (mt_y_of_s - fl_y_mean);
mt_x_y_multiply = (mt_x_devi_from_mean).*(mt_y_devi_from_mean);
mt_cov_component_weighted = mt_f_of_s.*(mt_x_y_multiply);
fl_cov_xy = sum(mt_cov_component_weighted, 'all');

%% 2. Compute Correlation

fl_cor_xy = fl_cov_xy/(fl_x_sd*fl_y_sd);

%% Display
if (bl_display_drvm2covcor)

    covvar_input_map = containers.Map('KeyType','char', 'ValueType','any');
    covvar_input_map('mt_x_of_s') = mt_x_of_s;
    covvar_input_map('mt_y_of_s') = mt_y_of_s;
    covvar_input_map('mt_f_of_s') = mt_f_of_s;
    covvar_input_map('fl_x_mean') = fl_x_mean;
    covvar_input_map('fl_x_sd') = fl_x_sd;
    covvar_input_map('fl_y_mean') = fl_y_mean;
    covvar_input_map('fl_y_sd') = fl_y_sd;    
    ff_container_map_display(covvar_input_map, 25, 15);

    covvar_output_map = containers.Map('KeyType','char', 'ValueType','any');
    covvar_output_map('mt_x_devi_from_mean') = mt_x_devi_from_mean;
    covvar_output_map('mt_y_devi_from_mean') = mt_y_devi_from_mean;
    covvar_output_map('mt_x_y_multiply') = mt_x_y_multiply;
    covvar_output_map('mt_cov_component_weighted') = mt_cov_component_weighted;

    ff_container_map_display(covvar_output_map, 25, 15);

    disp('fl_cov');
    disp(fl_cov_xy);

    disp('fl_cor');
    disp(fl_cor_xy);

end
end
