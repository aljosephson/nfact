* BEGIN * 

* Project: AZ COVID Food Security Survey, Economic consequences brief do file
* VERSION 2 - with ROUND 2 DATA 
* Created on 5 October 2020 
* Created by Freddy D.
* edits added by alj 
* updated 12 October 2021
* Stata v.16.1

* does
	* basic analysis with single tables, two way tables, and graphs 
	* analysis for brief on unemployment / economy in Arizona 
	
* assumes
	* standard - Stata v.16
	* have access to AZ survey dataset wave 2 ("AZ_wave2 (8_5_21)")
	* install catplot 
		*** (ssc install catplot) *** 

* TO DO:
	* analysis of any other variables that should be addressed

* ***********************************************************************
* 0 - Setup																*
* ***********************************************************************

	clear 
	*log close 
	
	*log using "C:\Users\aljosephson\Dropbox\COVID\COVID AZ Analysis and Briefs\Briefs\Round 2\Economy\alj_econ_brief2.smcl", append 
	*log using SAM'S PATHWAY  
	
* ***********************************************************************
* 1 - Importing data													*
* ***********************************************************************

	use 		"C:\Users\aljosephson\Dropbox\COVID\COVID AZ Analysis and Briefs\Data\2nd round\AZ_wave2 (8_5_21).dta"
	*save using SAM'S PATHWAY  

	
* ***********************************************************************
* 2 - single variable tables 										    *
* ***********************************************************************
		
* informational / context 

	tab			town, sort
	tab 		county, sort
	tab			year_born, sort
	tab 		age_estimate, sort
	tab 		income, sort
	tab			years_usa, sort
	tab 		know, sort
	
	tab 		num_people_under5 
	tab 		num_people_511,
	tab 		num_people_1217
	tab 		num_people_1865, 
	tab 		num_people_65up, 
	tab 		job_anychange 
	tab 		job_loss
	tab 		job_hours
	tab			job_furlo
	tab 		persp_open_econ
	tab			agecat
	tab 		RACE_ET
	tab			total_hh_num
	tab			FOOD_SECURITY_last4
	tab			FOOD_SECURITY_prior
	tab			FSS_prior
	tab 		FSS_since
	tab 		EDUC_comp
	
	tabstat		year_born total_hh_num, stat(min max mean p50) col(stat) 
 		
* ***********************************************************************
* 3 - two way variable tables										    *
* ***********************************************************************

* informational / context 

* job disruption and demographics

* JOB LOSS = complete loss of job 
	tab 		RACE_ET job_loss
	tab 		income job_loss
	tab 		years_usa job_loss
	tab		 	town job_loss
	tab 		EDUC_comp job_loss
	tab 		county job_loss 
	
* JOB CHANGE ANY = any status change in job 	
	tab 		RACE_ET job_anychange
	tab 		income job_anychange
	tab 		years_usa job_anychange
	tab			town job_anychange
	tab 		EDUC_comp job_anychange
	
* JOB HOURS = loss in job hours 	
	tab 		RACE_ET job_hours
	tab 		income job_hours
	tab 		years_usa job_hours
	tab		 	town job_hours
	tab 		EDUC_comp job_hours

* JOB FURLOUGH = furloughed from job 	
	tab 		RACE_ET job_furlo
	tab 		income job_furlo
	tab 		years_usa job_furlo
	tab		 	town job_furlo
	tab 		EDUC_comp job_furlo

* other demographics	
	tab 		income RACE_ET
	tab			income EDUC_comp
	tab 		Yes_Myself_dummy job_anychange
	
* food related 
	tab 		habits_throwless_usavg job_anychange
	tab 		habits_cook_usavg job_anychange
	
* ***********************************************************************
* 4 - graphs														    *
* ***********************************************************************
		
	catplot 	RACE_ET job_loss, percent(job_loss) asyvars stack subtitle(Percent of Job Loss by Race)
	
	catplot 	job_anychange RACE_ET, percent(RACE_ET) asyvars stack subtitle(Percent of any Change in Job Status by Race)
		
	graph 		hbar, over(job_loss) over(agecat) blabel(bar) title(Breakdown of Job Loss per Age Category)
	
	egen 		children_hh_dummy = anymatch (num_people_under5 num_people_511 num_people_1217), v(1/7)
	label 		define hh_child 0 "HH w/o Children" 1 "HH with Children"
	label 		values children_hh_dummy hh_child
	
	graph 		hbar, over(job_loss) over( children_hh_dummy ) blabel(bar) title(Breakdown of Job Loss by Households with children)
	
******* SAM STOP HERE !! **********	
	
* examine changes in job status 

* changes in employment status since the outbreak
** WILL BECOME FIG 0
	tab 		job_loss [aw=WEIGHTS] if job_anychange!=.
	tab 		job_hours [aw=WEIGHTS] if job_anychange!=.
	tab 		job_furlo [aw=WEIGHTS] if job_anychange!=.
	tab 		job_anychange [aw=WEIGHTS]

* changes in employment status since the outbreak by race/ethnicity (using a modified version of the race/ethnicity variable)
* create modified race / ethnicity variable 
	gen race_3 = .
	replace race_3 = 0 if RACE_ET == 0
	replace race_3 = 1 if RACE_ET == 1
	replace race_3 = 2 if race_3 == .
	label define race_3 0 "Hispanic" 1 "NH White" 2 "Other"
	label var race_3 "three category race variable"

** TRIAL FIGURE 1 **
	tab 		race_3 job_anychange  [aw=WEIGHTS], row

* changes in employment status since the outbreak by income group
** TRIAL FIGURE 2 ** 
	tab 		scrn_inc_4CAT job_anychange [aw=WEIGHTS], row

* include changes in food security associated with job changes 

* changes in food security by change in employment status  
** TRIAL FIGURE 3 ** 
	tab 		FOOD_SECURITY_last4 job_anychange [aw=WEIGHTS], col

	tabstat 	FOOD_SECURITY_last4 [aw=WEIGHTS], by(job_anychange) stat(mean)

* changes in food security by change in employment status by income group
** TRIAL FIGURE 4 **
	tabstat 	FOOD_SECURITY_last4 [aw=WEIGHTS] if job_anychange==1, by(scrn_inc_4CAT) stat(mean N)
	tabstat 	FOOD_SECURITY_last4 [aw=WEIGHTS] if job_anychange==0, by(scrn_inc_4CAT) stat(mean N)

* changes in food security by change in employment status by children in the hh
** TRIAL FIGURE 5 **
	tabstat 	FOOD_SECURITY_last4 [aw=WEIGHTS] if job_anychange==1, by(CHILDREN_inHH) stat(mean N)
	tabstat 	FOOD_SECURITY_last4 [aw=WEIGHTS] if job_anychange==0, by(CHILDREN_inHH) stat(mean N)

* changes in food security by change in employment status by race/ethnicity
** TRIAL FIGURE 6** 
	tabstat 	FOOD_SECURITY_last4 [aw=WEIGHTS] if job_anychange==1, by(race_3) stat(mean N)
	tabstat 	FOOD_SECURITY_last4 [aw=WEIGHTS] if job_anychange==0, by(race_3) stat(mean N)

* worries by job change
** TRIAL FIGURE 7 **

	tabstat worry_enoughfood_BIN [aw=WEIGHTS] , by(job_anychange) stat(mean N)
	tabstat worry_countryfood_BIN [aw=WEIGHTS] , by(job_anychange) stat(mean N)
	tabstat worry_foodunsafe_BIN [aw=WEIGHTS] , by(job_anychange) stat(mean N)
	tabstat worry_foodexp_BIN [aw=WEIGHTS] , by(job_anychange) stat(mean N)
	tabstat worry_housefood_BIN [aw=WEIGHTS] , by(job_anychange) stat(mean N)
	tabstat worry_income_BIN [aw=WEIGHTS] , by(job_anychange) stat(mean N)
	tabstat worry_programs_BIN [aw=WEIGHTS] , by(job_anychange) stat(mean N)	
	
* habits by job change
** TRIAL FIGURE 8 **

* WILL EXPLORE LATER

* ***********************************************************************
* 5 - FOR LATER														    *
* ***********************************************************************
	
*** THESE VARIABLES / QUESTIONS ARE NOT YET CLEANED FOR USE IN ROUND 2 DATA	
	/*

* for consideration later: food related worries - by change in job status 

	
* for later consideration: challenges - by change in job status  

*	tabstat challenge_asmuch 	 [aw=WEIGHTS] if challenge_asmuch!=88, 	   by(job_anychange) stat(mean N)
*	tabstat challenge_kinds 	 [aw=WEIGHTS] if challenge_kinds!=88, 	   by(job_anychange) stat(mean N )
*	tabstat challenge_findhelp 	 [aw=WEIGHTS] if challenge_findhelp!=88,   by(job_anychange) stat(mean N)
*	tabstat challenge_close 	 [aw=WEIGHTS] if challenge_close!=88, 	   by(job_anychange) stat(mean N)
*	tabstat challenge_reducgroc  [aw=WEIGHTS] if challenge_reducgroc!=88,  by(job_anychange) stat(mean N)
*	tabstat challenge_moreplaces [aw=WEIGHTS] if challenge_moreplaces!=88, by(job_anychange) stat(mean N)

*	bysort job_anychange: sum challenge_moreplaces [aw=WEIGHTS] if challenge_moreplaces!= 88

* for consideration later: strategies - by job change status 
* strat_accept_cur, strat_borrow_cur, strat_cheap_cur, strat_credit_cur 
	* strat_gobad_cur, strat_pantry_cur, strat_stretch_cur, strat_grow_cur
* and consideration of using these in the future 
* same variables as above but with _fut instead of _cur	

* for consideration later: habits - by job change 

	tabstat habits_buymore_my 	[aw=WEIGHTS], by(job_anychange) stat(mean N)
	tabstat habits_deliver_my 	[aw=WEIGHTS], by(job_anychange) stat(mean N)
	tabstat habits_donate_my 	[aw=WEIGHTS], by(job_anychange) stat(mean N)	
	tabstat habits_normal_my 	[aw=WEIGHTS], by(job_anychange) stat(mean N)
	tabstat habits_supply_my 	[aw=WEIGHTS], by(job_anychange) stat(mean N)
	tabstat habits_dist_my 		[aw=WEIGHTS], by(job_anychange) stat(mean N)
	tabstat habits_cook_my 		[aw=WEIGHTS], by(job_anychange) stat(mean N)
	tabstat habits_throwless_my [aw=WEIGHTS], by(job_anychange) stat(mean N)
	tabstat habits_throwmore_my [aw=WEIGHTS], by(job_anychange) stat(mean N)
	tabstat habits_volunteer_my [aw=WEIGHTS], by(job_anychange) stat(mean N)
	tabstat habits_mask_my 		[aw=WEIGHTS], by(job_anychange) stat(mean N) 

* for consideration later: what would help - by job change status  

*	tab helpful_transit     job_anychange [aw=WEIGHTS], miss  		
*	tab helpful_mealhours   job_anychange [aw=WEIGHTS], miss  		
*	tab helpful_extramoney  job_anychange [aw=WEIGHTS], miss  	
*	tab helpful_infprograms job_anychange [aw=WEIGHTS], miss  
*	tab helpful_morefood    job_anychange [aw=WEIGHTS], miss  	                                                         
*	tab helpful_trustfood   job_anychange [aw=WEIGHTS], miss                                                          
*	tab helpful_trustdeliv  job_anychange [aw=WEIGHTS], miss  	                                                        
*	tab helpful_truststores job_anychange [aw=WEIGHTS], miss  
*	tab helpful_costfood    job_anychange [aw=WEIGHTS], miss  

*/
	
* ***********************************************************************
* 6 - end matter													    *
* ***********************************************************************	

	compress
	
	save "C:\Users\aljosephson\Dropbox\COVID\COVID AZ Analysis and Briefs\Briefs\Round 2\Economy\R2-data_economy-brief.dta", replace 
	* save SAM'S PATHWAY
	
	log	close
	
* END * 