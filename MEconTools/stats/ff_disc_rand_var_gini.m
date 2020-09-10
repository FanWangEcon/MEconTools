%% FF_DISC_RAND_VAR_GINI Gini Index for Discrete Random Variable
%    Gini index for discrete random variable. Think about width and height.
%    There is a box width = 1, and height = 1. The area below 45 degree
%    line is 1/2. Imagine the height (=1) is equal to the aggreagte wealth
%    (income or other variables) in the economy, which we normalized to 1.
%    We can think about that 1 been composed of the wealth (income etc) of
%    each type of individual in the economy, with the probability mass
%    associated with that individual type, and the wealth (income etc) of
%    that type. 
%
%    Furthermore, along the x-axis, think of the total width of 1 as the
%    total probability of all types. Given M types, sorting from the least
%    to theh most wealthy, we assign different width segment to each type,
%    depending on the P(M) for each type. 
%
%    As we proceeding in ascending order of wealth along the x-axis,
%    compute the weighted (and normalized) cumulative sum of wealth by this
%    point. 
%
%    We have a curve stretching from 0,0 to 1,1. If the curve is linear,
%    its area is equal to 1/2, and we have perfect equality. The Gini index
%    compute the total area below this curve relative to 1/2.
%
%    [FL_GINI_INDEX] = FF_DISC_RAND_VAR_GINI(AR_CHOICE_UNIQUE_SORTED,
%    AR_CHOICE_PROB)
%
%    See also FX_DISC_RAND_VAR_GINI
%

%%
function [fl_gini_index] = ff_disc_rand_var_gini(varargin)

%% Parse Main Inputs and Set Defaults

% parse inputs
if (~isempty(varargin))
   
    if (length(varargin) == 2)
        [ar_choice_unique_sorted, ar_choice_prob] = varargin{:};
    end
   
else 
    
    fl_binom_n = 20;
    fl_binom_p = 0.01;
    ar_binom_x = 0:1:fl_binom_n;
    ar_choice_prob_a = binopdf(ar_binom_x, fl_binom_n, fl_binom_p);
    
    fl_binom_n = 20;
    fl_binom_p = 0.99;
    ar_binom_x = 0:1:fl_binom_n;
    ar_choice_prob_b = binopdf(ar_binom_x, fl_binom_n, fl_binom_p);
    
    ar_choice_prob = (ar_choice_prob_a + ar_choice_prob_b);
    ar_choice_prob = ar_choice_prob/sum(ar_choice_prob);
    
    % x
    ar_choice_unique_sorted = ar_binom_x;
       
end

%% Compute the gini index

% 1. to normalize, get mean
fl_mean = sum(ar_choice_unique_sorted.*ar_choice_prob);

% 2. get cumulative mean at each point
ar_mean_cumsum = cumsum(ar_choice_unique_sorted.*ar_choice_prob);

% 3. Share of wealth (income etc) accounted for up to this sorted type
ar_height = ar_mean_cumsum./fl_mean;

% 4. The total area, is the each height times each width summed up
fl_area_drm = sum(ar_choice_prob.*ar_height);

% 5. area below 45 degree line might not be 1/2, depends on discretness
fl_area_below45 = sum(ar_choice_prob.*(cumsum(ar_choice_prob)./sum(ar_choice_prob)));

% 5. Gini is the distance betwe
fl_gini_index = (fl_area_below45-fl_area_drm)/fl_area_below45;

end
