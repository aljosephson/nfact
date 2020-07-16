# National Food Access and COVID Research Team

This README describes the directory structure & should enable users to replicate code associated with NFACT work. NFACT is a collaborative, interdisciplinary multi-state research effort that uses common measurement tools, codebooks, code, data aggregation tools, and outreach materials to collectively examine and communicate the effect of COVID-19 on household food access and security.

DOI: https://zenodo.org/badge/latestdoi/279348981

## Index

 - [Introduction](#introduction)
 - [Data cleaning](#data-cleaning)
 - [Pre-requisites](#pre-requisites)
 - [Folder structure](#folder-structure)

## Introduction

This is the repo for NFACT.<br>

Contributors: *add link to NFACT page*

As described in more detail below, scripts various go through each step, from cleaning raw data to analysis.

## Data cleaning

The code in `file.do` (to be done - update with real name) replicates the data cleaning and analysis.

### Pre-requisites

#### Stata req's

  * The data processing and analysis requires a number of user-written Stata programs:
    1. `estout`
    2. `customsave`

#### Folder structure

The *link to GoogleDrive / other appropriate location* provides more details on the data cleaning.

The general repo structure looks as follows:<br>

```stata
nfact
├────README.md
├────file.do
│    
├────country & state       /* one dir for each state / national survey */
|    ├──sub-state          /* one dir for each sub survey within a state */
│       ├──cleaning_code        
│       ├──regression_code
│       └──output
│          ├──tables
│          └──figures
│
│────Analysis              /* overall analysis */
│    ├──code
│    └──output
│       ├──tables
│       └──figures
│   
└────config
```
