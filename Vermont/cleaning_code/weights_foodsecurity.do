* Project: UVM 
* Created on: July 2020
* Created by: alj
* Stata v.16

* does
	* implements survey weights on education
	* examines food security variables with weights 
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
	log 		using 	"C:\Users\aljosephson\Dropbox\COVID\UVM/13July_weights", append
	

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
* 2 - unbalanced  
* **********************************************************************

* want to compare status at various points

* last year to since covid	
	tab 		food_sec_yearcov
	svy:		tab food_sec_yearcov

* food security bin last year 
	tab 		food_sec_year_bin_T1
	svy: 		tab food_sec_year_bin_T1

* food security bin covid 
	tab 		food_sec_covid_bin_T1
	svy: 		tab food_sec_covid_bin_T1

* food security bin last 30 
	tab 		food_sec_last30_bin_T2
	svy: 		tab food_sec_last30_bin_T2
	
* covid to last 30 
	tab 		food_sec_cov30
	svy: 		tab food_sec_cov30

* save - updated file with weights	
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_wide_weights-unbal.dta", replace 
	
* **********************************************************************
* 3 - create balanced weight variable and set weights 
* **********************************************************************

* using wide data set (need to open again, saved unbalanced weights above)

	use 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_10July_wide.dta", clear 

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

* not sure if this makes a difference - do not need to re-create variable for weights
* but it seems like it might matter given population is a component of weighting 

* so want to drop attriters 	
	drop 		if non_respon_food_sec == 1
	*** should drop 43 observations 

* set weights 
	svyset 		education_T1 [pweight=educationweight]
	*** to compare variables, use regular command for unweighted, preface with svy for weighted
	*** not all commands allowed SPECIFICALLY no ttest, etc. 
	
* **********************************************************************
* 4 - balanced  
* **********************************************************************

* want to compare status at various points

* last year to since covid	
	tab 		food_sec_yearcov
	svy:		tab food_sec_yearcov

* food security bin last year 
	tab 		food_sec_year_bin_T1
	svy: 		tab food_sec_year_bin_T1

* food security bin covid 
	tab 		food_sec_covid_bin_T1
	svy: 		tab food_sec_covid_bin_T1

* food security bin last 30 
	tab 		food_sec_last30_bin_T2
	svy: 		tab food_sec_last30_bin_T2
	
* covid to last 30 
	tab 		food_sec_cov30
	svy: 		tab food_sec_cov30

* save - updated file with weights	
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_wide_weights-bal.dta", replace 
	
* **********************************************************************
* 5 - end matter
* **********************************************************************

* save new datasets as appropriate 
* should be saved above 

* close the log
	log	close

/* END */