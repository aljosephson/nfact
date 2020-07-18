* Project: UVM 
* Created on: July 2020
* Created by: alj
* Stata v.16

* does
	* implements survey weights on education
	* examines challenges variables with weights 
	* updates file related to excel "panel_analysis" 

* assumes
	* standard - Stata v.16
	* assumes variables created in attrition_challenges do file
	
* TO DO:
	* adjust directiories for universal use - right now set to alj 

* **********************************************************************
* 0 - setup
* **********************************************************************

* open log
	cap 		log close
	log 		using 	"C:\Users\aljosephson\Dropbox\COVID\UVM/17July_weights-challenges", append
	

* using wide data set 

	use 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_17July_wide.dta", clear 

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

*** AS MUCH ***

* T1
	tab 		challenge_asmuch_T1e
	svy: 		tab challenge_asmuch_T1e

* T2
	tab 		challenge_asmuch_T2e
	svy: 		tab challenge_asmuch_T2e
	
*** KINDS ***

* T1
	tab 		challenge_kinds_T1e
	svy: 		tab challenge_kinds_T1e

* T2
	tab 		challenge_kinds_T2e
	svy: 		tab challenge_kinds_T2e
	
*** FIND HELP ***

* T1
	tab 		challenge_findhelp_T1e
	svy: 		tab challenge_findhelp_T1e

* T2
	tab 		challenge_findhelp_T2e
	svy: 		tab challenge_findhelp_T2e

*** MORE PLACES ***

* T1
	tab 		challenge_moreplaces_T1e
	svy: 		tab challenge_moreplaces_T1e

* T2
	tab 		challenge_moreplaces_T2e
	svy: 		tab challenge_moreplaces_T2e
	
*** CLOSE ***

* T1
	tab 		challenge_close_T1e
	svy: 		tab challenge_close_T1e

* T2
	tab 		challenge_close_T2e
	svy: 		tab challenge_close_T2e
	
*** REDUC GROC ***

* T1
	tab 		challenge_reducgroc_T1e
	svy: 		tab challenge_reducgroc_T1e

* T2
	tab 		challenge_reducgroc_T2e
	svy: 		tab challenge_reducgroc_T2e
	
* save - updated file with weights	
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_wide_weights-unbal.dta", replace 
	
* **********************************************************************
* 3 - unbalanced - means 
* **********************************************************************

* want to compare means at various points
* cannot use t-test - so cannot say if unweighted is different from weighted
* or cannot really compare if T1 (year, covid) differs from T2

*** AS MUCH ***

	mean 		challenge_asmuch_T1e
	svy: 		mean challenge_asmuch_T1e
	
	mean 		challenge_asmuch_T2e
	svy: 		mean challenge_asmuch_T2e
	
*** KINDS ***

	mean 		challenge_kinds_T1e
	svy: 		mean challenge_kinds_T1e
	
	mean 		challenge_kinds_T2e
	svy: 		mean challenge_kinds_T2e


*** FIND HELP ***

	mean 		challenge_findhelp_T1e
	svy: 		mean challenge_findhelp_T1e
	
	mean 		challenge_findhelp_T2e
	svy: 		mean challenge_findhelp_T2e

*** MORE PLACES ***

	mean 		challenge_moreplaces_T1e
	svy: 		mean challenge_moreplaces_T1e
	
	mean 		challenge_moreplaces_T2e
	svy: 		mean challenge_moreplaces_T2e
	
*** CLOSE ***

	mean 		challenge_close_T1e
	svy: 		mean challenge_close_T1e
	
	mean 		challenge_close_T2e
	svy: 		mean challenge_close_T2e

*** REDUC GROC ***

	mean 		challenge_reducgroc_T1e
	svy: 		mean challenge_reducgroc_T1e
	
	mean 		challenge_reducgroc_T2e
	svy: 		mean challenge_reducgroc_T2e
	
* **********************************************************************
* 4 - end matter
* **********************************************************************

* save new datasets as appropriate 
* should be saved above 

* close the log
	log	close

/* END */