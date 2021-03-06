# National Food Access and COVID Research Team

This README describes the directory structure & should enable users to replicate code associated with NFACT work. NFACT is a collaborative, interdisciplinary multi-state research effort that uses common measurement tools, codebooks, code, data aggregation tools, and outreach materials to collectively examine and communicate the effect of COVID-19 on household food access and security.

<a href="https://zenodo.org/badge/latestdoi/279348981"><img src="https://zenodo.org/badge/279348981.svg" alt="DOI"></a>

## Index

 - [Introduction](#introduction)
 - [Data cleaning](#data-cleaning)
 - [Pre-requisites](#pre-requisites)
 - [Folder structure](#folder-structure)

## Introduction

This is the repo for NFACT.<br>

Contributors include members of NFACT: https://www.nfactresearch.org/. 

As described in more detail below, scripts various go through each step, from cleaning raw data to analysis.

## Data cleaning

The code shared replicates the data cleaning and analysis.

### Pre-requisites

Data should be extracted following these instructions: 
 - From Qualtrics: Data & Analysis → Export Data 
 - Click on the Excel tab to download the data as an Excel file (rather than CSV, which is the default)
 - Unclick ‘Use choice text’ and select ‘Use numeric values’
 - From the ‘More Options panel (right below): 
 - Select ‘Recode seen but unanswered questions as -99’ 
 - Select ‘Recode seen but unanswered multi-value fields as 0’’. Here, manually change the ‘0’ into a ‘-99’. This is IMPORTANT! 
 - Make sure the option "Split multi-value fields into columns" is unchecked 
 - Then, download the data!
