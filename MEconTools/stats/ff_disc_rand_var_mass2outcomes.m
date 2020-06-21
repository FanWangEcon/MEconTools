%% FF_DISC_RAND_VAR_MASS2OUTCOMES Generate Discrete Random Variable
%    Given mass at state space points, and y, c, a, z and other outcomes or
%    other information at each corresponding state space points, generate
%    discrete random variable, with unique sorted values, and mass for each
%    unique sorted values. Also generate additional joint distributions: if
%    initial distribution is over f(a,z), generate joint distribution of
%    f(y,a) or f(y,z).
%
%    * ST_Y_NAME string of Y outcome/state given state-space
%    * MT_Y_OF_S matrix or array of y values at each s point
%    * MT_F_OF_S matrix or array probability mass at each s point
%
%    [AR_F_OF_Y, AR_Y_UNIQUE_SORTED] = FF_DISC_RAND_VAR_STATS(ST_Y_NAME,
%    MT_Y_OF_S, MT_F_OF_S) generates sort y array with associated mass, a
%    discrete random variable. MT_Y_OF_S and MT_F_OF_S must be matrixes
%    with multiple columns or a single column.
%
%    [AR_F_OF_Y, AR_Y_UNIQUE_SORTED, MT_F_OF_Y_SROW, MT_F_OF_Y_SCOL] =
%    FF_DISC_RAND_VAR_STATS(ST_Y_NAME, MT_Y_OF_S, MT_F_OF_S) generates
%    f(y), f(y,a) and f(y,z) given f(a,z) and y(a,z). To compute
%    conditional statistics, must provide matrix inputs.
%
%    [AR_F_OF_Y, AR_Y_UNIQUE_SORTED] = FF_DISC_RAND_VAR_STATS(ST_Y_NAME,
%    MT_Y_OF_S, MT_F_OF_S, BL_DISPLAY_DRVM2OUTCOMES) generates f(y), print
%    or not verbose details.
%
%    [AR_F_OF_Y, AR_Y_UNIQUE_SORTED] = FF_DISC_RAND_VAR_STATS(ST_Y_NAME,
%    MT_Y_OF_S, MT_F_OF_S, BL_DISPLAY_DRVM2OUTCOMES, BL_DRVM2OUTCOMES_VEC)
%    generates f(y), print or not verbose details, and vectorize code
%    generation.
%
%    See also FX_DISC_RAND_VAR_MASS2OUTCOMES
%

%%
function [ar_f_of_y, ar_y_unique_sorted, varargout] = ...
    ff_disc_rand_var_mass2outcomes(varargin)
%% FF_DISC_RAND_VAR_MASS2OUTCOMES find f(y) based on f(a,z), and y(a,z)
% Having derived f(a,z) the probability mass function of the joint discrete
% random variables, we now obtain distributional statistics. Note that we
% know f(a,z), and we also know relevant policy functions a'(a,z), c(a,z),
% or other policy functions. We can simulate any choices that are a
% function of the random variables (a,z), using f(a,z).
%
% The procedure here has these steps:
%
% # Sort [c(a,z), f(a,z)] by c(a,z)
% # Generate unique IDs of sorted c(a,z): unique
% # sum(f(a,z)|c) for each unique c(a,z): accumarray, this generates f(c)
% # calculate statistics based on f(c), the discrete distribution of c.
%
% Outputs are:
%
% * unique sorted outcomes, note different (a,z) can generate the same
% outcomes and not in order
% * find total probabiliy for p(outcome, a) = sum_{z}( 1{outcome(a,z)==outcome}*f(a,z))
%
% $$ p(y,a) = \sum_{z} \left(1\left\{Y(a,z)=y\right\} \cdot p(a,z) \right)$$
%
% * find total probabiliy for p(outcome, z) = sum_{a}( 1{outcome(a,z)==outcome}*f(a,z))
%
% $$ p(y,z) = \sum_{a} \left(1\left\{Y(a,z)=y\right\} \cdot p(a,z) \right)$$
%
% * find total probabiliy for p(outcome) = sum_{a,z}( 1{outcome(a,z)==outcome}*f(a,z) )
%
% $$ p(Y=y) = \sum_{a,z} \left( 1\left\{Y(a,z)=y\right\} \cdot p(a,z) \right)$$
%

%% Default
% use binomial as test case, z maps to binomial win prob, remember binom
% approximates normal.

if (~isempty(varargin))

    % if invoked from outside overrid fully
    [st_y_name, mt_y_of_s, mt_f_of_s] = varargin{:};
    
    if (length(varargin) == 3)        
        
        [st_y_name, mt_y_of_s, mt_f_of_s] = varargin{:};
        
        % do not print vectorize
        bl_display_drvm2outcomes = false;
        bl_drvm2outcomes_vec = true;
        
    elseif (length(varargin) == 4)
        
        [st_y_name, mt_y_of_s, mt_f_of_s, ...
            bl_display_drvm2outcomes] = varargin{:};
        
        % vectorize
        bl_drvm2outcomes_vec = true;
        
    elseif (length(varargin) == 5)
        
        [st_y_name, mt_y_of_s, mt_f_of_s, ...
            bl_display_drvm2outcomes, bl_drvm2outcomes_vec] = varargin{:};
        
    end
    
    % Parse Outputs
    bl_prob_byYZ = false;
    bl_prob_byYA = false;    
    nout = max(nargout, 1) - 2;
    if (nout == 1)
        bl_prob_byYA = true;
    elseif (nout == 2)
        bl_prob_byYA = true;
        bl_prob_byYZ = true;
    end    

else

    clear all;
    close all;

    it_states = 6;
    it_shocks = 5;
    fl_binom_n = it_states-1;
    ar_binom_p = (1:(it_shocks))./(it_shocks+2);
    ar_binom_x = (0:1:(it_states-1)) - 3;

    % a
    ar_y_unique_sorted = ar_binom_x;
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

    % y(a,z), some non-smooth structure
    rng(123);
    mt_y_of_s = ar_binom_x' - 0.01*ar_binom_x'.^2  + ar_binom_p - 0.5*ar_binom_p.^2 + rand([it_states, it_shocks]);
    mt_y_of_s = round(mt_y_of_s*2);

    % display
    st_y_name = 'binomtest';

    % display
    bl_display_drvm2outcomes = true;
    bl_drvm2outcomes_vec = true;
    
    % out conditional
    nout = 2;
    bl_prob_byYZ = true;
    bl_prob_byYA = true;
end

%% 1. Generate Y(a) and f(y) and f(y,a) and f(y,z)
% 1. Get Choice Matrix (choice or outcomes given choices)
% see end of
% <https://fanwangecon.github.io/CodeDynaAsset/m_az/solve/html/ff_az_vf_vecsv.html
% ff_az_vf_vecsv> outcomes in result_map are cells with two elements,
% first element is y(a,z), second element will be f(y) and y, generated
% here.
ar_choice_cur_bystates = mt_y_of_s(:);

%% 2. Sort and Generate Unique

ar_choice_bystates_sorted = sort(ar_choice_cur_bystates);
ar_y_unique_sorted = unique(ar_choice_bystates_sorted);

%% 3. Sum up Density at each element of ar_choice

ar_f_of_y = zeros([length(ar_y_unique_sorted),1]);
if (bl_prob_byYZ)
    mt_f_of_y_scol = zeros([length(ar_y_unique_sorted), size(mt_f_of_s,2)]);
end
if (bl_prob_byYA)
    mt_f_of_y_srow = zeros([length(ar_y_unique_sorted), size(mt_f_of_s,1)]);
end

if (~bl_drvm2outcomes_vec)

    %% 2. Looped solution

    for it_z_i = 1:size(mt_f_of_s,2)
        for it_a_j = 1:size(mt_f_of_s,1)

            % get f(a,z) and c(a,z)
            fl_mass_curstate = mt_f_of_s(it_a_j, it_z_i);
            fl_choice_cur = mt_y_of_s(it_a_j, it_z_i);

            % add f(a,z) to f(c(a,z))
            ar_choice_in_unique_idx = (ar_y_unique_sorted == fl_choice_cur);

            % add probability to p(y)
            ar_f_of_y(ar_choice_in_unique_idx) = ar_f_of_y(ar_choice_in_unique_idx) + fl_mass_curstate;

            % add probability to p(y,z)
            if (bl_prob_byYZ)
                mt_f_of_y_scol(ar_choice_in_unique_idx, it_z_i) = mt_f_of_y_scol(ar_choice_in_unique_idx, it_z_i) + fl_mass_curstate;
            end
            
            % add probability to p(y,a)
            if (bl_prob_byYA)
                mt_f_of_y_srow(ar_choice_in_unique_idx, it_a_j) = mt_f_of_y_srow(ar_choice_in_unique_idx, it_a_j) + fl_mass_curstate;
            end
        end
    end

else

    %% 3 Vectorized Solution

    % Generating Unique Index
    [~, ~, ar_idx_of_unique] = unique(mt_y_of_s(:));
    mt_idx_of_unique = reshape(ar_idx_of_unique, size(mt_y_of_s));

    %% 3.1 Vectorized solution for f(Y)

    ar_f_of_y = accumarray(ar_idx_of_unique, mt_f_of_s(:));

    %% 3.2 Vectorized solution for f(Y,z)
    
    if (bl_prob_byYZ)
        for it_z_i = 1:size(mt_f_of_s,2)

            % f(y,z) for one z
            ar_choice_prob_byY_curZ = accumarray(mt_idx_of_unique(:, it_z_i), mt_f_of_s(:, it_z_i), [length(ar_y_unique_sorted), 1]);
            % add probability to p(y,z)
            mt_f_of_y_scol(:, it_z_i) = ar_choice_prob_byY_curZ;

        end
    end
    
    %% 3.3 Vectorized solution for f(Y,a)
    
    if (bl_prob_byYA)
        for it_a_j = 1:size(mt_f_of_s,1)

            % f(y,z) for one z
            mt_choice_prob_byY_curA = accumarray(mt_idx_of_unique(it_a_j, :)', mt_f_of_s(it_a_j, :)', [length(ar_y_unique_sorted), 1]);
            % add probability to p(y,a)
            mt_f_of_y_srow(:, it_a_j) = mt_choice_prob_byY_curA;

        end
    end    
end

%% Out 

for k = 1:nout
    if (k==1)
        varargout{k} = mt_f_of_y_srow;
    end
    if (k==2)
        varargout{k} = mt_f_of_y_scol;
    end    
end

%% Display

if (bl_display_drvm2outcomes)

    disp('INPUT f(a,z): mt_dist_bystates');
    disp(mt_f_of_s);

    disp('INPUT y(a,z): mt_choice_bystates');
    disp(mt_y_of_s);

    disp('OUTPUT f(y): ar_choice_prob_byY');
    disp(ar_f_of_y);
    
    if (bl_prob_byYZ)
        disp('OUTPUT f(y,z): mt_choice_prob_byYZ');
        disp(mt_f_of_y_scol);
    end
    
    if (bl_prob_byYA)
        disp('OUTPUT f(y,a): mt_choice_prob_byYA');
        disp(mt_f_of_y_srow);
    end
    
    disp('OUTPUT f(y) and y in table: tb_choice_drv_cur_byY');
    tb_choice_drv_cur_byY = table(ar_y_unique_sorted, ar_f_of_y);
    tb_choice_drv_cur_byY.Properties.VariableNames = matlab.lang.makeValidName([string([char(st_y_name) ' outcomes']), 'prob mass function']);
    disp(tb_choice_drv_cur_byY);

end
end
