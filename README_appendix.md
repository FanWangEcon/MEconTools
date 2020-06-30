# (APPENDIX) Appendix {-}

# Index and Code Links

## Savings Dynamic Programming links

1. [Looped Solution for Infinite Horizon Optimal Savings Dynamic Programming Problem](https://fanwangecon.github.io/MEconTools/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_loop.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/fx_vfi_az_loop.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_loop.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_loop.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_loop.html)
	+ Slow looped solution.
	+ Given preferences, some AR(1) shock process, solve the infinite horizon household savings dynamic programming problem. The state-space and choice-space share the same asset grid.
	+ **MEconTools**: *ff_vfi_az_loop()*
2. [Vectorized Solution for Infinite Horizon Optimal Savings Dynamic Programming Problem](https://fanwangecon.github.io/MEconTools/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_vec.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/fx_vfi_az_vec.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_vec.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_vec.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_vec.html)
	+ Faster vectorized solution.
	+ Given preferences, some AR(1) shock process, solve the infinite horizon household savings dynamic programming problem. The state-space and choice-space share the same asset grid.
	+ **MEconTools**: *ff_vfi_az_vec()*

## Summarize Policy and Value links

1. [Summarize ND Array Policy and Value Functions](https://fanwangecon.github.io/MEconTools/MEconTools/doc/summ/htmlpdfm/fx_summ_nd_array.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/summ/fx_summ_nd_array.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/summ/htmlpdfm/fx_summ_nd_array.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/summ/htmlpdfm/fx_summ_nd_array.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/summ/htmlpdfm/fx_summ_nd_array.html)
	+ Given an NDarray matrix with N1, N2, ..., ND dimensions. Generate average and standard deviation for the 3rd dimension, grouping by the other dimensions.
	+ For example, show the 5th dimension as the column groups, and the other variables generate combinations shown as rows.
	+ The resulting summary statistics table contains mean and standard deviation among other statistics over the policy or value contained in the ND array.
	+ **MEconTools**: *ff_summ_nd_array()*

## Distributional Analysis links

1. [Gateway Joint Probability Mass Statistics](https://fanwangecon.github.io/MEconTools/MEconTools/doc/stats/htmlpdfm/fx_simu_stats.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/fx_simu_stats.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/htmlpdfm/fx_simu_stats.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/htmlpdfm/fx_simu_stats.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/stats/htmlpdfm/fx_simu_stats.html)
	+ Given probability mass function f(s), and information y(s), x(s), z(s) at each element of the state-space, compute statistics for each variable, y, x, z, which are all discrete random variables.
	+ Compute their correlation and covariance.
	+ **MEconTools**: *ff_simu_stats()*
2. [Discrete Random Variable Distributional Statistics](https://fanwangecon.github.io/MEconTools/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_stats.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/fx_disc_rand_var_stats.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_stats.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_stats.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_stats.html)
	+ Model simulation generates discrete random variables, calculate mean, standard deviation, min, max, percentiles, and proportion of outcomes held by x percentiles, etc.
	+ **MEconTools**: *ff_disc_rand_var_stats()*
3. [Generate Discrete Random Variable](https://fanwangecon.github.io/MEconTools/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_mass2outcomes.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/fx_disc_rand_var_mass2outcomes.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_mass2outcomes.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_mass2outcomes.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_mass2outcomes.html)
	+ Given mass at state space points, and y, c, a, z and other outcomes or other information at each corresponding state space points, generate discrete random variable, with unique sorted values, and mass for each unique sorted values.
	+ Generate additional joint distributions: if initial distribution is over f(a,z), generate joint distribution of f(y,a) or f(y,z).
	+ **MEconTools**: *ff_disc_rand_var_mass2outcomes()*
4. [Discrete Random Variable Correlation and Covariance](https://fanwangecon.github.io/MEconTools/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_mass2covcor.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/fx_disc_rand_var_mass2covcor.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_mass2covcor.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_mass2covcor.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_mass2covcor.html)
	+ Given probability mass function f(s), X(s), and Y(s), compute the covariance and correlation betwen X and Y.
	+ **MEconTools**: *ff_disc_rand_var_mass2covcor()*

## Graphs links

1. [Multiple Line Graph Function](https://fanwangecon.github.io/MEconTools/MEconTools/doc/graph/htmlpdfm/fx_graph_grid.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/graph/fx_graph_grid.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/graph/htmlpdfm/fx_graph_grid.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/graph/htmlpdfm/fx_graph_grid.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/graph/htmlpdfm/fx_graph_grid.html)
	+ Grid based Graph, x-axis one param, color another param, over outcomes.
	+ **MEconTools**: *ff_graph_grid()*

## Data Structures links

1. [Log and Power Spaced Asset and Choice Grids](https://fanwangecon.github.io/MEconTools/MEconTools/doc/generate/htmlpdfm/fx_saveborr_grid.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/generate/fx_saveborr_grid.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/generate/htmlpdfm/fx_saveborr_grid.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/generate/htmlpdfm/fx_saveborr_grid.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/generate/htmlpdfm/fx_saveborr_grid.html)
	+ Generate linear, log-space, power-space, or threshold-cut asset or choice grids.
	+ **MEconTools**: *ff_saveborr_grid()*

## Common Functions links

1. [Discretize AR1 Normal Shock Tauchen (1986)](https://fanwangecon.github.io/MEconTools/MEconTools/doc/external/htmlpdfm/fxy_tauchen.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/external/fxy_tauchen.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/external/htmlpdfm/fxy_tauchen.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/external/htmlpdfm/fxy_tauchen.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/external/htmlpdfm/fxy_tauchen.html)
	+ Mean zero AR(1) shock discretize following Tauchen (1986).
	+ **MEconTools**: *ffy_tauchen()*
2. [Discretize AR1 Normal Shock Rouwenhorst (1995)](https://fanwangecon.github.io/MEconTools/MEconTools/doc/external/htmlpdfm/fxy_rouwenhorst.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/external/fxy_rouwenhorst.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/external/htmlpdfm/fxy_rouwenhorst.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/external/htmlpdfm/fxy_rouwenhorst.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/external/htmlpdfm/fxy_rouwenhorst.html)
	+ Mean zero AR(1) shock discretize following Rouwenhorst (1995).
	+ **MEconTools**: *ffy_rouwenhorst()*

## Support Tools links

1. [Organizes and Prints Container Map Key and Values](https://fanwangecon.github.io/MEconTools/MEconTools/doc/tools/htmlpdfm/fx_container_map_display.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/tools/fx_container_map_display.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/tools/htmlpdfm/fx_container_map_display.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/tools/htmlpdfm/fx_container_map_display.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/tools/htmlpdfm/fx_container_map_display.html)
	+ Summarizes the contents of a map container by data types. Includes, scalar, array, matrix, string, functions, tensors (3-tuples), tesseracts (4-tuples).
	+ **MEconTools**: *ff_container_map_display()*
