* Project: UVM 
* Created on: July 2020
* Created by: alj
* Stata v.16

* does
	* implements survey weights on education
	* implements survey weights with gender
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

* set gender weighted
* follows:
	* Women should be 0.5070 of population in VT, represented in sample by 0.794, so weight = 0.638539043
	* Men should be 0.493 of population in VT, represented in sample by 0.206, so weight = 2.393203883

* create weight variable
	gen 		genderweight = .
	replace		genderweight = 0.638539043 if female == 1
	replace		genderweight = 2.393203883 if female == 0 
	*** grouped by binary version of gender 
	
* set multiple weights
* create new variables
* not sure if this is the correct process - but trying it for now
	gen			educgenweight = . 
	gen 		educgen = . 
	replace		educgenweight = educationweight * genderweight
	replace		educgen = education_T1 * female 
	
* **********************************************************************
* 2 - unbalanced  
* **********************************************************************

* want to compare status at various points
* education weights 

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
	
* reset weights 
* gender weights
	svyset 		female [pweight=genderweight]	
	
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
	
* reset weights
* gender and education weights
	svyset 		educgen [pweight=educgenweight]
	
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
* 3 - create balanced variables and set weights 
* **********************************************************************

* using wide data set (need to open again, saved unbalanced weights above)

	use 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_19July_wide.dta", clear 

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

* set gender weighted
* follows:
	* Women should be 0.5070 of population in VT, represented in sample by 0.794, so weight = 0.638539043
	* Men should be 0.493 of population in VT, represented in sample by 0.206, so weight = 2.393203883

* create weight variable
	gen 		genderweight = .
	replace		genderweight = 0.638539043 if female == 1
	replace		genderweight = 2.393203883 if female == 0 
	*** grouped by binary version of gender 

* set multiple weights
* create new variables
* not sure if this is the correct process - but trying it for now
	gen			educgenweight = . 
	gen 		educgen = . 
	replace		educgenweight = educationweight * genderweight
	replace		educgen = education_T1 * female 

* so want to drop attriters 	
	drop 		if non_respon_food_sec == 1
	*** should drop 43 observations 

* set weights 
	svyset 		education_T1 [pweight=educationweight]
	*** to compare variables, use regular command for unweighted, preface with svy for weighted
	*** not all commands allowed SPECIFICALLY no ttest, etc. 
	
* reset weights 
* gender weights
	svyset 		female [pweight=genderweight]	
	
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
	
* reset weights 
* gender and education weights
	svyset 		educgen [pweight=educgenweight]
	
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