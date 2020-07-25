* Project: UVM 
* Created on: July 2020
* Created by: alj
* Stata v.16

* does
	* inspects variables related to: challenges 
	* attrition basic analysis on variables above

* assumes
	* standard - Stata v.16
	* previously created files
	
* TO DO:
	* adjust directiories for universal use - right now set to alj 

* **********************************************************************
* 0 - setup
* **********************************************************************

* open log
	cap 		log close
	log 		using 	"C:\Users\aljosephson\Dropbox\COVID\UVM/challenges-log", append

* **********************************************************************
* 1 - program uses variables (long)
* **********************************************************************

* looking at food security variables
* using long data set 		
* only have T1 and T2 (not T1 year and T1 covid)

use 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_9July.dta", clear 
	*** this is the "long" dataset where T1 and T2 are stacked 
	
**** AS MUCH ****	
	
* create variables to compare two time periods 		
	gen 		challenge_asmuch_comp = . 
	destring	challenge_asmuch, generate(challenge_asmuche)
	label 		var challenge_asmuche "destrung version of challenge_asmuch"
	replace 	challenge_asmuch_comp = challenge_asmuche if period == 1
	replace 	challenge_asmuch_comp = challenge_asmuche if period == 2
	tab 		challenge_asmuch_comp
	ttest	 	challenge_asmuch_comp, by (period)
	*** statistically different
	*** T1 larger 
	*** Pr(|T| > |t|) = 0.0000 
	
**** KINDS ****

* create variables to compare two time periods 		
	gen 		challenge_kinds_comp = . 
	destring	challenge_kinds, generate(challenge_kindse)
	label 		var challenge_kindse "destrung version of challenge_kinds"
	replace 	challenge_kinds_comp = challenge_kindse if period == 1
	replace 	challenge_kinds_comp = challenge_kindse if period == 2
	tab 		challenge_kinds_comp
	ttest	 	challenge_kinds_comp, by (period)
	*** statistically different
	*** T1 larger 
	*** Pr(|T| > |t|) = 0.0002 

**** FIND HELP ****

* create variables to compare two time periods 		
	gen 		challenge_findhelp_comp = . 
	destring	challenge_findhelp, generate(challenge_findhelpe)
	label 		var challenge_findhelpe "destrung version of challenge_findhelp"
	replace 	challenge_findhelp_comp = challenge_findhelpe if period == 1
	replace 	challenge_findhelp_comp = challenge_findhelpe if period == 2
	tab 		challenge_findhelp_comp
	ttest	 	challenge_findhelp_comp, by (period)
	*** statistically different
	*** T1 larger 
	*** Pr(|T| > |t|) = 0.0046 

**** MORE PLACES ****

* create variables to compare two time periods 		
	gen 		challenge_moreplaces_comp = . 
	destring	challenge_moreplaces, generate(challenge_moreplacese)
	label 		var challenge_moreplacese "destrung version of challenge_moreplaces"
	replace 	challenge_moreplaces_comp = challenge_moreplacese if period == 1
	replace 	challenge_moreplaces_comp = challenge_moreplacese if period == 2
	tab 		challenge_moreplaces_comp
	ttest	 	challenge_moreplaces_comp, by (period)
	*** statistically different
	*** T1 larger 
	*** Pr(|T| > |t|) = 0.0000   
	
**** CLOSE ****

* create variables to compare two time periods 		
	gen 		challenge_close_comp = . 
	destring	challenge_close, generate(challenge_closee)
	label 		var challenge_closee "destrung version of challenge_close"
	replace 	challenge_close_comp = challenge_closee if period == 1
	replace 	challenge_close_comp = challenge_closee if period == 2
	tab 		challenge_close_comp
	ttest	 	challenge_close_comp, by (period)
	*** marginally statistically different
	*** T1 larger 
	*** Pr(|T| > |t|) = 0.0781
	
**** REDUC GROC ****

* create variables to compare two time periods 		
	gen 		challenge_reducgroc_comp = . 
	destring	challenge_reducgroc, generate(challenge_reducgroce)
	label 		var challenge_closee "destrung version of challenge_reducgroc"
	replace 	challenge_reducgroc_comp = challenge_reducgroce if period == 1
	replace 	challenge_reducgroc_comp = challenge_reducgroce if period == 2
	tab 		challenge_reducgroc_comp
	ttest	 	challenge_reducgroc_comp, by (period)
	*** statistically different
	*** T1 larger 
	*** Pr(|T| > |t|) = 0.0012
	
* save 	
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_25July.dta", replace 

* **********************************************************************
* 2 - programs variables (wide)
* **********************************************************************

* using wide data set 

	use 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_9July_wide.dta", clear
	*** this is the "wide" dataset where T1 and T2 are next to each other - like in Excel data  

**** AS MUCH ****		

* need to destring
	destring	challenge_asmuch_T1, generate (challenge_asmuch_T1e)
	destring	challenge_asmuch_T2, generate (challenge_asmuch_T2e)
	
* non-respondents to these questions in all periods	
	count 		if challenge_asmuch_T1e != . & challenge_asmuch_T2e != .
	*** 1,219 respond to both periods 
	tab 		challenge_asmuch_T1e, missing
	*** 13 indicate question not relevant
	*** 1,230 respondents 
	*** 6 non-respondents
	tab 		challenge_asmuch_T2e, missing
	*** 30 indicate question not relevant
	*** 1,236 respondents 
	*** 12 non-respondents
	
* create variable to determine movement in status between T1 and T2	
* variable not able to be created in the same way
* since not binary questions are different
* will not create this movement variable at this time

**** KINDS ****		

* need to destring
	destring	challenge_kinds_T1, generate (challenge_kinds_T1e)
	destring	challenge_kinds_T2, generate (challenge_kinds_T2e)
	
* non-respondents to these questions in all periods	
	count 		if challenge_kinds_T1e != . & challenge_kinds_T2e != .
	*** 1,225 respond to both periods 
	tab 		challenge_kinds_T1e, missing
	*** 19 indicate question not relevant
	*** 1,236 respondents 
	*** 6 non-respondents
	tab 		challenge_kinds_T2e, missing
	*** 22 indicate question not relevant
	*** 1,236 respondents 
	*** 5 non-respondents
	
* create variable to determine movement in status between T1 and T2	
* variable not able to be created in the same way
* since not binary questions are different
* will not create this movement variable at this time
**** FIND HELP ****		

* need to destring
	destring	challenge_findhelp_T1, generate (challenge_findhelp_T1e)
	destring	challenge_findhelp_T2, generate (challenge_findhelp_T2e)
	
* non-respondents to these questions in all periods	
	count 		if challenge_findhelp_T1e != . & challenge_findhelp_T2e != .
	*** 1,202 respond to both periods 
	tab 		challenge_findhelp_T1e, missing
	*** 302 indicate question not relevant
	*** 1,236 respondents 
	*** 9 non-respondents
	tab 		challenge_findhelp_T2e, missing
	*** 324 indicate question not relevant
	*** 1,236 respondents 
	*** 26 non-respondents
	
* create variable to determine movement in status between T1 and T2	
* variable not able to be created in the same way
* since not binary questions are different
* will not create this movement variable at this time

**** MORE PLACES ****		

* need to destring
	destring	challenge_moreplaces_T1, generate (challenge_moreplaces_T1e)
	destring	challenge_moreplaces_T2, generate (challenge_moreplaces_T2e)
	
* non-respondents to these questions in all periods	
	count 		if challenge_moreplaces_T1e != . & challenge_moreplaces_T2e != .
	*** 1,219 respond to both periods 
	tab 		challenge_moreplaces_T1e, missing
	*** 79 indicate question not relevant
	*** 1,236 respondents 
	*** 8 non-respondents
	tab 		challenge_moreplaces_T2e, missing
	*** 84 indicate question not relevant
	*** 1,236 respondents 
	*** 9 non-respondents
	
* create variable to determine movement in status between T1 and T2	
* variable not able to be created in the same way
* since not binary questions are different
* will not create this movement variable at this time

**** CLOSE ****		

* need to destring
	encode 		challenge_close_T1, generate (challenge_close_T1e)
	encode 		challenge_close_T2, generate (challenge_close_T2e)
	
* non-respondents to these questions in all periods	
	count 		if challenge_close_T1e != . & challenge_close_T2e != .
	*** 1,223 respond to both periods 
	tab 		challenge_close_T1e, missing
	*** 61 indicate question not relevant
	*** 1,236 respondents 
	*** 8 non-respondents
	tab 		challenge_close_T2e, missing
	*** 68 indicate question not relevant
	*** 1,236 respondents 
	*** 6 non-respondents
	
* create variable to determine movement in status between T1 and T2	
* variable not able to be created in the same way
* since not binary questions are different
* will not create this movement variable at this time

**** REDUC GROC ****		

* need to encode
	destring	challenge_reducgroc_T1, generate (challenge_reducgroc_T1e)
	destring	challenge_reducgroc_T2, generate (challenge_reducgroc_T2e)
	
* non-respondents to these questions in all periods	
	count 		if challenge_reducgroc_T1e != . & challenge_reducgroc_T2e != .
	*** 1,225 respond to both periods 
	tab 		challenge_reducgroc_T1e, missing
	*** 11 indicate question not relevant
	*** 1,236 respondents 
	*** 6 non-respondents
	tab 		challenge_reducgroc_T2e, missing
	*** 10 indicate question not relevant
	*** 1,236 respondents 
	*** 5 non-respondents
	
* create variable to determine movement in status between T1 and T2	
* variable not able to be created in the same way
* since not binary questions are different
* will not create this movement variable at this time
		
* save again 
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_25July_wide.dta", replace

* **********************************************************************
* 3 - preliminary attrition analysis 
* **********************************************************************

**** AS MUCH ****		

* generate variable for attriters
* people who do not respond to all periods 
	gen 		non_respon_chalasmuch = 0 if challenge_asmuch_T1e != . & challenge_asmuch_T2e != . 
	replace 	non_respon_chalasmuch = 1 if non_respon_chalasmuch == .
	tab			non_respon_chalasmuch
	*** 17
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_chalasmuch female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** statistically significant difference by year born: older = more likely to not respond 

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_chalasmuch female white year_born_T1 race_white_T1 income_T1 
	*** no change from above 

* include female, white Hispanic, white race, year born
	reg 		non_respon_chalasmuch female white year_born_T1 race_white_T1 
	*** no change from above 
	
**** KINDS ****		

* generate variable for attriters
* people who do not respond to all periods 
	gen 		non_respon_chalkinds = 0 if challenge_kinds_T1e != . & challenge_kinds_T2e != . 
	replace 	non_respon_chalkinds = 1 if non_respon_chalkinds == .
	tab			non_respon_chalkinds
	*** 11
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_chalkinds female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** no significant difference  

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_chalkinds female white year_born_T1 race_white_T1 income_T1 
	*** small change from above - now similar to 'asmuch regs'
	*** statistically significant difference by year born: older = more likely to not respond 
	
* include female, white Hispanic, white race, year born
	reg 		non_respon_chalkinds female white year_born_T1 race_white_T1 
	*** small change from above - now similar to 'asmuch regs'
	*** statistically significant difference by year born: older = more likely to not respond 

**** FIND HELP ****		

* generate variable for attriters
* people who do not respond to all periods 
	gen 		non_respon_chalhelp = 0 if challenge_findhelp_T1e != . & challenge_findhelp_T2e != . 
	replace 	non_respon_chalhelp = 1 if non_respon_chalhelp == .
	tab			non_respon_chalhelp
	*** 34
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_chalhelp female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** similar to 'as much' and 'kinds'
	*** statistically significant difference by year born: older = more likely to not respond 

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_chalhelp female white year_born_T1 race_white_T1 income_T1 
	*** no change from above 
	
* include female, white Hispanic, white race, year born
	reg 		non_respon_chalhelp female white year_born_T1 race_white_T1 
	*** no change from above 

**** MORE PLACES ****		

* generate variable for attriters
* people who do not respond to all periods 
	gen 		non_respon_chalplaces = 0 if challenge_moreplaces_T1e != . & challenge_moreplaces_T2e != . 
	replace 	non_respon_chalplaces = 1 if non_respon_chalplaces == .
	tab			non_respon_chalplaces
	*** 17
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_chalplaces female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** no significant differences

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_chalplaces female white year_born_T1 race_white_T1 income_T1 
	*** small change from above - now similar to other variables
	*** statistically significant difference by year born: older = more likely to not respond 
	
* include female, white Hispanic, white race, year born
	reg 		non_respon_chalplaces female white year_born_T1 race_white_T1 
	*** small change from above - now similar to other variables
	*** statistically significant difference by year born: older = more likely to not respond 
	*** only marginally statistically significant 

**** CLOSE ****		

* generate variable for attriters
* people who do not respond to all periods 
	gen 		non_respon_chalclose = 0 if challenge_close_T1e != . & challenge_close_T2e != . 
	replace 	non_respon_chalclose = 1 if non_respon_chalclose == .
	tab			non_respon_chalclose
	*** 13
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_chalclose female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** no significant differences

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_chalclose female white year_born_T1 race_white_T1 income_T1 
	*** small change from above - now similar to other variables
	*** statistically significant difference by year born: older = more likely to not respond 
	
* include female, white Hispanic, white race, year born
	reg 		non_respon_chalclose female white year_born_T1 race_white_T1 
	*** small change from above - now similar to other variables
	*** statistically significant difference by year born: older = more likely to not respond 
	*** only marginally statistically significant 	

**** CLOSE ****		

* generate variable for attriters
* people who do not respond to all periods 
	gen 		non_respon_chalreducgroc = 0 if challenge_reducgroc_T1e != . & challenge_reducgroc_T2e != . 
	replace 	non_respon_chalreducgroc = 1 if non_respon_chalreducgroc == .
	tab			non_respon_chalreducgroc
	*** 11
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_chalreducgroc female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** similar to other variables
	*** statistically significant difference by year born: older = more likely to not respond 

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_chalreducgroc female white year_born_T1 race_white_T1 income_T1 
	*** no change from above
	
* include female, white Hispanic, white race, year born
	reg 		non_respon_chalreducgroc female white year_born_T1 race_white_T1 
	*** no change from above

* save again 
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_25July_wide.dta", replace

* **********************************************************************
* 3 - end matter
* **********************************************************************

* save new datasets as appropriate 
* should be saved above 

* close the log
	log	close

/* END */