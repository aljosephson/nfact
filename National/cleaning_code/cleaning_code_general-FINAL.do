* project: food security & covid
* created on: July 2020
* created by: fd + lm 
* edited by: alj, fa 
* last edited: 30 September 2020 
* Stata v.15.1 / 16 

* does
	* cleans qualtrics response data
	* data must be downloaded from qualtrics following xxx 
	* outputs as: "food_security_data_cleaned.csv"
	
* assumes
	* MS designates "multiple select" question from survey
	* access to code book 
	
* notes 
/* ON TYPES OF MISSING VALUES

	* SYSTEM MISSING (missing observations from respondents who DID SEE a 
		question and did NOT answer it) are recorded in Qualtrics as -99 and 
		in Stata as "."
	* OMITTED MISSING (i.e., missing values from questions respondents DID NOT
		see, due to survey logic, and did NOT (could not) answer) are 
		recorded in Qualtrics as BLANKS and Stata as ".a"
	* Values of "I DON'T KNOW" or similar are coded as 99 
	* Values of "DOES NOT APPLY / NOT APPLICABLE ' ETC. are coded as 88 
	* labels for 99 and 88 are updated when used */	

* **********************************************************************
* 0 - setup
* **********************************************************************
* update for user as appropriate 

* set cd 
	clear					all
	cd 						"..."
	*** need to enter cd 
	
* start log
	*cap log off 
	*log using "", replace
	*** will need to enter file

* ***********************************************************************
* 1 - prepare exported data
* *********************************************************************** 

* load data
	*clear
	import excel "...", sheet("Sheet0") firstrow case(lower)
	*** put in file name
	
	
* Cleaning 	
	
	drop in 1	 
	*** as exported without modifications in excel, will need to drop first row, as it is just a repeat of the labels 

* drop Qualtrics survey metadata
	
	drop					recipientlastname recipientfirstname ///
							recipientemail externalreference responseid
															
* drop first row (labels from qualtrics export)	
	drop if 				startdate == "Start Date" 
	
	
* rename and label intro/screener variables 		
* want to use screener data for weights, income, etc.					
	rename					qs3 resp_consent
	label var				resp_consent "Respondent Consent"
	
	rename					qs6 scrn_age_group
tab scrn_age_group		
	label var				scrn_age_group "Screen: Age Group"
	
	clonevar 				scrn_genderid = qs7
	label var				scrn_genderid "Screen: Gender Identity"            
	tab 					scrn_genderid, miss
	replace 				scrn_genderid = "6" if strpos(scrn_genderid, ",")
	tab 					scrn_genderid, miss	
	destring 				scrn_genderid, replace	

	replace					scrn_genderid = 3 if scrn_genderid>=3 & scrn_genderid!=.
	label 					define gender  1 "1=male" 2 "2=female" 3 "3=other" 
	label 					value	scrn_genderid gender
	tab 					scrn_genderid, miss
	tab 					qs7 scrn_genderid, miss
	
	rename					qs7_5_text text_scrn_genderid
	label var				text_scrn_genderid "Screen: Text: Gender ID"
	
	rename					qs8	scrn_hisplat_origin
	label var				scrn_hisplat_origin "Screen: Hispanic, Latino, or Spanish Origin"
	tab 					scrn_hisplat_origin, miss
		
	clonevar 				scrn_race = qs9
	label var				scrn_race "Screen: Race"							
	tab 					scrn_race, miss
	replace 				scrn_race = "6" if strpos(scrn_race, ",")
	tab 					scrn_race, miss	
	destring 				scrn_race, replace	
	replace 				scrn_race = 5 if scrn_race==6
	label 					define race_1  1 "1=Asian" 2 "2=Black" 3 "3=Native American" 4 "4=White" 5 "5=Other/Multiple"
	label 					value	scrn_race race_1
	tab 					scrn_race, miss
	tab 					qs9 scrn_race, miss	
	
	
* RACE/ETHNICITY 
gen RACE = . 
replace RACE = 0 if scrn_hisplat_origin == "1"
replace RACE = 1 if scrn_race == 4 & RACE == .
replace RACE = 2 if scrn_race == 2 & RACE == .
replace RACE = 3 if scrn_race == 1 & RACE == .
replace RACE = 4 if scrn_race == 3 & RACE == .
replace RACE = 5 if scrn_race == 5 & RACE == .
label define race_ethnicity  0 "0=Hispanic" 1 "1=NH white" 2 "2=NH Black" 3 "3=Asian" 4 "4=Native American" 5 "5=Other/Multiple"	
label value	RACE race_ethnicity
tab RACE, miss
bysort scrn_hisplat_origin: tab RACE scrn_race, miss	

	
	rename 					qs9_5_text text_scrn_race
	label var				text_scrn_race "Screen: Text: Race"					

	
	rename 					qs10 scrn_educ
	
	
	label var				scrn_educ "Screen: Education"					
tab scrn_educ, miss
destring scrn_educ, replace

gen EDUC = . 
replace EDUC = 1 if scrn_educ==1 | scrn_educ==2
replace EDUC = 2 if scrn_educ==3
replace EDUC = 3 if scrn_educ==4
replace EDUC = 4 if scrn_educ==5
replace EDUC = 5 if scrn_educ==6
label define education   1 "1=HS or less" 2 "2=Some college" 3 "3=Associates degree" 4 "4=College degree" 5 "5=More advanced degree" 
label value	EDUC education
tab EDUC scrn_educ, miss


		
	rename					qs11 scrn_income
tab scrn_income, miss
destring scrn_income, replace	
	label var				scrn_income "Screen: Income"
	label 					define Income_Screener 1 "Less than $10,000" 2 "$10,000-$24,999" ///
								3 "$25,000-$49,999" 4 "$50,000-$74,999" 5 "$75,000-$99,999" 6 "$100,000 or more" 
	label values 			scrn_income Income_Screener 
	
* create observation ID variable - to easily identify data point for potential removal 
	generate 				obs_Id= _n

* ***********************************************************************
* 2 - internal consistency 
* ***********************************************************************	

* update later as needed 
* will include checks done for consistency 
* these are currently done in Excel

* ***********************************************************************
* 3 - Part 1/5: General Food Access
*     Created by: lem, Joelle
*	  edited by: alj, fa
* ***********************************************************************	

* Item 1 (Qualtrics var name "Q1"): Which of the following places did your 
* household use to get food in the last year and since the COVID-19 outbreak 
* (March 11th)? 

* rename text response vars to keep them out of encoding loop below

	rename 				source_othertxt_1 text_source_yr
	rename 				source_othertxt_2 text_source_covid

* label food acquisition vars
	
	lab var 			source_groc "Source: Grocery"
	lab var 			source_conv "Source: Convienience"
	lab var 			source_spec "Source: Specialty"
	lab var 			source_grocdel "Source: Grocery Delivery"
	lab var 			source_mealdel "Source: Meal Kit Delivery"
	lab var 			source_mow "Source: Meals on Wheels"
	lab var 			source_restdel "Source: Resturant Delivery"
	lab var 			source_restin "Source: Restaurant Eat In"
	lab var 			source_prog "Source: Food Programs"
	lab var 			source_group  "Source: Congregate"
	lab var 			source_farmmkt "Source: Farm Market"
	lab var 			source_localfrm "Source: CSA"
	lab var				source_grow "Source: Own Canned Goods, Fish, Hunt"
	lab var				source_otherbin	"Source: Other"
	lab var				text_source_yr "Source: Additional sources (year)"
	lab var				text_source_covid "Source: Additional sources (COVID)"
	
* Recode Loop (Used for Items: )
	* appends "_temp" to original "source_" variables: `v'_temp
	* encodes source_ variables generating a numeric var with the original
		* string vars as value labels: `v'
	* replaces values in the NEW source var where all values are SYSTEM 
		* missings: .
	* replaces values of new label based on values of original var
	* replaces OMITTED missing values with ".a"
	* defines and assigns labels
	* drops ORIGINAL string variable: `v'_temp
	
	foreach v of varlist source* {    
	   rename 			`v' `v'_temp
	   encode 			`v'_temp, gen(`v') 
	   replace			`v' = .
	   replace 			`v' = 1 if `v'_temp == "1,2" 
	   replace 			`v' = 2 if `v'_temp == "1"
	   replace 			`v' = 3 if `v'_temp == "2"
	   replace 			`v' = 4 if `v'_temp == "3"
	   replace			`v' = . if `v'_temp == "-99"
	   replace			`v' = 99 if `v'_temp == "99"
	   lab def 			`v'_lab1  1 "Always Used" 2 "Stopped Since COVID" 3 ///
							"Started Since COVID" 4 "Never Used" 
	   lab val 			`v'  `v'_lab1
	   drop 			*_temp
	   }	
	  	  
	tab1				source_*, miss	
	sum 				source_*
	   
* BINARY VARIABLES LOOP (Used for items:
* source_X_prior where 1 = used before and 0 otherwise (ie "since")
	foreach v of varlist source_* {
	gen 				`v'_prior = .
	replace 			`v'_prior = . if `v' == .
	replace 			`v'_prior = 1 if `v' == 1 | `v' == 2
	replace 			`v'_prior = 0 if `v' == 3 | `v' == 4 
	label var			`v'_prior "Used `v' before COVID"
	}	   
	   
	tab1 				*_prior, miss
	sum					*_prior 
	
* source_X_since where 0 = used before and 1 = used since
	foreach v of varlist source_* {
	gen 				`v'_since = .
	replace 			`v'_since = . if `v' == .
	replace 			`v'_since = 0 if `v' == 4 | `v' == 2
	replace 			`v'_since = 1 if `v' == 3 | `v' == 1 
	label var			`v'_since "Used `v' since COVID"
	}	   
	   
	drop 				*_prior_since
   	   
	tab1 				*_since, miss
	sum 				*_since
	
	
	tab1 				source_grow source_grow_prior source_grow_since, miss
	

* Item 2 (Qualtrics var names "Q2#covid" & "Q2#year"): How true are these 
* statements about your household’s food situation in the year before the 
* COVID-19 outbreak and since the COVID-19 outbreak on March 11th? 

* same process as above; label variables

	lab var				usda_foodlast_year "USDA: Food didn't last (year)"
	lab var				usda_foodlast_covid  "USDA: Food didn't last (since COVID)"
	lab var				usda_afford_year "USDA: Can't afford to eat (year)"
	lab var				usda_afford_covid "USDA: Can't afford to eat (COVID)"
	
	tab1 				usda_foodlast* usda_afford*, miss	

* --> The food that my household bought just didn't last, and I/we didn't 
* have money to get more (year before): usda_foodlast_year
* --> I/we couldn't afford to eat balanced meals (year before): usda_afford_year

tostring usda_foodlast_year usda_afford_year, replace

	foreach v of varlist usda_foodlast_year usda_afford_year{               
		rename 			`v' `v'_temp
		encode 			`v'_temp, gen(`v')
		replace 		`v' = .		  
		replace 		`v' = 1 if `v'_temp == "1" 
	    replace 		`v' = 2 if `v'_temp == "2"
	    replace 		`v' = 3 if `v'_temp == "3"
		replace 		`v' = 99 if `v'_temp == "99"
		replace 		`v' = . if `v'_temp == "-99"
		label def 		`v'_lab2_1 1 "Never true" 2 "Sometimes true" ///
							3 "Often true" 99 "Do not know"					
		label values 	`v' `v'_lab2_1
		drop 			*_temp		 
          }

	tab1 				usda_foodlast_year, miss
	tab1 				usda_afford_year, miss		  
	sum					usda_foodlast_year usda_afford_year	  

* --> The food that my household bought just didn't last, and I/we didn't 
* have money to get more (since covid): usda_foodlast_covid
* --> I/we couldn't afford to eat balanced meals (since covid): usda_afford_covid

tostring usda_foodlast_covid usda_afford_covid, replace

	foreach v of varlist usda_foodlast_covid usda_afford_covid{
		rename 			`v' `v'_temp
		encode 			`v'_temp, gen(`v')
		replace 		`v' = .		  
		replace 		`v' = 1 if `v'_temp == "1" 
	    replace 		`v' = 2 if `v'_temp == "2"
	    replace 		`v' = 3 if `v'_temp == "3"
		replace 		`v' = 99 if `v'_temp == "0"
		replace 		`v' = 99 if `v'_temp == "99"
		replace 		`v' = . if `v'_temp == "-99"
		label def 		`v'_lab2_2 1 "Never true" 2 "Sometimes true" 3 "Often true" ///	
							99 "Do not know"
		label values 	`v' `v'_lab2_2
		drop 			*_temp		 
          }
		  		  
	tab1 				usda_foodlast_covid, miss
	tab1 				usda_afford_covid, miss	
	sum					usda_foodlast_covid usda_afford_covid
		  
		  
* Item 2A: (Qualtrics var name "Q2a#covid" and "Q2a#year"): How true are 
* these statements about your household’s food situation in the year before 
* the COVID-19 outbreak and since the COVID-19 outbreak on March 11th?

	lab var				usda_eatless_year "USDA: Eat less (year)"
	lab var				usda_eatless_covid  "USDA: Eat less(since COVID)"
	lab var				usda_cutskip_year "USDA: Cut/Skip Meals (year)"
	lab var				usda_cutskip_covid "USDA: Cut/Skip Meals (COVID)"
	lab var				usda_hungry_year "USDA: Go Hungry (year)"
	lab var				usda_hungry_covid "USDA: Go Hungry (COVID)"
	
	
tostring usda_eatless* usda_cutskip* usda_hungry*, replace	

	foreach v of varlist usda_eatless* usda_cutskip* usda_hungry*{
		rename 			`v' `v'_temp
		encode 			`v'_temp, gen(`v')
		replace 		`v' = .		  
		replace 		`v' = 1 if `v'_temp == "1" 
	    replace 		`v' = 0 if `v'_temp == "0"
		replace 		`v' = 99 if `v'_temp == "99"
		replace 		`v' = . if `v'_temp == "-99"
		label def 		`v'_lab2_3 1 "Yes" 0 "No" ///						
							99 "Do not know" 									
		label values 	`v' `v'_lab2_3
		drop 			*_temp		 
          }
  
		  
	tab1 				usda_eatless* usda_cutskip* usda_hungry*, miss
	sum 				usda_eatless* usda_cutskip* usda_hungry*
	

* Item 2B: (Qualtrics var name "Q2b#covid" and "Q2b#year"): How often did you 
* cut the size of your meals or skip meals?
* only respond if you did cut the size of your meals (per usda_cutskip*)

	lab var				usda_oftencut_year "USDA: How Often Cut/Skip Meals (year)"
	lab var				usda_oftencut_covid "USDA: How Often Cut/Skip Meals (COVID)" 


tostring usda_oftencut_year usda_oftencut_covid, replace		

	foreach v of varlist usda_oftencut_year{
		rename 			`v' `v'_temp
		encode 			`v'_temp, gen(`v')
		replace 		`v' = .		  
		replace 		`v' = 1 if `v'_temp == "1" 
	    replace 		`v' = 2 if `v'_temp == "2"
		replace 		`v' = 3 if `v'_temp == "3"
		replace		    `v' = . if `v'_temp == "-99"
		label def 		`v'_lab2_4 	1 "Only 1 or 2 months" ///
							2 "Some months but not every month" ///
							3 "Almost every month"			
		label values 	`v' `v'_lab2_4
		drop 			*_temp		 
          }
		  
		replace		    usda_oftencut_year = .a if usda_cutskip_year == 0
		tab 			usda_oftencut_year, missing 
		
		tab 			usda_cutskip_year usda_oftencut_year, miss		
		replace			usda_cutskip_year = 1 if usda_oftencut_year == 1 | ///
							usda_oftencut_year == 2 | usda_oftencut_year == 3 /* ADDED */ 
		tab 			usda_cutskip_year usda_oftencut_year, miss	

		tab 			usda_oftencut_covid, miss
		tab 			usda_oftencut_covid, nola

		
	foreach v of varlist usda_oftencut_covid{
		rename 			`v' `v'_temp
		encode 			`v'_temp, gen(`v')
		replace 		`v' = .		  
		replace 		`v' = 1 if `v'_temp == "1" 
	    replace 		`v' = 2 if `v'_temp == "2"
		replace 		`v' = 3 if `v'_temp == "3"
		replace		    `v' = . if `v'_temp == "-99"
		label def 		`v'oftencutcv 1 "Only one or two weeks" 2 "Some weeks but not every week" 3 "Almost every week" 	
		label values 	`v' `v'oftencutcv
		drop 			*_temp		 
          }
		  
	replace		    usda_oftencut_covid = .a if usda_cutskip_covid == 0
	tab 			usda_oftencut_covid, missing 

		
tab usda_cutskip_covid usda_oftencut_covid, miss		
replace	usda_cutskip_year = 1 if usda_oftencut_year == 1 | usda_oftencut_year == 2 | usda_oftencut_year == 3 /* ADDED */ 
tab usda_cutskip_covid usda_oftencut_covid, miss		
	  
	
	tab1 				usda_oftencut_year	usda_oftencut_covid, miss 
	sum 				usda_oftencut_year	usda_oftencut_covid 

	
*********************	
*** FOOD SECURITY *** 
*********************

*** SINCE COVID ***	
	
tab1 usda_foodlast_covid usda_afford_covid usda_eatless_covid usda_cutskip_covid usda_hungry_covid usda_oftencut_covid, miss

gen FSS_since = 0 
label variable FSS_since "Food security scale (0-6) since covid" 

*1
tab1 usda_foodlast_covid, miss	
tab1 usda_foodlast_covid, miss nola
replace FSS_since = FSS_since + 1  if usda_foodlast_covid==2 | usda_foodlast_covid==3

*2
tab1 usda_afford_covid, miss	
tab1 usda_afford_covid, miss nola
replace FSS_since = FSS_since + 1  if usda_afford_covid==2 | usda_afford_covid==3

*3 
tab usda_eatless_covid, miss 
tab usda_eatless_covid, miss nola
replace FSS_since = FSS_since + 1  if usda_eatless_covid==1
	
*4 
tab usda_hungry_covid, miss 
tab usda_hungry_covid, miss nola
replace FSS_since = FSS_since + 1  if usda_hungry_covid==1	
		
*5
tab usda_cutskip_covid, miss 
tab usda_cutskip_covid, miss nola
replace FSS_since = FSS_since + 1  if usda_cutskip_covid==1	
	
*6
tab usda_oftencut_covid, miss 
tab usda_oftencut_covid, miss nola
replace FSS_since = FSS_since + 1  if usda_oftencut_covid==2  
replace FSS_since = FSS_since + 1  if usda_oftencut_covid==3

tab FSS_since, miss	
	
gen count_miss_usda_since = 0 
label variable count_miss_usda_since "How many of the USDA questions (since covid) are missing or DK"
replace count_miss_usda_since = count_miss_usda_since+1 if usda_foodlast_covid==99 | usda_foodlast_covid==.
replace count_miss_usda_since = count_miss_usda_since+1 if usda_afford_covid==99   | usda_afford_covid==.	
replace count_miss_usda_since = count_miss_usda_since+1 if usda_eatless_covid==99  | usda_eatless_covid==.	
replace count_miss_usda_since = count_miss_usda_since+1 if usda_hungry_covid==99   | usda_hungry_covid==.	
replace count_miss_usda_since = count_miss_usda_since+1 if usda_cutskip_covid==99  | usda_cutskip_covid==.	
replace count_miss_usda_since = count_miss_usda_since+1 if usda_oftencut_covid==99 | usda_oftencut_covid==.	

tab count_miss_usda_since

tab FSS_since count_miss_usda_since, miss 

replace FSS_since = . if FSS_since == 0 & count_miss_usda_since>1
replace FSS_since = . if FSS_since == 1 & count_miss_usda_since>0

tab FSS_since count_miss_usda_since, miss


*** PRIOR TO COVID ***	

tab1 usda_foodlast_year usda_afford_year usda_eatless_year usda_cutskip_year usda_hungry_year usda_oftencut_year, miss

gen FSS_prior = 0 
label variable FSS_prior "Food security scale (0-6) prior year" 

*1
tab1 usda_foodlast_year, miss	
tab1 usda_foodlast_year, miss nola
replace FSS_prior = FSS_prior + 1  if usda_foodlast_year==2 | usda_foodlast_year==3

*2
tab1 usda_afford_year, miss	
tab1 usda_afford_year, miss nola
replace FSS_prior = FSS_prior + 1  if usda_afford_year==2 | usda_afford_year==3

*3 
tab usda_eatless_year, miss 
tab usda_eatless_year, miss nola
replace FSS_prior = FSS_prior + 1  if usda_eatless_year==1
	
*4 
tab usda_hungry_year, miss 
tab usda_hungry_year, miss nola
replace FSS_prior = FSS_prior + 1  if usda_hungry_year==1	
		
*5
tab usda_cutskip_year, miss 
tab usda_cutskip_year, miss nola
replace FSS_prior = FSS_prior + 1  if usda_cutskip_year==1	
	
*6
tab usda_oftencut_year, miss 
tab usda_oftencut_year, miss nola
replace FSS_prior = FSS_prior + 1  if usda_oftencut_year==2
replace FSS_prior = FSS_prior + 1  if usda_oftencut_year==3  

tab FSS_prior, miss	
	
gen count_miss_usda_prior = 0 
label variable count_miss_usda_prior "How many of the USDA questions (prior year) are missing or DK"
replace count_miss_usda_prior = count_miss_usda_prior+1 if usda_foodlast_year==99 | usda_foodlast_year==.
replace count_miss_usda_prior = count_miss_usda_prior+1 if usda_afford_year==99   | usda_afford_year==.	
replace count_miss_usda_prior = count_miss_usda_prior+1 if usda_eatless_year==99  | usda_eatless_year==.	
replace count_miss_usda_prior = count_miss_usda_prior+1 if usda_hungry_year==99   | usda_hungry_year==.	
replace count_miss_usda_prior = count_miss_usda_prior+1 if usda_cutskip_year==99  | usda_cutskip_year==.	
replace count_miss_usda_prior = count_miss_usda_prior+1 if usda_oftencut_year==99 | usda_oftencut_year==.	

tab count_miss_usda_prior

tab FSS_prior count_miss_usda_prior, miss 

replace FSS_prior = . if FSS_prior == 0 & count_miss_usda_prior>1
replace FSS_prior = . if FSS_prior == 1 & count_miss_usda_prior>0

tab FSS_prior count_miss_usda_prior, miss


*** FOOD SECURITY ***

tab1 FSS_prior FSS_since, miss

gen FOOD_SECURITY_prior = . 
label variable FOOD_SECURITY_prior "Food security yes/no 12 months prior to covid" 
replace FOOD_SECURITY_prior = 1 if FSS_prior==0 | FSS_prior==1
replace FOOD_SECURITY_prior = 0 if FSS_prior>=2 & FSS_prior<=6
label define yesno 0 "0=No" 1 "1=Yes" 
label values FOOD_SECURITY_prior yesno 
tab FSS_prior FOOD_SECURITY_prior, miss	

gen FOOD_SECURITY_since = . 
label variable FOOD_SECURITY_since "Food security yes/no since covid" 
replace FOOD_SECURITY_since = 1 if FSS_since==0 | FSS_since==1
replace FOOD_SECURITY_since = 0 if FSS_since>=2 & FSS_since<=6
label values FOOD_SECURITY_since yesno 
tab FSS_since FOOD_SECURITY_since, miss	


tab FOOD_SECURITY_prior FOOD_SECURITY_since, miss

tab FOOD_SECURITY_prior FOOD_SECURITY_since, cell

	
* Item 3 (Qualtrics var name "Q3"): Which of the following food assistance 
* programs did your household use in the past, if any, and since the COVID-19 
* outbreak (March 11)? 

* rename text response vars to keep them out of encoding loop below

	rename				prog_othertxt_1 text_prog_yr
	rename				prog_othertxt_2 text_prog_covid
	
* label prog vars

	lab var 			prog_snap "Programs: SNAP Participation"
	lab var			    prog_wic "Programs: WIC Particpation"
	lab var 			prog_school "Programs: School Foods Participation"
	lab var 			prog_pantry "Programs: Food Pantry Participation"
	lab var				prog_other "Programs: Other Participation"
	lab var				text_prog_yr "Programs: Other programs (Yr)"
	lab var				text_prog_covid "Programs: Other programs (Covid)"
		

* loop to recode, appends "temp" to source vars and renames encoded vars
	
	foreach v of varlist prog_* {    
		rename 			`v' `v'_temp
		encode 			`v'_temp, gen (`v') 
		replace			`v' = .
		replace 		`v' = 1 if `v'_temp == "1,2" 
		replace 		`v' = 2 if `v'_temp == "1"
		replace 		`v' = 3 if `v'_temp == "2"
		replace 		`v' = 4 if `v'_temp == "3"
		replace			`v' = . if `v'_temp == "-99"
		lab def 		`v'_lab3  1 "Always Used" 2 "Stopped Since COVID" 3 ///
						"Started Since COVID" 4 "Never Used"
		lab val 		`v'  `v'_lab3
		drop 			*_temp
	   }	
	   
		tab1 			prog*, miss 
		sum				prog*
	   
*binary variables for prog_X_prior where 1 = used before and 0 otherwise (ie "since")
	foreach v of varlist prog_* {
	gen 				`v'_prior = .	
	replace 			`v'_prior = . if `v' == .
	replace 			`v'_prior = 1 if `v' == 1 | `v' == 2
	replace 			`v'_prior = 0 if `v' == 3 | `v' == 4 
	label var			`v'_prior "Used `v' before COVID"
	}

	tab1 				*_prior, miss 
	
* source_X_since where 0 = used before and 1 = used since
	foreach v of varlist prog_* {
	gen 				`v'_since = .
	replace 			`v'_since = . if `v' == .
	replace 			`v'_since = 0 if `v' == 4 | `v' == 2
	replace 			`v'_since = 1 if `v' == 3 | `v' == 1 
	label var			`v'_since "Used `v' since COVID"
	}	   
	   
	drop 				*_prior_since   
	   
	tab1 				*_since, miss
	sum 				*_since
	
* Item 3A (Qualtrics var name "Q3a"): Please indicate your level of agreement 
* regarding using SNAP (or Food Stamps) food benefits since the COVID-19 
* outbreak.


* rename text response vars to keep them out of encoding loop below

	rename				q3atxt text_othercomments_snap
	rename 				snap_usefull snap_unable
	
* label SNAP vars

	lab var 			snap_easy   "SNAP: Easy to use"
	lab var				snap_enough "SNAP: Enough"
	lab var				snap_online "SNAP: Online"
	lab var				snap_unable "SNAP: Unable to use all benefits"
	lab var				text_othercomments_snap "SNAP: Other comments"

* loop to recode, appends "temp" to source vars and renames encoded vars

tostring snap_*, replace 
	
	foreach v of varlist snap_* {    
	   rename 			`v' `v'_temp
	   encode 			`v'_temp, gen (`v') 
	   replace			`v' = .
	   replace 			`v' = 1 if `v'_temp == "1" 
	   replace 			`v' = 2 if `v'_temp == "2"
	   replace 			`v' = 3 if `v'_temp == "3"
	   replace 			`v' = 4 if `v'_temp == "4"
	   replace 			`v' = 5 if `v'_temp == "5" 
	   replace			`v' = . if `v'_temp == "-99"
	   replace 			`v' = .a if prog_snap == 4 | prog_snap == 2				
	   lab def 			`v'_lab3a  1 "Strongly disagree" 2 "Disagree" ///
						3 "Neither agree nor disagree" 4 "Agree" ///
						5 "Strongly agree"	   

	   lab val 			`v'  `v'_lab3a
	   	drop 			*_temp	
	   }	 
		
		tab1 			snap_*, miss 
		sum 			snap_*

* Item 3B (Qualtrics var name "Q3b") : Please indicate your level of agreement 
* regarding using WIC benefits since the COVID-19 outbreak.

	rename				q3btxt text_othercomments_wic
	rename 				wic_useful wic_unable
	
* label WIC vars

	lab var 			wic_easy "WIC: Easy"
	lab var				wic_limited "WIC: Limited"
	lab var				wic_online "WIC: Online"
	lab var				wic_unable "WIC: Unable to use all benefits"
	lab	var				text_othercomments_wic "WIC: Other Comments"

* loop to recode, appends "temp" to source vars and renames encoded vars

tostring wic_*, replace
	
	foreach v of varlist wic_* {    
	   rename `v' `v'_temp
	   encode `v'_temp, gen (`v') 
	   replace			`v' = .
	   replace 			`v' = 1 if `v'_temp == "1" 
	   replace 			`v' = 2 if `v'_temp == "2"
	   replace 			`v' = 3 if `v'_temp == "3"
	   replace 			`v' = 4 if `v'_temp == "4"
	   replace 			`v' = 5 if `v'_temp == "5" 
	   replace			`v' = . if `v'_temp == "-99"
	   replace 			`v' = .a if prog_wic == 4 | prog_wic == 2				
		lab def 		`v'_lab3b  1 "Strongly disagree" 2 "Disagree" ///
		3 "Neither agree nor disagree" 4 "Agree" 5 "Strongly agree"
	   lab val 			`v'  `v'_lab3b
	   	drop 			*_temp	   
	   }	

   	tab1 				wic_*, miss 
	sum					wic_*
					

* Item 3C (Qualtrics var name "Q3c"): Please indicate your level of agreement 
* regarding using School Meals for children in your household since the 
* COVID-19 outbreak.

* rename text response vars to keep them out of encoding loop below

	rename				q3ctxt text_othercomments_pebt

* label school vars

	lab var 			school_helpful "School: Helpful"
	lab var				school_notopen "School: Not Open"
	lab var				school_kitchen "School: No Kitchen Eqp"
	lab var				school_hard "School: Meal Deliv. Hard to Arrange"
	lab var 			school_time "School: Inconvenient time"
	lab var				school_place "School: Inconvenient location"
	lab var				school_runout "School: Run out of meals before next time"
	lab var				school_pebt "School: PEBT card is helpful"
	lab var				text_othercomments_pebt "School: Other Comments: PEBT"
	

* loop to recode, appends "temp" to source vars and renames encoded vars

tostring school_*, replace
	
foreach v of varlist school_* {    
	   rename 			`v' `v'_temp
	   encode 			`v'_temp, gen (`v') 
	   replace			`v' = .
	   replace 			`v' = 1 if `v'_temp == "1" 
	   replace 			`v' = 2 if `v'_temp == "2"
	   replace 			`v' = 3 if `v'_temp == "3"
	   replace 			`v' = 4 if `v'_temp == "4"
	   replace 			`v' = 5 if `v'_temp == "5" 
	   replace			`v' = 88 if `v'_temp == "88"
	   replace 			`v' = .a if prog_school == 4 | prog_school == 2				
	   replace			`v' = . if `v'_temp == "-99"
	   lab def 			`v'_lab3c  1 "Strongly disagree" 2 "Disagree" 3 "Neither agree nor disagree" ///
							4 "Agree" 5 "Strongly agree" 88 "Not Applicable"
	   lab val 			`v'  `v'_lab3c
	   	drop 			*_temp	    
	   }	

		tab1 			school_*, miss 
		sum 			school_*


* Item 3D (Qualtrics var name "Q3d") : Please indicate your level of agreement 
* regarding using a food pantry/food bank since the COVID-19 outbreak.


* rename text response vars to keep them out of encoding loop below

	rename				q3dtxt text_othercomments_pantry

* label pantry vars

	lab var			    pantry_helpful "Food Pantry: Food offered is helpful"
	lab var			    pantry_foodlike "Food Pantry: Does not have food we like"
	lab var			    pantry_foodquality "Food Pantry: No good quality food"
	lab var			    pantry_foodprepare "Food Pantry: Don't know how to prepare"
	lab var			    pantry_runsout "Food Pantry: Runs out often"
	lab var			    pantry_hours "Food Pantry: Hrs inconvenient/irregular"
	lab var			    pantry_lines "Food Pantry: Long lines and wait"
	lab var			    pantry_limits "Food Pantry: Limited visits"
	lab var				text_othercomments_pantry "Food Pantry: Other Comments"
	
	
* loop to recode, appends "temp" to source vars and renames encoded vars

tostring pantry_*, replace
	
foreach v of varlist pantry_* {    
	   rename 			`v' `v'_temp
	   encode 			`v'_temp, gen (`v') 
	   replace			`v' = .
	   replace 			`v' = 1 if `v'_temp == "1" 
	   replace 			`v' = 2 if `v'_temp == "2"
	   replace 			`v' = 3 if `v'_temp == "3"
	   replace 			`v' = 4 if `v'_temp == "4"
	   replace 			`v' = 5 if `v'_temp == "5" 
	   replace			`v' = . if `v'_temp == "-99"
	   replace 			`v' = .a if prog_pantry == 4 | prog_pantry == 2				 
	   lab def 			`v'_lab3d  1 "Strongly disagree" 2 "Disagree" ///
							3 "Neither agree nor disagree" 4 "Agree" 5 "Strongly agree" 
	   lab val 			`v'  `v'_lab3d
		drop 		    *_temp	
	   }	

	tab1 				pantry_*, miss
	sum					pantry_*
	
	
	
* create a binary variable indicating households who did not use ANY of these programs prior/since covid 

gen prog_anyuse_prior = .
label var prog_anyuse_prior "Used ANY food assistance programs prior to covid" 
replace prog_anyuse_prior = 0 if prog_snap_prior==0 & prog_wic_prior==0 & ///
							prog_school_prior==0 & prog_pantry_prior==0 & prog_other_prior==0 		
replace prog_anyuse_prior = 1 if prog_snap_prior==1 | prog_wic_prior==1 | ///
							prog_school_prior==1 | prog_pantry_prior==1 | prog_other_prior==1 
label values prog_anyuse_prior yesno 
tab prog_anyuse_prior, miss	

gen prog_anyuse_since = .
label var prog_anyuse_since "Used ANY food assistance programs since covid" 
replace prog_anyuse_since = 0 if prog_snap_since==0 & prog_wic_since==0 & ///
							prog_school_since==0 & prog_pantry_since==0 & prog_other_since==0 		
replace prog_anyuse_since = 1 if prog_snap_since==1 | prog_wic_since==1 | ///
							prog_school_since==1 | prog_pantry_since==1 | prog_other_since==1 
label values prog_anyuse_since yesno 
tab prog_anyuse_since, miss
	
* Item 3E (Qualtrics var name "Q3e") : Please indicate your level of agreement
* regarding concerns and barriers to using income-based food programs and food 
* pantries since the COVID-19 outbreak.
* skips apply here - only respond to these if you use these programs 
	
* label prog vars

	lab var			    foodprog_paperwork "Food Programs: Worried about paperwork"
	lab var			    foodprog_indep "Food Programs: Don't want to rely"
	lab var			    foodprog_travel "Food Programs: Difficult to travel"
	lab var			    foodprog_assets "Food Programs: Can't qualify because too many assets"
	lab var			    foodprog_stigma "Food Programs: Stigma"

* loop to recode, appends "temp" to source vars and renames encoded vars

tostring foodprog_*, replace

tab1 				foodprog_*, miss 
	
foreach v of varlist foodprog_* {    
	   rename 			`v' `v'_temp
	   encode 			`v'_temp, gen (`v') 		
	   replace			`v' = .
	   replace 			`v' = 1 if `v'_temp == "1" 
	   replace 			`v' = 2 if `v'_temp == "2"
	   replace 			`v' = 3 if `v'_temp == "3"
	   replace 			`v' = 4 if `v'_temp == "4"
	   replace 			`v' = 5 if `v'_temp == "5" 
	   replace			`v' = . if `v'_temp == "-99"	   
	   lab def 			`v'_lab3e  1 "Strongly disagree" 2 "Disagree" 3 "Neither agree nor disagree" 4 "Agree" 5 "Strongly agree"
	   lab val 			`v'  `v'_lab3e
	   	drop 			*_temp	
	   }	

	tab1 				foodprog_*, miss 
	sum					foodprog_*
	

* Item 4 (Qualtrics var name "Q4"):	What were the typical types of transportation 
* you used to get food for your household, in the last 12 months and since the 
* COVID-19 outbreak? 

* rename text response vars to keep them out of encoding loop below

	rename				q4txt_1_1 text_trans_addltypesyr
	rename				q4txt_1_2 text_trans_addltypescovid
	
* label prog vars

	lab var 			trans_bus "Transportation: Bus"
	lab var			    trans_vehicle "Transportation: Own Vehicle"
	lab var 			trans_friend "Transportation: Friend/Family/Neighbor"
	lab var 			trans_taxi "Transportation: Taxi/Lyft"
	lab var 			trans_bringfood "Transportation: Someone Brings Food"
	lab var			    trans_walk "Transportation: Walk/Bike"
	lab var				text_trans_addltypesyr "Transportation: Additional Types of Transportation (Yr)"
	lab var				text_trans_addltypescovid "Transportation: Additional Types of Transportation (Covid)"
	lab var 			trans_otherbin "Transportation: Other Types"


* loop to recode, appends "temp" to source vars and renames encoded vars
	
foreach v of varlist trans_* {    
	   rename `v' `v'_temp
	   encode `v'_temp, gen (`v') 
	   replace			`v' = .
	   replace 			`v' = 1  if `v'_temp == "1,2" 
	   replace 			`v' = 2 if `v'_temp == "1"
	   replace 			`v' = 3 if `v'_temp == "2"
	   replace 			`v' = 4 if `v'_temp == "3"
	   replace			`v' = . if `v'_temp == "-99"
	   lab def 			`v'_lab4  1 "Always Used" 2 "Stopped Since COVID" 3 ///
							"Started Since COVID" 4 "Never Used" 
	   lab val 			`v'  `v'_lab4
	   	drop 				*_temp	 
	   }	

	tab1 				trans_*, miss 
	sum					trans_*
	
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

	rename				q5a text_challenge_foodwant
	label var			text_challenge_foodwant "Challenge: Text: Wanted food but could not get"
	rename				q5b text_challenge_foodget
	label var			text_challenge_foodget "Challenge: Text: Got food did not want"
	rename				q5c text_challenge_standclose
	label var			text_challenge_standclose "Challenge: Text: Had to Stand Close Getting Food"

	
* label prog vars

	lab var			    challenge_asmuch "Challenge: As Much Food"
	lab var 			challenge_kinds "Challenge: Types of Food"
	lab var			    challenge_findhelp "Challenge: Find Help"
	lab var 			challenge_moreplaces "Challenge: More Places"
	lab var			    challenge_close "Challenge: Stand Close"
	lab var 			challenge_reducgroc "Challenge:  Reduce Grocery Trips"

		
* loop to recode, appends "temp" to source vars and renames encoded vars
	
	foreach v of varlist challenge_* {    
		   rename `v' `v'_temp
		   encode `v'_temp, gen (`v') 
		   replace			`v' = .
		   replace 			`v'= 1  if `v'_temp == "1" 
		   replace 			`v' = 2 if `v'_temp == "2"
		   replace 			`v' = 3 if `v'_temp == "3"
		   replace 			`v' = 4 if `v'_temp == "4"
		   replace			`v' = 88 if `v'_temp == "88"
		   replace			`v' = . if `v'_temp == "-99"
		   lab def 			`v'_lab5  1 "Never" 2 "Sometimes" 3 "Usually" 4 "Every time" ///
								88 "Not Applicable"
		   lab val 			`v'  `v'_lab5
			drop 			*_temp	
		   }	


	tab1 				challenge_*, miss    
	sum					challenge_*

* Item 6 (Qualtrics var name "Q6"): Have you or anyone in your household 
* experienced a loss of income or job since the COVID-19 outbreak (March 11th)? 
* MS

* label job vars

	lab var 			job_loss "Job: Lost income/job"
	lab var			    job_hours "Job: Reduced hours/income"
	lab var 			job_furlo "Job: Furloughed"
	
rename job_no job_nochange
	lab var 			job_nochange "Job: No changes"
	
	
tab1 job_*, miss 	
	
foreach v of varlist job_* {    
	 rename     `v' `v'_temp
	 encode     `v'_temp, gen (`v') 
	 replace	`v' = .
	 replace 	`v' = 1 if `v'_temp == "1,2" 
	 replace 	`v' = 1 if `v'_temp == "1"
	 replace 	`v' = 1 if `v'_temp == "2"
	 replace 	`v' = 0 if `v'_temp == "-99"
	 	 
	 lab val 	`v'  yesno	
	}
	
drop job*temp
tab1 job_*, miss  
  	
tab job_nochange job_loss , miss  	
tab job_nochange job_hours, miss
tab job_nochange job_furlo, miss
tab job_nochange, miss

replace job_nochange=0 if job_loss==1 | job_hours==1 | job_furlo==1

replace job_nochange=1 if job_loss==0 & job_hours==0 & job_furlo==0


* new variable to indicate 'any change'  
gen job_anychange = . 
label variable job_anychange "Job: Any change" 
replace job_anychange = 0 if job_loss==0 & job_hours==0 & job_furlo==0
replace job_anychange = 1 if job_loss==1 | job_hours==1 | job_furlo==1
label values job_anychange yesno
tab job_anychange job_nochange, miss

drop job_nochange

tab1 job*, miss

tab FOOD_SECURITY_since job_anychange, col

bysort scrn_income: tab FOOD_SECURITY_since job_anychange, col	
	
* Item 7 (Qualtrics var name "Q7"): Have you received any money from these 
* sources since the COVID-19 outbreak?  MS


* label prog vars
	rename				q7 money
	lab var				money "Received Money"


* loop to recode, appends "temp" to source vars and renames encoded vars
	
	foreach v of varlist money {    
		   rename `v' `v'_temp
		   encode `v'_temp, gen (`v') 
		   replace			`v' = .
		   replace 			`v' = 1 if `v'_temp == "1" 
		   replace 			`v' = 2 if `v'_temp == "2"
		   replace 			`v' = 3 if `v'_temp == "3"
		   replace		    `v' = 4 if `v'_temp == "4"
		   replace 			`v' = 5 if `v'_temp == "1,2,3"
		   replace 			`v' = 6 if `v'_temp == "1,2"
		   replace 			`v' = 7 if `v'_temp == "1,3"
		   replace		    `v' = 8 if `v'_temp == "2,3"
		   replace			`v' = . if `v'_temp == "-99"
		   lab def 			`v'_labm  1 "Federal Stimulus Check" ///
								2 "Friends or family" ///
								3 "Unemployment benefits, other" ///
								4 "Did not receive money" ///
								5 "Stimulus & Friends/family & Unemployment, other" ///
								6 "Stimulus & Friends/family" ///
								7 "Stimulus & Unemployment, other" ///
								8 "Friends/family & unemployment benefits/other" 					
		   lab val 			`v'  `v'_labm
		   drop 				money_temp
		   }	

			tab 			money*, miss
			sum 			money*
						
*binary variables for money where 1 = money received before COVID and 0 otherwise 
	foreach v of varlist money* {
	gen 				`v'_d = 1	
	replace 			`v'_d = 0 if `v' == 4
	replace 			`v'_d = . if `v' == .
	replace 			`v'_d = .a if `v' == .a 
	}		
		
	label var			money_d "Received Money Binary"

	tab1 				money*, miss  
	sum					money*


* ***********************************************************************
* 4 - Part 2/5: Food Access
*     Created by: lem
*	  edited by: alj, fa
* ***********************************************************************	

* Item 8 (Qualtrics var name "Q8"): What, if anything, would make it easier 
* for your household to meet its food needs during the coronavirus pandemic?


	rename 				q8txt text_helpful
	rename 				hepful_costfood helpful_costfood

	lab var 			helpful_transit "Helpful: Access to transit"
	lab var 			helpful_mealhours "Helpful: Different meal hours"
	lab var 			helpful_extramoney "Helpful: Extra money"
	lab var 			helpful_infprograms "Helpful: Info food assistance"
	lab var 			helpful_morefood "Helpful: More food in stores"
	lab var 			helpful_trustfood "Helpful: More trust in safety of food"
	lab var 			helpful_trustdeliv "Helpful: More trust in safety of food delivery"
	lab var 			helpful_truststores "Helpful: More trust in safety stores"
	lab var 			helpful_costfood "Helpful: Defray food delivery cost"
	lab var 			helpful_bin "Helpful: Other"
	lab var				text_helpful "Helpful: What else would be helpful"
	

	
tostring helpful*, replace	
	
foreach v of varlist helpful* {    
	   rename `v' `v'_temp
	   encode `v'_temp, gen (`v') 
	   replace			`v' = .
	   replace 			`v'= 0 if `v'_temp == "0" 
	   replace 			`v' = 1 if `v'_temp == "1"
	   replace 			`v' = 88 if `v'_temp == "-88"
	   replace 			`v' = . if `v'_temp == "-99"
	   lab def 			`v'_lab8  1 "Helpful" 0 "Not helpful" 88 "Do not need this help"		
	   lab val 			`v'  `v'_lab8
	   drop 			*_temp	
	   }	
	   
	   
	rename 				q8a helpful_howmuch
	label var 			helpful_howmuch "Helpful: How much money would help"

	tab1 				helpful*, miss 
	sum 				helpful*


* Item 9 (Qualtrics var name "Q9"): On a scale from 1 (not at all worried) to 6
* (extremely worried), what is your level of worry for your household about 
* the following as it relates to COVID-19:


	rename				q9txt text_worry

* label worry vars

	lab var				worry_enoughfood "Worry: not enough in store"
	lab var 			worry_countryfood "Worry: the country will not have enough food for everyone"
	lab var 			worry_foodexp "Worry: food will become more expensive"
	lab var			    worry_foodunsafe "Worry: food will be unsafe, contaminated"
	lab var 			worry_programs "Worry: household will lose access to food programs"
	lab var 			worry_income "Worry: household will lose income, can't afford food"
	lab var 			worry_housefood "Worry: household won't have enough if have to stay home"
	lab var				text_worry "Worry: Other worries"


* loop to recode, appends "temp" to source vars and renames encoded vars


tostring worry_*, replace	
	
foreach v of varlist worry_* {    
	   rename 			`v' `v'_temp
	   encode 			`v'_temp, gen (`v') 
	   replace			`v' = .
	   replace 			`v' = 1 if `v'_temp == "1" 
	   replace 			`v' = 2 if `v'_temp == "2"
	   replace 			`v' = 3 if `v'_temp == "3"
	   replace 			`v' = 4 if `v'_temp == "4"
	   replace 			`v' = 5 if `v'_temp == "5" 
	   replace 			`v' = 6 if `v'_temp == "6"
	   replace 			`v' = 88 if `v'_temp == "88"
	   replace			`v' = . if `v'_temp == "-99"
	 lab def 			`v'_lab9  1 "1 (not worried at all)" 2 "2" ///
						3 "3" 4 "4" ///
						5 "5" 6 "6 (very worried)" 88 "Not Applicable"
	   lab val 			`v'  `v'_lab9
	   	drop 			*_temp	
	   }	

	tab1 				worry_*, miss 
	sum 				worry_*
	*** labels between 1 and 6 were unclear

 
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
	
	rename				othertxt_1 text_strat_cur
	lab var				text_strat_cur "Strategy: Current: Other Text"
	


tab1 *_cur, miss
tostring *_cur, replace	

	
foreach v of varlist *_cur {    
	   rename 			`v' `v'_temp
	   encode 			`v'_temp, gen (`v') 
	   replace			`v' = 0							/* Changed this from . to 0 */
*	   replace 			`v'= 0 if `v'_temp == "-99" 
	   replace 			`v' = 1 if `v'_temp == "1"
	   lab def 			`v'_lab10a  1 "Yes" 0 "No" 			
	   lab val 			`v'  `v'_lab10a
	   drop 			*_temp	 
	   }	
	

	tab1 				*_cur, miss 
	sum					*_cur

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
	
	rename				othertxt_2 text_strat_fut
	lab var				text_strat_fut "Strategy: Future: Other Text"

* loop to recode, appends "temp" to source vars and renames encoded vars
	

tab1 *_fut, miss

tostring *_fut, replace	

	
foreach v of varlist *_fut {    
	   rename `v' `v'_temp
	   encode `v'_temp, gen (`v')
	   replace			`v' = .
	   replace 			`v' = 1 if `v'_temp == "1" 
	   replace 			`v' = 2 if `v'_temp == "2"
	   replace 			`v' = 3 if `v'_temp == "3"
	   replace 			`v' = 4 if `v'_temp == "4"
	   replace 			`v' = 5 if `v'_temp == "5" 
	   replace			`v' = 6 if `v'_temp == "6"
	   replace 			`v' = 99 if `v'_temp == "99"
	   replace			`v' = . if `v'_temp == "-99"
	   lab def 			`v'_lab10b  1 "Very unlikely" 2 "Unlikely" ///
							3 "Somewhat unlikely" 4 "Somewhat likely" ///
							5 "Likely" 6 "Very likely" 99 "Not applicable"
	   lab val 			`v'  `v'_lab10b
	   }	

	tab1 				*_fut, miss 
	sum 				*_fut 


* ***********************************************************************
* 5 - Part 3/5: Eating and Purchasing Behaviors
*     Created by: fd
* 	  edited by : alj, fa 
* ***********************************************************************	

* Item 11 (qualtrics var name Q11) - Do you or someone in your household have 
* a special diet? 
	
	rename 					q11 diet_special1
	rename					q11a_x8 diet_special_no
	rename					q11_7_text text_diet_special
	lab var					text_diet_special "Special Diet: Text"
	

	encode					diet_special1, gen (diet_special)
	replace 				diet_special = .
	replace 				diet_special = 1 if diet_special1 == "1"
	replace 				diet_special = 2 if diet_special1 == "2"
	replace 				diet_special = 3 if diet_special1 == "3"
	replace 				diet_special = 4 if diet_special1 == "4"
	replace 				diet_special = 5 if diet_special1 == "5"
	replace 				diet_special = 6 if diet_special1 == "6"
	replace 				diet_special = 7 if diet_special1 == "7"
	replace 				diet_special = 8 if diet_special1 == "8"
	replace					diet_special = . if diet_special1 == "-99"
	replace					diet_special = 99 if diet_special1 == "99"
	drop					diet_special1
		
	label 					define diet 1 "Food allergy that requires avoiding some foods" ///
							2 "Food sensitivity that causes problems from eating some foods" ///
							3 "Need to avoid some foods for health condition like diabetes or kidney disease" ///
							4 "Religious restriction" 5 "Vegetarian/Vegan" 6 "Weight loss diet that requires special foods" ///
							7 "Other" 8 "No one in my household has a special diet" ///
							99 "Not applicable"
	
	label values 			diet_special diet
	label var				diet_special "Household member has special diet"
	label var 				diet_special_no "Special Diet: No One in HH has special diet"
	lab var					text_diet_special "Special Diet: Text"
	
* special diet dummy vars; creates a dummy for each possible outcome
	
	tab 					diet_special, gen(diet_special_d)

	tab1 					diet_special, miss
	sum 					diet_special 

	
* Item 11a (qualtrics var name q11a) - Have you had challenges finding food that 
* meets these food needs since the COVID-19 outbreak (March 11th)?	

	label 				variable diet_change_allergy "Special Diet: Food Allergy"
	label var			diet_change_sensitive "Special Diet: Food Sensitivity"
	label var 			diet_change_health "Special Diet: Health"
	label var			diet_change_religion "Special Diet: Religion"
	label var 			diet_veg "Special Diet: Vegetarian"
	label var 			diet_weight "Special Diet: Weight"
	label var 			diet_other "Special Diet: Other"


* binary variable where 1 = "Yes" (i.e. the respondent found a challenge with
* finding food that meets their special diets since 3/11 and 0 otherwise. accounts for no special diet response + system missings

	gen 				diet_change = .
	replace 			diet_change = 1 if diet_change_allergy == "1" | diet_change_sensitive == "1" | ///
							diet_change_health == "1"|diet_change_religion == "1" ///
							|diet_veg == "1"|diet_weight == "1" |diet_other == "1"
	replace 			diet_change = 0 if diet_special == 8
	replace 			diet_change = -99 if diet_change_allergy == "-99" | diet_change_sensitive == "-99" ///
							| diet_change_health == "-99"|diet_change_religion == "-99" ///
							|diet_veg == "-99"|diet_weight == "-99" |diet_other == "-99"
	label var 			diet_change "Hard to meet special diet needs since COVID"
	

	
*************************************************	
	
* Item 12 (codebook question 12) - The next questions are about how you have
* been eating in the past month during the COVID-19 outbreak (since March 11th).
	
	rename 				Q121 eating_fruit
	rename 				Q122 eating_vegtables
	rename 				Q123 eating_redmeat
	rename 				Q124 eating_procmeat
	
	label define 			eating_fruit_veg 0 "None" 1 "1/2 cup or less" 2 "1/2 to 1 cup" ///
								3 "1 - 2 cups" 4 "2 - 3 cups" 5 "3 - 4 cups" 6 "4 or more cups"
	label define 			eating_redmeat_procmeat 0 "Never" 1 "1 times last month" ///
								2 "2 - 3 times last month" 3 "1 time per week" 4 "2 times per week"///
								5 "3 - 4 times per week" 6 "5 - 6 times per week" 7 "1 time per day" 8 "2 or more times per day"
	
	label values 			eating_fruit eating_fruit_veg
	label values 			eating_vegtables eating_fruit_veg
	label values 			eating_redmeat eating_redmeat_procmeat
	label values 			eating_procmeat eating_redmeat_procmeat
	label define 			Less_more 1 "Less" 2 "Same" 3 "More"
	label values 			eating_comp_fruitveg eating_comp_meats eating_comp_seafood Less_more
	
* Item 13 (codebook question 13) - Please indicate your level of agreement with 
* the following statements regarding eating during the COVID-19 outbreak
* (since March 11th)
	
	label define 			eathabits 1 "Strongly disagree" 2 "Disagree" ///
								3 "Neither agree nor disagree" 4 "Agree" ///
								5 "Strongly agree" 88 "Not applicable"
	
	label values 			eathabits_emotional eathabits_lonely eathabits_stress eathabits_comfort eathabits

	
	
* Item 14 (codebook question 14) - Please indicate whether any of the 
* following is true about your eating and shopping behaviors in the year before
* the COVID-19 outbreak and since the COVID-19 outbreak (March 11th):
	
	label define 			behaviors 1 "Never true" 2 "Sometimes true" 3 "Often true" 99 "I dont know"
	label values 			behaviors_local_year behaviors_pack_year behaviors_bags_year ///
								behaviors_veg_year behaviors_sust_year behaviors_local_covid ///
								behaviors_pack_covid behaviors_bags_covid behaviors_veg_covid behaviors_sust_covid behaviors
	
*************************************************	
																				
* Item 15 (Qualtrics var name Q15) - Please indicate whether any of the 
* following is true about your eating and shopping behaviors in the year before
* the COVID-19 outbreak and since the COVID-19 outbreak (March 11th):
	
* loop to recode, appends "temp" to source vars and renames encoded vars		

	foreach v of varlist habits* {
		rename `v' temp_`v'
		gen `v'_my = .
		replace `v'_my = . if temp_`v' == "-99"
		replace `v'_my = 1 if temp_`v' == "1" | temp_`v' == "1,2"
		replace `v'_my = 0 if temp_`v' == "2"
		label def			`v'_1 1 "Yes" 0  "No"
		label values          `v'_my `v'_1
		
		gen `v'_usavg = .
		replace `v'_usavg = . if temp_`v' == "-99"
		replace `v'_usavg = 1 if temp_`v' == "2" | temp_`v' == "1,2"
		replace `v'_usavg = 0 if temp_`v' == "1"
		label def				 `v'_2  1 "Yes" 0 "No"
		label values			`v'_usavg `v'_2
		
		drop					temp_`v'
		}
	
* label "My Household" habits vars
	lab var 				habits_buymore_my "Habits: My Household: Bought More Food"
	lab var			  	 	habits_deliver_my "Habits: My Household: Deliver Food to Others"
	lab var 				habits_donate_my "Habits: My Household: Donate"
	lab var 				habits_normal_my "Habits: My Household: Stayed Normal"
	lab var					habits_supply_my "Habits: My Household: Two Week Food Supply"
	lab var 				habits_dist_my "Habits: My Household: Social Distancing"
	lab var			 	    habits_cook_my "Habits: My Household: More Cooking"
	lab var 				habits_throwless_my "Habits: My Household: Throw Away Less Food"
	lab var 				habits_throwmore_my "Habits: My Household: Throw Away More Food"
	lab var					habits_volunteer_my "Habits: My Household: Volunteer"
	lab var					habits_mask_my "Habits: My Household: Wear Mask"
	
* label "Avg US Household" habits vars
	lab var 				habits_buymore_usavg "Habits: Avg US Household: Bought More Food"
	lab var			  	 	habits_deliver_usavg "Habits:Avg US Household: Deliver Food to Others"
	lab var 				habits_donate_usavg "Habits: Avg US Household: Donate"
	lab var 				habits_normal_usavg "Habits: Avg US Household: Stayed Normal"
	lab var					habits_supply_usavg "Habits: Avg US Household: Two Week Food Supply"
	lab var 				habits_dist_usavg "Habits: Avg US Household: Social Distancing"
	lab var			 	    habits_cook_usavg "Habits: Avg US Household: More Cooking"
	lab var 				habits_throwless_usavg "Habits: Avg US Household: Throw Away Less Food"
	lab var 				habits_throwmore_usavg "Habits: Avg US Household: Throw Away More Food"
	lab var					habits_volunteer_usavg "Habits: Avg US Household: Volunteer"
	lab var					habits_mask_usavg "Habits: Avg US Household: Wear Mask"
	
	sum 					habits*
	tab1 					habits*, missing 

	
* ***********************************************************************
* 6 - Part 4/5: Perspectives and Experience
*     Created by: fd
* 	  edited by: alj, fa  
* ***********************************************************************
	
* Item 16 (Qualtrics var name Q16) - On a scale from 1 (strongly disagree) to 6
* (strongly agree), how much do you agree with the following statements:

* label persp vars
	
	label var 				persp_st "Perspective: Other States More Affected than Mine" 
	label var 				persp_us "Perspective: Other Countries More Affected than US"
	label var				persp_me "Perspective: COVID-19 Will Affect People Like Me"
	label var				persp_flu "Perspective: COVID-19 Like Seasonal Flu"
	label var 				persp_me "Perspective: Will Affect People Like Me"
	label var 				persp_econ "Perspective: Economy Over Public Health"
	label var 				persp_action "Perspective: Stay Home"
	label var 				persp_foodsource "Perspective: Food Not Source of COVID"
	label var 				persp_prepared "Perspective: Felt Prepared"
	label var 				persp_packages "Perspective: Transmit Through Food Packages"
	label var 				persp_open_econ "Perspective: Worth Reopen Economy"
	label var 				persp_foodsupply "Perspective: Maintain Food Supply"
	label var 				persp_strike "Perspective: Support Strike"
	
* For each "perspective" variable:

** Note: survey does not specify non-numeric interpretations for scale values 
** beyond 1 (strongly disagree) and 6 (strongly agree). 
	
	foreach v of varlist persp* {
	destring 		`v', replace
	replace 		`v' = . if `v' < = 0 & `v' != -99
	label define 	`v'_persp 1 "1 (strongly disagree)" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6 (strongly agree)" 99 "DK" -99 "."
	label values 	`v' `v'_persp
	}
	
	sum 			persp_*
	tab1 			persp_*, missing 
	
* Item 17 (Qualtrics var name Q17) - Do you anyone with symptoms of, or 
* diagnosed with, the coronavirus (COVID-19)? If so, who? Check all that apply.

	rename 					q17 temp	
	gen 					know = .
	replace 				know = 1 if temp == "1"
	replace 				know = 2 if temp == "2"
	replace 				know = 3 if temp == "3"
	replace 				know = 4 if temp == "4"
	replace 				know = 5 if temp == "5"
	replace 				know = 6 if temp == "1,2"
	replace 				know = 7 if temp == "1,3"
	replace 				know = 8 if temp == "1,4"
	replace					know = 9 if temp == "1,2,3"
	replace 				know = 10 if temp == "1,2,4"
	replace 				know = 11 if temp == "1,2,3,4"
	replace 				know = 12 if temp == "2,3"
	replace 				know = 13 if temp == "2,4"
	replace 				know = 14 if temp == "2,3,4"
	replace 				know = 15 if temp == "3,4"
	replace					know = . if temp == "-99"
	
	label define 			lab_know 1 "Yes, family" 2 "Yes, friend(s)" 3 "Yes, myself" ///
								4 "Yes, other" 5 "No, I don't know anyone" ///
								6 "Yes, family and friends" 7 "Yes, family and myself" ///
								8 "Yes, family and other" 9 "Yes, family and friend(s) and myself" ///
								10 "Yes, family and friend(s) and other" ///
								11 "Yes, family and friend(s) and myself and other" ///
								12 "Yes, friend(s) and myself" 13 "Yes, friend(s) and other" ///
								14 "Yes, friend(s) and myself and other" 15 "Yes, myself and other"
	
	label values 			know lab_know
	label var				know "Know Anyone Diagnosed or With Symptoms"
	
* binary variables
	
	split 				temp, p(,) destring
tab temp, miss
tab know, miss
	egen				Yes_Family_dummy  = anymatch (temp1 temp2 temp3 temp4), v(1)
	egen				Yes_Friends_dummy = anymatch (temp1 temp2 temp3 temp4), v(2)
	egen				Yes_Myself_dummy  = anymatch (temp1 temp2 temp3 temp4), v(3)
	egen				Yes_Other_dummy   = anymatch (temp1 temp2 temp3 temp4), v(4)
*	egen				No_dummy          = anymatch (temp1 temp2 temp3 temp4), v(5)
	drop 				temp*
	
		
	tab1 					know* Yes*dummy, miss	
	
	

*** Know anyone (including self) with covid ***

gen KNOW_ANY1_COVID = .
label var KNOW_ANY1_COVID "Do you anyone with symptoms of, or diagnosed with, the coronavirus (COVID-19)" 
replace KNOW_ANY1_COVID = 0 if know==5
replace KNOW_ANY1_COVID = 1 if KNOW_ANY1_COVID==. & know!=.
tab know KNOW_ANY1_COVID, miss


	
* Item 18 (Qualtrics var name Q18) - Have you had to quarantine in your home due 
* to coronavirus (for example because of illness or exposure symptoms)?

	
	rename 					q18 know_quaran
	label var				know_quaran "Know Quarantine"
	destring				know_quaran, replace
	label define 			no_yes 0 "No" 1 "Yes"
	label values 			know_quaran no_yes
	replace					know_quaran = . if know_quaran == -99

	tab 					know_quaran, miss
	sum 					know_quaran 
	
* ***********************************************************************
* 7 - Part 5/5: Demographics
*     Created by: fd
* 	  edited by: alj, fa
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
	recode 					num_people_under5 num_people_517 num_people_1865 num_people_65up (-99 = .)
	*recode 				num_people_under5 num_people_517 num_people_1865 num_people_65up (-99 = 0)
	
	tab1 					num_people*, miss	
	
* create new variable for total household number  
	egen 					total_hh_num = rowtotal(num_people_under5 num_people_517 num_people_1865 num_people_65up)
	label var 				total_hh_num "Total Household Size" 
	tab1 					total_hh_num 
	
*browse total_hh_num num_people_under5 num_people_517 num_people_1865 num_people_65up if total_hh_num==0

sum total_hh_num

* create new variable for household size variable 
	gen 					householdsize =. 
	replace 				householdsize = 1 if total_hh_num <=2 
	replace 				householdsize = 2 if total_hh_num >= 3 & total_hh_num <=5 
	replace 				householdsize = 3 if total_hh_num >=6 
	label var 				householdsize "Household Size Categories" 
	label def 				householdsize 1 "1-2 members" 2 "3-5 members" 3 "6 or more members" 
	label values 			householdsize householdsize 
	
* Item 20 (Qualtrics var name Q20) - Which of the following best describes your current occupation

	*labels for Q20 

	destring 				q20, replace 	
	rename 					q20 occupation
	label define 			Occupation 1 "Not currently employed" 2 "Agriculture, Forestry, Fishing and Hunting" ///
								3 "Arts, Entertainment, and Recreation" 4 "Broadcasting and MEdia" 5 "Childcare Provider" ///
								6 "Clerical/Administrative" 7 "College, University, and Adult Education" ///
								8 "Computer and Electronics Manufacturing" 9 "Construction" 10 "Disabled and on Disability Benefits" ///
								11 "FInance and Insurance" 12 "Food and Beverage Services" 13 "Government and Public Administration" ///
								14 "Health Care and Social Assistance" 15 "Homemaker" 16 "Hotel and Hospitality Services" ///
								17 "Information Services and Data Processing" 18 "Legal Services" 19 "Military" ///
								20 "Mining" 21 "Other Information Industry" 22 "Other Manufactoring" ///
								23 "Primary/Secondary (K-12) Education" 24 "Publishing" 25 "Real Estate, Rental, and Leasing" ///
								26 "Religious" 27 "Retail" 28 "Retired" 29 "Scientific or Technical Services" 30 "Self-employed" ///
								31 "Software" 32 "Student" 33 "Telecommunications" 34 "Transportation and Warehousing" ///
								35 "Utilities" 36 "Other (please describe below if selected) "
	
	label values 			occupation Occupation
	label var 				occupation "Occupation"
	rename					q20txt text_occupation
	label var 				text_occupation "Occupation Text"
	replace					occupation = . if occupation == -99
	
	tab1 					occupation*, miss	 
	
	
	
* Item 21 (Qualtrics var name Q21b) - What is your ZIP Code?

*STATE: Q21a - What state do you live in? * 
		rename 				q21a state 
		label var 			state "State of Residence" 							
		
tab state, miss	 



* Labels for Q21b
	
	rename 					q21b zipcode
	destring 				zipcode, replace
	label var 				zipcode "ZIP code"
	replace					zipcode = . if zipcode == -99
	
	tab1 					zipcode, miss

* Item 22 (Qualtrics var name Q22) - In what year were you born?

* labels for Q22
	
	rename 					q22 year_born
	destring 				year_born, replace
	label var 				year_born "Year Born"
	replace					year_born= . if year_born < 1900 | year_born > 2020		/* Changed this */ 
	
	tab1 					year_born, miss 	
	
* generate age variable = year 2020 - year of birth 
	generate 				age_estimate = 2020 - year_born
	label var  				age_estimate "Estimated Age 2020 - YOB"
	tab1 					age_estimate, missing
	sum 					age_estimate

* generate variable for age categories
	recode 					age_estimate (18/34 = 1 "18-34") (35/54 = 2 "35-54") ///
								(55/120 = 3 "55+") , generate (agecat) 					/* Changed the categories to align with the screener */ 
tab scrn_age_group agecat, miss	
	
	
* Item 23 (Qualtrics var name Q24) - Are you of Hispanic, Latino, or Spanish Origin?

* labels for Q24
	
	rename 					q24 ethnicity
	destring 				ethnicity, replace
	label define 			hispanic_type 0 "Not hispanic" 1 "Yes, Mexican/Mexican American/Chicano" 2 "Yes, Puerto Rican" 3 "Yes, Cuban" 4 "Yes, Other"
	label values 			ethnicity hispanic_type
	label var 				ethnicity "Ethnicity"
	label var 				q24_4_text "Ethnicity Text"
	rename 					q24_4_text ethnicity_text
	replace					ethnicity_text = ".a" if ethnicity_text== "-99"
	
	* binary variable where values 1-4 of ethnicity are recoded as 1 and 0 otherwise (implies 0 is non-hispanic)
	
	egen 					hispanic_d = anymatch (ethnicity), v(1,2,3,4)
	label var				hispanic_d "Hispanic Origin"
	tab 					hispanic_d
	
tab scrn_hisplat_origin hispanic_d, miss
	
	
* Item 24 (Qualtrics var name Q25) - What is your race? Check all that apply:

	*** Commented out code creates dummy variables for different race
	*   combinations. Can delete if wanted. 
	
	label var 				q25_13_text "Race Text"
	rename 					q25_13_text text_race

gen race = . 
label var race "Race"	

replace race = 1 if q25=="12"
replace race = 2 if q25=="3"
replace race = 3 if q25=="1"
replace race = 4 if q25=="2" | q25=="5" | q25=="6" | q25=="7" | q25=="8" | q25=="11"
replace race = 5 if q25=="4" | q25=="9" | q25=="10" 
replace race = 6 if q25=="13"
replace race = 6 if strpos(q25, ",")

	label 					define race_label 1 "White" 2 "Black or African American" ///
								3 "Native American" 4 "Asians" 5 "PIs" 6 "Multiple/Other"
	label values			race race_label
	
tab scrn_race race, miss 

/* Categories from codebook 
1 = American Indian or Alaskan Native, 2 = Asian Indian, 3 = Black or African American, 
4 = Chamorro, 5 = Chinese, 6 = Filipino, 7 = Japanese, 8 = Korean, 9 = Native Hawaiian, 
10 = Samoan, 11 = Vietnamese, 12 = White, 13 = Other */ 

* Item 25 (Qualtrics var name Q27) - Which of the following best describes your
* household income range in 2019 before taxes?

* labels for Q27

	rename 					q27 income
	destring				income, replace	
	label define 			Income 1 "Less than $10,000" 2 "$10,000 to $14,999" 3 "$15,000 to $24,999" ///
								4 "$25,000 to $34,999" 5 "$35,000 to $49,999" 6 "$50,000 to $74,999" ///
								7 "$75,000 to $99,999" 8 "$100,000 to $149,000" 9 "$150,000 to $199,999" 10 "$200,000 or more" -99 "."   /* Changed .a to . */ 
	label values 			income Income
	label var 				income "Income Range"	
	
	
	tab						income, miss
	sum 					income 
	*** will want to use income from screener - but this cleaned anyway 
tab scrn_income income, miss	

* Item 26 (Qualtrics var name Q28) - How long have you lived in the United States?

* labels for Q28

	destring 				q28, replace 	
	rename 					q28 years_usa
	label define 			years_in_usa 1 "I was born in the US" 2 "Less than 5 years" 3 "5 - 10 years" 4 "10 or more years" -99 "."   /* Changed .a to . */ 
	label values 			years_usa years_in_usa
	label var 				years_usa "Years Living in USA"

	tab						years_usa, miss  	
	sum 					years_usa 
	
* Item 27 (Qualtrics var name Q29) - Which of the following political 
* affiliations do you most identify with? 

	* labels for Q29
tab q29
	destring 				q29, replace
	rename 					q29 political
	label define 			Political 1 "Democrat" 2 "Green Party" 3 "Independent" 4 "Libertarian" 5 "No affiliation" ///
								6 "Progressive" 7 "Republican" 8 "Other" -99 ".a"
	label values 			political Political
	label var 				political "Political Affiliation"
	rename					q29_8_text text_political
	label var				text_political "Text: Political Affiliation"
	replace 				text_political = "." if text_political == "-99"			 /* Changed .a to . */ 
	tab						political, miss	

	
*
gen POLITICAL = . 
label var POLITICAL "Political Affiliation (fewer categories)" 
replace POLITICAL = 1 if political == 1
replace POLITICAL = 2 if political == 3
replace POLITICAL = 3 if political == 5
replace POLITICAL = 4 if political == 7
replace POLITICAL = 5 if POLITICAL == . & political != -99
tab political POLITICAL, miss

label define politics 1 "1=Democrat"  2 "2=Independent"  3 "3=No affiliation"  4 "4=Republican"  5 "5=Other"
label values POLITICAL politics 	
	
	
	
* Item 28 (Qualtrics var name Q30) - Do you have any additional comments or
* experiences related to the issue of food during the COVID-19 outbreak that you
* would like to share? Please use this

	* labels for Q30
	
	rename 					q30 other_comments
	label var 				other_comments "Any Other Comments"
	replace					other_comments ="." if other_comments== "-99"

	tab 					other_comments, miss		
	
* ***********************************************************************
* 7 - Comparisons of screener questions with demographic questions
*    
* ***********************************************************************	

* update later as needed 
* will include checks done for consistency 
* these are currently done in Excel
* see NFACT folder for more
	
* **********************************************************************
* 8 - WEIGHTS (based on income quintile)
* **********************************************************************	

* actual weights will vary depending on sample
* general code below 
* will require adaptation 
	
tab scrn_income, miss	
tab scrn_income, nola	

	
gen WEIGHTS = . 
label var WEIGHTS "Weights based on income groups"
/*replace WEIGHTS =   if scrn_income==1
replace WEIGHTS =   if scrn_income==2
replace WEIGHTS =  if scrn_income==3
replace WEIGHTS =  if scrn_income==4
replace WEIGHTS =  if scrn_income==5
replace WEIGHTS =  if scrn_income==6	*/
	*** this would be updated with relevant information 

sum WEIGHTS, det

tabstat FSS_since, by(scrn_income) stat(mean)
tabstat FSS_since [aw=WEIGHTS], by(scrn_income) stat(mean)

tab scrn_income FOOD_SECURITY_since, row
tab scrn_income FOOD_SECURITY_since [aw=WEIGHTS], row

* **********************************************************************
* 9 - end matter
* **********************************************************************

* save "food_security_data_cleaned.dta", replace
* save "food_security_data_cleaned.csv", replace
	*** update saving location 

* close the log
*	log	close

/* END */