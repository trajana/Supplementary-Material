# Supplementary-Material

# Overview

This repository contains supplementary material for the term paper "Social Closeness in Asymmetric Coordination Games." The paper investigates how social closeness impacts coordination success by comparing interactions between friends and strangers in various coordination games. This repository includes datasets, Python scripts, Stata code files, and other relevant resources.

# Contents

1. Python_Code_CCG: The experiment was programmed using Python and oTree. This file contains the Python code. 
2. Dataset and Classification: Contains the data generated during the experiment, as well as the classifications of messages.
3. CCG_file_for_stata: The Stata data file used for statistical analysis in the study.
4. CCG_do_file_stata: The Stata DO file that contains all commands used for data cleaning, descriptive statistics, regression analysis, and hypothesis testing.

# Requirements

- Python: Version 3.7 or higher.
- Stata: Version 14 or higher for running the DO file.

# Usage

1. Python_Code_CCG: Run this script to replicate the data processing and classification procedures conducted during the experiment. Ensure that all required libraries are installed.
2. Dataset and Classification: This file contains all participant responses, decisions, and classification criteria.
3. CCG_file_for_stata: This file is the primary data input for Stata. Open it in Stata for further analysis.
4. CCG_do_file_stata: Execute this DO file in Stata to perform the statistical analysis. It includes data cleaning, summary statistics, non-parametric tests, and probit regressions. Before running the DO file in Stata, adjust the initial settings:
   - Set the overall directory path by modifying the line: cd "H:\Stata" to your own directory path.
   - Load the dataset by ensuring the correct file name in the command: sysuse CCG_file_for_stata.
