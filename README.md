# Air raids on the UK: understanding the effect of time on casualties

## Overview
This repository contains code, data, and supplementary materials for the paper "Air raids on the UK: understanding the effect of time on casualties".  
This paper analyzes data on air raids conducted by Germany on Britain during WW2 to understand what variables, namely time, affected the incidence of casualties during air raid incidents. 

## File Structure 

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from tacookson's GitHub repository.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models. 
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.

## Prerequisites for project replication OR to look over the process:
- Programming Language: R
  -- Version 4.4.2 or later
  -- Recommended: use R Studio
- ~3GB of free space
- Follow instructions in the preamble
  -- Download R packages listed as prerequisites in the project files
  -- run the indicated prerequisite files before running the current file 

## Statement on LLM usage

Aspects of the code were written with the help of the auto-complete tool, GPT-4. The datasheet and parts of the analysis was written with the help of GPT-4 and the entire chat history is available in inputs/llms/usage.txt.

## Citation
If you would like to cite this paper, please cite:

@Manual{airraids,
title={Air raids on the UK: understanding the effect of time on casualties},
author={Dennis Netchitailo},
year={2024},
url ={https://github.com/dennisnetchitailo/air-raids}
}