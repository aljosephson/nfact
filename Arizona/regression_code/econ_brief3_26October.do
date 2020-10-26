


* Project: AZ COVID Food Security Survey, Economic consequences brief do file
* Created on 10/5/2020
* Created by Freddy D.
* edits added by alj 
* Stata v.16.1


* does
	*drops vars that I dont think are needed for this brief
	*basic analysis with single tables, two way tables, and graphs. 
	* My own comments or questions are denoted by /*

	
* assumes
	* standard - Stata v.16
	* have access to AZ survey dataset wave 1 (10_5_20)

	
* TO DO:
	* weighting some of the results where needed
	* mapping?
	* analysis of any other variables that should be addressed
	* suggestions for any other analysis 

* ***********************************************************************
* 0 - Setup																*
* ***********************************************************************
	/* commented out in case im missing something here
	
	cd "C:Users\dries\Dropbox\COVID AZ Analysis and Briefs\Briefs\Brief Analysis\3. Economy
	log using "fd_econ_brief", append
	
	*/
* ***********************************************************************
* 1 - Importing data													*
* ***********************************************************************

	*use 		"C:\Users\dries\Dropbox\COVID AZ Analysis and Briefs\Data - Stata code\1. Dataset preparation\AZ_wave1 - step 1 (10_5_20).dta"
	use 		"C:\Users\aljosephson\Dropbox\COVID\COVID AZ Analysis and Briefs\Briefs\Brief Analysis\3. Economy\AZ_wave1 - step 1 (10_7_20).dta"

* ***********************************************************************
* 2 - Condense/drop variables											*
* ***********************************************************************

	/*	I started out by focusing on jobs and demographics, so this drops most of 
		the other vars. I commented out some of it in case there is another
		variable of interest that should I should be looking at. - alj mute for now  
	
	drop 		startdate 
	drop 		enddate 
	drop 		status 
	drop 		ipaddress 
	drop 		progress 
	drop 		durationinseconds 
	drop 		finished 		
	drop 		recordeddate 
	drop 		locationlatitude 
	drop 		locationlongitude 
	drop 		distributionchannel 
	drop 		userlanguage 
	drop 		resp_consent 
	drop 		scrn_lived_AZ 
	drop 		scrn_age_group 
	drop 		qs7 
	drop 		text_scrn_genderid 
	drop 		scrn_hisplat_origin 
	drop 		qs9
	drop 		text_scrn_race
	drop 		scrn_educ 
	drop 		scrn_income
	drop 		text_source_yr
	drop 		text_source_covid
	drop 		text_prog_yr
	drop 		text_prog_covid
	drop 		text_othercomments_snap
	drop 		text_othercomments_wic
	drop 		text_othercomments_pebt 
	drop 		text_othercomments_pantry
	drop 		text_trans_addltypesyr
	drop 		text_trans_addltypescovid
	drop 		text_challenge_foodwant
	drop 		text_challenge_foodget
	drop 		text_challenge_standclose
	drop 		text_helpful 
	drop 		helpful_howmuch
	drop 		text_worry
	drop 		opp 
	drop 		risn
	drop 		rid
	drop 		v
	drop 		ls 
	drop 		rnid
	drop 		study
	drop 		pid
	drop 		psid 
	drop 		k2 
	drop 		uig 
	drop 		med 
	drop 		q_totalduration
	drop 		qpmid 
	drop 		gc 
	drop 		term 
	drop 		scrn_genderid
	drop 		scrn_race
	
	*drop strat_accept_fut_temp strat_borrow_fut_temp strat_cheap_fut_temp strat_credit_fut_temp strat_gobad_fut_temp strat_pantry_fut_temp strat_stretch_fut_temp strat_grow_fut_temp strat_otherbin_fut_temp text_strat_fut_temp text_diet_special diet_change_allergy diet_change_sensitive diet_change_health diet_change_religion diet_veg diet_weight diet_other diet_other_text diet_special_no persp_me persp_us persp_vt persp_flu persp_action persp_foodsource persp_prepared persp_packages persp_foodsupply persp_strike q25 political text_political other_comments source_conv source_spec source_grocdel source_mealdel source_mow source_restdel source_restin source_prog source_group source_farmmkt source_localfrm source_grow source_otherbin source_groc_prior source_conv_prior source_spec_prior source_grocdel_prior source_mealdel_prior source_mow_prior source_restdel_prior source_restin_prior source_prog_prior source_group_prior source_farmmkt_prior source_localfrm_prior source_grow_prior source_otherbin_prior  source_conv_since source_spec_since source_grocdel_since source_mealdel_since source_mow_since source_restdel_since source_restin_since source_prog_since source_group_since source_farmmkt_since source_localfrm_since source_grow_since source_otherbin_since usda_foodlast_year usda_afford_year usda_foodlast_covid usda_afford_covid usda_eatless_year usda_eatless_covid usda_cutskip_year usda_cutskip_covid usda_hungry_year usda_hungry_covid usda_oftencut_year usda_oftencut_covid count_miss_usda_since count_miss_usda_prior prog_snap prog_wic prog_school prog_pantry prog_other prog_snap_prior prog_wic_prior prog_school_prior prog_pantry_prior prog_other_prior prog_snap_since prog_wic_since prog_school_since prog_pantry_since prog_other_since snap_easy snap_enough snap_online snap_unable wic_easy wic_limited wic_unable wic_online school_helpful school_notopen school_kitchen school_hard school_time school_place school_runout school_pebt pantry_helpful pantry_foodlike pantry_foodquality pantry_foodprepare pantry_runsout pantry_hours pantry_lines pantry_limits foodprog_paperwork foodprog_indep foodprog_travel foodprog_assets foodprog_stigma trans_bus trans_vehicle trans_friend trans_taxi trans_bringfood trans_walk trans_otherbin trans_bus_dummy_1 trans_bus_dummy_2 trans_bus_dummy_3 trans_bus_dummy_4 trans_vehicle_dummy_1 trans_vehicle_dummy_2 trans_vehicle_dummy_3 trans_vehicle_dummy_4 trans_friend_dummy_1 trans_friend_dummy_2 trans_friend_dummy_3 trans_friend_dummy_4 trans_taxi_dummy_1 trans_taxi_dummy_2 trans_taxi_dummy_3 trans_taxi_dummy_4 trans_bringfood_dummy_1 trans_bringfood_dummy_2 trans_bringfood_dummy_3 trans_bringfood_dummy_4 trans_walk_dummy_1 trans_walk_dummy_2 trans_walk_dummy_3 trans_walk_dummy_4 trans_otherbin_dummy_1 trans_otherbin_dummy_2 trans_otherbin_dummy_3 trans_otherbin_dummy_4 challenge_asmuch challenge_kinds challenge_findhelp challenge_moreplaces challenge_close challenge_reducgroc helpful_transit helpful_mealhours helpful_extramoney helpful_infprograms helpful_morefood helpful_trustfood helpful_trustdeliv helpful_truststores helpful_costfood helpful_bin worry_enoughfood worry_countryfood worry_foodexp worry_foodunsafe worry_programs worry_income worry_housefood strat_accept_cur strat_borrow_cur strat_cheap_cur strat_credit_cur strat_gobad_cur strat_pantry_cur strat_stretch_cur strat_grow_cur strat_otherbin_cur text_strat_cur strat_accept_fut strat_borrow_fut strat_cheap_fut strat_credit_fut strat_gobad_fut strat_pantry_fut strat_stretch_fut strat_grow_fut strat_otherbin_fut text_strat_fut diet_special diet_special_d1 diet_special_d2 diet_special_d3 diet_special_d4 diet_special_d5 diet_special_d6 diet_special_d7 diet_special_d8 diet_challenge habits_deliver_my habits_deliver_usavg habits_donate_my habits_donate_usavg habits_supply_my habits_supply_usavg habits_dist_my habits_dist_usavg habits_volunteer_my habits_volunteer_usavg habits_mask_my habits_mask_usavg worry_enoughfood_BIN worry_countryfood_BIN worry_foodexp_BIN worry_foodunsafe_BIN worry_housefood_BIN worry_income_BIN worry_programs_BIN */


	
	

* ***********************************************************************
* 3 - Single variable tables										    *
* ***********************************************************************

	/* 	These are just tables looking at some of the single variables I thought
		were important. Some of these can be pretty long, so I dont think that
		the entire table should be included in the brief, but some of it may be
		useful. Same goes for the two variable tables. */
		
	tab 		occupation, sort	
	tab			town, sort
	tab 		county, sort
	tab			year_born, sort
	tab 		age_estimate, sort
	tab 		income, sort
	tab			years_usa, sort
	tab 		know, sort
	tab 		money, sort
	
	tab 		num_people_under5 
	tab 		num_people_517, 
	tab 		num_people_1865, 
	tab 		num_people_65up, 
	tab 		job_anychange 
	tab 		job_loss
	tab 		job_hours
	tab			job_furlo
	tab 		persp_open_econ
	tab 		ethnicity
	tab			agecat
	tab			race
	tab 		RACE
	tab			total_hh_num
	tab			FOOD_SECURITY_since
	tab			FOOD_SECURITY_prior
	tab			FSS_prior
	tab 		FSS_since
	tab 		EDUC_comp
	
	tabstat		year_born total_hh_num, stat(min max mean p50) col(stat) 
 		

* ***********************************************************************
* 5 - Two way variable tables										    *
* ***********************************************************************

	/* 	"by : tabulate" also works, and breaks it down a little differently
		then what is below but I didn't want to include all the different "sort"
		commands so I have it like this for now. */
		
		
* job disruption and demographics

	tab 		occupation job_loss
	tab 		race job_loss 
	tab 		RACE job_loss
	tab 		income job_loss
	tab 		years_usa job_loss
	tab		 	town job_loss
	tab 		EDUC_comp job_loss
	tab 		county job_loss 
	
	tab 		occupation job_anychange
	tab 		race job_anychange
	tab 		RACE job_anychange
	tab 		income anychange
	tab 		years_usa any change
	tab			town job_anychange
	tab 		EDUC_comp job_anychange
	
	tab 		occupation job_hours
	tab 		race job_hours 
	tab 		RACE job_hours
	tab 		income job_hours
	tab 		years_usa job_hours
	tab		 	town job_hours
	tab 		EDUC_comp job_hours

	tab 		occupation job_furlo
	tab 		race job_furlo
	tab 		RACE job_furlo
	tab 		income job_furlo
	tab 		years_usa job_furlo
	tab		 	town job_furlo
	tab 		EDUC_comp job_furlo

* other demographics	
	
	tab 		income RACE
	tab			income EDUC_comp
	tab 		Yes_Myself_dummy job_anychange
	
* food related 
	tab 		habits_throwless_usavg job_anychange
	tab 		habits_cook_usavg job_anychange
	
	
	
* ***********************************************************************
* 6 - Graphs														    *
* ***********************************************************************
 
	/* 	installed the catplot command to make one of the graphs I used. These
		graphs aren't final, but just an example. So things like labels arent
		added */
	
	*ssc 		inst catplot
		

	catplot 	RACE job_loss, percent(job_loss) asyvars stack subtitle(Percent of Job Loss by Race)
	
	catplot 	job_anychange RACE, percent(RACE) asyvars stack subtitle(Percent of any Change in Job Status by Race)
	
	histogram 	FOOD_SECURITY_3CAT, bin(3) by(job_anychange)
	
	graph 		hbar, over(job_loss) over(agecat) blabel(bar) title(Breakdown of Job Loss per Age Category)
	/* 	a suggestion was made to change this graph and the graph below was
		my interpretation of the comment. It doesnt include everything that was 
		mentioned, but I wanted to see if this was along the lines of what was
		being asked.*/
	
	egen 		children_hh_dummy = anymatch (num_people_under5 num_people_517), v(1/7)
	label 		define hh_child 0 "HH w/o Children" 1 "HH with Children"
	label 		values children_hh_dummy hh_child
	graph 		hbar, over(job_loss) over( children_hh_dummy ) blabel(bar) title(Breakdown of Job Loss by Households with children)
	
	/* 	 added - alj 10 10 20 */
	
* examine changes in job status 

* changes in employment status since the outbreak

	tab 		job_loss [aw=WEIGHTS] if job_anychange!=.
	tab 		job_hours [aw=WEIGHTS] if job_anychange!=.
	tab 		job_furlo [aw=WEIGHTS] if job_anychange!=.
	tab 		job_anychange [aw=WEIGHTS]
*** do we report these as figures, rather than as visualizations? 
*** freddy would you see if there is a good way to include visualizations for the changes in job status variables 

* changes in employment status since the outbreak by race/ethnicity (using a modified version of the race/ethnicity variable)
** TRIAL FIGURE 1 **
	tab 		race_temp job_anychange  [aw=WEIGHTS], row

* changes in employment status since the outbreak by income group
** TRIAL FIGURE 2 ** 
	tab 		scrn_inc_4CAT job_anychange [aw=WEIGHTS], row

* include changes in food security associated with job changes 

* changes in food security by change in employment status  
** TRIAL FIGURE 3 ** 
	tab 		FOOD_SECURITY_since job_anychange [aw=WEIGHTS], col

	tabstat 	FOOD_SECURITY_since [aw=WEIGHTS], by(job_anychange) stat(mean)

* changes in food security by change in employment status by income group
** TRIAL FIGURE 4 **
	tabstat 	FOOD_SECURITY_since [aw=WEIGHTS] if job_anychange==1, by(scrn_inc_4CAT) stat(mean N)
	tabstat 	FOOD_SECURITY_since [aw=WEIGHTS] if job_anychange==0, by(scrn_inc_4CAT) stat(mean N)

* changes in food security by change in employment status by children in the hh
** TRIAL FIGURE 5 **
	tabstat 	FOOD_SECURITY_since [aw=WEIGHTS] if job_anychange==1, by(CHILDREN_inHH) stat(mean N)
	tabstat 	FOOD_SECURITY_since [aw=WEIGHTS] if job_anychange==0, by(CHILDREN_inHH) stat(mean N)

* changes in food security by change in employment status by race/ethnicity
** TRIAL FIGURE 6** 
	tabstat 	FOOD_SECURITY_since [aw=WEIGHTS] if job_anychange==1, by(RACE_ET) stat(mean N)
	tabstat 	FOOD_SECURITY_since [aw=WEIGHTS] if job_anychange==0, by(RACE_ET) stat(mean N)

* TRIAL FIGURES 1 - 6 LOOK GOOD 
* A FEW MORE BELOW FOR CONSIDERATION 

* worries - by change in job status
* TRIAL FIGURE 7
*** similar to Francesco's figure 6 in national brief 
	tabstat worry_enoughfood_BIN  [aw=WEIGHTS] if worry_enoughfood_BIN!=88, by(job_anychange) stat(mean N)
	tabstat worry_countryfood_BIN  [aw=WEIGHTS] if worry_countryfood_BIN!=88, by(job_anychange) stat(mean N)
	tabstat worry_foodunsafe_BIN  [aw=WEIGHTS] if worry_foodunsafe_BIN!=88, by(job_anychange) stat(mean N)
	tabstat worry_foodexp_BIN  [aw=WEIGHTS] if worry_foodexp_BIN!=88, by(job_anychange) stat(mean N)
	tabstat worry_housefood_BIN  [aw=WEIGHTS] if worry_housefood_BIN!=88, by(job_anychange) stat(mean N)
	tabstat worry_income_BIN  [aw=WEIGHTS] if worry_income_BIN!=88, by(job_anychange) stat(mean N)
	tabstat worry_programs_BIN  [aw=WEIGHTS] if worry_programs_BIN!=88, by(job_anychange) stat(mean N)
	
* challenges - by change in job status  
* TRIAL FIGURE 8
	tabstat challenge_asmuch 	 [aw=WEIGHTS] if challenge_asmuch!=88, 	   by(job_anychange) stat(mean N)
	tabstat challenge_kinds 	 [aw=WEIGHTS] if challenge_kinds!=88, 	   by(job_anychange) stat(mean N )
	tabstat challenge_findhelp 	 [aw=WEIGHTS] if challenge_findhelp!=88,   by(job_anychange) stat(mean N)
	tabstat challenge_close 	 [aw=WEIGHTS] if challenge_close!=88, 	   by(job_anychange) stat(mean N)
	tabstat challenge_reducgroc  [aw=WEIGHTS] if challenge_reducgroc!=88,  by(job_anychange) stat(mean N)
	tabstat challenge_moreplaces [aw=WEIGHTS] if challenge_moreplaces!=88, by(job_anychange) stat(mean N)

	
	*bysort job_anychange: sum challenge_moreplaces [aw=WEIGHTS] if challenge_moreplaces!= 88

* for consideration later: strategies - by job change status 
* strat_accept_cur, strat_borrow_cur, strat_cheap_cur, strat_credit_cur 
	* strat_gobad_cur, strat_pantry_cur, strat_stretch_cur, strat_grow_cur
* and consideration of using these in the future 
* same variables as above but with _fut instead of _cur	

* for consideration later: habits - by job change 
* TRIAL FIGURE 9
*** similar to Francesco's figure 7 in national brief 
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
* TRIAL FIGURE 10
*** similar to Francesco's figure 8 
	tab helpful_transit     job_anychange [aw=WEIGHTS], miss  		
	tab helpful_mealhours   job_anychange [aw=WEIGHTS], miss  		
	tab helpful_extramoney  job_anychange [aw=WEIGHTS], miss  	
	tab helpful_infprograms job_anychange [aw=WEIGHTS], miss  
	tab helpful_morefood    job_anychange [aw=WEIGHTS], miss  	                                                         
	tab helpful_trustfood   job_anychange [aw=WEIGHTS], miss                                                          
	tab helpful_trustdeliv  job_anychange [aw=WEIGHTS], miss  	                                                        
	tab helpful_truststores job_anychange [aw=WEIGHTS], miss  
	tab helpful_costfood    job_anychange [aw=WEIGHTS], miss  

	
* ***********************************************************************
* 6 - end matter													    *
* ***********************************************************************	
	
	
	/*
	compress
	
	log	close
	
	 END */
	 
	 