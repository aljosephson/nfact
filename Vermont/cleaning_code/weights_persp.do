* Project: UVM 
* Created on: July 2020
* Created by: alj
* Stata v.16

* does
	* implements survey weights on education
	* examines perspectives variables with weights 
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
	log 		using 	"C:\Users\aljosephson\Dropbox\COVID\UVM/weights-perspectives", append
	

* using wide data set 

	use 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_25July_wide.dta", clear 

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
	
* set gender weights
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
	
* set weights 
	svyset 		educgen [pweight=educgenweight]
	*** to compare variables, use regular command for unweighted, preface with svy for weighted
	*** not all commands allowed SPECIFICALLY no ttest, etc. 
	
* **********************************************************************
* 2 - unbalanced  - comparisons over time
* **********************************************************************

* want to compare status at various points
* per discussion with MN on 15 July - only use full set for now

* NOT CURRENTLY A COMPONENT OF "panel_analysis" FILE - SO NOT INCLUDED IN EXCEL FILE

*** FLU ***

* T1
	tab 		persp_flu_T1e
	svy: 		tab persp_flu_T1e

* T2
	tab 		persp_flu_T2e
	svy: 		tab persp_flu_T2e
	
*** VT ***

* T1
	tab 		persp_vt_T1e
	svy: 		tab persp_vt_T1e

* T2
	tab 		persp_vt_T2e
	svy: 		tab persp_vt_T2e

*** USA ***

* T1
	tab 		persp_us_T1e
	svy: 		tab persp_us_T1e

* T2
	tab 		persp_us_T2e
	svy: 		tab persp_us_T2e

*** me ***

* T1
	tab 		persp_me_T1e
	svy: 		tab persp_me_T1e

* T2
	tab 		persp_me_T2e
	svy: 		tab persp_me_T2e
	
*** econ ***

* T1
	tab 		persp_econ_T1e
	svy: 		tab persp_econ_T1e

* T2
	tab 		persp_econ_T2e
	svy: 		tab persp_econ_T2e	
	
*** action ***

* T1
	tab 		persp_action_T1e
	svy: 		tab persp_action_T1e

* T2
	tab 		persp_action_T2e
	svy: 		tab persp_action_T2e
	

*** prepared ***

* T1
	tab 		persp_prepared_T1e
	svy: 		tab persp_prepared_T1e

* T2
	tab 		persp_prepared_T2e
	svy: 		tab persp_prepared_T2e	
	

*** packages ***

* T1
	tab 		persp_packages_T1e
	svy: 		tab persp_packages_T1e

* T2
	tab 		persp_packages_T2e
	svy: 		tab persp_packages_T2e	
	
* save - updated file with weights	
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_wide_weights-unbal.dta", replace 
	
* **********************************************************************
* 3 - unbalanced - means 
* **********************************************************************

* want to compare means at various points
* cannot use t-test - so cannot say if unweighted is different from weighted
* or cannot really compare if T1 (year, covid) differs from T2

*** FLU ***

* T1
	mean 		persp_flu_T1e
	svy: 		mean persp_flu_T1e

* T2
	mean 		persp_flu_T2e
	svy: 		mean persp_flu_T2e
	
*** VT ***

* T1
	mean 		persp_vt_T1e
	svy: 		mean persp_vt_T1e

* T2
	mean 		persp_vt_T2e
	svy: 		mean persp_vt_T2e

*** USA ***

* T1
	mean 		persp_us_T1e
	svy: 		mean persp_us_T1e

* T2
	mean 		persp_us_T2e
	svy: 		mean persp_us_T2e

*** me ***

* T1
	mean 		persp_me_T1e
	svy: 		mean persp_me_T1e

* T2
	mean 		persp_me_T2e
	svy: 		mean persp_me_T2e
	
*** econ ***

* T1
	mean 		persp_econ_T1e
	svy: 		mean persp_econ_T1e

* T2
	mean 		persp_econ_T2e
	svy: 		mean persp_econ_T2e	
	
*** action ***

* T1
	mean 		persp_action_T1e
	svy: 		mean persp_action_T1e

* T2
	mean 		persp_action_T2e
	svy: 		mean persp_action_T2e
	

*** prepared ***

* T1
	mean 		persp_prepared_T1e
	svy: 		mean persp_prepared_T1e

* T2
	mean 		persp_prepared_T2e
	svy: 		mean persp_prepared_T2e	
	

*** packages ***

* T1
	mean 		persp_packages_T1e
	svy: 		mean persp_packages_T1e

* T2
	mean 		persp_packages_T2e
	svy: 		mean persp_packages_T2e		
	
* **********************************************************************
* 4 - end matter
* **********************************************************************

* save new datasets as appropriate 
* should be saved above 

* close the log
	log	close

/* END */