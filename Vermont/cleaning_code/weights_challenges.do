* Project: UVM 
* Created on: July 2020
* Created by: alj
* Stata v.16

* does
	* implements survey weights on education, gender, both
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
* results are reasonable from this - use in UVM brief 
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
* 4 - changes in challenges 
* **********************************************************************

* create changes in food security variables 

* food security and benefits-
* Newfoodsec=1 if food insecure in T2 and food insecure in T1.  newfoodsec=2 if food insecure in T2 and foodsecure in T1.  Newfoodsec=3 if food secure in T1 and food insecure in T2.
	generate 	newfoodsec_T2=1 if food_sec_last30_bin_T2==1 & food_sec_covid_bin_T1==1
	recode 		newfoodsec_T2 (.=2) if food_sec_covid_bin_T1==1 & food_sec_last30_bin_T2==0
	recode 		newfoodsec_T2 (.=3) if food_sec_covid_bin_T1==0 & food_sec_last30_bin_T2==1

* relationship of different new money sources to food security status over T1 and T2
* not weighted
	tabulate 	newfoodsec_T2 money_sources_unemp_T2, chi2 column
	tabulate 	newfoodsec_T2 money_sources_fed_T2, chi2 column
	tabulate 	newfoodsec_T2 money_sources_friends_T2, chi2 column

* T1 food insecure but now food secure compared to all others currently food insecure (e.g. coded 2 in newfoodsec above)
	generate 	nowfoodsec=1 if newfoodsec_T2==2
	recode 		nowfoodsec (.=0) if newfoodsec_T2==1
	recode 		nowfoodsec (.=0) if newfoodsec_T2==3

* use of money sources as it relates to people who are now food secure in T2 but were food insecure in T1
* not weighted 
	tabulate 	nowfoodsec money_sources_fed_T2, chi2 column
	tabulate 	nowfoodsec money_sources_unemp_T2, chi2 column
	tabulate 	nowfoodsec money_sources_friends_T2, chi2 column

* difference in challenges by person- positive numbers indicate less challenges in T2, 
* negative indicate more challenges
	generate 	challenge_asmuch_diff= challenge_asmuch_T1e-challenge_asmuch_T2e
	tab 		challenge_asmuch_diff
	*** about half no change
	*** only 13 percent total have more challenges in T2
	*** overall fewer challenges in T2
	
	generate 	challenge_kinds_diff= challenge_kinds_T1e-challenge_kinds_T2e
	tab			challenge_kinds_diff
	*** fewer than 18 percent had more challenges in T2
	*** 55 percent no change
	*** overall, fewer or no change in challenges 
	
	generate 	challenge_findhelp_diff= challenge_findhelp_T1e-challenge_findhelp_T2e
	tab			challenge_findhelp_diff
	*** fewer than 10 percent more challenges in T2
	*** 73 percent no change
	*** overall, fewer or no change in challenges
	
	generate 	challenge_moreplaces_diff= challenge_moreplaces_T1e-challenge_moreplaces_T2e
	tab			challenge_moreplaces_diff
	*** about 16 percent had more challenges in T2
	*** 55 percent no change
	*** overall, fewer or no change in challenges 
	
	generate 	challenge__reducgroc_diff= challenge_reducgroc_T1e-challenge_reducgroc_T2e
	tab 		challenge__reducgroc_diff 
	*** fewer than 15 percent had more challenges
	*** 62 percent no change
	*** overall, fewer or no change in challenges 
	
	generate 	challenge__close_diff= challenge_close_T1e-challenge_close_T2e
	tab			challenge__close_diff
	*** fewer than 6 percent had more challenges
	*** 50 percent no change
	*** overall, fewer or no change in challenges 
	
* relationship of nowfoodsec to challenges differences
	logistic 	nowfoodsec challenge_asmuch_diff [pweight = educgenweight]
	*** not significantly different 
	logistic 	nowfoodsec challenge_kinds_diff [pweight = educgenweight]
	*** not significantly different
	logistic 	nowfoodsec challenge_findhelp_diff [pweight = educgenweight]
	margins 
	*** significantly different 10 percent
	*** easier to find places - 28.5 percent 
	logistic 	nowfoodsec challenge_moreplaces_diff [pweight = educgenweight]
	*** not significantly different 
	logistic 	nowfoodsec challenge__reducgroc_diff [pweight = educgenweight]
	margins
	*** significantly different at 5 percent
	*** fewer people adjusting grocery visits ?? - 29.6 percent
	logistic 	nowfoodsec challenge__close_diff [pweight = educgenweight]
	*** not significantly different 
	
* **********************************************************************
* 5 - end matter
* **********************************************************************

* save new datasets as appropriate 
* should be saved above 

* close the log
	log	close

/* END */