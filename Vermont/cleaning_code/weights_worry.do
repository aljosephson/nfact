* Project: UVM 
* Created on: July 2020
* Created by: alj
* Stata v.16

* does
	* implements survey weights on education
	* examines worries variables with weights 
	* updates file related to excel "panel_analysis" 

* assumes
	* standard - Stata v.16
	* assumes variables created in attrition_worry do file
	
* TO DO:
	* adjust directiories for universal use - right now set to alj 

* **********************************************************************
* 0 - setup
* **********************************************************************

* open log
	cap 		log close
	log 		using 	"C:\Users\aljosephson\Dropbox\COVID\UVM/18July_weights-worry", append
	

* using wide data set 

	use 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_18July_wide.dta", clear 

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

*** ENOUGH FOOD ***

* T1
	tab 		worry_enoughfood_T1e
	svy: 		tab worry_enoughfood_T1e

* T2
	tab 		worry_enoughfood_T2e
	svy: 		tab worry_enoughfood_T2e
	
*** FOOD EXP ***

* T1
	tab 		worry_foodexp_T1e
	svy: 		tab worry_foodexp_T1e

* T2
	tab 		worry_foodexp_T2e
	svy: 		tab worry_foodexp_T2e
	
*** FOOD UNSAFE ***

* T1
	tab 		worry_foodunsafe_T1e
	svy: 		tab worry_foodunsafe_T1e

* T2
	tab 		worry_foodunsafe_T2e
	svy: 		tab worry_foodunsafe_T2e
	
*** FOOD UNSAFE ***

* T1
	tab 		worry_programs_T1e
	svy: 		tab worry_programs_T1e

* T2
	tab 		worry_programs_T2e
	svy: 		tab worry_programs_T2e
	
*** FOOD UNSAFE ***

* T1
	tab 		worry_income_T1e
	svy: 		tab worry_income_T1e

* T2
	tab 		worry_income_T2e
	svy: 		tab worry_income_T2e

*** FOOD UNSAFE ***

* T1
	tab 		worry_housefood_T1e
	svy: 		tab worry_housefood_T1e

* T2
	tab 		worry_housefood_T2e
	svy: 		tab worry_housefood_T2e	
	
* save - updated file with weights	
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_wide_weights-unbal.dta", replace 
	
* **********************************************************************
* 3 - unbalanced - means 
* **********************************************************************

* want to compare means at various points
* cannot use t-test - so cannot say if unweighted is different from weighted
* or cannot really compare if T1 (year, covid) differs from T2


*** ENOUGH FOOD ***

* T1
	mean 		worry_enoughfood_T1e
	svy: 		mean worry_enoughfood_T1e

* T2
	mean 		worry_enoughfood_T2e
	svy: 		mean worry_enoughfood_T2e
	
*** FOOD EXP ***

* T1
	mean 		worry_foodexp_T1e
	svy: 		mean worry_foodexp_T1e

* T2
	mean 		worry_foodexp_T2e
	svy: 		mean worry_foodexp_T2e
	
*** FOOD UNSAFE ***

* T1
	mean 		worry_foodunsafe_T1e
	svy: 		mean worry_foodunsafe_T1e

* T2
	mean 		worry_foodunsafe_T2e
	svy: 		mean worry_foodunsafe_T2e
	
*** FOOD UNSAFE ***

* T1
	mean 		worry_programs_T1e
	svy: 		mean worry_programs_T1e

* T2
	mean 		worry_programs_T2e
	svy: 		mean worry_programs_T2e
	
*** FOOD UNSAFE ***

* T1
	mean 		worry_income_T1e
	svy: 		mean worry_income_T1e

* T2
	mean 		worry_income_T2e
	svy: 		mean worry_income_T2e

*** FOOD UNSAFE ***

* T1
	mean 		worry_housefood_T1e
	svy: 		mean worry_housefood_T1e

* T2
	mean 		worry_housefood_T2e
	svy: 		mean worry_housefood_T2e	

	
* **********************************************************************
* 4 - end matter
* **********************************************************************

* save new datasets as appropriate 
* should be saved above 

* close the log
	log	close

/* END */