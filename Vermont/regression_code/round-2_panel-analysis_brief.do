* Project: UVM 
* Created on: July 2020
* Created by: MN
* edited: just added top - alj 
* Stata v.16

* does
	* comparisons used in food security brief
	* comparisons for panel_analysis brief 

* assumes
	* standard - Stata v.16
	
* TO DO:
	* add location of files 

**female variable
recode gender_id_T1 "Other"=5

generate female=1 if gender_id_T1==2
recode female (.=0) if gender_id_T1==1


**Job loss T1 compared to T2
tabulate loss_job_T1 loss_job_last30_T2, chi2 column
tabulate loss_job_T1 loss_job_today_T2, chi2 column
tabulate loss_job_T1 loss_hours_last30_T2, chi2 column
tabulate loss_job_T1 loss_hours_today_T2, chi2 column
tabulate loss_job_T1 loss_furlo_last30_T2, chi2 column
tabulate loss_job_T1 loss_furlo_today_T2, chi2 column
tabulate loss_job_T1 loss_no_last30_T2, chi2 column
tabulate loss_job_T1 loss_no_today_T2, chi2 column

**Unemployment use in T2 related to Jobs in T1, T2
tabulate money_sources_unemp_T2 loss_job_T1, chi2 column
tabulate money_sources_unemp_T2 loss_job_last30_T2, chi2 column
tabulate money_sources_unemp_T2 loss_job_today_T2, chi2 column
tabulate money_sources_unemp_T2 loss_hours_last30_T2, chi2 column
tabulate money_sources_unemp_T2 loss_hours_today_T2, chi2 column
tabulate money_sources_unemp_T2 loss_furlo_last30_T2, chi2 column
tabulate money_sources_unemp_T2 loss_furlo_today_T2, chi2 column
tabulate money_sources_unemp_T2 loss_no_last30_T2, chi2 column
tabulate money_sources_unemp_T2 loss_no_today_T2, chi2 column

**food security and benefits- Newfoodsec=1 if food insecure in T2 and food insecure in T1.  newfoodsec=2 if food insecure in T2 and foodsecure in T1.  Newfoodsec=3 if food secure in T1 and food insecure in T2.
generate newfoodsec_T2=1 if food_sec_last30_bin_T2==1 & food_sec_covid_bin_T1==1
recode newfoodsec_T2 (.=2) if food_sec_covid_bin_T1==1 & food_sec_last30_bin_T2==0
recode newfoodsec_T2 (.=3) if food_sec_covid_bin_T1==0 & food_sec_last30_bin_T2==1

*Relationship of different new money sources to food security status over T1 and T2
tabulate newfoodsec_T2 money_sources_unemp_T2, chi2 column
tabulate newfoodsec_T2 money_sources_fed_T2, chi2 column
tabulate newfoodsec_T2 money_sources_friends_T2, chi2 column

**T1 food insecure but now food secure compared to all others currently food insecure (e.g. coded 2 in newfoodsec above)
generate nowfoodsec=1 if newfoodsec_T2==2
recode nowfoodsec (.=0) if newfoodsec_T2==1
recode nowfoodsec (.=0) if newfoodsec_T2==3

*use of money sources as it relates to people who are now food secure in T2 but were food insecure in T1.
tabulate nowfoodsec money_sources_fed_T2, chi2 column
tabulate nowfoodsec money_sources_unemp_T2, chi2 column
tabulate nowfoodsec money_sources_friends_T2, chi2 column


**benefit use over the two time periods. =0 if never used. =1 if used in T1 but not T2.  =2 if used in T2 but not T1.  =3 if used in both T1 and T2.
generate SNAPuse=0 if prog_snap_T2==0 & source_snap_covid_T1==0
recode SNAPuse (.=1) if prog_snap_T2==0 & source_snap_covid_T1==1
recode SNAPuse (.=2) if prog_snap_T2==1 &source_snap_covid_T1==0
recode SNAPuse (.=3) if prog_snap_T2==1 &source_snap_covid_T1==1
tabulate newfoodsec_T2 SNAPuse, chi2 column

generate pantryuse=0 if prog_pantry_T2==0 & source_pantry_covid_T1==0
recode pantryuse (.=1) if prog_pantry_T2==0 & source_pantry_covid_T1==1
recode pantryuse (.=2) if prog_pantry_T2==1 &source_pantry_covid_T1==0
recode pantryuse (.=3) if prog_pantry_T2==1 &source_pantry_covid_T1==1
tabulate newfoodsec_T2 pantryuse, chi2 column

tabulate newfoodsec_T2 prog_pantry_T2, chi2 column

tabulate nowfoodsec SNAPuse, chi2 column
tabulate nowfoodsec pantryuse, chi2 column


**JOBS INDEX- =1 if people lost their job in T1, and =0 if everything else in T1.
generate joblost1=1 if loss_job_T1==4
recode joblost1 (.=0) if loss_job_T1==3
recode joblost1 (.=0) if loss_job_T1==2
recode joblost1 (.=0) if loss_job_T1==1

*=1 if lost job, furloughed, or loss of hours in T1, =0 if no job impact in T1.
generate job1=1 if loss_job_T1==4
recode job1 (.=1) if loss_job_T1==3
recode job1 (.=1) if loss_job_T1==2
recode job1 (.=0) if loss_job_T1==1

*jobtoday=1 if no job impact in T2 as of time of survey. =2 if furloughed in T2, =3 if lost hours in T2, =4 if job loss in T2.
generate jobstoday=1 if loss_no_today_T2==1
recode jobstoday (.=2) if loss_furlo_today_T2==1
recode jobstoday (.=3) if loss_hours_today_T2==1
recode jobstoday (.=4) if loss_job_today_T2==1

**relationship of job experiences previous and today
tabulate joblost1 loss_job_today_T2, column
tabulate job1 loss_job_today_T2, column
tabulate joblost1 jobstoday, chi2 column
tabulate job1 jobstoday, chi2 column

** jobrecovery=1 if had a job disruption in T1 and no longer an impact in T2.
generate jobrecovery=1 if job1==1 & jobstoday==1
recode jobrecovery (.=0) if job1==1 & jobstoday==2
recode jobrecovery (.=0) if job1==1 & jobstoday==3
recode jobrecovery (.=0) if job1==1 & jobstoday==4

*relationship of food security to job recovery.
tabulate nowfoodsec jobrecovery, chi2 column

*Jobs30=1 replication of jobstoday but for previous 30 days
generate jobs30=1 if loss_no_last30_T2==1
recode jobs30 (.=2) if loss_furlo_last30_T2==1
recode jobs30 (.=3) if loss_hours_last30_T2==1
recode jobs30 (.=4) if loss_job_last30_T2==1

*job recovery in 30 days previous
generate jobrecovery30=1 if job1==1 & jobs30==1
recode jobrecovery30 (.=0) if job1==1 & jobs30==2
recode jobrecovery30 (.=0) if job1==1 & jobs30==3
recode jobrecovery30 (.=0) if job1==1 & jobs30==4

*food security recovery compared to job recovery in 30 days prior
tabulate nowfoodsec jobrecovery30, chi2 column

*anyrecovery=1 if jobrecovery today or previous 30 days, basically any job recovery since T1.
generate anyrecovery=1 if jobrecovery==1
recode anyrecovery (.=1) if jobrecovery30==1
recode anyrecovery (.=0) if jobrecovery==0
recode anyrecovery (.=0) if jobrecovery30==0

tabulate nowfoodsec anyrecovery, chi2 column

**correlations of people who are now T2 food secure but were T1 food insecure to program use, challenges,
tabulate nowfoodsec prog_snap_T2, chi2 column
tabulate nowfoodsec prog_wic_T2, chi2 column
tabulate nowfoodsec prog_school_T2, chi2 column
tabulate nowfoodsec prog_pantry_T2, chi2 column
tabulate nowfoodsec challenge_asmuch_T2, chi2 column
tabulate nowfoodsec challenge_kinds_T2, chi2 column
tabulate nowfoodsec challenge_findhelp_T2, chi2 column
tabulate nowfoodsec challenge_moreplaces_T2, chi2 column
tabulate nowfoodsec challenge_close_T2, chi2 column
tabulate nowfoodsec challenge_reducgroc_T2, chi2 column


*education bucket- college educated
generate college=1 if education==5
recode college (.=1) if education==6
recode college (.=0) if education==1
recode college (.=0) if education==2
recode college (.=0) if education==3
recode college (.=0) if education==4

*children in the house
generate kids=1 if num_people_under5_T2>0
recode kids (.=1) if num_people_5to17_T2>0
recode kids (.=0) if num_people_under5_T2==0 & num_people_5to17_T2==0

**comparison by key demographics
tabulate college food_sec_year_bin_T1 
tabulate college food_sec_covid_bin_T1 
tabulate college food_sec_last30_bin_T2

tabulate female food_sec_year_bin_T1 
tabulate female food_sec_covid_bin_T1 
tabulate female food_sec_last30_bin_T2

tabulate kids food_sec_year_bin_T1 
tabulate kids food_sec_covid_bin_T1 
tabulate kids food_sec_last30_bin_T2

tabulate race_bin_T1 food_sec_year_bin_T1 
tabulate race_bin_T1 food_sec_covid_bin_T1 
tabulate race_bin_T1 food_sec_last30_bin_T2

tabulate anyrecovery food_sec_year_bin_T1 
tabulate anyrecovery food_sec_covid_bin_T1 
tabulate anyrecovery food_sec_last30_bin_T2

**logits predicting ORs
logit food_sec_year_bin_T1 college, or
logit food_sec_covid_bin_T1 college, or
logit food_sec_last30_bin_T2 college, or

logit food_sec_year_bin_T1 female, or
logit food_sec_covid_bin_T1 female, or
logit food_sec_last30_bin_T2 female, or

logit food_sec_year_bin_T1 kids, or
logit food_sec_covid_bin_T1 kids, or
logit food_sec_last30_bin_T2 kids, or

logit food_sec_year_bin_T1 race_bin_T1, or
logit food_sec_covid_bin_T1 race_bin_T1, or
logit food_sec_last30_bin_T2 race_bin_T1, or

logit food_sec_year_bin_T1 jobrecovery, or
logit food_sec_covid_bin_T1 jobrecovery, or
logit food_sec_last30_bin_T2 jobrecovery, or

***JULY 25***** NEW ANALYSIS

**generate female
generate female=.
recode female (.=1) if gender_id_T1==2
recode female (.=0) if gender_id_T1==1

generate children=.
recode children (.=1)  if num_people_under5_T2 >0
recode children (.=1)  if num_people_5to17_T2 >0
recode children (.=0) if num_people_under5_T2==0
recode children (.=0) if num_people_5to17_T2==0

generate POC=.
recode POC (.=1) if race_bin_T1==0
recode POC (.=0) if race_bin_T1==1

*education bucket- college educated
generate college=1 if education_T1==5
recode college (.=1) if education_T1==6
recode college (.=0) if education_T1==1
recode college (.=0) if education_T1==2
recode college (.=0) if education_T1==3
recode college (.=0) if education_T1==4

generate nocollege=1 if education_T1==1
recode nocollege (.=1) if education_T1==2
recode nocollege (.=1) if education_T1==3
recode nocollege (.=1) if education_T1==4
recode nocollege (.=0) if education_T1==5
recode nocollege (.=0) if education_T1==6



** T2 food insecurity and demographic comparisons

logistic food_sec_last30_bin_T2 age_T1 [pweight = educgenweight]
logistic food_sec_last30_bin_T2 POC [pweight = educgenweight]
logistic food_sec_last30_bin_T2 urban_county_T1 [pweight = educgenweight]
logistic food_sec_last30_bin_T2 num_people_under5_T2 [pweight = educgenweight]
logistic food_sec_last30_bin_T2 num_people_5to17_T2 [pweight = educgenweight]
logistic food_sec_last30_bin_T2 children [pweight = educgenweight]
logistic food_sec_last30_bin_T2 female [pweight = educgenweight]
logistic food_sec_last30_bin_T2 loss_job_T1 [pweight = educgenweight]
logistic food_sec_last30_bin_T2 loss_job_last30_T2 [pweight = educgenweight]
logistic food_sec_last30_bin_T2 loss_job_today_T2 [pweight = educgenweight]
logistic food_sec_last30_bin_T2 money_sources_unemp_T2 [pweight = educgenweight]
logistic food_sec_last30_bin_T2 nocollege [pweight = educgenweight]

logistic prog_pantry_T2 age_T1 [pweight = educgenweight]
logistic prog_pantry_T2 POC [pweight = educgenweight]
logistic prog_pantry_T2 urban_county_T1 [pweight = educgenweight]
logistic prog_pantry_T2 children [pweight = educgenweight]
logistic prog_pantry_T2 female [pweight = educgenweight]
logistic prog_pantry_T2 loss_job_T1 [pweight = educgenweight]
logistic prog_pantry_T2 loss_job_last30_T2 [pweight = educgenweight]
logistic prog_pantry_T2 loss_job_today_T2 [pweight = educgenweight]
logistic prog_pantry_T2 money_sources_unemp_T2 [pweight = educgenweight]
logistic prog_pantry_T2 nocollege [pweight = educgenweight]

logistic prog_snap_T2 age_T1 [pweight = educgenweight]
logistic prog_snap_T2 POC [pweight = educgenweight]
logistic prog_snap_T2 urban_county_T1 [pweight = educgenweight]
logistic prog_snap_T2 children [pweight = educgenweight]
logistic prog_snap_T2 female [pweight = educgenweight]
logistic prog_snap_T2 loss_job_T1 [pweight = educgenweight]
logistic prog_snap_T2 loss_job_last30_T2 [pweight = educgenweight]
logistic prog_snap_T2 loss_job_today_T2 [pweight = educgenweight]
logistic prog_snap_T2 money_sources_unemp_T2 [pweight = educgenweight]
logistic prog_snap_T2 nocollege [pweight = educgenweight]

logistic prog_wic_T2 age_T1 [pweight = educgenweight]
logistic prog_wic_T2 POC [pweight = educgenweight]
logistic prog_wic_T2 urban_county_T1 [pweight = educgenweight]
logistic prog_wic_T2 children [pweight = educgenweight]
logistic prog_wic_T2 female [pweight = educgenweight]
logistic prog_wic_T2 loss_job_T1 [pweight = educgenweight]
logistic prog_wic_T2 loss_job_last30_T2 [pweight = educgenweight]
logistic prog_wic_T2 loss_job_today_T2 [pweight = educgenweight]
logistic prog_wic_T2 money_sources_unemp_T2 [pweight = educgenweight]
logistic prog_wic_T2 nocollege [pweight = educgenweight]

**now food secure and reasons
logistic nowfoodsec age_T1 [pweight = educgenweight]
logistic nowfoodsec POC [pweight = educgenweight]
logistic nowfoodsec urban_county_T1 [pweight = educgenweight]
logistic nowfoodsec children [pweight = educgenweight]
logistic nowfoodsec female [pweight = educgenweight]
logistic nowfoodsec loss_job_T1 [pweight = educgenweight]
logistic nowfoodsec loss_job_last30_T2 [pweight = educgenweight]
logistic nowfoodsec loss_job_today_T2 [pweight = educgenweight]
logistic nowfoodsec loss_no_today_T2 [pweight = educgenweight]
logistic nowfoodsec money_sources_unemp_T2 [pweight = educgenweight]
logistic nowfoodsec nocollege [pweight = educgenweight]
logistic nowfoodsec jobrecovery [pweight = educgenweight]
logistic nowfoodsec anyrecovery [pweight = educgenweight]
logistic nowfoodsec prog_pantry_T2 [pweight = educgenweight]
logistic nowfoodsec prog_snap_T2 [pweight = educgenweight]
logistic nowfoodsec prog_wic_T2 [pweight = educgenweight]
logistic nowfoodsec money_sources_friends_T2 [pweight = educgenweight]

**difference in worry by person- positive numbers indicate less worry in T2, 
**negative indicate more worry
generate worry_enoughfood_diff= worry_enoughfood_T1- worry_enoughfood_T2
generate worry_foodexp_diff= worry_foodexp_T1- worry_foodexp_T2
generate worry_foodunsafe_diff= worry_foodunsafe_T1- worry_foodunsafe_T2
generate worry_programs_diff= worry_programs_T1- worry_programs_T2
generate worry_income_diff= worry_income_T1- worry_income_T2
generate worry_housefood_diff= worry_housefood_T1- worry_housefood_T2

**relationship of nowfoodsec to worries difference
logistic nowfoodsec worry_enoughfood_diff [pweight = educgenweight]
logistic nowfoodsec worry_foodexp_diff [pweight = educgenweight]
logistic nowfoodsec worry_foodunsafe_diff [pweight = educgenweight]
logistic nowfoodsec worry_programs_diff [pweight = educgenweight]
logistic nowfoodsec worry_income_diff [pweight = educgenweight]
logistic nowfoodsec worry_housefood_diff [pweight = educgenweight]


**difference in challenges by person- positive numbers indicate less challenges in T2, 
**negative indicate more challenges
generate challenge_asmuch_diff= challenge_asmuch_T1-challenge_asmuch_T2
generate challenge_kinds_diff= challenge_kinds_T1-challenge_kinds_T2
generate challenge_findhelp_diff= challenge_findhelp_T1-challenge_findhelp_T2
generate challenge__moreplaces_diff= challenge_moreplaces_T1-challenge_moreplaces_T2
generate challenge__reducgroc_diff= challenge_reducgroc_T1-challenge_reducgroc_T2
generate challenge__close_diff= challenge_close_T1-challenge_close_T2

**relationship of nowfoodsec to challenges differences
logistic nowfoodsec challenge_asmuch_diff [pweight = educgenweight]
logistic nowfoodsec challenge_kinds_diff [pweight = educgenweight]
logistic nowfoodsec challenge_findhelp_diff [pweight = educgenweight]
logistic nowfoodsec challenge__moreplaces_diff [pweight = educgenweight]
logistic nowfoodsec challenge__reducgroc_diff [pweight = educgenweight]
logistic nowfoodsec challenge__close_diff [pweight = educgenweight]
