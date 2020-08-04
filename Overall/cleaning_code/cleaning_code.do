* project: food security & covid
* created on: July 2020
* created by: fd + lm 
* edited by: alj 
* last edited: 4 august 2020 
* Stata v.15.1 / 16 

* does
	* inputs Temp/az_dummy_sample_19July.dta
		*** update with your sample 
	* cleans qualtrics response data
	* outputs as 
		*** update with output information 

* assumes
	* update with appropriate commands
	* files ? 

* to do:
	* formatting
	* var Q11 help
	* var Q25 help
	* missing values as -99 or "."?
	* gen food security scores and screener comparison

* **********************************************************************
* 0 - setup
* **********************************************************************

* set cd 
	clear					all
	cd 						"/Users/lauramccann/Box"

* ***********************************************************************
* 1 - prepare exported data
* ***********************************************************************

* load data
* load your own data - currently loading dummy sample from arizona 
	use						"az_dummy_sample_19July.dta", clear

* drop Qualtrics survey metadata
	
	drop					RecipientLastName RecipientFirstName ///
							RecipientEmail ExternalReference ResponseId
							
* rename and label intro/screener variables 							
	rename					Qs3 resp_consent
	label var				resp_consent "Respondent Consent"
	rename					Qs5 scrn_lived_AZ
	label var				scrn_lived_AZ "Screen: Lived in AZ since 1/1/2020"
	rename					Qs6 scrn_age_group
	label var				scrn_age_group "Screen: Age Group"
	rename					Qs7 scrn_genderid
	label var				scrn_genderid "Screen: Gender Identity"
	rename					Qs7_5_TEXT text_scrn_genderid
	label var				text_scrn_genderid "Screen: Text: Gender ID"
	rename					Qs8	scrn_hisplat_origin
	label var				scrn_hisplat_origin "Screen: Hispanic, Latino, or Spanish Origin"
	rename 					Qs9 scrn_race
	label var				scrn_race "Screen: Race"
	rename 					Qs9_5_TEXT text_scrn_race
	label var				text_scrn_race "Screen: Text: Race"
	rename 					Qs10 scrn_educ
	label var				scrn_educ "Screen: Education"
	rename					Qs11 scrn_income
	label var				scrn_income "Screen: Income"
	
	
* ***********************************************************************
* 2 - Internal Consistency and screener questions. "MS" indicates response
* 	  allows for multiple selections
* ***********************************************************************	

** Joelle's doing this -- will insert code later

* ***********************************************************************
* 3 - Part 1/5: General Food Access
*     Created by: lem, Joelle
*	  last updated: 07_31_2020
* ***********************************************************************	

* Item 1 (Qualtrics var name "Q1"): Which of the following places did your 
* household use to get food in the last year and since the COVID-19 outbreak 
* (March 11th)? 


* checkthis combined values 1 and 2 for "No change" category ok?
* Note: "No Change" incicates use both in the year before and since COVID" 

* rename text response vars to keep them out of encoding loop below

	rename 				source_othertxt_1 text_source_yr
	rename 				source_othertxt_2 text_source_covid

* label food acquisition vars
	* vars commented out if not in practice data set but included in AZ survey
	
	lab var 			source_groc "Source: Grocery"
	lab var 			source_conv "Source: Convienience"
	lab var 			source_spec "Source: Specialty"
	lab var 			source_grocdel "Source: Grocery Delivery"
	lab var 			source_mealdel "Source: Meal Kit Delivery"
	lab var 			source_MoW "Source: Meals on Wheels"
	lab var 			source_restdel "Source: Resturant Delivery"
	lab var 			source_restin "Source: Restaurant Eat In"
	lab var 			source_prog "Source: Food Programs"
	lab var 			source_group  "Source: Congregate"
	lab var 			source_farmmkt "Source: Farm Market"
	lab var 			source_localfrm "Source: CSA"
	*lab var 			source_garden "Source: CSA"
	*lab var 			source_fish "Source: Fish"
	*lab var 			source_hunt "Source: Hunt"
	*lab var 			source_forage "Source: Forage"
	lab var				text_source_yr "Additional sources (year)"
	lab var				text_source_covid "Additional sources (COVID)"

	
* loop to recode, appends "temp" to source vars and renames encoded vars

	foreach v of varlist source* {    
	   rename 			`v' `v'_temp
	   encode 			`v'_temp, gen(`v') 
	   replace			`v' = .
	   replace 			`v' = 1 if `v'_temp == "1,2" 
	   replace 			`v' = 2 if `v'_temp == "1"
	   replace 			`v' = 3 if `v'_temp == "2"
	   replace 			`v' = 4 if `v'_temp == "3"
	   lab def 			`v'_lab1  1 "No Change" 2 "Stopped Since COVID" 3 ///
							"Started Since COVID" 4 "Never Used" 
	   lab val 			`v'  `v'_lab1
	   }	
	
* drop temp vars
	drop 				*_temp	   
	
* creation of dummy var
	tab 				source_groc, gen(source_groc_dummy_)
	tab 				source_conv, gen(source_conv_dummy_)
	tab 				source_spec, gen(source_spec_dummy_)
	tab 				source_grocdel, gen(source_grocdel_dummy_)
	tab 				source_mealdel, gen(source_mealdel_dummy_)
	tab 				source_MoW , gen(source_MoW_dummy_)
	tab 				source_restdel, gen(source_restdel_dummy_)
	tab 				source_restin, gen(source_restin_dummy_)
	tab 				source_prog, gen(source_prog_dummy_)
	tab 				source_group, gen( source_group_dummy_)
	tab 				source_farmmkt, gen( source_farmmkt_dummy_)
	tab 				source_localfrm, gen( source_localfrm_dummy_)
	tab 				source_grow, gen( source_grow_dummy_)
	tab 				source_otherbin, gen( source_otherbin_dummy_)

* Item 2A (Qualtrics var names "Q2#covid" & "Q2#year"): How true are these 
* statements about your household’s food situation in the year before the 
* COVID-19 outbreak and since the COVID-19 outbreak on March 11th? 

* --> The food that my household bought just didn't last, and I/we didn't 
* have money to get more (year before, since covid)
* --> I/we couldn't afford to eat balanced meals (year before/year since)

* same process as above; label variables

	lab var				usda_foodlast_year "USDA: Food didn't last (year)"
	lab var				usda_foodlast_covid  "USDA: Food didn't last (since COVID)"
	lab var				usda_afford_year "USDA: Can't afford to eat (year)"
	lab var				usda_afford_covid "USDA: Can't afford to eat (COVID)"

* gen temp variables, fill in and encode, label values
	foreach v of varlist usda_foodlast* usda_afford*{
		rename 			`v' `v'_temp
		encode 			`v'_temp, gen(`v')
		replace 		`v' = .		  
		replace 		`v' = 1 if `v'_temp == "1" 
	    replace 		`v' = 2 if `v'_temp == "2"
	    replace 		`v' = 3 if `v'_temp == "3"
		label def 		`v'_lab2_1 1 "Never true" 2 "Sometimes true" ///
							3 "Often true"
		label values 	`v' `v'_lab2_1
          }

* checkthis how does this need to be analyzed because it seems like we're 
* going to need a "No change" variable, but that will be tricky +add in labels

		  
* Item 2B: (Qualtrics var name "Q2b#covid" and "Q2b#year"): How often did you 
* cut the size of your meals or skip meals?

	rename				usda_oftencut_year usda_oftencut_year_temp
	encode 				usda_oftencut_year_temp, gen (usda_oftencut_year)
	lab def				oftencutyr 1 "Only 1 or 2 months" ///
							2 "Some months but not every month" ///
							3 "Almost every month" 99  "I don't know"
	lab values			usda_oftencut_year oftencut_yr
	lab var				usda_oftencut_year "USDA: Often Cut Meals (Yr)"
	drop				usda_oftencut_year_temp
		
	rename				usda_oftencut_covid usda_oftencut_covid_temp
	encode 				usda_oftencut_covid_temp, gen (usda_oftencut_covid)
	lab def				oftencutcv 1 "Once" 2 "Twice" 3 "Weekly" 4 "Daily"
	lab values			usda_oftencut_covid oftencut_cv
	lab var				usda_oftencut_covid "USDA: Often Cut Meals (Since Covid)"
	drop				usda_oftencut_covid_temp

* Item 3 (Qualtrics var name "Q3"): Which of the following food assistance 
* programs did your household use in the past, if any, and since the COVID-19 
* outbreak (March 11)? 

* rename text response vars to keep them out of encoding loop below

	rename				prog_othertxt_1 text_prog_yr
	rename				prog_othertxt_2 text_prog_covid
	
* label prog vars

	lab var 			prog_snap "SNAP Participation"
	lab var			    prog_wic "WIC Particpation"
	lab var 			prog_school "School Foods Participation"
	lab var 			prog_pantry "Food Pantry Participation"
	lab var				prog_other "Other Participation"
	lab var				text_prog_yr "Text: Other programs (Yr)"
	lab var				text_prog_covid "Text: Other programs (Covid)"
		

* loop to recode, appends "temp" to source vars and renames encoded vars
	
	foreach v of varlist prog_* {    
		rename `v' `v'_temp
		encode `v'_temp, gen (`v') 
		replace			`v' = .
		replace 		`v' = 1 if `v'_temp == "1,2" 
		replace 		`v' = 2 if `v'_temp == "1"
		replace 		`v' = 3 if `v'_temp == "2"
		replace 		`v' = 4 if `v'_temp == "3"
		lab def 		`v'_lab3  1 "No Change" 2 "Stopped Since COVID" 3 ///
						"Started Since COVID" 4 "Never Used" 
		lab val 		`v'  `v'_lab3
	   }	

* drop temp vars
	drop 				*_temp	   

* creation of dummy var
	tab 				prog_snap, gen(prog_snap_dummy_)
	tab 				prog_wic, gen( prog_wic_dummy_)
	tab 				prog_school, gen( prog_school_dummy_)
	tab 				prog_pantry, gen ( prog_pantry_dummy_)
	tab 				prog_other, gen(prog_other_dummy_)

* Item 3A (Qualtrics var name "Q3a"): Please indicate your level of agreement 
* regarding using SNAP (or Food Stamps) food benefits since the COVID-19 
* outbreak.


* rename text response vars to keep them out of encoding loop below

	rename				Q3atxt text_othercomments_snap
	rename 				snap_usefull snap_useful
	
* label SNAP vars

	lab var 			snap_easy "SNAP: Participation"
	lab var				snap_enough "SNAP: Enough"
	lab var				snap_online "SNAP: Online"
	lab var				snap_useful "SNAP: Useful"
	lab var				text_othercomments_snap "Other comments: SNAP"

* loop to recode, appends "temp" to source vars and renames encoded vars
	
	foreach v of varlist snap_* {    
	   rename 		`v' `v'_temp
	   encode 		`v'_temp, gen (`v') 
	   replace		`v' = .
	   replace 		`v' = 1 if `v'_temp == "1" 
	   replace 		`v' = 2 if `v'_temp == "2"
	   replace 		`v' = 3 if `v'_temp == "3"
	   replace 		`v' = 4 if `v'_temp == "4"
	   replace 		`v' = 5 if `v'_temp == "5" 
	   replace 		`v' = 99 if `v'_temp == "99" 
	   lab def 		`v'_lab3a  1 "Strongly disagree" 2 "Disagree" ///
						3 "Neither agree nor disagree" 4 "Agree" ///
						5 "Strongly agree" 99 "I don't know"
	   lab val 		`v'  `v'_lab3a
	   }	

* drop temp vars
	drop 				*_temp	   

	
* Item 3B (Qualtrics var name "Q3b") : Please indicate your level of agreement 
* regarding using WIC benefits since the COVID-19 outbreak.


* rename text response vars to keep them out of encoding loop below

	rename				Q3btxt text_othercomments_wic
	
* label WIC vars

	lab var 			wic_easy "WIC Participation"
	lab var				wic_limited "WIC Limited"
	lab var				wic_online "WIC Online"
	lab var				wic_usefull "WIC Useful"
	lab	var				text_othercomments_wic "Other Comments: WIC"

* loop to recode, appends "temp" to source vars and renames encoded vars
	
	foreach v of varlist wic_* {    
	   rename `v' `v'_temp
	   encode `v'_temp, gen (`v') 
	   replace		`v' = .
	   replace 		`v' = 1 if `v'_temp == "1" 
	   replace 		`v' = 2 if `v'_temp == "2"
	   replace 		`v' = 3 if `v'_temp == "3"
	   replace 		`v' = 4 if `v'_temp == "4"
	   replace 		`v' = 5 if `v'_temp == "5" 
	   replace 		`v' = 99 if `v'_temp == "I don't know" 
		lab def 		`v'_lab3b  1 "Strongly disagree" 2 "Disagree" ///
		3 "Neither agree nor disagree" 4 "Agree" 5 "Strongly agree" 99 "I don't know"
	   lab val 		`v'  `v'_lab3b
	   }	

* drop temp vars
	drop 				*_temp	   



* Item 3C (Qualtrics var name "Q3c"): Please indicate your level of agreement 
* regarding using School Meals for children in your household since the 
* COVID-19 outbreak.


* rename text response vars to keep them out of encoding loop below

	rename				Q3ctxt text_othercomments_pebt

* label school vars

	lab var 			school_helpful "School: Helpful"
	lab var				school_notopen "School: Not Open"
	lab var				school_kitchen "School: No Kitchen Eqp"
	lab var				school_hard "School: Meal Deliv. Hard to Arrange"
	lab var 			school_time "School: Inconvenient time"
	lab var				school_place "School: Inconvenient location"
	lab var				school_runout "School: Run out of meals before next time"
	lab var				school_PEBT "School: PEBT card is helpful"
	lab var				text_othercomments_pebt "Other Comments: PEBT"
	

* loop to recode, appends "temp" to source vars and renames encoded vars
	
foreach v of varlist school_* {    
	   rename `v' `v'_temp
	   encode `v'_temp, gen (`v') 
	   replace			`v' = .
	   replace 			`v' = 1 if `v'_temp == "1" 
	   replace 			`v' = 2 if `v'_temp == "2"
	   replace 			`v' = 3 if `v'_temp == "3"
	   replace 			`v' = 4 if `v'_temp == "4"
	   replace 			`v' = 5 if `v'_temp == "5" 
	   replace 			`v' = 99 if `v'_temp == "I don't know" 
	 lab def 			`v'_lab3c  1 "Strongly disagree" 2 "Disagree" 3 "Neither agree nor disagree" 4 "Agree" 5 "Strongly agree" 99 "I don't know"
	   lab val 			`v'  `v'_lab3c
	   }	

* drop temp vars
	drop 				*_temp	   
	
	
	

* Item 3D (Qualtrics var name "Q3d") : Please indicate your level of agreement 
* regarding using a food pantry/food bank since the COVID-19 outbreak.


* rename text response vars to keep them out of encoding loop below

	rename				Q3dtxt text_othercomments_pantry

* label pantry vars

	lab var			    pantry_helpful "Food Pantry: Food offered is helpful"
	lab var			    pantry_foodlike "Food Pantry: Does not have food we like"
	lab var			    pantry_foodquality "Food Pantry: No good quality food"
	lab var			    pantry_foodprepare "Food Pantry: Don't know how to prepare"
	lab var			    pantry_runsout "Food Pantry: Runs out often"
	lab var			    pantry_hours "Food Pantry: Hrs inconvenient/irregular"
	lab var			    pantry_lines "Food Pantry: Long lines and wait"
	lab var			    pantry_limits "Food Pantry: Limited visits"
	lab var				text_othercomments_pantry "Other Comments: Pantry"
	
	
	
* loop to recode, appends "temp" to source vars and renames encoded vars
	
foreach v of varlist pantry_* {    
	   rename `v' `v'_temp
	   encode `v'_temp, gen (`v') 
	   replace			`v' = .
	   replace 			`v' = 1 if `v'_temp == "1" 
	   replace 			`v' = 2 if `v'_temp == "2"
	   replace 			`v' = 3 if `v'_temp == "3"
	   replace 			`v' = 4 if `v'_temp == "4"
	   replace 			`v' = 5 if `v'_temp == "5" 
	   replace 			`v' = 99 if `v'_temp == "I don't know" 
 lab def 			`v'_lab3d  1 "Strongly disagree" 2 "Disagree" 3 "Neither agree nor disagree" 4 "Agree" 5 "Strongly agree" 99 "I don't know"
	   lab val 			`v'  `v'_lab3d
	   }	

* drop temp vars
	drop 				*_temp	   
	
	
* Item 3E (Qualtrics var name "Q3e") : Please indicate your level of agreement
* regarding concerns and barriers to using income-based food programs and food 
* pantries since the COVID-19 outbreak.
	
* label prog vars

	lab var			    foodprog_paperwork "Food Programs: Worried about paperwork"
	lab var			    foodprog_indep "Food Programs: Don't want to rely"
	lab var			    foodprog_travel "Food Programs: Difficult to travel"
	lab var			    foodprog_assets "Food Programs: Can't qualify because too many assets"
	lab var			    foodprog_stigma "Food Programs: Stigma"

* loop to recode, appends "temp" to source vars and renames encoded vars
	
foreach v of varlist foodprog_* {    
	   rename `v' `v'_temp
	   encode `v'_temp, gen (`v') 
	   replace			`v' = .
	   replace 			`v' = 1 if `v'_temp == "1" 
	   replace 			`v' = 2 if `v'_temp == "2"
	   replace 			`v' = 3 if `v'_temp == "3"
	   replace 			`v' = 4 if `v'_temp == "4"
	   replace 			`v' = 5 if `v'_temp == "5" 
	   replace 			`v' = 99 if `v'_temp == "I don't know" 
 lab def 			`v'_lab3e  1 "Strongly disagree" 2 "Disagree" 3 "Neither agree nor disagree" 4 "Agree" 5 "Strongly agree" 99 "I don't know"
	   lab val 			`v'  `v'_lab3e
	   }	

* drop temp vars
	drop 				*_temp	   
		
	
	
	
* Item 4 (Qualtrics var name "Q4"):	What were the typical types of transportation 
* you used to get food for your household, in the last 12 months and since the 
* COVID-19 outbreak? 


* rename text response vars to keep them out of encoding loop below

	rename				Q4txt_1_1 text_trans_addltypesyr
	rename				Q4txt_1_2 text_trans_addltypescovid
	
* label prog vars

	lab var 			trans_bus "Transportation: Bus"
	lab var			    trans_vehicle "Transportation: Own Vehicle"
	lab var 			trans_friend "Transportation: Friend/Family/Neighbor"
	lab var 			trans_taxi "Transportation: Taxi/Lyft"
	lab var 			trans_bringfood "Transportation: Someone Brings Food"
	lab var			    trans_walk "Transportation: Walk/Bike"
	lab var				text_trans_addltypesyr "Text: Additional Types of Transportation (Yr)"
	lab var				text_trans_addltypescovid "Text: Additional Types of Transportation (Covid)"


* loop to recode, appends "temp" to source vars and renames encoded vars
	
foreach v of varlist trans_* {    
	   rename `v' `v'_temp
	   encode `v'_temp, gen (`v') 
	   replace			`v' = .
	   replace 			`v'= 1 if `v'_temp == "1,2" 
	   replace 			`v' = 2 if `v'_temp == "1"
	   replace 			`v' = 3 if `v'_temp == "2"
	   replace 			`v' = 4 if `v'_temp == "3"
	   lab def 			`v'_lab4  1 "No Change" 2 "Stopped Since COVID" 3 ///
							"Started Since COVID" 4 "Never Used" 
	   lab val 			`v'  `v'_lab4
	   }	

* drop temp vars
	drop 				*_temp	   

* creation of dummy var
	tab 				trans_bus, gen(trans_bus_dummy_)
	tab 				trans_vehicle, gen( trans_vehicle_dummy_)
	tab 				trans_friend, gen( trans_friend_dummy_)
	tab 				trans_taxi, gen( trans_taxi_dummy_)
	tab 				trans_bringfood, gen(trans_bringfood_dummy_)
	tab 				trans_walk, gen( trans_walk_dummy_)
	tab 				trans_otherbin, gen( trans_otherbin_dummy_)


* Item 5 (Qualtrics var name "Q5"): 
* How often did these happen to your household when getting food, since the 
* COVID-19 outbreak (March 11th)?


* rename text response vars to keep them out of encoding loop below
* checkthis
	rename				Q5a text_challenge_foodwant
	rename				Q5b text_challenge_foodget
	rename				Q5c text_challenge_standclose

	
* label prog vars

*	lab var 			challenge_afford "Challenge: Afford"
	lab var			    challenge_asmuch "Challenge: As Much Food"
	lab var 			challenge_kinds "Challenge: Types of Food"
*	lab var			    challenge_deliver "Challenge: Delivered to Friend"
*	lab var 			challenge_pantry "Challenge: Food Pantry"
*	lab var			    challenge_school "Challenge: Food School Program"
*	lab var 			challenge_MoW "Challenge: Meals on Wheels"
*	lab var			    challenge_findhelp "Challenge: Find Help"
*	lab var 			challenge_moreplaces "Challenge: More Places"
	lab var			    challenge_close "Challenge: Stand Close"
	lab var 			challenge_reducgroc "Challenge:  Reduce Groceries"
*	lab var			    challenge_morecook "Challenge: More Time Cooking"
*	lab var			    challenge_volunteer "Challenge: Volunteer"
	lab var				text_challenge_foodwant "Text: Challenge to get food wanted, couldn't get"
	lab var				text_challenge_foodget "Text: Challenge to get food got, unwanted"
	lab var				text_challenge_standclose "Text: List where you had to stand close to get food"
	
	
* loop to recode, appends "temp" to source vars and renames encoded vars
	
foreach v of varlist challenge_* {    
	   rename `v' `v'_temp
	   encode `v'_temp, gen (`v') 
	   replace			`v' = .
	   replace 			`v'= 1 if `v'_temp == "1" 
	   replace 			`v' = 2 if `v'_temp == "2"
	   replace 			`v' = 3 if `v'_temp == "3"
	   replace 			`v' = 4 if `v'_temp == "4"
	   replace			`v' = 88 if `v'_temp == "88"
	   lab def 			`v'_lab5  1 "Never" 2 "Sometimes" 3 "Usually" 4 "Every time" 88 "Not Applicable"
	   lab val 			`v'  `v'_lab5
	   }	

* drop temp vars
	drop 				*_temp	   


* Item 6 (Qualtrics var name "Q6"): Have you or anyone in your household 
* experienced a loss of income or job since the COVID-19 outbreak (March 11th)? 
* MS

* label job vars

	lab var 			job_loss "Yes, lost"
	lab var			    job_hours "Yes, reduced hours/income"
	lab var 			job_furlo "Yes, furloughed"
	lab var 			job_no "No, no changes"



* loop to recode, appends "temp" to source vars and renames encoded vars
	
foreach v of varlist job_* {    
	   rename `v' `v'_temp
	   encode `v'_temp, gen (`v') 
	   replace			`v' = .
	   replace 			`v'= 1 if `v'_temp == "1,2" 
	   replace 			`v' = 2 if `v'_temp == "1"
	   replace 			`v' = 3 if `v'_temp == "2"
	   replace 			`v' = 4 if `v'_temp == "3"
	   replace 			`v' = 4 if `v'_temp == "3"
	   lab def 			`v'_lab6  1 "Job lost and still lost" 2 "Job lost since COVID" 3 ///
							"Job reduced hrs income" 4 "Furloughed" 5 "No change at job" 
	   lab val 			`v'  `v'_lab6
	   }	

* drop temp vars
	drop 				*_temp	 



* Item 7 (Qualtrics var name "Q7"): Have you received any money from these 
* sources since the COVID-19 outbreak?  MS


* label prog vars
	rename				Q7 money


* loop to recode, appends "temp" to source vars and renames encoded vars
	
foreach v of varlist money {    
	   rename `v' `v'_temp
	   encode `v'_temp, gen (`v') 
	   replace			`v' = .
	   replace 			`v'= 1 if `v'_temp == "1" 
	   replace 			`v' = 2 if `v'_temp == "2"
	   replace 			`v' = 3 if `v'_temp == "3"
	   replace		    `v' = 4 if `v'_temp == "4"
	   replace 			`v' = 5 if `v'_temp == "1,2,3"
	   replace 			`v' = 6 if `v'_temp == "1,2"
	   replace 			`v' = 7 if `v'_temp == "1,3"
	   replace		    `v' = 8 if `v'_temp == "2,3"
	   lab def 			`v'_labm  1 "Federal Stimulus Check" ///
							2 "Friends or family" ///
							3 "Unemployment benefits, other" ///
							4 "No changes" ///
							5 "Stimulus & Friends/family & Unemployment, other" ///
							6 "Stimulus & Friends/family" ///
							7 "Stimulus & Unemployment, other" ///
							8 "Friends/family & unemployment benefits/other" 
					
	   lab val 			`v'  `v'_labm
	   }	

* rename
	drop 				money_temp



* ***********************************************************************
* 4 - Part 2/5: Food Access
*     Created by: lem
*	  last updated: 07_21_2020
* ***********************************************************************	

* Item 8 (Qualtrics var name "Q8"): What, if anything, would make it easier 
* for your household to meet its food needs during the coronavirus pandemic?


	rename Q8txt text_helpful
	rename Q8a helpful_howmuch



	lab var 			helpful_transit "Helpful: Access to transit"
	lab var 			helpful_mealhours "Helpful: Different meal hours"
	lab var 			helpful_extramoney "Helpful: Extra money"
	lab var 			helpful_infprograms "Helpful: Info food assistance"
	lab var 			helpful_morefood "Helpful: More food in stores"
	lab var 			helpful_trustfood "Helpful: More trust in safety of food"
	lab var 			helpful_trustdeliv "Helpful: More trust in safety of food delivery"
	lab var 			helpful_truststores "Helpful: More trust in safety stores"
	*lab var 			helpful_costfood "Helpful: Defray food delivery cost"
	lab var 			helpful_bin "Helpful: Other"
	lab var 			helpful_howmuch "Helpful: How much extra money"
	lab var				text_helpful "Text: What else would be helpful"
	
	
foreach v of varlist helpful* {    
	   rename `v' `v'_temp
	   encode `v'_temp, gen (`v') 
	   replace			`v' = .
	   replace 			`v'= 0 if `v'_temp == "0" 
	   replace 			`v' = 1 if `v'_temp == "1"
	   lab def 			`v'_lab8  1 "Yes" 0 "No" 			
	   lab val 			`v'  `v'_lab8
	   }	

* drop temp vars
	drop 				*_temp	




* Item 9 (Qualtrics var name "Q9"): On a scale from 1 (not at all worried) to 6
* (extremely worried), what is your level of worry for your household about 
* the following as it relates to COVID-19:


	rename				Q9txt text_worry

* label worry vars

	lab var				worry_enoughfood "Worry not enough in store"
	lab var 			worry_countryfood "Worry the country will not have enough food for everyone"
	lab var 			worry_foodexp "Worry food will become more expensive"
	lab var			    worry_foodunsafe "Worry food will be unsafe, contaminated"
	lab var 			worry_programs "Worry household will lose access to food programs"
	lab var 			worry_income "Worry household will lose income, can't afford food"
	lab var 			worry_housefood "Worry household won't have enough if have to stay home"
	lab var				text_worry "Text: Other worries"


* loop to recode, appends "temp" to source vars and renames encoded vars
	
foreach v of varlist worry_* {    
	   rename `v' `v'_temp
	   encode `v'_temp, gen (`v') 
	   replace			`v' = .
	   replace 			`v' = 1 if `v'_temp == "1" 
	   replace 			`v' = 2 if `v'_temp == "2"
	   replace 			`v' = 3 if `v'_temp == "3"
	   replace 			`v' = 4 if `v'_temp == "4"
	   replace 			`v' = 5 if `v'_temp == "5" 
	   replace 			`v' = 99 if `v'_temp == "I don't know" 
	 lab def 			`v'_lab9  1 "Strongly disagree" 2 "Disagree" ///
						3 "Neither agree nor disagree" 4 "Agree" ///
						5 "Strongly agree" 99 "I don't know"
	   lab val 			`v'  `v'_lab9
	   }	

* drop temp vars
	drop 				*_temp	   



* Item 10A (Qualtrics var name "Q10#cur") Which of the following 
* strategies, if any, are you using now to afford food? 

* label strategy-current


	lab var 			strat_accept_cur "Strategy: Current: Accept food friends/family"
	lab var 			strat_borrow_cur "Strategy: Current: Borrow money friends/family"
	lab var 			strat_cheap_cur "Strategy: Current: Buy different, cheaper foods"
	lab var			    strat_credit_cur "Strategy: Current: Buy food on credit"
	lab var 			strat_gobad_cur "Strategy: Current: Buy non-perishables"
	lab var 			strat_pantry_cur "Strategy: Current: Get food from food pantry/soup kitchen"
	lab var			    strat_stretch_cur "Strategy: Current: Stretch food"
	lab var 			strat_grow_cur "Strategy: Current: Rely more on hunting/fishing"
	lab var 			strat_otherbin_cur "Strategy: Current: Other"
	
	
foreach v of varlist *_cur {    
	   rename `v' `v'_temp
	   encode `v'_temp, gen (`v') 
	   replace			`v' = .
	   replace 			`v'= 0 if `v'_temp == "0" 
	   replace 			`v' = 1 if `v'_temp == "1"
	   lab def 			`v'_lab10a  1 "Yes" 0 "No" 			
	   lab val 			`v'  `v'_lab10a
	   }	

* drop temp vars
	drop 				*_temp	



* Item 10B (Qualtrics var name "Q10#fut") If not using them now, 
* how likely are you to use these if your household has challenges affording 
* food in the future during the COVID-19 outbreak?



* label strategy-future vars

	lab var 			strat_accept_fut "Strategy: Future: Accept food friends/family"
	lab var 			strat_borrow_fut "Stratehy: Future: Borrow money friends/family"
	lab var 			strat_cheap_fut "Strategy: Future: Buy different, cheaper foods"
	lab var 			strat_credit_fut "Strategy: Future: Buy food on credit"
	lab var 			strat_gobad_fut "Strategy: Future: Buy non-perishables"
	lab var 			strat_pantry_fut "Strategy: Future: Get food from food pantry/soup kitchen"
	lab var 			strat_stretch_fut "Strategy: Future: Stretch food"
	lab var 			strat_grow_fut "Strategy: Future: Rely more on hunting/fishing"
	lab var 			strat_otherbin_fut "Strategy: Future: Other"

* loop to recode, appends "temp" to source vars and renames encoded vars
	
foreach v of varlist *_fut {    
	   rename `v' `v'_temp
	   encode `v'_temp, gen (`v') 
	   replace			`v' = .
	   replace 			`v' = 1 if `v'_temp == "1" 
	   replace 			`v' = 2 if `v'_temp == "2"
	   replace 			`v' = 3 if `v'_temp == "3"
	   replace 			`v' = 4 if `v'_temp == "4"
	   replace 			`v' = 5 if `v'_temp == "5" 
	   replace 			`v' = 99 if `v'_temp == "I don't know" 
	   lab def 			`v'_lab10b  1 "Very unlikely" 2 "Unlikely" ///
							3 "Somewhat unlikely" 4 "Somewhat likely" ///
							5 "Likely" 6 "Very likely"
	   lab val 			`v'  `v'_lab10b
	   }	

* drop temp vars
	drop 				*_temp	   


* ***********************************************************************
* 5 - Part 3/5: Eating and Purchasing Behaviors
*     Created by: fd
* ***********************************************************************	

* Item 11 (qualtrics var name Q11) - Do you or someone in your household have 
* a special diet? MS

	*** checkthis: may not be the best way to code this var. 
	
	rename 					Q11 diet_change
	rename 					Q11_7_TEXT diet_change_other
	
	gen 					diet_change_recode=.
	replace 				diet_change_recode=1 if diet_change=="1"
	replace 				diet_change_recode=2 if diet_change=="2"
	replace 				diet_change_recode=3 if diet_change=="3"
	replace 				diet_change_recode=4 if diet_change=="4"
	replace 				diet_change_recode=5 if diet_change=="5"
	replace 				diet_change_recode=6 if diet_change=="6"
	replace 				diet_change_recode=7 if diet_change=="7"
	replace 				diet_change_recode=8 if diet_change=="8"
	replace 				diet_change_recode=9 if diet_change=="1,2"
	replace 				diet_change_recode=10 if diet_change=="1,2,3"
	replace 				diet_change_recode=11 if diet_change=="1,2,4"
	replace 				diet_change_recode=12 if diet_change=="1,2,5"
	replace 				diet_change_recode=13 if diet_change=="1,2,6"
	replace 				diet_change_recode=14 if diet_change=="1,2,7"
	replace 				diet_change_recode=15 if diet_change=="1,2,3,4"
	replace 				diet_change_recode=16 if diet_change=="1,2,3,5"
	replace 				diet_change_recode=17 if diet_change=="1,2,3,6"
	replace 				diet_change_recode=18 if diet_change=="1,2,3,7"
	replace 				diet_change_recode=19 if diet_change=="1,2,3,4,5"
	replace 				diet_change_recode=20 if diet_change=="1,2,3,4,6"
	replace 				diet_change_recode=21 if diet_change=="1,2,3,4,7"
	replace 				diet_change_recode=22 if diet_change=="1,2,3,4,5,6"
	replace 				diet_change_recode=23 if diet_change=="1,2,3,4,5,7"
	replace 				diet_change_recode=24 if diet_change=="1,2,3,4,5,6,7"
	replace 				diet_change_recode=25 if diet_change=="1,3"
	replace 				diet_change_recode=26 if diet_change=="1,3,4"
	replace 				diet_change_recode=27 if diet_change=="1,3,5"
	replace 				diet_change_recode=28 if diet_change=="1,3,6"
	replace 				diet_change_recode=29 if diet_change=="1,3,7"
	replace 				diet_change_recode=30 if diet_change=="1,3,4,5"
	replace 				diet_change_recode=31 if diet_change=="1,3,4,6"
	replace 				diet_change_recode=32 if diet_change=="1,3,4,7"
	replace 				diet_change_recode=33 if diet_change=="1,3,4,5,6"
	replace 				diet_change_recode=34 if diet_change=="1,3,4,5,7"
	replace 				diet_change_recode=35 if diet_change=="1,3,4,5,6,7"
	replace 				diet_change_recode=36 if diet_change=="1,4"
	replace 				diet_change_recode=37 if diet_change=="1,4,5"
	replace 				diet_change_recode=38 if diet_change=="1,4,6"
	replace 				diet_change_recode=39 if diet_change=="1,4,7"
	replace 				diet_change_recode=40 if diet_change=="1,4,5,6"
	replace 				diet_change_recode=41 if diet_change=="1,4,5,7"
	replace 				diet_change_recode=42 if diet_change=="1,4,5,6,7"
	replace 				diet_change_recode=43 if diet_change=="1,5"
	replace 				diet_change_recode=44 if diet_change=="1,5,6"
	replace 				diet_change_recode=45 if diet_change=="1,5,7"
	replace 				diet_change_recode=46 if diet_change=="1,5,6,7"
	replace 				diet_change_recode=47 if diet_change=="1,6"
	replace 				diet_change_recode=48 if diet_change=="1,6,7"
	replace 				diet_change_recode=49 if diet_change=="1,7"
	replace 				diet_change_recode=50 if diet_change=="2,3"
	replace 				diet_change_recode=51 if diet_change=="2,3,4"
	replace 				diet_change_recode=52 if diet_change=="2,3,5"
	replace 				diet_change_recode=53 if diet_change=="2,3,6"
	replace 				diet_change_recode=54 if diet_change=="2,3,7"
	replace 				diet_change_recode=55 if diet_change=="2,3,4,5"
	replace 				diet_change_recode=56 if diet_change=="2,3,4,6"
	replace 				diet_change_recode=57 if diet_change=="2,3,4,7"
	replace 				diet_change_recode=58 if diet_change=="2,3,4,5,6"
	replace 				diet_change_recode=59 if diet_change=="2,3,4,5,7"
	replace 				diet_change_recode=60 if diet_change=="2,3,4,5,6,7"
	replace 				diet_change_recode=61 if diet_change=="2,4"
	replace 				diet_change_recode=62 if diet_change=="2,4,5"
	replace 				diet_change_recode=63 if diet_change=="2,4,6"
	replace 				diet_change_recode=64 if diet_change=="2,4,7"
	replace 				diet_change_recode=65 if diet_change=="2,4,5,6"
	replace 				diet_change_recode=66 if diet_change=="2,4,5,7"
	replace 				diet_change_recode=67 if diet_change=="2,4,5,6,7"
	replace 				diet_change_recode=68 if diet_change=="2,5"
	replace 				diet_change_recode=69 if diet_change=="2,5,6"
	replace 				diet_change_recode=70 if diet_change=="2,5,7"
	replace 				diet_change_recode=71 if diet_change=="2,5,6,7"
	replace 				diet_change_recode=72 if diet_change=="2,6"
	replace 				diet_change_recode=73 if diet_change=="2,6,7"
	replace 				diet_change_recode=74 if diet_change=="2,7"
	replace 				diet_change_recode=75 if diet_change=="3,4"
	replace 				diet_change_recode=76 if diet_change=="3,4,5"
	replace 				diet_change_recode=77 if diet_change=="3,4,6"
	replace 				diet_change_recode=78 if diet_change=="3,4,7"
	replace 				diet_change_recode=79 if diet_change=="3,4,5,6"
	replace 				diet_change_recode=80 if diet_change=="3,4,5,7"
	replace 				diet_change_recode=81 if diet_change=="3,4,5,6,7"
	replace 				diet_change_recode=82 if diet_change=="3,5"
	replace 				diet_change_recode=83 if diet_change=="3,5,6"
	replace 				diet_change_recode=84 if diet_change=="3,5,7"
	replace 				diet_change_recode=85 if diet_change=="3,5,6,7"	
	replace 				diet_change_recode=86 if diet_change=="3,6"
	replace 				diet_change_recode=87 if diet_change=="3,6,7"
	replace 				diet_change_recode=88 if diet_change=="3,7"
	replace 				diet_change_recode=89 if diet_change=="4,5"
	replace 				diet_change_recode=90 if diet_change=="4,5,6"
	replace 				diet_change_recode=91 if diet_change=="4,5,7"
	replace 				diet_change_recode=92 if diet_change=="4,5,6,7"
	replace 				diet_change_recode=93 if diet_change=="4,6"
	replace 				diet_change_recode=94 if diet_change=="4,6,7"
	replace 				diet_change_recode=95 if diet_change=="4,7"
	replace 				diet_change_recode=96 if diet_change=="5,6"
	replace 				diet_change_recode=97 if diet_change=="5,6,7"
	replace 				diet_change_recode=98 if diet_change=="5,7"
	replace 				diet_change_recode=99 if diet_change=="6,7"
	
	label 					define dietchange 1 "Food allergy that requires avoiding some foods" 2 "Food sensitivity that causes problems from eating some foods" 3 "Need to avoid some foods for health condition like diabetes or kidney disease" 4 "Religious restriction" 5 "Vegetarian/Vegan" 6 "Weight loss diet that requires special foods" 7 "Other" 8 "No one in my household has a special diet" 9 "Food Allergy and Food Sensitivity" 10 "Food allergy, Food sensitivity and Avoid some foods for health" 11 "Food allergy, Food sensitivity and Religious restriction" 12 "Food allergy, Food sensitivity and Vegetarian/Vegan" 13 "Food allergy, Food sensitivity and Weight loss" 14 "Food allergy, Food sensitivity and Other" 15 "Food allergy, Food sensitivity, Avoid some foods for health and Religious restriction" 16 "Food allergy, Food sensitivity, Avoid some foods for health and Vegetarian/Vegan" 17 "Food allergy, Food sensitivity, Avoid some foods for health and Weight loss" 18 "Food allergy, Food sensitivity, Avoid some foods for health and Other" 19 "Food allergy, Food sensitivity, Avoid some foods for health, Religious restriction and Vegetarian/Vegan" 20 "Food allergy, Food sensitivity, Avoid some foods for health, Religious restriction and Weight loss" 21 "Food allergy, Food sensitivity, Avoid some foods for health, Religious restriction and Other" 22 "Food allergy, Food sensitivity, Avoid some foods for health, Religious restriction, Vegetarian/Vegan and Weight loss" 23 "Food allergy, Food sensitivity, Avoid some foods for health, Religious restriction, Vegetarian/Vegan and Other" 24 "Food allergy, Food sensitivity, Avoid some foods for health, Religious restriction, Vegetarian/Vegan, Weight loss and Other" 25 "Food allergy and Avoid some foods for health" 26 "Food allergy, Avoid some foods for health and Religious restriction" 27 "Food allergy, Avoid some foods for health and Vegetarian/Vegan" 28 "Food allergy, Avoid some foods for health and Weight loss" 29 "Food allergy, Avoid some foods for health and Other" 30 "Food sensitivity, Avoid some foods for health, Religios restriction and Vegetarian/Vegan" 31 "Food sensitivity, Avoid some foods for health, Religious restriction and Weight loss" 32 "Food sensitivity, Avoid some foods for health, Religious restriction and Other" 33 "Food sensitivity, Avoid some foods for health, Religious restriction, Vegetarian/Vegan and Weight loss" 34 "Food sensitivity, Avoid some foods for health, Religious restriction, Vegetarian/Vegan and Other" 35 "Food sensitivity, Avoid some foods for health, Religious restriction, Vegetarian/Vegan, Weight loss and Other" 36 "Food allergy and Religious restriction" 37 "Food Allergy, Religious restriction and Vegetarian/Vegan" 38 "Food Allergy, Religious restriction and Weight loss" 39 "Food Allergy, Religious restriction and Other" 40 "Food allergy, Religious Restriction, Vegetarian/Vegan and Weight loss" 41 "Food allergy, Religious Restriction, Vegetarian/Vegan and Other" 42 "Food allergy, Religious restriction, Vegetarian/Vegan, Weight loss and Other" 43 "Food allergy and Vegetarian/Vegan" 44 "Food allergy, Vegetarian/Vegan and Weight loss" 45 "Food allergy, Vegetarian/Vegan and Other" 46 "Food allergy, Vegetarian/Vegan, Weight loss and Other" 47 "Food allergy and Weight loss" 48 "Food allergy, Weight loss and Other" 49 "Food allergy and Other" 50 "Food sensitivity and Avoid some foods for health" 51 "Food sensitivity, Avoid some foods for health and Religious restriction" 52 "Food sensitivity, Avoid some foods for health and Vegetarian/Vegan" 53 "Food sensitivity, Avoid some foods for health and Weight loss" 54 "Food sensitivity, Avoid some foods for health and Other" 55 "Food sensitivity, Avoid some foods for health, Religious restriction and Vegetarian/Vegan" 56 "Food sensitivity, Avoid some foods for health, Religious restriction and Weight loss" 57 "Food sensitivity, Avoid some foods for health, Religious restriction and other" 58 "Food sensitivity, Avoid some foods for health, Religious restriction, Vegetarian/Vegan, and Weight loss" 59 "Food sensitivity, Avoid some foods for health, Religious restriction, Vegetarian/Vegan, and Other" 60 "Food sensitivity, Avoid some foods for health, Religious restriction, Vegetarian/Vegan, Weight loss and other" 61 "Food sensitivity and Religious restriction" 62 "Food sensitivity, Religious restriction and Vegetarian/Vegan" 63 "Food sensitivity, Religious restriction and Weight loss" 64 "Food sensitivity, Religious restriction and Other" 65 "Food sensitivity, Religious restriction, Vegetarian/Vegan and Weight loss" 66 "Food sensitivity, Religious restriction, Vegetarian/Vegan and Other" 67 "Food sensitivity, Religious restriction, Vegetarian/Vegan Weight loss and Other" 68 "Food sensitivity and Vegetarian/Vegan" 69 "Food sensitivity, Vegetarian/Vegan and Weight loss" 70 "Food sensitivity, Vegetarian/Vegan and Other" 71 "Food sensitivity, Vegetarian/Vegan, Weight loss, and Other" 72 "Food sensitivity and Weight loss" 73 "Food sensitivity, Weight loss and Other" 74 "Food sensitivity and Other" 75 "Avoid some foods for health and Religious Restriction" 76 "Avoid some foods for health, Religious restriction and Vegetarian/Vegan" 77 "Avoid some foods for health, Religious restriction and Weight loss" 78 "Avoid some foods for health, Religious restriction and Other" 79 "Avoid some foods for health, Religious restriction, Vegetarian/Vegan and Weight loss" 80 "Avoid some foods for health, Religious restriction, Vegetarian/Vegan and Other" 81 "Avoid some foods for health, Religious restriction, Vegetarian/Vegan, Weight loss and Other" 82 "Avoid some foods for health and Vegetarian/Vegan" 83 "Avoid some foods for health, Vegetarian/Vegan and Weight loss" 84 "Avoid some foods for health, Vegetarian/Vegan and Other" 85 "Avoid some foods for health, Vegetarian/Vegan, Weight loss and Other" 86 "Avoid some foods for health and Weight loss" 87 "Avoid some foods for health, Weight loss, and Other" 88 "Avoid some foods for health and Other" 89 "Religious restriction and Vegetarian/Vegan" 90 "Religious restriction, Vegetarian/Vegan and Weight loss" 91 "Religious restriction, Vegetarian/Vegan and Other" 92 "Religious restriction, Vegetarian/Vegan, Weight loss and Other" 93 "Religious restriction and Weight loss" 94 "Religious restriction, Weight loss and Other" 95 "Religious restriction and Other" 96 "Vegetarian/Vegan and Weight loss" 97 "Vegetarian/Vegan, Weight loss and Other" 98 "Vegetarian/Vegan and Other" 99 "Weight loss and Other", replace
	
	label values 				diet_change_recode dietchange
	label var					diet_change_recode "Diet Changes"
	
	* creation of dummy var
	* creates a dummy for each possible outcome
	
	tab 						diet_change_recode, gen(diet_change_dummy_)
	
	* drop diet_change var
	drop						diet_change
	
* Item 11a (qualtrics var name Q11a) - Have you had challenges finding food that
* meets these food needs since the COVID-19 outbreak (March 11th)?

	label define 			No_Yes_NA 0 "No" 1 "Yes" 88 "Not applicable"
	label values 			diet_change_allergy diet_change_sensitive diet_change_health diet_change_religion diet_veg diet_weight diet_other No_Yes_NA
	
* Item 12 (codebook question 12) - The next questions are about how you have
* been eating in the past month during the COVID-19 outbreak (since March 11th).

	* FD: in codebook but not in az survey
	
	*rename 				Q121 eating_fruit
	*rename 				Q122 eating_vegtables
	*rename 				Q123 eating_redmeat
	*rename 				Q124 eating_procmeat
	
	*label define 			eating_fruit_veg 0 "None" 1 "1/2 cup or less" 2 "1/2 to 1 cup" 3 "1 - 2 cups" 4 "2 - 3 cups" 5 "3 - 4 cups" 6 "4 or more cups"
	*label define 			eating_redmeat_procmeat 0 "Never" 1 "1 times last month" 2 "2 - 3 times last month" 3 "1 time per week" 4 "2 times per week" 5 "3 - 4 times per week" 6 "5 - 6 times per week" 7 "1 time per day" 8 "2 or more times per day"
	
	*label values 			eating_fruit eating_fruit_veg
	*label values 			eating_vegtables eating_fruit_veg
	*label values 			eating_redmeat eating_redmeat_procmeat
	*label values 			eating_procmeat eating_redmeat_procmeat
	*label define 			Less_more 1 "Less" 2 "Same" 3 "More"
	*label values 			eating_comp_fruitveg eating_comp_meats eating_comp_seafood Less_more
	
* Item 13 (codebook question 13) - Please indicate your level of agreement with 
* the following statements regarding eating during the COVID-19 outbreak
* (since March 11th)

	* FD: in codebook but not in az survey
	
	*label define 			eathabits 1 "Strongly disagree" 2 "Disagree" 3 "Neither agree nor disagree" 4 "Agree" 5 "Strongly agree" 88 "Not applicable"
	
	*label values 			eathabits_emotional eathabits_lonely eathabits_stress eathabits_comfort eathabits
	
* Item 14 (codebook question 14) - Please indicate whether any of the 
* following is true about your eating and shopping behaviors in the year before
* the COVID-19 outbreak and since the COVID-19 outbreak (March 11th):

	* FD: in codebook but not in az survey
	
	*label define behaviors 1 "Never true" 2 "Sometimes true" 3 "Often true" 99 "I dont know"
	*label values behaviors_local_year behaviors_pack_year behaviors_bags_year behaviors_veg_year behaviors_sust_year behaviors_local_covid behaviors_pack_covid behaviors_bags_covid behaviors_veg_covid behaviors_sust_covid behaviors
	
* Item 15 (Qualtrics var name Q15) - Please indicate whether any of the 
* following is true about your eating and shopping behaviors in the year before
* the COVID-19 outbreak and since the COVID-19 outbreak (March 11th):
	
	* label habits vars

	lab var 				habits_buymore "Habits Bought More Food"
	lab var			  	 	habits_deliver "Habits Deliver Food to Others"
	lab var 				habits_donate "Habits Donate"
	lab var 				habits_normal "Habits Stayed Normal"
	lab var					habits_supply "Habits Two Week Food Supply"
	lab var 				habits_dist "Habits Social Distancing"
	lab var			 	    habits_cook "Habits More Cooking"
	lab var 				habits_throwless "Habits Thorw Away Less Food"
	lab var 				habits_throwmore "Habits Throw Away More Food"
	lab var					habits_volunteer "Habits Volunteer"
	lab var					habits_mask "Habits Wear Mask"

* loop to recode, appends "temp" to source vars and renames encoded vars
	
foreach v of varlist habits_* {    
	   rename `v' `v'_temp
	   encode `v'_temp, gen (`v'_recode) 
	   replace			`v'_recode = .
	   replace 			`v'_recode= 1 if `v'_temp == "1,2" 
	   replace 			`v'_recode = 2 if `v'_temp == "1"
	   replace 			`v'_recode = 3 if `v'_temp == "2"
	   lab def 			`v'  1 "Both" 2 "My household has done this" 3 ///
							"I believe the average U.S. household has done this" 
	   lab val 			`v'_recode  `v'
	   }	

* drop temp vars
	drop 				*_temp	   
	
	
* ***********************************************************************
* 6 - Part 4/5: Perspectives and Experience
*     Created by: fd
* ***********************************************************************
	
* Item 16 (Qualtrics var name Q16) - On a scale from 1 (strongly disagree) to 6
* (strongly agree), how much do you agree with the following statements:

	* label persp vars
	
	label var	 			diet_change_allergy "Diet Change Allergy"
	label var	 			diet_change_sensitive "Diet Change Sensitive"
	label var	 			diet_change_health "Diet Change Health"
	label var	 			diet_change_religion "Diet Change Religion"
	label var	 			diet_veg "Diet Vegtatbles"
	label var	 			diet_weight "Diet Weight"
	label var	 			diet_other "Diet Other"
	label var	 			persp_flu "Perspective Seasonal Flu"
	label var				persp_VT "Perspective "
	label var 				persp_VT "Perspective Other States More Affected"
	label var 				persp_US "Perspective Other Countries More Affected"
	label var				persp_me "Perspective COVID-19 Will Affect People Like Me"
	label var				persp_flu "Perspective COVID-19 Like Seasonal Flu"
	label var				persp_flu "Perspective Like Seasonal Flu"
	label var 				persp_me "Perspective Will Affect People Like Me"
	label var 				persp_econ "Perspective Economy Over Public Health"
	label var 				persp_action "Perspective Stay Home"
	label var 				persp_foodsource "Perspective Food Source"
	label var 				persp_prepared "Perspective Felt Prepared"
	label var 				persp_packages "Perspective Transmit Through Food Packges"
	label var 				persp_open_econ "Perspective Worth Reopen Economy"
	label var 				persp_foodsupply "Perspective Food Supply"
	label var 				persp_strike "Perspective Support Strike"
	
	* destring and clean persp vars
	
	
	destring 			persp_flu persp_VT persp_US persp_me persp_econ persp_action persp_foodsource persp_prepared persp_packages persp_open_econ persp_foodsupply persp_strike, replace
	
	label define 		persp 1 "1 (strongly disagree)" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6 (strongly agree)" 99 "I don't know"
	
	label values 		persp_flu persp_VT persp_US persp_me persp_econ persp_action persp_foodsource persp_prepared persp_packages persp_open_econ persp_foodsupply persp_strike persp
	
* Item 17 (Qualtrics var name Q17) - Do you anyone with symptoms of, or diagnosed with, the coronavirus (COVID-19)? If so, who? Check all that apply.

	* clean and label know var

	rename 				Q17 know
	
	gen 					know_recode=.
	replace 				know_recode=1 if know=="1"
	replace 				know_recode=2 if know=="2"
	replace 				know_recode=3 if know=="3"
	replace 				know_recode=4 if know=="4"
	replace 				know_recode=5 if know=="5"
	replace 				know_recode=6 if know=="1,2"
	replace 				know_recode=7 if know=="1,3"
	replace 				know_recode=8 if know=="1,4"
	replace					know_recode=9 if know=="1,2,3"
	replace 				know_recode=10 if know=="1,2,4"
	replace 				know_recode=11 if know=="1,2,3,4"
	replace 				know_recode=12 if know=="2,3"
	replace 				know_recode=13 if know=="2,4"
	replace 				know_recode=14 if know=="2,3,4"
	replace 				know_recode=15 if know=="3,4"
	
	label define 			Know 1 "Yes, family" 2 "Yes, friend(s)" 3 "Yes, myself" 4 "Yes, other" 5 "No, I don't know anyone" 6 "Yes, family and friends" 7 "Yes, family and myself" 8 "Yes, family and other" 9 "Yes, family and friend(s) and myself" 10 "Yes, family and friend(s) and other" 11 "Yes, family and friend(s) and myself and other" 12 "Yes, friend(s) and myself" 13 "Yes, friend(s) and other" 14 "Yes, friend(s) and myself and other" 15 "Yes, myself and other"
	
	label values 			know_recode Know
	label var				know_recode "Know Anyone Diagnosed or With Symptoms"
	
* drop know vars

	drop know
	
	* checkthis: propably an easier/more concise way of coding this question

	
* Item 18 (Qualtrics var name Q18) - Have you had to quarantine in your home due 
*to coronavirus (for example because of illness or exposure symptoms)?

	* label and define know_quaran var
	
	label define 			no_yes 0 "No" 1 "Yes"
	rename 					Q18 know_quaran
	label values 			know_quaran no_yes
	label var				know_quaran "Know Quarantine"
	
* ***********************************************************************
* 7 - Part 5/5: Demographics
*     Created by: fd
* ***********************************************************************	

* Item 19 (Qualtrics var name Q19) -  How many people in the following age 
* groups currently live in your household (household defined as those currently
* living within your household, including family and non-family members)? 

	* destring and label num vars
	
	destring 				num_people_under5 num_people_517 num_people_1865 num_people_65up, replace
	
	label var 				num_people_under5 "Number of People in Household Under Age 5"
	label var				num_people_517 "Number of People in Household Ages 15-17"
	label var 				num_people_1865 "Number of People in Household  Ages 18-65"
	label var 				num_people_65up "Number of People in Household Ages 65 and up"
	
	* checkthis: should I replace -99 with with something or leave as is
	
* Item 20 (Qualtrics var name Q20) - Which of the following best describes your 
* current occupation

	*labels for Q20 
	
	rename 					Q20 occupation
	label define 			Occupation 1 "Not currently employed" 2 "Agriculture, Forestry, Fishing and Hunting" 3 "Arts, Entertainment, and Recreation" 4 "Broadcasting and MEdia" 5 "Childcare Provider" 6 "Clerical/Administrative" 7 "College, University, and Adult Education" 8 "Computer and Electronics Manufacturing" 9 "Construction" 10 "Disabled and on Disability Benefits" 11 "FInance and Insurance" 12 "Food and Beverage Services" 13 "Government and Public Administration" 14 "Health Care and Social Assistance" 15 "Homemaker" 16 "Hotel and Hospitality Services" 17 "Information Services and Data Processing" 18 "Legal Services" 19 "Military" 20 "Mining" 21 "Other Information Industry" 22 "Other Manufactoring" 23 "Primary/Secondary (K-12) Education" 24 "Publishing" 25 "Real Estate, Rental, and Leasing" 26 "Religious" 27 "Retail" 28 "Retired" 29 "Scientific or Technical Services" 30 "Self-employed" 31 "Software" 32 "Student" 33 "Telecommunications" 34 "Transportation and Warehousing" 35 "Utilities" 36 "Other (please describe below if selected) "
	
	label values 			occupation Occupation
	label var 				occupation "Occupation"
	label var 				Q20txt "Occupation Text"
	
* Item 21 (Qualtrics var name Q21b) - What is your ZIP Code?

	* Labels for Q21b
	
	rename 					Q21b zipcode
	destring 				zipcode, replace
	label var 				zipcode "ZIP code"

* Item 22 (Qualtrics var name Q22) - In what year were you born?

	* labels for Q22
	
	rename 					Q22 year_born
	destring 				year_born, replace
	label var 				year_born "Year Born"
	
* Item 23 (Qualtrics var name Q24) - Are you of Hispanic, Latino, or Spanish Origin?

	* labels for Q24
	
	rename 					Q24 ethnicity
	label define 			hispanic_type 0 "Not hispanic" 1 "Yes, Mexican/Mexican American/Chicano" 2 "Yes, Puerto Rican" 3 "Yes, Cuban" 4 "Yes, Other"
	label values 			ethnicity hispanic_type
	label var 				ethnicity "Ethnicity"
	label var 				Q24_4_TEXT "Ethnicity Text"

* Item 24 (Qualtrics var name Q25) - What is your race? Check all that apply:

	*** checkthis: includes up to two combinations for race. also not sure if this is the best way to code this var.
	
	rename 					Q25 race
	label var 				Q25_13_TEXT "Race Text"
	
	gen 					race_recode=.
	replace 				race_recode=1 if race=="1"
	replace 				race_recode=2 if race=="2"
	replace 				race_recode=3 if race=="3"
	replace 				race_recode=4 if race=="4"
	replace 				race_recode=5 if race=="5"
	replace 				race_recode=6 if race=="6"
	replace 				race_recode=7 if race=="7"
	replace 				race_recode=8 if race=="8"
	replace 				race_recode=9 if race=="9"
	replace 				race_recode=10 if race=="10"
	replace 				race_recode=11 if race=="11"
	replace 				race_recode=12 if race=="12"
	replace 				race_recode=13 if race=="13"
	replace 				race_recode=14 if race=="1,2"
	replace 				race_recode=15 if race=="1,3"
	replace 				race_recode=16 if race=="1,4"
	replace 				race_recode=17 if race=="1,5"
	replace 				race_recode=18 if race=="1,6"
	replace 				race_recode=19 if race=="1,7"
	replace 				race_recode=20 if race=="1,8"
	replace 				race_recode=21 if race=="1,9"
	replace 				race_recode=22 if race=="1,10"
	replace 				race_recode=23 if race=="1,11"
	replace 				race_recode=24 if race=="1,12"
	replace 				race_recode=25 if race=="2,3"
	replace 				race_recode=26 if race=="2,4"
	replace 				race_recode=27 if race=="2,5"
	replace 				race_recode=28 if race=="2,6"
	replace 				race_recode=29 if race=="2,7"
	replace 				race_recode=30 if race=="2,8"
	replace 				race_recode=31 if race=="2,9"
	replace 				race_recode=32 if race=="2,10"
	replace 				race_recode=33 if race=="2,11"
	replace 				race_recode=34 if race=="2,12"
	replace 				race_recode=35 if race=="3,4"
	replace 				race_recode=36 if race=="3,5"
	replace 				race_recode=37 if race=="3,6"
	replace 				race_recode=38 if race=="3,7"
	replace 				race_recode=39 if race=="3,8"
	replace 				race_recode=40 if race=="3,9"
	replace 				race_recode=41 if race=="3,10"
	replace 				race_recode=42 if race=="3,11"
	replace 				race_recode=43 if race=="3,12"
	replace 				race_recode=44 if race=="4,5"
	replace 				race_recode=45 if race=="4,6"
	replace 				race_recode=46 if race=="4,7"
	replace 				race_recode=47 if race=="4,8"
	replace 				race_recode=48 if race=="4,9"
	replace 				race_recode=49 if race=="4,10"
	replace 				race_recode=50 if race=="4,11"
	replace 				race_recode=51 if race=="4,12"
	replace 				race_recode=52 if race=="5,6"
	replace 				race_recode=53 if race=="5,7"
	replace 				race_recode=54 if race=="5,8"
	replace 				race_recode=55 if race=="5,9"
	replace 				race_recode=56 if race=="5,10"
	replace 				race_recode=57 if race=="5,11"
	replace 				race_recode=58 if race=="5,12"
	replace 				race_recode=59 if race=="6,7"
	replace 				race_recode=60 if race=="6,8"
	replace 				race_recode=61 if race=="6,9"
	replace 				race_recode=62 if race=="6,10"
	replace 				race_recode=63 if race=="6,11"
	replace 				race_recode=64 if race=="6,12"
	replace 				race_recode=65 if race=="7,8"
	replace 				race_recode=66 if race=="7,9"
	replace 				race_recode=67 if race=="7,10"
	replace 				race_recode=68 if race=="7,11"
	replace 				race_recode=69 if race=="7,12"
	replace 				race_recode=70 if race=="8,9"
	replace 				race_recode=71 if race=="8,10"
	replace 				race_recode=72 if race=="8,11"
	replace 				race_recode=73 if race=="8,12"
	replace 				race_recode=74 if race=="9,10"
	replace 				race_recode=75 if race=="9,11"
	replace 				race_recode=76 if race=="9,12"
	replace 				race_recode=77 if race=="10,11"
	replace 				race_recode=78 if race=="10,12"
	replace 				race_recode=79 if race=="11,12"
	
	label define 			Race 1 "American Indian or Alaskan Native" 2 "Asian Indian" 3 "Black or African American" 4 "Chamorro" 5 "Chinese" 6 "Filipino" 7 "Japanese" 8 "Korean" 9 "Native Hawaiin" 10 "Samoan" 11 "Vietnamese" 12 "White" 13 "Other race or origin" 14 "American Indian or Alaskan Native and Asian Indian" 15 "American Indian or Alaskan Native and Black or African American" 16 "American Indian or Alaskan Native and Chamorro" 17 "American Indian or Alaskan Native and Chinese" 18 "American Indian or Alaskan Native and Filipino" 19 "American Indian or Alaskan Native and Japanese" 20 "American Indian or Alaskan Native and Korean" 21 "American Indian or Alaskan Native and Native Hawaiian" 22 "American Indian or Alaskan Native and Samoan" 23 "American Indian or Alaskan Native and Vietnamese" 24 "American Indian or Alaskan Native and White" 25 "Asian Indian and Black or African American" 26 "Asian Indian and Chamorro" 27 "Asian Indian and Chinese" 28 "Asian Indian and Filipino" 29 "Asian Indian and Japanese" 30 "Asian Indian and Korean" 31 "Asian Indian and Native Hawaiian" 32 "Asian Indian and Samoan" 33 "Asian Indian and Vietnamese" 34 "Asian Indian and White" 35 "Black or African American and Chamorro" 36 "Black or African American and Chinese" 37 "Black or African American and Filipino" 38 "Black or African American and Japanese" 39 "Black or African American and and Korean" 40 "Black or African American and Native Hawaiian" 41 "Black or African American and and Samoan" 42 "Black or African American and Vietnamese" 43 "Black or African American and and White" 44 "Chamorro and Chinese" 45 "Chamorro and Filipino" 46 "Chamorro and Japanese" 47 "Chamorro and Korean" 48 "Chamorro and Native Hawaiian" 49 "Chamorro and Samoan" 50 "Chamorro and Vietnamese" 51 "Chamorro and White" 52 "Chinese and Filipino" 53 "Chinese and Japanese" 54 "Chinese and Korean" 55 "Chinese and Native Hawaiian" 56 "Chinese and Samoan" 57 "Chinese and Vietnamese" 58 "Chinese and White" 59 "Filipino and Jananese" 60 "Filipino and Korean" 61 "Filipino and Native Hawaiian" 62 "Fillipino and Samoan" 63 "Filipino and Vietnamese" 64 "Fillipino and White" 65 "Japanese and Korean" 66 "Japanese and Native Hawaiian" 67 "Japanese and Samoan" 68 "Japanese and Vietnamese" 69 "Japanese and White" 70 "Korean and Native Hawaiian" 71 "Korean and Samoan" 72 "Korean and Vietnamese" 73 "Korean and White" 74 "Native Hawaiian and Samoan" 75 "Native Hawaiian and Vietnamese" 76 "Native Hawaiian and White" 77 "Samoan and Vietnamese" 78 "Samoan and White" 79 "Vietnamese and White"

	label values 			race_recode Race
	label var				race_recode "Race"
	
	* craetion of dummy var 
	* creates a dummy for each possible outcome
	
	tab 					(race_recode), gen(race_dummy_)
	
	* drop race var 
	drop					race
	
* Item 25 (Qualtrics var name Q27) - Which of the following best describes your
* household income range in 2019 before taxes?

	* labels for Q27
	
	rename 					Q27 income
	label define 			Income 1 "Less than $10,000" 2 "$10,000 to $14,999" 3 "$15,000 to $24,999" 4 "$25,000 to $34,999" 5 "$35,000 to $49,999" 6 "$50,000 to $74,999" 7 "$75,000 to $99,999" 8 "$100,000 to $149,000" 9 "$150,000 to $199,999" 10 "$200,000 or more"
	label values 			income Income
	label var 				income "Income Range"	

* Item 26 (Qualtrics var name Q28) - How long have you lived in the United States?

	* labels for Q28
	
	rename 					Q28 years_usa
	label define 			years_in_usa 1 "I was born in the US" 2 "Less than 5 years" 3 "5 - 10 years" 4 "10 or more years"
	label values 			years_usa years_in_usa
	label var 				years_usa "Years Living in USA"
	
* Item 27 (Qualtrics var name Q29) - Whichc of the following political 
* affiliations do you most identify with? 

	* labels for Q29

	rename 					Q29 political
	label define 			Political 1 "Democrat" 2 "Green Party" 3 "Independent" 4 "Libertarian" 5 "No affiliation" 6 "Progressive" 7 "Republican" 8 "Other"
	label values 			political Political
	label var 				political "Political Affiliation"
	label var 				Q29_8_TEXT "Political Affiliation Text"
	
* Item 28 (Qualtrics var name Q30) - Do you have any additional comments or
* experiences related to the issue of food during the COVID-19 outbreak that you
* would like to share? Please use this

	* labels for Q30
	
	rename 					Q30 other_comments
	label var 				other_comments "Any Other Comments"
	
* ***********************************************************************
* 7 - Comparisons of screener questions with demographic questions
*     Created by: 
* ***********************************************************************	

* INCOME - Screener vs. Demographics* 
*
* Compare responses the do not match for screeer vars (incom_scr) vs. 
* demographic var (income_deom) to identify potential flags* 
* Make note of participant ID* 
	sort 			income_scr 
	browse if 		incomequality  == 2 
	tab 			income_demo income_scr if incomequality  == 2

	 
* ***AGE - Screener vs. Demographics***** 
* NOTE: JHU Income vars: Screener Section is Qs6;  Demographics Section is Q22 

	destring 		Qs6, replace 			
	gen 			age_scr  =  Qs6 
	lab 			var age_scr "Qs6 Age Categories in Screener" 
	lab 			def Age_Scr 1 "< 18 yrs" 2" 18-34 yrs" 3 "35-54 yrs" ///
						4 "55 yrs+" 
	lab 			val age_scr Age_Scr 

	destring 		Q22, replace 			
	gen 			age  =  2020 - Q22 
	recode 			age (18/34 = 1)(35/54 = 2) (55/100 = 3), prefix(new_) 

	tab 			age_scr new_age, m 

	gen 			age_qualcheck  = . 
	replace 			age_qualcheck  =  1 if age_scr  == 2 & new_age  == 1
	replace 			age_qualcheck  =  2 if age_scr  == 3 & new_age  == 2 
	replace 			age_qualcheck  =  3 if age_scr  == 4 & new_age  == 3
	replace 			age_qualcheck  =  4 if age_scr  == 1 & age <18 
	replace 			age_qualcheck  =  5 if age_scr  == . | age  == . 
	recode 			age_qualcheck (1/3 = 1) (4  = 2) (5 = 3) (. = 4) 
	lab 			var age_qualcheck "Age Data Quality Check" 
	lab 			def data_quality_match_age 1 "Matched" ///
						2 "Under 18/Ineligible" 3 "Some Missing" 4 "No Match" 
	lab 			val age_qualcheck data_quality_match_age
	tab 			age_qualcheck
	
* Compare responses the do not match for screeer vars (age_scr) vs. 
* demographic var (income_deom) to identify potential flags* 
* Make note of participant ID's* 
	sort 			age 
	browse if 		age_qualcheck == 4
	tab 			age age_scr if age_qualcheck  == 4 


* **********************************************************************
* 8 - end matter
* **********************************************************************

* save new datasets as appropriate 

* close the log
	log	close

/* END */