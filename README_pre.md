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
