* Project: UVM 
* Created on: July 2020
* Created by: alj
* Stata v.16

* does
	* implements survey weights on education
	* examines program use variables with weights 
	* updates file related to excel "panel_analysis" 

* assumes
	* standard - Stata v.16
	* assumes variables created in attrition_foodsecurity do file
	
* TO DO:
	* adjust directiories for universal use - right now set to alj 

* **********************************************************************
* 0 - setup
* **********************************************************************

* open log
	cap 		log close
	log 		using 	"C:\Users\aljosephson\Dropbox\COVID\UVM/15July_weights-programuse", append
	

* using wide data set 

	use 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_10July_wide.dta", clear 

* **********************************************************************
* 1 - create unbalanced weight variable and set weights 
* **********************************************************************

* set education weights 
* follows: 
	* No College Degree should be 0.627 of pouplation in VT, represented in sample by 0.347, so weight = 1.806916427
	* College Degree should be 0.373 of population in VT, represented in sample by 0.653, so weight = 0.571209801

* create weight variable 
	gen 		educationweight = .
	replace 	educationweight = 1.806916427 if education_T1 == 1
	replace 	educationweight = 1.806916427 if education_T1 == 2
	replace 	educationweight = 1.806916427 if education_T1 == 3
	replace 	educationweight = 1.806916427 if education_T1 == 4
	replace 	educationweight = 0.571209801 if education_T1 == 5
	replace 	educationweight = 0.571209801 if education_T1 == 6
	*** grouped by college degree, no college degree 
	
* set weights 
	svyset 		education_T1 [pweight=educationweight]
	*** to compare variables, use regular command for unweighted, preface with svy for weighted
	*** not all commands allowed SPECIFICALLY no ttest, etc. 
	
* **********************************************************************
* 2 - unbalanced  - comparisons over time
* **********************************************************************

* want to compare status at various points
* per discussion with MN on 15 July - only use full set for now

* NOT CURRENTLY A COMPONENT OF "panel_analysis" FILE - SO NOT INCLUDED IN EXCEL FILE

*** SNAP ***

* last year to since covid	
	tab 		source_snap_yearcov
	svy:		tab source_snap_yearcov

* food security bin last year 
	tab 		source_snap_year_T1
	svy: 		tab source_snap_year_T1

* food security bin covid 
	tab 		source_snap_covid_T1
	svy: 		tab source_snap_covid_T1

* food security bin last 30 
	tab 		prog_snap_T2
	svy: 		tab prog_snap_T2
	
* covid to last 30 
	tab 		source_snap_cov30
	svy: 		tab source_snap_cov30
	
*** WIC ***

* last year to since covid	
	tab 		source_wic_yearcov
	svy:		tab source_wic_yearcov

* food security bin last year 
	tab 		source_wic_year_T1
	svy: 		tab source_wic_year_T1

* food security bin covid 
	tab 		source_wic_covid_T1
	svy: 		tab source_wic_covid_T1

* food security bin last 30 
	tab 		prog_wic_T2
	svy: 		tab prog_wic_T2
	
* covid to last 30 
	tab 		source_wic_cov30
	svy: 		tab source_wic_cov30	
	
*** SCHOOL ***

* last year to since covid	
	tab 		source_school_yearcov
	svy:		tab source_school_yearcov

* food security bin last year 
	tab 		source_school_year_T1
	svy: 		tab source_school_year_T1

* food security bin covid 
	tab 		source_school_covid_T1
	svy: 		tab source_school_covid_T1

* food security bin last 30 
	tab 		prog_school_T2
	svy: 		tab prog_school_T2
	
* covid to last 30 
	tab 		source_school_cov30
	svy: 		tab source_school_cov30	
	
*** PANTRY ***

* last year to since covid	
	tab 		source_pantry_yearcov
	svy:		tab source_pantry_yearcov

* food security bin last year 
	tab 		source_pantry_year_T1
	svy: 		tab source_pantry_year_T1

* food security bin covid 
	tab 		source_pantry_covid_T1
	svy: 		tab source_pantry_covid_T1

* food security bin last 30 
	tab 		prog_pantry_T2
	svy: 		tab prog_pantry_T2
	
* covid to last 30 
	tab 		source_pantry_cov30
	svy: 		tab source_pantry_cov30	

* save - updated file with weights	
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_wide_weights-unbal.dta", replace 
	
* **********************************************************************
* 3 - unbalanced - means 
* **********************************************************************

* want to compare means at various points
* cannot use t-test - so cannot say if unweighted is different from weighted
* or cannot really compare if T1 (year, covid) differs from T2

*** SNAP ***

	mean 		source_snap_year_T1
	svy: 		mean source_snap_year_T1
	
	mean 		source_snap_covid_T1
	svy: 		mean source_snap_covid_T1
	
	mean 		prog_snap_T2
	svy: 		mean prog_snap_T2
		
*** WIC ***

	mean 		source_wic_year_T1
	svy: 		mean source_wic_year_T1
	
	mean 		source_wic_covid_T1
	svy: 		mean source_wic_covid_T1
	
	mean 		prog_wic_T2
	svy: 		mean prog_wic_T2
	
*** SCHOOL ***

	mean 		source_school_year_T1
	svy: 		mean source_school_year_T1
	
	mean 		source_school_covid_T1
	svy: 		mean source_school_covid_T1
	
	mean 		prog_school_T2
	svy: 		mean prog_school_T2
	
*** PANTRY ***

	mean 		source_pantry_year_T1
	svy: 		mean source_pantry_year_T1
	
	mean 		source_pantry_covid_T1
	svy: 		mean source_pantry_covid_T1
	
	mean 		prog_pantry_T2
	svy: 		mean prog_pantry_T2
	
* **********************************************************************
* 4 - end matter
* **********************************************************************

* save new datasets as appropriate 
* should be saved above 

* close the log
	log	close

/* END */