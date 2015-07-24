---
title       : Course Project for Getting and Cleaning Data
---

## Introduction

This project operates on the data set from

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

and generates mean data for selected variables within that data set.

## Files

Included with this distribution are:

- This file
- run_analysis.R, the R source program
- CodeBook.md, listing the codes used
- tidy_data.txt, the output (this is stored on Coursera)

## Required Package

To run this project successfully, you will need to install the reshape2 package.  Please type
```
install.packages("reshape2")
```
at the R command-line prompt if you have already installed this package.

## What to do
- Make sure the reshape2 package is installed (see "Required Package, above")
- Download the raw data to a local directory (see "Introduction")
- move the file run_analysis.R into that local directory
- open R and set the working directory to that local directory
- at the R command-line prompt type
```
source("run_analysis.R")
```

### Output
The output, also provided precomputed in this package as "tidy_data.txt", provides averages for each of the original 66 variables that were means and standard deviations themselves, containing "mean()" and "std()", respectively.  These averages are calculated for each combination of the thirty subjects and six activity types.