[![HitCount](http://hits.dwyl.io/fanwangecon/MEconTools.svg)](https://github.com/FanWangEcon/MEconTools)  [![Star](https://img.shields.io/github/stars/fanwangecon/MEconTools?style=social)](https://github.com/FanWangEcon/MEconTools/stargazers) [![Fork](https://img.shields.io/github/forks/fanwangecon/MEconTools?style=social)](https://github.com/FanWangEcon/MEconTools/network/members) [![Star](https://img.shields.io/github/watchers/fanwangecon/MEconTools?style=social)](https://github.com/FanWangEcon/MEconTools/watchers)

This is a work-in-progress Matlab package consisting of functions that facilitate Dynamic Programming and Related Tasks. Materials gathered from various [projects](https://fanwangecon.github.io/research) in which Matlab code is used. Files are the [MEconTools](https://github.com/FanWangEcon/MEconTools) repository. Matlab files are linked below by section with livescript files. Tested with [Matlab](https://www.mathworks.com/products/matlab.html) 2019a.

> Download and install the Matlabtool: [MEconTools.mltbx](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools.mltbx)
> Toolbox Vignette Manual: [**bookdown site**](https://fanwangecon.github.io/MEconTools/bookdown) and [**bookdown pdf**](https://fanwangecon.github.io/MEconTools/bookdown/Data-Structures-and-Dynamic-Optimization-with-Matlab.pdf).

Bullet points below show vignette files for functions that are available from [MEconTools](https://github.com/FanWangEcon/MEconTools). Each Vignette file contains various examples for invoking each function. The goal of this repository is to make it easier to find/re-use codes produced for various projects. The vignette files are also collected in the bookdown file:

From other repositories: For dynamic borrowing and savings problems, see [Dynamic Asset Repository](https://fanwangecon.github.io/CodeDynaAsset/); For code examples, see also [R Example Code](https://fanwangecon.github.io/R4Econ/), [Matlab Example Code](https://fanwangecon.github.io/M4Econ/), and [Stata Example Code](https://fanwangecon.github.io/Stata4Econ/); For intro stat with R, see [Intro Statistics for Undergraduates](https://fanwangecon.github.io/Stat4Econ/), and intro Math with Matlab, see [Intro Mathematics for Economists](https://fanwangecon.github.io/Math4Econ/). See [here](https://github.com/FanWangEcon) for all of [Fan](https://fanwangecon.github.io/)'s public repositories.

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

# 1  Summarize Policy and Value

1. [Summarize ND Array Policy and Value Functions](https://fanwangecon.github.io/MEconTools/MEconTools/doc/summ/htmlpdfm/fx_summ_nd_array.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/summ/fx_summ_nd_array.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/summ/htmlpdfm/fx_summ_nd_array.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/summ/htmlpdfm/fx_summ_nd_array.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/summ/htmlpdfm/fx_summ_nd_array.html)
	+ Given an NDarray matrix with N1, N2, ..., ND dimensions. Generate average and standard deviation for the 3rd dimension, grouping by the other dimensions.
	+ For example, show the 5th dimension as the column groups, and the other variables generate combinations shown as rows.
	+ The resulting summary statistics table contains mean and standard deviation among other statistics over the policy or value contained in the ND array.
	+ **MEconTools**: *ff_summ_nd_array()*

# 2  Distributional Analysis

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

# 3  Graphs

1. [Multiple Line Graph Function](https://fanwangecon.github.io/MEconTools/MEconTools/doc/graph/htmlpdfm/fx_graph_grid.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/graph/fx_graph_grid.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/graph/htmlpdfm/fx_graph_grid.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/graph/htmlpdfm/fx_graph_grid.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/graph/htmlpdfm/fx_graph_grid.html)
	+ Grid based Graph, x-axis one param, color another param, over outcomes.
	+ **MEconTools**: *ff_graph_grid()*

# 4  Support Tools

1. [Organizes and Prints Container Map Key and Values](https://fanwangecon.github.io/MEconTools/MEconTools/doc/tools/htmlpdfm/fx_container_map_display.html): [**mlx**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/tools/fx_container_map_display.mlx) \| [**m**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/tools/htmlpdfm/fx_container_map_display.m) \| [**pdf**](https://github.com/FanWangEcon/MEconTools/blob/master/MEconTools/doc/tools/htmlpdfm/fx_container_map_display.pdf) \| [**html**](https://fanwangecon.github.io/MEconTools/MEconTools/doc/tools/htmlpdfm/fx_container_map_display.html)
	+ Summarizes the contents of a map container by data types. Includes, scalar, array, matrix, string, functions, tensors (3-tuples), tesseracts (4-tuples).
	+ **MEconTools**: *ff_container_map_display()*

----
Please contact [![](https://img.shields.io/github/followers/fanwangecon?label=FanWangEcon&style=social)](https://github.com/FanWangEcon) [![](https://img.shields.io/twitter/follow/fanwangecon?label=%20&style=social)](https://twitter.com/fanwangecon) for issues or problems.

![RepoSize](https://img.shields.io/github/repo-size/fanwangecon/MEconTools)
![CodeSize](https://img.shields.io/github/languages/code-size/fanwangecon/MEconTools)
![Language](https://img.shields.io/github/languages/top/fanwangecon/MEconTools)
![Release](https://img.shields.io/github/downloads/fanwangecon/MEconTools/total)
![License](https://img.shields.io/github/license/fanwangecon/MEconTools)

