* Project: UVM 
* Created on: July 2020
* Created by: alj
* Stata v.16

* does
	* basic food security analysis

* assumes
	* standard - Stata v.16
	
* TO DO:
	* adjust directiories for universal use - right now set to alj 

* **********************************************************************
* 0 - setup
* **********************************************************************

* open log
	cap 		log close
	log 		using 	"C:\Users\aljosephson\Dropbox\COVID\UVM/19July_foodsecreg", append

* **********************************************************************
* 1 - 
* **********************************************************************

* looking at food security variables and outcomes
* using long data set 		

use 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_19July_wide.dta", clear 
	*** this is the "wide" dataset 

* **********************************************************************
* 1 - compare groups: create variables, set weights
* **********************************************************************

* create new variable 
* three groups
	*** = 0 if become food insecure
	*** = 1 if no change
	*** = 2 if become food secure 
	
	tab 		food_sec_cov30
	gen 		rfood_sec_cov30 = .
	replace 	rfood_sec_cov30 = 0 if food_sec_cov30 == 0
	replace 	rfood_sec_cov30 = 0 if food_sec_cov30 == 2
	replace 	rfood_sec_cov30 = 0 if food_sec_cov30 == 1
	replace 	rfood_sec_cov30 = 1 if food_sec_cov30 == 2
	replace 	rfood_sec_cov30 = 1 if food_sec_cov30 == 0
	replace 	rfood_sec_cov30 = 2 if food_sec_cov30 == -1	

* create two additional variables
* two groups
		*** = 0 if no change
		*** = 1 if become food insecure
	gen 		rfood_sec_cov30_insec = . 
	replace		rfood_sec_cov30_insec = 0 if rfood_sec_cov30 == 1
	replace		rfood_sec_cov30_insec = 1 if rfood_sec_cov30 == 0
		
* two groups
		*** = 0 if no change
		*** = 1 if become food secure		
	gen 		rfood_sec_cov30_sec = . 
	replace		rfood_sec_cov30_sec = 0 if rfood_sec_cov30 == 1
	replace		rfood_sec_cov30_sec = 1 if rfood_sec_cov30 == 2
		
* **********************************************************************
* 2 - add MNiles variables
* **********************************************************************

* food security and benefits
* =1 if food insecure in T2 and food insecure in T1, =2 if food insecure in T2 and foodsecure in T1, =3 if food secure in T1 and food insecure in T2.
	generate 	newfoodsec_T2=1 if food_sec_last30_bin_T2==1 & food_sec_covid_bin_T1==1
	recode 		newfoodsec_T2 (.=2) if food_sec_covid_bin_T1==1 & food_sec_last30_bin_T2==0
	recode 		newfoodsec_T2 (.=3) if food_sec_covid_bin_T1==0 & food_sec_last30_bin_T2==1

* T1 food insecure but now food secure compared to all others currently food insecure (e.g. coded 2 in newfoodsec above)
	generate 	nowfoodsec=1 if newfoodsec_T2==2
	recode 		nowfoodsec (.=0) if newfoodsec_T2==1
	recode 		nowfoodsec (.=0) if newfoodsec_T2==3

* benefit use over the two time periods 
* =0 if never used. =1 if used in T1 but not T2.  =2 if used in T2 but not T1.  =3 if used in both T1 and T2.
* snap	
	generate 	snapuse=0 if prog_snap_T2==0 & source_snap_covid_T1==0
	recode 		snapuse (.=1) if prog_snap_T2==0 & source_snap_covid_T1==1
	recode 		snapuse (.=2) if prog_snap_T2==1 &source_snap_covid_T1==0
	recode 		snapuse (.=3) if prog_snap_T2==1 &source_snap_covid_T1==1
* pantry
	generate 	pantryuse=0 if prog_pantry_T2==0 & source_pantry_covid_T1==0
	recode 		pantryuse (.=1) if prog_pantry_T2==0 & source_pantry_covid_T1==1
	recode 		pantryuse (.=2) if prog_pantry_T2==1 &source_pantry_covid_T1==0
	recode 		pantryuse (.=3) if prog_pantry_T2==1 &source_pantry_covid_T1==1

* JOBS INDEX- =1 if people lost their job in T1, and =0 if everything else in T1.
* type mismatch with job loss - must destring 
	destring 	loss_job_T1, generate(loss_job_T1a)

	generate 	joblost1=1 if loss_job_T1a==4
	recode 		joblost1 (.=0) if loss_job_T1a==3
	recode 		joblost1 (.=0) if loss_job_T1a==2
	recode 		joblost1 (.=0) if loss_job_T1a==1

*=1 if lost job, furloughed, or loss of hours in T1, =0 if no job impact in T1.
	generate 	job1=1 if loss_job_T1a==4
	recode 		job1 (.=1) if loss_job_T1a==3
	recode 		job1 (.=1) if loss_job_T1a==2
	recode 		job1 (.=0) if loss_job_T1a==1

*jobtoday=1 if no job impact in T2 as of time of survey. =2 if furloughed in T2, =3 if lost hours in T2, =4 if job loss in T2.
	generate 	jobstoday=1 if loss_no_today_T2==1
	recode 		jobstoday (.=2) if loss_furlo_today_T2==1
	recode 		jobstoday (.=3) if loss_hours_today_T2==1
	recode 		jobstoday (.=4) if loss_job_today_T2==1

** jobrecovery=1 if had a job disruption in T1 and no longer an impact in T2.
	generate 	jobrecovery=1 if job1==1 & jobstoday==1
	recode 		jobrecovery (.=0) if job1==1 & jobstoday==2
	recode 		jobrecovery (.=0) if job1==1 & jobstoday==3
	recode 		jobrecovery (.=0) if job1==1 & jobstoday==4

*Jobs30=1 replication of jobstoday but for previous 30 days
	generate 	jobs30=1 if loss_no_last30_T2==1
	recode 		jobs30 (.=2) if loss_furlo_last30_T2==1
	recode 		jobs30 (.=3) if loss_hours_last30_T2==1
	recode 		jobs30 (.=4) if loss_job_last30_T2==1

*job recovery in 30 days previous
	generate 	jobrecovery30=1 if job1==1 & jobs30==1
	recode 		jobrecovery30 (.=0) if job1==1 & jobs30==2
	recode 		jobrecovery30 (.=0) if job1==1 & jobs30==3
	recode 		jobrecovery30 (.=0) if job1==1 & jobs30==4

*anyrecovery=1 if jobrecovery today or previous 30 days, basically any job recovery since T1.
	generate 	anyrecovery=1 if jobrecovery==1
	recode 		anyrecovery (.=1) if jobrecovery30==1
	recode 		anyrecovery (.=0) if jobrecovery==0
	recode 		anyrecovery (.=0) if jobrecovery30==0
	
* save file with new variables 	
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_13July_foodsecan.dta", replace 

* **********************************************************************
* 3 - create survey weights  
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
	
* save file with new variables 	
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_19July_foodsecan.dta", replace 
	
* **********************************************************************
* 4 - basic regs 
* **********************************************************************

* going to consider 
	*** rfood_sec_cov30_insec (only included as 0 those with no change)
	*** rfood_sec_cov30_sec (only included as 0 those with no change)

* rfood_sec_cov30_insec - those who became food insecure 
* simplest version, with obvious variables	
	
* without weights 	
	reg 		rfood_sec_cov30_insec joblost snapuse pantryuse money_sources_unemp_T2 ///
					money_sources_fed_T2 money_sources_friends_T2, cluster(UNIQUE_ID)
	*** nothing significant 
	probit 		rfood_sec_cov30_insec joblost snapuse pantryuse money_sources_unemp_T2 ///
					money_sources_fed_T2 money_sources_friends_T2, cluster(UNIQUE_ID)
	*** pantryuse significant - associated with having become food insecure - makes sense, regression does not get to causality
					
* with weights 
	svy: 		reg rfood_sec_cov30_insec joblost snapuse pantryuse money_sources_unemp_T2 ///
					money_sources_fed_T2 money_sources_friends_T2
	*** joblost negatively associated with food insecure
	*** receipt of fed money / friends with food positively associated with food insecure 
	svy:        probit rfood_sec_cov30_insec joblost snapuse pantryuse money_sources_unemp_T2 ///
					money_sources_fed_T2 money_sources_friends_T2
	*** receipt of money from friends positively associated with food insecure 
					
	*** can think about adding in more variables here
	*** problem is that we need to be strategic - did Meredith's results show anything significant?
	*** did our results show significant changes that would be worth investigating more?
	*** already losing a number of observations due to low responses ... so want to be sure that we're including appropriate variables

* rfood_sec_cov30_sec - those who became food secure 
* simplest version, with obvious variables	
	
* without weights 	
	reg 		rfood_sec_cov30_insec joblost snapuse pantryuse money_sources_unemp_T2 ///
					money_sources_fed_T2 money_sources_friends_T2, cluster(UNIQUE_ID)
	*** nothing significant
	probit 		rfood_sec_cov30_insec joblost snapuse pantryuse money_sources_unemp_T2 ///
					money_sources_fed_T2 money_sources_friends_T2, cluster(UNIQUE_ID)
	*** pantry use significant associated with becoming food secure 

* with weights 
	svy: 		reg rfood_sec_cov30_insec joblost snapuse pantryuse money_sources_unemp_T2 ///
					money_sources_fed_T2 money_sources_friends_T2
	*** joblost negatively associated with food insecure
	*** receipt of fed money / friends with food positively associated with food insecure 
	*** results seem to be the same as above - so maybe some swamping from the "other" groups driving results
	svy:        probit rfood_sec_cov30_insec joblost snapuse pantryuse money_sources_unemp_T2 ///
					money_sources_fed_T2 money_sources_friends_T2
	*** receipt of money from friends positively associated with food insecure 
	*** results seem to be the same as above - so maybe some swamping from the "other" groups driving results
	
* **********************************************************************
* 5 - end matter
* **********************************************************************

* save new datasets as appropriate 
* should be saved above 

* close the log
	log	close

/* END */