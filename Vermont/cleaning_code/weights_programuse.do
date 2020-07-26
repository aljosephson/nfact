* Project: UVM 
* Created on: July 2020
* Created by: alj
* Stata v.16

* does
	* implements survey weights on education, gender, both 
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
	log 		using 	"C:\Users\aljosephson\Dropbox\COVID\UVM/weights-programuse", append
	

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
* already defined 
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
* 4 - changes in challenges 
* **********************************************************************

* difference in worry by person - positive numbers indicate less use in T2, negative indicates more use in T2

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

*** SNAP ***	
	
	generate 	prog_snap_diffy2 = source_snap_year_T1- prog_snap_T2
	tab 		prog_snap_diffy2
	*** 95 percent no change
	*** only 14 use less, 41 use more 
	generate	prog_snap_diffc2 = source_snap_covid_T1- prog_snap_T2
	tab			prog_snap_diffc2
	*** 95 percent no change
	*** only 4 use less, 60 use more 
	
*** WIC ***	
	
	generate 	prog_wic_diffy2 = source_wic_year_T1- prog_wic_T2
	tab 		prog_wic_diffy2
	*** 98 percent no change
	*** only 14 use less, 7 use more 
	generate	prog_wic_diffc2 = source_wic_covid_T1- prog_wic_T2
	tab			prog_wic_diffc2
	*** 95 percent no change
	*** only 1 use less, 14 use more 
	
*** SCHOOL ***	
	
	generate 	prog_school_diffy2 = source_school_year_T1- prog_school_T2
	tab 		prog_school_diffy2
	*** 89 percent no change
	*** 96 use less, 50 use more 
	generate	prog_school_diffc2 = source_school_covid_T1- prog_school_T2
	tab			prog_school_diffc2
	*** 98 percent no change
	*** only 29 use less, 38 use more 
	
*** PANTRY ***	
	
	generate 	prog_pantry_diffy2 = source_pantry_year_T1- prog_pantry_T2
	tab 		prog_pantry_diffy2
	*** 95 percent no change
	*** 51 use less, 53 use more 
	generate	prog_pantry_diffc2 = source_pantry_covid_T1- prog_pantry_T2
	tab			prog_pantry_diffc2
	*** 93 percent no change
	*** only 21 use less, 65 use more 

*** LOGITS *** 

*** SNAP ***
	
	logistic 	nowfoodsec prog_snap_diffy2 [pweight = educgenweight]
	*** not statistically different
	logistic 	nowfoodsec prog_snap_diffc2 [pweight = educgenweight]
	margins 
	*** statistically different at 1 percent level
	*** 29.7 percent less likely to be using
	
*** WIC ***
	
	logistic 	nowfoodsec prog_wic_diffy2 [pweight = educgenweight]
	*** not statistically different
	logistic 	nowfoodsec prog_wic_diffc2 [pweight = educgenweight]
	*** not statistically different

*** SCHOOL ***
	
	logistic 	nowfoodsec prog_school_diffy2 [pweight = educgenweight]
	*** not statistically different
	logistic 	nowfoodsec prog_school_diffc2 [pweight = educgenweight]
	*** not statistically different
	
*** PANTRY ***
	
	logistic 	nowfoodsec prog_pantry_diffy2 [pweight = educgenweight]
	*** not statistically different
	*** really close, but above 10 percent level 
	logistic 	nowfoodsec prog_pantry_diffc2 [pweight = educgenweight]
	*** not statistically different

* save - updated file with weights	
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_wide_weights-unbal.dta", replace 

* **********************************************************************
* 5 - end matter
* **********************************************************************

* save new datasets as appropriate 
* should be saved above 

* close the log
	log	close

/* END */