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
	log 		using 	"C:\Users\aljosephson\Dropbox\COVID\UVM/weights-worry", append
	

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
* using in UVM brief
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
	
*** PROGRAMS ***

* T1
	tab 		worry_programs_T1e
	svy: 		tab worry_programs_T1e

* T2
	tab 		worry_programs_T2e
	svy: 		tab worry_programs_T2e
	
*** INCOME ***

* T1
	tab 		worry_income_T1e
	svy: 		tab worry_income_T1e

* T2
	tab 		worry_income_T2e
	svy: 		tab worry_income_T2e

*** HOUSEFOOD ***

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
	
*** PROGRAMS ***

* T1
	mean 		worry_programs_T1e
	svy: 		mean worry_programs_T1e

* T2
	mean 		worry_programs_T2e
	svy: 		mean worry_programs_T2e
	
*** INCOME ***

* T1
	mean 		worry_income_T1e
	svy: 		mean worry_income_T1e

* T2
	mean 		worry_income_T2e
	svy: 		mean worry_income_T2e

*** HOUSE FOOD ***

* T1
	mean 		worry_housefood_T1e
	svy: 		mean worry_housefood_T1e

* T2
	mean 		worry_housefood_T2e
	svy: 		mean worry_housefood_T2e	

	
* **********************************************************************
* 4 - changes in challenges 
* **********************************************************************

**difference in worry by person- positive numbers indicate less worry in T2, 
**negative indicate more worry

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

	generate 	worry_enoughfood_diff= worry_enoughfood_T1e- worry_enoughfood_T2e
	tab 		worry_enoughfood_diff
	*** about half no change
	*** only 18 percent total have more worries in T2
	*** overall fewer challenges in T2
	
	generate 	 worry_foodexp_diff= worry_foodexp_T1e- worry_foodexp_T2e
	tab			 worry_foodexp_diff
	*** more than 40 percent had more worries in T2 - first time seeing this as a bigger worry_enoughfood_T1e 
	*** 35 percent no change
	*** people are worried about food becoming more expensive 
	
	generate 	worry_foodunsafe_diff= worry_foodunsafe_T1e- worry_foodunsafe_T2e
	tab			worry_foodunsafe_diff
	*** fewer than 23 percent more worries in T2
	*** 30 percent no change
	*** overall, fewer or no change in worries
	
	generate 	worry_programs_diff= worry_programs_T1e- worry_programs_T2e
	tab			worry_programs_diff
	*** about 35 percent had more worries in T2
	*** 43 percent no change
	*** people seem concerned about more worries in programs
	
	generate 	worry_income_diff= worry_income_T1e- worry_income_T2e
	tab 		worry_income_diff 
	*** fewer than 20 percent had more challenges
	*** 40 percent no change
	*** overall, fewer or no change in challenges 
	
	generate 	worry_housefood_diff= worry_housefood_T1e- worry_housefood_T2e
	tab			worry_housefood_diff
	*** fewer than 20 percent had more challenges
	*** 30 percent no change
	*** overall, fewer or no change in challenges 
	
* relationship of nowfoodsec to challenges differences
	logistic 	nowfoodsec worry_enoughfood_diff [pweight = educgenweight]
	*** not significantly different 
	logistic 	nowfoodsec worry_foodexp_diff [pweight = educgenweight]
	*** not significantly different
	logistic 	nowfoodsec worry_foodunsafe_diff [pweight = educgenweight] 
	*** not significantly different
	logistic 	nowfoodsec worry_programs_diff [pweight = educgenweight]
	margins 
	*** significantly different at 5 percent: increase of 19.0 percent 
	logistic 	nowfoodsec worry_income_diff [pweight = educgenweight]
	*** not significantly different 
	logistic 	nowfoodsec worry_housefood_diff [pweight = educgenweight]
	margins
	*** significantly different at 5 percent
	*** increase of 30.5 percent 

* **********************************************************************
* 5 - end matter
* **********************************************************************

* save new datasets as appropriate 
* should be saved above 

* close the log
	log	close

/* END */