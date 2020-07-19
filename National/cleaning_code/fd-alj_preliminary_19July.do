* Project:AZ COVID Food Security Survey data cleaning practice*
* Created on 7/5/2020*
* Created by Freddy D.*
* edited by alj 
* Stata v.16.1

* does
	* Gets rid of current variable labels carried over from excel file
	* Adds new variable labels
	* Adds dummy variables for multiple response questions
	
* assumes
	* standard - Stata v.16
	* questions use March 11th as a start date for the COVID-19 outbreak. 
	* when asked about “the year before the COVID-19 outbreak,” means March 11, 2019 to March 10, 2020.
	* have access to temporary dataset
	* customsave
	
* TO DO:
	* Figure out multiple variable cleaning/organization
	*** source variables
	*** usda variables
	*** prog variables
	*** trans variables
	*** job variables
	*** q11 
	*** q11a
	*** habits variables
	*** q17
	*** some demographics
	*** habits variables
	
* **********************************************************************
* 0 - setup
* **********************************************************************

* set global user
	global user "aljosephson"

* define paths
	loc root 	 	= "G:/My Drive/UA-NFACT/data/raw"
	loc export 		= "G:/My Drive/UA-NFACT/data/refined"
	loc logout 		= "G:/My Drive/UA-NFACT/data/logs"
	*** having some trouble with the " " in "My Drive" - will need to find a solution for that 
	
* open log
	cap 		log close
	log 		using "`logout'/basic-cleaning", append
	
* **********************************************************************
* 1 - Importing data
* **********************************************************************

* Preparing excel file
	* open up AZ Temporary Dataset(7_2_20)
	* Delete second row (Second row is a duplicate of first row)
	* Save new excel file

* import data set from excel
	import 		excel "'root'/national-low-income_17July", sheet("Sheet0") firstrow
	
* save imported file as .dta 
	save 		"`export'\az_dummy_sample_19July", replace 
	
* **********************************************************************
* 2 - Getting rid of previous variable labels
* **********************************************************************

* eliminates rid of labels that came attached from excel 
	label variable StartDate "Start Date"
	label variable EndDate "End Date"
	label variable IPAddress "IPA ddress"
	label variable RecipientLastName "Recipient Last Name"
	label variable RecipientFirstName "Recipient First Name"
	label variable RecipientEmail "Recipient Email"
	label variable ExternalReference "Externa lReference"
	label variable LocationLatitude "Location Latitude"
	label variable LocationLongitude "Location Long itude"
	label variable DistributionChannel "Distribution Channel"
	label variable UserLanguage "User Language"
	label variable Qs3 ""
	label variable Qs5 ""
	label variable Qs6 ""
	label variable Qs7 ""
	label variable Qs7_5_TEXT ""
	label variable Qs8 ""
	label variable Qs9 ""
	label variable Qs9_5_TEXT ""
	label variable Qs10 ""
	label variable Qs11 ""
	label variable term ""
	label variable gc ""
	label variable qpmid ""
	label variable Q_TotalDuration ""
	label variable med ""
	label variable uig ""
	label variable psid ""
	label variable K2 ""
	label variable PID ""
	label variable study ""
	label variable rnid ""
	label variable LS ""
	label variable V ""
	label variable rid ""
	label variable RISN ""
	label variable opp ""
	label variable Q30 ""
	label variable Q29_8_TEXT ""
	label variable Q29 ""
	label variable Q28 ""
	label variable Q27 ""
	label variable Q25_13_TEXT ""
	label variable Q25 ""
	label variable Q24_4_TEXT ""
	label variable Q24 ""
	label variable Q22 ""
	label variable Q21b ""
	label variable Q20txt ""
	label variable Q20 ""
	label variable num_people_65up ""
	label variable num_people_1865 ""
	label variable num_people_517 ""
	label variable num_people_under5 ""
	label variable Q18 ""
	label variable Q17 ""
	label variable persp_strike ""
	label variable persp_foodsupply ""
	label variable persp_open_econ ""
	label variable persp_packages ""
	label variable persp_prepared ""
	label variable persp_foodsource ""
	label variable persp_action ""
	label variable persp_econ ""
	label variable persp_me ""
	label variable persp_US ""
	label variable persp_VT ""
	label variable persp_flu ""
	label variable habits_mask ""
	label variable habits_volunteer ""
	label variable habits_throwmore ""
	label variable habits_throwless ""
	label variable habits_cook ""
	label variable habits_dist ""
	label variable habits_supply ""
	label variable habits_normal ""
	label variable habits_donate ""
	label variable habits_deliver ""
	label variable habits_buymore ""
	label variable Q11a_x8 ""
	label variable diet_other_TEXT ""
	label variable diet_other ""
	label variable diet_weight ""
	label variable diet_veg ""
	label variable diet_change_religion ""
	label variable diet_change_health ""
	label variable diet_change_sensitive ""
	label variable diet_change_allergy ""
	label variable Q11_7_TEXT ""
	label variable Q11 ""
	label variable othertxt_2 ""
	label variable othertxt_1 ""
	label variable strat_otherbin_fut ""
	label variable strat_grow_fut ""
	label variable strat_stretch_fut ""
	label variable strat_pantry_fut ""
	label variable strat_gobad_fut ""
	label variable strat_credit_fut ""
	label variable strat_cheap_fut ""
	label variable strat_borrow_fut ""
	label variable strat_accept_fut ""
	label variable strat_otherbin_cur ""
	label variable strat_grow_cur ""
	label variable strat_stretch_cur ""
	label variable strat_pantry_cur ""
	label variable strat_gobad_cur ""
	label variable strat_credit_cur ""
	label variable strat_cheap_cur ""
	label variable strat_borrow_cur ""
	label variable strat_accept_cur ""
	label variable Q9txt ""
	label variable worry_housefood ""
	label variable worry_income ""
	label variable worry_programs ""
	label variable worry_foodunsafe ""
	label variable worry_foodexp ""
	label variable worry_countryfood ""
	label variable worry_enoughfood ""
	label variable Q8a ""
	label variable Q8txt ""
	label variable helpful_bin ""
	label variable hepful_costfood ""
	label variable helpful_truststores ""
	label variable helpful_trustdeliv ""
	label variable helpful_trustfood ""
	label variable helpful_morefood ""
	label variable helpful_infprograms ""
	label variable helpful_extramoney ""
	label variable helpful_mealhours ""
	label variable helpful_transit ""
	label variable Q7 ""
	label variable job_no ""
	label variable job_furlo ""
	label variable job_hours ""
	label variable job_loss ""
	label variable Q5c ""
	label variable Q5b ""
	label variable Q5a ""
	label variable challenge_reducgroc ""
	label variable challenge_close ""
	label variable challenge_moreplaces ""
	label variable challenge_findhelp ""
	label variable challenge_kinds ""
	label variable challenge_asmuch ""
	label variable Q4txt_1_2 ""
	label variable Q4txt_1_1 ""
	label variable trans_otherbin ""
	label variable trans_walk ""
	label variable trans_bringfood ""
	label variable trans_taxi ""
	label variable trans_friend ""
	label variable trans_vehicle ""
	label variable trans_bus ""
	label variable foodprog_stigma ""
	label variable foodprog_assets ""
	label variable foodprog_travel ""
	label variable foodprog_indep ""
	label variable foodprog_paperwork ""
	label variable Q3dtxt ""
	label variable pantry_lines ""
	label variable pantry_limits ""
	label variable pantry_hours ""
	label variable pantry_runsout ""
	label variable pantry_foodprepare ""
	label variable pantry_foodquality ""
	label variable pantry_foodlike ""
	label variable pantry_helpful ""
	label variable Q3ctxt ""
	label variable school_PEBT ""
	label variable school_runout ""
	label variable school_place ""
	label variable school_time ""
	label variable school_hard ""
	label variable school_kitchen ""
	label variable school_notopen ""
	label variable school_helpful ""
	label variable Q3btxt ""
	label variable wic_online ""
	label variable wic_usefull ""
	label variable wic_limited ""
	label variable wic_easy ""
	label variable Q3atxt ""
	label variable snap_usefull ""
	label variable snap_online ""
	label variable snap_enough ""
	label variable snap_easy ""
	label variable prog_othertxt_2 ""
	label variable prog_othertxt_1 ""
	label variable prog_other ""
	label variable prog_pantry ""
	label variable prog_school ""
	label variable prog_wic ""
	label variable prog_snap ""
	label variable usda_oftencut_covid ""
	label variable usda_oftencut_year ""
	label variable usda_hungry_covid ""
	label variable usda_eatless_covid ""
	label variable usda_cutskip_covid ""
	label variable usda_hungry_year ""
	label variable usda_eatless_year ""
	label variable usda_cutskip_year ""
	label variable usda_afford_covid ""
	label variable usda_foodlast_covid ""
	label variable usda_afford_year ""
	label variable usda_foodlast_year ""
	label variable source_othertxt_2 ""
	label variable source_othertxt_1 ""
	label variable source_otherbin ""
	label variable source_grow ""
	label variable source_localfrm ""
	label variable source_farmmkt ""
	label variable source_group ""
	label variable source_prog ""
	label variable source_restin ""
	label variable source_restdel ""
	label variable source_MoW ""
	label variable source_mealdel ""
	label variable source_grocdel ""
	label variable source_spec ""
	label variable source_conv ""
	label variable source_groc ""
	
* **********************************************************************
* 2 - Variable label for each question. Adds dummy variables when needed.
* **********************************************************************

* questions are numbered/ordered in same way as final version of AZ food survey doc.

	********************************************************************************************************************************
	*** had some issues in this section - would not let me label strings?

	* Question 3
	label variable Qs3 "Food access and food security in Arizona since the Coronavirus outbreak"
	label variable Qs3 "Consent and Screener"
	label define No_Yes 0 "No" 1 "Yes"
	label values Qs3 No_Yes

	* Question 5
	label variable Qs5 "Arizona Resident Screener"
	label values Qs5 No_Yes

	* Question 6
	label variable Qs6 "Age Group"
	label define Age_Group 1 ">18 Years old" 2 "18 - 34 Years old" 3 "35 - 54 Years old" 4 "55 Years and older"
	label values Qs6 Age_Group

	* Question 7
	label define Gender 1 "Male" 2 "Female" 3 "Transgender" 4 "Non-Binary" 5 "Prefer to self describe"
	label variable Qs7 "Gender Identity"
	destring Qs7, replace
	label values Qs7 Gender
	label variable Qs7_5_TEXT "Gender self description"
	* Tabulate shows distribution of Gender
	tabulate Qs7

	* Question 8 
	label values Qs8 No_Yes
	label variable Qs8 "Hispanic, Latino, or Spanish origin"
	* Tabulate shows distribution of Gender
	tabulate Qs8

	* Question 9
	label define Race 1 "Asian" 2 "Black or African American" 3 "Native American" 4 "White" 5 "Other"
	label variable Qs9 "Race"
	split Qs9, p(,) destring
	label variable Qs91 "Race"
	label variable Qs92 "Race"
	label values Qs92 Race
	label values Qs91 Race
	
	egen Race_Asian1 = anymatch(Qs91), v(1)
	egen Race_Asian2 = anymatch(Qs92), v(1)
	egen Race_Black_AA1 = anymatch(Qs91), v(2)
	egen Race_Black_AA2 = anymatch(Qs92), v(2)
	egen Race_NA1 = anymatch(Qs91), v(3)
	egen Race_NA2 = anymatch(Qs92), v(3)
	egen Race_White1 = anymatch(Qs91), v(4)
	egen Race_White2 = anymatch(Qs92), v(4)
	egen Race_Other1 = anymatch(Qs91), v(5)
	egen Race_Other2 = anymatch(Qs92), v(5)
	
	* Final dummy variables	
	gen Race_Asian = Race_Asian1 + Race_Asian2
	gen Race_Black_AA = Race_Black_AA1 + Race_Black_AA2
	gen Race_NA = Race_NA1 + Race_NA2
	gen Race_White = Race_White1 + Race_White2
	gen Race_Other = Race_Other1 + Race_Other2
	* Once final variables are made, can drop variable versions one and two
	* Final labeling
	label variable Race_Asian "# of Asian in dataset"
	label variable Race_Black_AA "# of Black/African American in dataset"
	label variable Race_NA "# of Native American in dataset"
	label variable Race_White "# of White in dataset"
	label variable Race_Other "# of Others in dataset"
	label values Race_Asian No_Yes
	label values Race_Black_AA No_Yes
	label values Race_NA No_Yes
	label values Race_White No_Yes
	label values Race_Other No_Yes
	
	* Question 10
	label variable Qs10 "Highest level of completed education"
	label define Completed_education 1 "Some high school (no diploma)" 2 "High school graduate (including GED)" 3 "Some college (no degree)" 4 "Associates degree, technical school, apprentinship" 5 "Bachelor's degree" 6 "Postgraduate, professional degree"
	label values Qs10 Completed_education
	
	********************************************************************************************************************************
	*** can you break this variable (Q10) down into a binary: college education completed v. no college education 

	* Question 11
	label variable Qs11 "Household income range before taxes in 2019"
	label define income_range 1 "Less than $10,000 per year" 2 "$10,000 - $24,999 per year  " 3 "$25,000 - $49,999 per year   " 4 "$50,000 - $74,999 per year   " 5 "$75,000 - $99,999 per year   " 6 "More than $100,000 per year  "
	label values Qs11 income_range

* General food access part 1
	* source questions
	label define Pre_Post_no_Covid 1 "Year before COVID-19" 2 "Since COVID 19" 3 "Did not get food here"
	label variable source_groc "Grocerey store, supermarket, large bulk stores"
	label variable source_conv "Convenience store, corner store  "
	label variable source_spec "Specialty store (ethnic market, co-op, health food store)"
	label variable source_grocdel "Grocery (like Amazon or Instacart) "
	label variable source_grocdel "Delivered grocery (like Amazon or Instacart) "
	label variable source_mealdel "Meal-kit (like Blue Apron)"
	label variable source_MoW "Meals on Wheels "
	label variable source_restdel "To go (delivery, take-out, curbside pickup) "
	label variable source_restin "Restaurant or cafeteria - eat-in "
	label variable source_prog "Programs that give food (such as food pantry, school food) "
	label variable source_group "Meals served in group setting like senior center, church, or synagogue  "
	label variable source_farmmkt "Farmers' market "
	label variable source_localfrm "Direct from farm: (Community Supported Agriculture (CSA), farm stand pickup / de"
	label variable source_grow ": Garden, fishing, foraging, hunting, or using my own canned goods "
	label variable source_otherbin "Other"
	label variable source_othertxt_1 "Other food source self description"
	label variable source_othertxt_1 "Other food source self description before COVID"
	label variable source_othertxt_2 "Other food source self description after COVID"
	
	* Destring 
	split source_groc, p(,) destring
	split source_otherbin , p(,) destring
	split source_conv, p(,) destring
	split source_spec, p(,) destring
	split source_grocdel, p(,) destring
	split source_mealdel, p(,) destring
	split source_MoW, p(,) destring
	split source_restdel, p(,) destring
	split source_restin, p(,) destring
	split source_prog, p(,) destring
	split source_group, p(,) destring
	split source_farmmkt, p(,) destring
	split source_localfrm, p(,) destring
	split source_grow, p(,) destring
	
	*generation of new variables
	generate source_groc_recode=. 
	replace source_groc_recode=1 if source_groc== "1,2" 
	replace source_groc_recode=2 if source_groc== "1"
	replace source_groc_recode=3 if source_groc== "2"
	replace source_groc_recode=4 if source_groc== "3"
	label variable source_groc_recode "Source Grocery Recode"
	label define Change  1 "No Change" 2 "Stopped Since COVID" 3 "Started Since COVID" 4 "Never Used" 
	*** alj wonders: difference between 1 and 4?
	label values source_groc_recode Change
	*** alj recommendation: follow joelle's code here for these variables, but go one step further
	
	********************************************************************************************************************************
	* create two new variables
	* 1 - stop using groceries since covid 
	gen			source_groc_stopcov = . 
	replace		source_groc_stopcov = 1 if source_groc_recode == 2
	replace 	source_groc_stopcov = 0 if source_groc_recode == 1
	replace 	source_groc_stopcov = 0 if source_groc_recode == 3
	replace 	source_groc_stopcov = 0 if source_groc_recode == 4
	* 2. - start uisng groceries since covid 
	gen			source_groc_startcov = . 
	replace		source_groc_startcov = 1 if source_groc_recode == 2
	replace 	source_groc_startcov = 0 if source_groc_recode == 1
	replace 	source_groc_startcov = 0 if source_groc_recode == 3
	replace 	source_groc_startcov = 0 if source_groc_recode == 4

	*** it's a lot - but repeat this for all of the relevant questions, i think... 
	
	* usda questions

	* prog questions

	* snap questions
	
	
	********************************************************************************************************************************
	*** for this section generally - does the Agree_disagree command get all the permetations? 
	*** since there are 1 - 6, i'm not actually sure
	*** since these are a scale, i don't think we need to do like above, with the "since covid" additional questions
	*** the scale variables should provide enough information 

	label variable snap_easy "SNAP benefits are easy to use to buy food for our household "
	label define Agree_disagree 1 "Strongly disagree" 2 "Disagree" 3 "Neither agree nor disagree" 4 "Agree" 5 "Strongly agree"
	label values snap_easy Agree_disagree
	label values snap_enough Agree_disagree
	label values snap_online Agree_disagree
	label values snap_usefull Agree_disagree
	label variable snap_enough "SNAP benefits are enough to meet our household’s needs "
	label variable snap_online "We cannot use SNAP benefits to pay for groceries ordered online "
	label variable snap_usefull "We are not able to use our full months’ worth of SNAP benefits "
	label variable snap_online "We cannot use SNAP benefits to pay for groceries ordered online"
	label variable snap_easy "SNAP benefits are easy to use to buy food for our household"
	label variable Q3atxt "SNAP self description"
	
	* wic questions
	label variable wic_easy "Overall, WIC benefits are easy to use to buy food for our household "
	label variable wic_limited "There is a limited selection of food at the stores that we can buy with our WIC "
	label variable wic_usefull "We cannot use our full months’ worth of WIC benefits "
	label variable wic_online "If available, we would be interested in shopping for WIC foods online and using "
	label variable Q3atxt "SNAP self description/other comments"
	label variable Q3btxt "WIC self description/other comments"
	label values wic_easy Agree_disagree
	label values wic_limited Agree_disagree
	label values wic_usefull Agree_disagree
	label values wic_online Agree_disagree

	* school questions
	label variable school_helpful "The school meals are very helpful for my household "
	label variable school_notopen "School meal sites are not open on a consistent basis "
	label variable school_kitchen "We do not have the kitchen equipment to safely store or re-heat meals "
	label variable school_hard "School meal delivery to our home is not available or is hard to arrange "
	label variable school_time "We are unable to pick up the meals at the time they are offered "
	label variable school_place "We are unable to pick up the meals at the place they are offered "
	label variable school_runout "Sites provide meals for several days at one time and we run out of meals before "
	label variable school_PEBT "The new Pandemic-EBT (P-EBT) card/benefits to pay for children’s meals  while sc"
	label variable school_PEBT "The new Pandemic-EBT(P-EBT) card/benefits to pay for children’s meals is helpful"
	label define Agree_disagree_NA 1 "Strongly disagree" 2 "Disagree" 3 "Neither agree nor disagree" 4 "Agree" 5 "Strongly agree" 88 "Not applicable "
	label values school_helpful Agree_disagree_NA
	label values school_notopen Agree_disagree_NA
	label values school_kitchen Agree_disagree_NA
	label values school_hard Agree_disagree_NA
	label values school_time Agree_disagree_NA
	label values school_place Agree_disagree_NA
	label values school_runout Agree_disagree_NA
	label variable Q3ctxt "School meal self description/other comments"

	* pantry questions
	label variable pantry_helpful "Food offered at the food pantry/food bank has been very helpful for my household"
	label variable pantry_foodlike "The food pantry does not have food that my household likes to eat"
	label values pantry_helpful Agree_disagree
	label values pantry_foodlike Agree_disagree
	label variable pantry_foodquality "The food pantry does not have good quality food "
	label variable pantry_foodprepare "The food pantry gives me foods I do not know how to prepare "
	label variable pantry_runsout "The food pantry runs out of food often "
	label variable pantry_hours "Food pantry hours are inconvenient or irregular "
	label variable pantry_lines "There are long lines / long wait times "
	label variable pantry_limits "There are limits on how often we can visit the food pantry close to our home "
	label values pantry_foodquality pantry_foodprepare pantry_runsout pantry_hours pantry_lines pantry_limits Agree_disagree
	label variable Q3dtxt "Food pantry self description/other comments"

	* foodprog questions
	label variable foodprog_paperwork "I am worried about the paperwork I need to share to enroll in food programs "
	label variable foodprog_indep "I do not want to rely on food programs because I value personal independence "
	label variable foodprog_travel "It's difficult for me to travel to the food program offices to apply or recertify"
	label variable foodprog_assets "Worried that I have too many personal assets (savings, house, car) to qualify"
	label variable foodprog_stigma "I’m worried people will find out I use these programs "
	label values foodprog_paperwork Agree_disagree
	label values foodprog_indep Agree_disagree
	label values foodprog_travel Agree_disagree
	label values foodprog_assets Agree_disagree
	label values foodprog_stigma Agree_disagree

	* trans questions
	label variable trans_bus "Bus or other public transit "
	label variable trans_vehicle "Own vehicle "
	label variable trans_friend "Ride from friend/family/neighbor "
	label variable trans_taxi "Ride from taxi or app like Lyft/Uber "
	label variable trans_bringfood "Someone brings food to me (delivery service or friend/family member) "
	label variable trans_walk "Walk or bike "
	label variable trans_otherbin "Other"
	*** missing text questions

	* challenge questions
	label variable challenge_asmuch "Could not find AS MUCH food as I wanted to buy (food not in store) "
	label define Never_NA 1 "Never" 2 "Sometimes" 3 "Usually" 4 "Everytime" 88 "Not applicable"
	label values challenge_asmuch Never_NA
	label variable challenge_kinds "Could not find THE TYPES of food my household prefers to eat"
	label values challenge_kinds Never_NA
	label variable challenge_findhelp "Had challenges knowing where to find help for getting food "
	label values challenge_findhelp Never_NA
	label variable challenge_moreplaces "Had to go to more places than usual to find the food my household wanted "
	label values challenge_moreplaces Never_NA
	label variable challenge_close "Had to stand too close to other people, when getting food (less than six feet aw"
	label values challenge_close Never_NA
	label variable challenge_reducgroc "Reduced grocery trips to avoid COVID-19 exposure "
	label values challenge_reducgroc Never_NA
	* may want to look into grouping kinds of foods if there are similar answers/trends
	
	********************************************************************************************************************************
	*** agree - have been wondering what the appropriate breakdown would be here ... 
	*** maybe we group 3 and 4 together as "usually and always" = 1 and =0 otherwise?
	*** as a note, if equal to 88 or -99 can change to . 

	* job questions
	*** missing
	label variable job_loss "Yes, lost job "
	label variable job_hours "Yes, reduced hours or income at job "
	label variable job_furlo "Yes, furloughed "
	label variable job_no "No, have not had any changes in job "
	*** missing question Q7
	label variable Q7 "Have you received any money from these sources since the COVID-19 outbreak?"

* Genreal food Access part two
	* helpful questions
	label variable helpful_transit "Access to public transit or rides "
	label variable helpful_mealhours "Different hours in meal programs or stores "
	label variable helpful_extramoney "Extra money to help pay for food or bills "
	label variable helpful_infprograms "Information about food assistance programs "
	label variable helpful_morefood "More (or different) food in stores "
	label variable helpful_trustfood "More trust in the safety of food "
	label variable helpful_trustdeliv "More trust in safety of food delivery  "
	label variable helpful_truststores "More trust in safety of going to stores "
	label variable hepful_costfood "Support for the cost of food delivery "
	label variable helpful_bin "Other"
	label define helpful 0 "Not helpful" 1 "Helpful" -99 "Do not need this help"
	destring helpful_transit helpful_mealhours helpful_extramoney helpful_infprograms helpful_morefood helpful_trustfood helpful_trustdeliv helpful_truststores hepful_costfood helpful_bin, replace
	label values helpful_transit helpful_mealhours helpful_extramoney helpful_infprograms helpful_morefood helpful_trustfood helpful_trustdeliv helpful_truststores hepful_costfood helpful_bin helpful
	destring Q8a, replace
	*** Need to replace -99 with "left bank" or something if you destring

	* worry variables
	label variable worry_enoughfood "There will not be enough food in the store "
	label variable worry_countryfood "The country will not have enough food to feed everyone "
	label variable worry_foodexp "Food will become more expensive for my household "
	label variable worry_foodunsafe "Food will become unsafe or contaminated "
	label variable worry_income "My household will lose so much income that we can’t afford enough food "
	label variable worry_programs "Not be able to get or will lose access to programs that provide free food or $"
	label variable worry_housefood "wont have enough food if we have to stay at home and cant go out at all"
	label define worry 1 "Not at all worried" 2 "meh" 3 "kinda no" 4 "kinda yes" 5 "worried" 6 "verry worried" 88 "NA"
	label values worry_enoughfood worry
	label values worry_countryfood worry
	label values worry_foodexp worry
	label values worry_foodunsafe worry
	label values worry_programs worry
	label values worry_income worry
	label values worry_housefood worry
	*** dont forget to ask and see what label values they may want for this type of question since its not clear. May end up just leaving the numbers as is.
	
	********************************************************************************************************************************
	*** i think and hope these are the same as above? strongly disagree, disagree, neither a nor d, agree, strongly agree
	*** hopefully codebook can confirm labels here
	*** this is another one we could group into 5 and 6 = 1 as strongly agree or agree, I think

	* strat variables
	label variable strat_accept_cur "Accept food from friends or family "
	label variable strat_borrow_cur "Borrow money from friends or family "
	label variable strat_cheap_cur "Buy different, cheaper foods "
	label variable strat_credit_cur "Buy food on credit "
	label variable strat_gobad_cur "Buy foods that don’t go bad quickly (like pasta, beans, rice, canned foods) "
	label variable strat_pantry_cur "Get food from a food pantry or soup kitchen "
	label variable strat_stretch_cur "Stretch the food that I have by eating less"
	label variable strat_grow_cur "Rely more on hunting/fishing/foraging/growing my own food "
	label variable strat_otherbin_cur "Other "
	label variable strat_accept_fut "Accept food from friends or family "
	label variable strat_borrow_fut "Borrow money from friends or family "
	label variable strat_cheap_fut "Buy different, cheaper foods "
	label variable strat_credit_fut "Buy food on credit "
	label variable strat_gobad_fut "Buy foods that don’t go bad quickly (like pasta, beans, rice, canned foods) "
	label variable strat_pantry_fut "Get food from a food pantry or soup kitchen "
	label variable strat_stretch_fut "Stretch the food that I have by eating less"
	label variable strat_grow_fut "Rely more on hunting/fishing/foraging/growing my own food "
	label variable strat_otherbin_fut "Other "
	destring strat_accept_cur strat_borrow_cur strat_cheap_cur strat_credit_cur strat_gobad_cur strat_pantry_cur strat_stretch_cur strat_grow_cur strat_otherbin_cur strat_accept_fut strat_borrow_fut strat_cheap_fut strat_credit_fut strat_gobad_fut strat_pantry_fut strat_stretch_fut strat_grow_fut strat_otherbin_fut, replace
	label define Yes_99 1 "Using now" -99 "Not using now"
	label values strat_accept_cur strat_borrow_cur strat_cheap_cur strat_credit_cur strat_gobad_cur strat_pantry_cur strat_stretch_cur strat_grow_cur strat_otherbin_cur Yes_99
	label define Future_Likely 1 "very unlikely" 2 "unlikely" 3 "somewhat unlikely" 4 "somewhat likely" 5 "likely" 6 "very likely" -99 "Using now"
	label values strat_accept_fut strat_borrow_fut strat_cheap_fut strat_credit_fut strat_gobad_fut strat_pantry_fut strat_stretch_fut strat_grow_fut strat_otherbin_fut Future_Likely
	*** some answers may overlap/ put use currently and future use
	
	********************************************************************************************************************************
	*** agree - have been wondering what the appropriate breakdown would be here ... 
	*** maybe we leave as a scale 

* Eating and purchasing behaviors (part 3 of 5)
	* q11
	
	* q11a
	
	* habits variables
	
* Perspectives and experience (part 4 of 5)
	* persp variables
	destring persp_flu persp_VT persp_US persp_me persp_econ persp_action persp_foodsource persp_prepared persp_packages persp_open_econ persp_foodsupply persp_strike, replace
	label variable persp_flu "The current COVID-19 outbreak us just like a seasonal flu"
	label variable persp_VT "COVID-19 will affect other states more than mine"
	label variable persp_US "COVID-19 will affect other countries more than the United States"
	label variable persp_me "COVID-19 will affect people like me"
	label variable persp_econ "The US should prioritize the economy over public health when it comes to COVID19"
	label variable persp_action "Average people should stay at home as much as possible to prevent possible sprea"
	label variable persp_foodsource "Food is not a source of COVID-19"
	label variable persp_prepared "I felt prepared for the COVID-19 outbreak"
	label variable persp_packages "Touching food packages cant transmit COVID-19"
	label variable persp_open_econ "It is worth the health risk to reopen the economy as soon as possible"
	label variable persp_foodsupply "It is worth the health risk to maintain the food supply chain"
	label variable persp_strike "If grocery store or food delivery workers went on strike I would support"
	label define Disagree_IDK 1 "Strongly disagree" 2 "disagree" 3 "kinda disagree" 4 "kinda agree" 5 "agree" 6 "strongly agree" 99 "I dont know"
	label values persp_flu persp_VT persp_US persp_me persp_econ persp_action persp_foodsource persp_prepared persp_packages persp_open_econ persp_foodsupply persp_strike Disagree_IDK
	*** value labels on word document arent clear
	*** need to double check/ask what -99 means. could mean differnt things on different questions or same thing. Answers can be left blank but may need to go back and fix others. 
	
	********************************************************************************************************************************
	*** agree - have been wondering what the appropriate breakdown would be here ... 
	*** maybe we group 4 - 6 together as "strongly agree and agree" = 1 and =0 otherwise?
	*** as a note, if equal to 88 or -99 can change to . 
	
	
	* q17
	
	* q18
	
* Demographics (part 5 of 5)
	* q19
	
	* q20
	*** may need to look at actual survey to get all different responses
	* q21
	
	* q22
	
	* q24
	
	* q25
	
	* Question 27
		label variable Q27 "Household income range in 2019 before taxes"
		label define Income_household 1 "Less than $10,000" 2 "$10,000 to $14,999  " 3 "$15,000 to $24,999  " 4 "$25,000 to $34,999  " 5 "$35,000 to $49,999  " 6 "$50,000 to $74,999  " 7 "$75,000 to $99,999  " 8 "$100,000 to $149,999  " 9 "$150,000 to $199,999  " 10 "$200,000 or more  "
		label values Q27 Income_household		

	* Question 28
		label variable Q28 "Length of time in years lived in US"
		label define Years_in_US 1 "I was born in the US" 2 "Less than 5 years" 3 "5 - 10  years" 4 "10 or more years"
		label values Q28 Years_in_US

	* Question 29
	label variable Q29 "Political affiliation"
	label define Political_affiliation 1 "Democrat" 2 "Green Party" 3 "Independent" 4 "Libertarian" 5 "No Affiliation" 6 "Progressive" 7 "Republican" 8 "Other"
	label values Q29 Political_affiliation

* **********************************************************************
*3 - end matter
* **********************************************************************

* Browse
	br

* prepare for export
* eventually we'll also include something like this but this code likely doesn't work yet
* this just saves some metadata with the log
	isid			IPAddress 
	compress
	describe
	summarize 
	*sort plot_id
	customsave , idvar(IPAddress) filename(AG_SEC2A.dta) path("`export'") ///
		dofile(2010_AGSEC2A) user($user)
		*** this part doesn't work yet 

* close the log
	log	close

/* END */