[![Star](https://img.shields.io/github/stars/fanwangecon/MEconTools?style=social)](https://github.com/FanWangEcon/MEconTools/stargazers) [![Fork](https://img.shields.io/github/forks/fanwangecon/MEconTools?style=social)](https://github.com/FanWangEcon/MEconTools/network/members) [![Star](https://img.shields.io/github/watchers/fanwangecon/MEconTools?style=social)](https://github.com/FanWangEcon/MEconTools/watchers) [![DOI](https://zenodo.org/badge/232354852.svg)](https://zenodo.org/badge/latestdoi/232354852)

This is a work-in-progress Matlab package consisting of functions that facilitate Dynamic Programming and Related Tasks. Materials gathered from various [projects](https://fanwangecon.github.io/research) in which Matlab code is used. Some of the solutions/algorithms are research outputs developed for specific research [papers](https://fanwangecon.github.io/research), other algorithms and methods are commonly-used. Files are the [MEconTools](https://github.com/FanWangEcon/MEconTools) repository. Matlab files are linked below by section with livescript files. Tested with [Matlab](https://www.mathworks.com/products/matlab.html) 2019a.

> Download and install the Matlab toolbox: [MEconTools.mltbx](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools.mltbx),
> Toolbox Vignette Manual: [**bookdown site**](https://fanwangecon.github.io/MEconTools/bookdown) and [**bookdown pdf**](https://fanwangecon.github.io/MEconTools/bookdown/Matlab-Toolbox-Heterogeneous-Agents-Dynamic-Programming.pdf).

Bullet points below show vignette files for functions that are available from [MEconTools](https://github.com/FanWangEcon/MEconTools). Each Vignette file contains various examples for invoking each function. The goal of this repository is to make it easier to find/re-use codes produced for various projects. The vignette files are also collected in the bookdown file:

From other repositories: For dynamic borrowing and savings problems, see [Dynamic Asset Repository](https://fanwangecon.github.io/CodeDynaAsset/); For code examples, see also [R Example Code](https://fanwangecon.github.io/R4Econ/), [Matlab Example Code](https://fanwangecon.github.io/M4Econ/), [Python Example Code](https://fanwangecon.github.io/Py4Econ/), and [Stata Example Code](https://fanwangecon.github.io/Stata4Econ/); For intro stat with R, see [Intro Statistics for Undergraduates](https://fanwangecon.github.io/Stat4Econ/), and intro Math with Matlab, see [Intro Mathematics for Economists](https://fanwangecon.github.io/Math4Econ/). See [here](https://github.com/FanWangEcon) for all of [Fan](https://fanwangecon.github.io/)'s public repositories.

Please contact [FanWangEcon](https://fanwangecon.github.io/) for issues or problems.

[![](https://img.shields.io/github/last-commit/fanwangecon/MEconTools)](https://github.com/FanWangEcon/MEconTools/commits/master) [![](https://img.shields.io/github/commit-activity/m/fanwangecon/MEconTools)](https://github.com/FanWangEcon/MEconTools/graphs/commit-activity) [![](https://img.shields.io/github/issues/fanwangecon/MEconTools)](https://github.com/FanWangEcon/MEconTools/issues) [![](https://img.shields.io/github/issues-pr/fanwangecon/MEconTools)](https://github.com/FanWangEcon/MEconTools/pulls)

# Installation

In addition to downloading and installing [MEconTools.mltbx](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools.mltbx), can also:

```
# Clone Package from Git Bash
cd "C:/Downloads"
git clone https://github.com/fanwangecon/MEconTools.git
```

Install the Package from inside Matlab:

```
# Install Matlab Toolbox MEconTools
toolboxFile = 'C:/Downloads/MEconTools/MEconTools.mltbx';
# toolboxFile = 'C:/Users/fan/MEconTools/MEconTools.mltbx';
agreeToLicense = true;
installedToolbox = matlab.addons.toolbox.installToolbox(toolboxFile, agreeToLicense)
```

# 1  Savings Dynamic Programming

1. [Looped Grid Infinite Horizon Dynamic Savings Problem](https://fanwangecon.github.io/MEconTools/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_loop.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/fx_vfi_az_loop.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_loop.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_loop.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_loop.html)
	+ Infinite horizon constrained dynamic savings problem with persistent shock.
	+ The state-space and choice-space share the same asset grid.
	+ Looped algorithm, slow but easy to modify, useful for developing new models.
	+ **MEconTools**: *[ff_vfi_az_loop()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_loop.m)*
2. [Vectorized Grid Infinite Horizon Dynamic Savings Problem](https://fanwangecon.github.io/MEconTools/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_vec.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/fx_vfi_az_vec.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_vec.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_vec.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_vec.html)
	+ Vectorized version of [ff_vfi_az_loop()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_loop.m), fast and sufficiently approximate value(a,z), but choices not precise.
	+ Broadcast and vectorized evaluation and maximization.
	+ Solve u(c) once, and retrieve with cell arrays.
	+ **MEconTools**: *[ff_vfi_az_vec()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_vec.m)*
3. [Looped Exact FOC Infinite Horizon Dynamic Savings Problem](https://fanwangecon.github.io/MEconTools/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_bisec_loop.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/fx_vfi_az_bisec_loop.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_bisec_loop.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_bisec_loop.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_bisec_loop.html)
	+ Infinite horizon constrained dynamic savings problem with persistent shock.
	+ The state-space is on a grid, the choice space are continuous percentages of cash-on-hand.
	+ Looped exact savings-percentage algorithm, slow but high precision at low grid size.
	+ Solves for EV(ap,z) given shock state and for a savings choice. Bisection based on FOC with analytical du(c(ap))/dap and spline slopes dEV(ap,z)/dap.
	+ **MEconTools**: *[ff_vfi_az_bisec_loop()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_bisec_loop.m) + [ff_optim_bisec_savezrone()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/optim/ff_optim_bisec_savezrone.m)*
4. [Vectorized Exact FOC Infinite Horizon Dynamic Savings Problem](https://fanwangecon.github.io/MEconTools/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_bisec_vec.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/fx_vfi_az_bisec_vec.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_bisec_vec.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_bisec_vec.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_bisec_vec.html)
	+ Vectorized version of [ff_vfi_az_bisec_loop()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_bisec_loop.m) exact savings-percentage algorithm, high precision and high speed.
	+ **MEconTools**: *[ff_vfi_az_bisec_vec()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_bisec_vec.m) + [ff_optim_bisec_savezrone()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/optim/ff_optim_bisec_savezrone.m)*
5. [Looped Exact Value Infinite Horizon Dynamic Savings Problem](https://fanwangecon.github.io/MEconTools/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_mzoom_loop.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/fx_vfi_az_mzoom_loop.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_mzoom_loop.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_mzoom_loop.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_mzoom_loop.html)
	+ Looped infinite horizon constrained dynamic savings problem with persistent shock.
	+ The state-space is on a grid, the choice space are continuous percentages of cash-on-hand.
	+ Evaluate value at choice grid iteratively by zooming-in to construct finer savings percentages.
	+ **MEconTools**: *[ff_vfi_az_mzoom_loop()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_mzoom_loop.m) + [ff_optim_mzoom_savezrone()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/optim/ff_optim_mzoom_savezrone.m)*
6. [Vectorized Exact Value Infinite Horizon Dynamic Savings Problem](https://fanwangecon.github.io/MEconTools/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_mzoom_vec.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/fx_vfi_az_mzoom_vec.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_mzoom_vec.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_mzoom_vec.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/vfi/htmlpdfm/fx_vfi_az_mzoom_vec.html)
	+ Vectorized version of [ff_vfi_az_mzoom_loop()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_mzoom_loop.m) exact savings-percentage algorithm.
	+ **MEconTools**: *[ff_vfi_az_mzoom_vec()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/vfi/ff_vfi_az_mzoom_vec.m) + [ff_optim_mzoom_savezrone()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/optim/ff_optim_mzoom_savezrone.m)*

# 2  Stationary Distribution

1. [Looped Grid Stationary Distribution Dynamic Savings Problem](https://fanwangecon.github.io/MEconTools/MEconTools/doc/ds/htmlpdfm/fx_ds_az_loop.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/ds/fx_ds_az_loop.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/ds/htmlpdfm/fx_ds_az_loop.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/ds/htmlpdfm/fx_ds_az_loop.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/ds/htmlpdfm/fx_ds_az_loop.html)
	+ Stationary distribution for infinite horizon constrained dynamic savings problem with persistent shock.
	+ The state-space and choice-space share the same asset grid.
	+ Looped algorithm.
	+ **MEconTools**: *[ff_ds_az_loop()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/ds/ff_ds_az_loop.m)*
2. [Looped Exact Stationary Distribution Dynamic Savings Problem](https://fanwangecon.github.io/MEconTools/MEconTools/doc/ds/htmlpdfm/fx_ds_az_cts_loop.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/ds/fx_ds_az_cts_loop.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/ds/htmlpdfm/fx_ds_az_cts_loop.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/ds/htmlpdfm/fx_ds_az_cts_loop.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/ds/htmlpdfm/fx_ds_az_cts_loop.html)
	+ Stationary distribution for infinite horizon constrained dynamic savings problem with persistent shock.
	+ The state-space is on a grid, the choice space are continuous percentages of cash-on-hand.
	+ Looped algorithm.
	+ **MEconTools**: *[ff_ds_az_cts_loop()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/ds/ff_ds_az_cts_loop.m)*
3. [Vectorized Exact Stationary Distribution Dynamic Savings Problem](https://fanwangecon.github.io/MEconTools/MEconTools/doc/ds/htmlpdfm/fx_ds_az_cts_vec.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/ds/fx_ds_az_cts_vec.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/ds/htmlpdfm/fx_ds_az_cts_vec.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/ds/htmlpdfm/fx_ds_az_cts_vec.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/ds/htmlpdfm/fx_ds_az_cts_vec.html)
	+ This is the vectorized version of [ff_ds_az_cts_loop()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/ds/ff_ds_az_cts_loop.m).
	+ **MEconTools**: *[ff_ds_az_cts_vec(8)](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/ds/ff_ds_az_cts_vec.m)*

# 3  Summarize Policy and Value

1. [Summarize ND Array Policy and Value Functions](https://fanwangecon.github.io/MEconTools/MEconTools/doc/summ/htmlpdfm/fx_summ_nd_array.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/summ/fx_summ_nd_array.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/summ/htmlpdfm/fx_summ_nd_array.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/summ/htmlpdfm/fx_summ_nd_array.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/summ/htmlpdfm/fx_summ_nd_array.html)
	+ Given an NDarray matrix with N1, N2, ..., ND dimensions. Generate average and standard deviation for the 3rd dimension, grouping by the other dimensions.
	+ For example, show the 5th dimension as the column groups, and the other variables generate combinations shown as rows.
	+ The resulting summary statistics table contains mean and standard deviation among other statistics over the policy or value contained in the ND array.
	+ **MEconTools**: *[ff_summ_nd_array()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/summ/ff_summ_nd_array.m)*

# 4  Distributional Analysis

1. [Gateway Joint Probability Mass Statistics](https://fanwangecon.github.io/MEconTools/MEconTools/doc/stats/htmlpdfm/fx_simu_stats.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/fx_simu_stats.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/htmlpdfm/fx_simu_stats.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/htmlpdfm/fx_simu_stats.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/stats/htmlpdfm/fx_simu_stats.html)
	+ Given model policy functions and stationary distribution, compute distributional statistics.
	+ Given discrete probability mass function f(s), and information y(s), x(s), z(s) at each element of the state-space, compute statistics for each variable, y, x, z, which are all discrete random variables.
	+ Compute correlation and covariance betwen input discrete random variables.
	+ **MEconTools**: *[ff_simu_stats()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/stats/ff_simu_stats.m)*
2. [Discrete Random Variable Distributional Statistics](https://fanwangecon.github.io/MEconTools/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_stats.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/fx_disc_rand_var_stats.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_stats.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_stats.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_stats.html)
	+ Model simulation generates discrete random variables, calculate mean, standard deviation, min, max, percentiles, and proportion of outcomes held by x percentiles, etc.
	+ **MEconTools**: *[ff_disc_rand_var_stats()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/stats/ff_disc_rand_var_stats.m)*
3. [Generate Discrete Random Variable](https://fanwangecon.github.io/MEconTools/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_mass2outcomes.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/fx_disc_rand_var_mass2outcomes.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_mass2outcomes.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_mass2outcomes.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_mass2outcomes.html)
	+ Given mass at state space points, and y, c, a, z and other outcomes or other information at each corresponding state space points, generate discrete random variable, with unique sorted values, and mass for each unique sorted values.
	+ Generate additional joint distributions: if initial distribution is over f(a,z), generate joint distribution of f(y,a) or f(y,z).
	+ **MEconTools**: *[ff_disc_rand_var_mass2outcomes()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/stats/ff_disc_rand_var_mass2outcomes.m)*
4. [Discrete Random Variable Correlation and Covariance](https://fanwangecon.github.io/MEconTools/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_mass2covcor.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/fx_disc_rand_var_mass2covcor.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_mass2covcor.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_mass2covcor.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/stats/htmlpdfm/fx_disc_rand_var_mass2covcor.html)
	+ Given probability mass function f(s), X(s), and Y(s), compute the covariance and correlation betwen X and Y.
	+ **MEconTools**: *[ff_disc_rand_var_mass2covcor()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/stats/ff_disc_rand_var_mass2covcor.m)*

# 5  Optimizers

1. [Bisection Exact Optimal Savings Share Multiple States](https://fanwangecon.github.io/MEconTools/MEconTools/doc/optim/htmlpdfm/fx_optim_bisec_savezrone.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/optim/fx_optim_bisec_savezrone.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/optim/htmlpdfm/fx_optim_bisec_savezrone.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/optim/htmlpdfm/fx_optim_bisec_savezrone.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/optim/htmlpdfm/fx_optim_bisec_savezrone.html)
	+ Given a First Order Condition function handle that takes the fraction of resources (cash-on-hand) saved as the input, solve for the optimal savings fraction via bisection. Solve this concurrently for many elements of the state-space. The function handle contains the FOC with parameters and state-space elements embeded.
	+ **MEconTools**: *[ff_optim_bisec_savezrone()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/optim/ff_optim_bisec_savezrone.m)*
2. [Multisection Exact Optimal Savings Share Multiple States](https://fanwangecon.github.io/MEconTools/MEconTools/doc/optim/htmlpdfm/fx_optim_mlsec_savezrone.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/optim/fx_optim_mlsec_savezrone.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/optim/htmlpdfm/fx_optim_mlsec_savezrone.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/optim/htmlpdfm/fx_optim_mlsec_savezrone.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/optim/htmlpdfm/fx_optim_mlsec_savezrone.html)
	+ Given a First Order Condition function handle that takes the fraction of resources (cash-on-hand) saved as the input, solve for the optimal savings fraction via multisection where there are multiple evaluations per iteration of the FOC. Solve this concurrently for many elements of the state-space. The function handle contains the FOC with parameters and state-space elements embeded.
	+ **MEconTools**: *[ff_optim_mlsec_savezrone()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/optim/ff_optim_mlsec_savezrone.m)*
3. [Vectorized Zooming Exact Optimal Savings Share Multiple States](https://fanwangecon.github.io/MEconTools/MEconTools/doc/optim/htmlpdfm/fx_optim_mzoom_savezrone.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/optim/fx_optim_mzoom_savezrone.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/optim/htmlpdfm/fx_optim_mzoom_savezrone.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/optim/htmlpdfm/fx_optim_mzoom_savezrone.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/optim/htmlpdfm/fx_optim_mzoom_savezrone.html)
	+ Given a Utility (not FOC) function handle that takes the fraction of resources (cash-on-hand) saved as the input, solve for the optimal savings fraction via iterative zooming where there are multiple evaluations per iteration of the utility function. Solve this concurrently for many elements of the state-space. The function handle contains the utilty function with parameters and state-space elements embeded.
	+ **MEconTools**: *[ff_optim_mzoom_savezrone()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/optim/ff_optim_mzoom_savezrone.m)*

# 6  Graphs

1. [Multiple Line Graph Function](https://fanwangecon.github.io/MEconTools/MEconTools/doc/graph/htmlpdfm/fx_graph_grid.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/graph/fx_graph_grid.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/graph/htmlpdfm/fx_graph_grid.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/graph/htmlpdfm/fx_graph_grid.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/graph/htmlpdfm/fx_graph_grid.html)
	+ Policy and Value Function graphs, x-axis one state, color another state, y-axis are value and policies.
	+ Distributional graphs, x-axis one state, y-axis and color another state, size show distributional mass.
	+ **MEconTools**: *[ff_graph_grid()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/graph/ff_graph_grid.m)*

# 7  Support Tools

1. [Organizes and Prints Container Map Key and Values](https://fanwangecon.github.io/MEconTools/MEconTools/doc/tools/htmlpdfm/fx_container_map_display.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/tools/fx_container_map_display.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/tools/htmlpdfm/fx_container_map_display.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/tools/htmlpdfm/fx_container_map_display.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/tools/htmlpdfm/fx_container_map_display.html)
	+ Summarizes the contents of a map container by data types. Includes, scalar, array, matrix, string, functions, tensors (3-tuples), tesseracts (4-tuples).
	+ **MEconTools**: *[ff_container_map_display()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/tools/ff_container_map_display.m)*

# 8  Data Structures

1. [Log and Power Spaced Asset and Choice Grids](https://fanwangecon.github.io/MEconTools/MEconTools/doc/generate/htmlpdfm/fx_saveborr_grid.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/generate/fx_saveborr_grid.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/generate/htmlpdfm/fx_saveborr_grid.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/generate/htmlpdfm/fx_saveborr_grid.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/generate/htmlpdfm/fx_saveborr_grid.html)
	+ Generate linear, log-space, power-space, or threshold-cut asset or choice grids.
	+ **MEconTools**: *[ff_saveborr_grid()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/generate/ff_saveborr_grid.m)*
2. [Randomly Perturb Some Parameter Value with Varying Magnitudes](https://fanwangecon.github.io/MEconTools/MEconTools/doc/generate/htmlpdfm/fx_perturb_logn.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/generate/fx_perturb_logn.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/generate/htmlpdfm/fx_perturb_logn.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/generate/htmlpdfm/fx_perturb_logn.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/generate/htmlpdfm/fx_perturb_logn.html)
	+ There is a starting estimation parameter value, perturb this initial starting points. Use a scalar so that 0 means almost no change, and 1 means maximum change to control how much to perturb the parameter. This is used for multi-start estimation
	+ **MEconTools**: *[ff_perturb_logn()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/generate/ff_perturb_logn.m)*
3. [Find Real-valued Domain of a Function](https://fanwangecon.github.io/MEconTools/MEconTools/doc/generate/htmlpdfm/fx_nonimg_posnegbd.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/generate/fx_nonimg_posnegbd.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/generate/htmlpdfm/fx_nonimg_posnegbd.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/generate/htmlpdfm/fx_nonimg_posnegbd.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/generate/htmlpdfm/fx_nonimg_posnegbd.html)
	+ Checks for valid domain for function that generates real-valued outcomes, and identifies values along the domain that generates positive and negative Values.
	+ **MEconTools**: *[ff_nonimg_posnegbd()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/generate/ff_nonimg_posnegbd.m)*

# 9  Common Functions

1. [Discretize AR1 Normal Shock Tauchen (1986)](https://fanwangecon.github.io/MEconTools/MEconTools/doc/external/htmlpdfm/fxy_tauchen.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/external/fxy_tauchen.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/external/htmlpdfm/fxy_tauchen.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/external/htmlpdfm/fxy_tauchen.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/external/htmlpdfm/fxy_tauchen.html)
	+ Mean zero AR(1) shock discretize following Tauchen (1986).
	+ **MEconTools**: *[ffy_tauchen()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/external/stats/ffy_tauchen.m)*
2. [Discretize AR1 Normal Shock Rouwenhorst (1995)](https://fanwangecon.github.io/MEconTools/MEconTools/doc/external/htmlpdfm/fxy_rouwenhorst.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/external/fxy_rouwenhorst.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/external/htmlpdfm/fxy_rouwenhorst.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/external/htmlpdfm/fxy_rouwenhorst.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/external/htmlpdfm/fxy_rouwenhorst.html)
	+ Mean zero AR(1) shock discretize following Rouwenhorst (1995).
	+ **MEconTools**: *[ffy_rouwenhorst()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/external/stats/ffy_rouwenhorst.m)*

# 10  System

1. [Search and Find File Names](https://fanwangecon.github.io/MEconTools/MEconTools/doc/sys/htmlpdfm/fx_find_files.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/sys/fx_find_files.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/sys/htmlpdfm/fx_find_files.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/sys/htmlpdfm/fx_find_files.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/sys/htmlpdfm/fx_find_files.html)
	+ Search and find file names.
	+ **MEconTools**: *[ff_find_files()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/sys/ff_find_files.m)*
2. [Execute and Export Livescript Files](https://fanwangecon.github.io/MEconTools/MEconTools/doc/sys/htmlpdfm/fx_mlx2htmlpdf_runandexport.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/sys/fx_mlx2htmlpdf_runandexport.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/sys/htmlpdfm/fx_mlx2htmlpdf_runandexport.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/sys/htmlpdfm/fx_mlx2htmlpdf_runandexport.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/sys/htmlpdfm/fx_mlx2htmlpdf_runandexport.html)
	+ Find livescript (mlx) files, execute MLX files, and export MLX files to HTML in a different folder.
	+ **MEconTools**: *[ff_mlx2htmlpdf_runandexport()](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/sys/ff_mlx2htmlpdf_runandexport.m)*

----
Please contact [![](https://img.shields.io/github/followers/fanwangecon?label=FanWangEcon&style=social)](https://github.com/FanWangEcon) [![](https://img.shields.io/twitter/follow/fanwangecon?label=%20&style=social)](https://twitter.com/fanwangecon) for issues or problems.

[![DOI](https://zenodo.org/badge/232354852.svg)](https://zenodo.org/badge/latestdoi/232354852)

![RepoSize](https://img.shields.io/github/repo-size/fanwangecon/MEconTools)
![CodeSize](https://img.shields.io/github/languages/code-size/fanwangecon/MEconTools)
![Language](https://img.shields.io/github/languages/top/fanwangecon/MEconTools)
![Release](https://img.shields.io/github/downloads/fanwangecon/MEconTools/total)
![License](https://img.shields.io/github/license/fanwangecon/MEconTools)

