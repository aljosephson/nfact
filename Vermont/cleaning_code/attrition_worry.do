* Project: UVM 
* Created on: July 2020
* Created by: alj
* Stata v.16

* does
	* inspects variables related to: worry 
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
	log 		using 	"C:\Users\aljosephson\Dropbox\COVID\UVM/worry-log", append

* **********************************************************************
* 1 - program uses variables (long)
* **********************************************************************

* looking at worry variables
* using long data set 		
* only have T1 and T2 (not T1 year and T1 covid)

use 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_25July.dta", clear 
	*** this is the "long" dataset where T1 and T2 are stacked 
	
**** ENOUGH FOOD ****	
	
* create variables to compare two time periods 		
	gen 		worry_enoughfood_comp = . 
	destring	worry_enoughfood, generate(worry_enoughfoode)
	label 		var worry_enoughfoode "destrung version of worry_enoughfood"
	replace 	worry_enoughfood_comp = worry_enoughfoode if period == 1
	replace 	worry_enoughfood_comp = worry_enoughfoode if period == 2
	tab 		worry_enoughfood_comp
	ranksum	 	worry_enoughfood_comp, by (period)
	*** statistically different
	*** z =   9.033, Prob > |z| =   0.0000
	
**** FOOD EXP ****	
	
* create variables to compare two time periods 		
	gen 		worry_foodexp_comp = . 
	destring	worry_foodexp, generate(worry_foodexpe)
	label 		var worry_enoughfoode "destrung version of worry_foodexp"
	replace 	worry_foodexp_comp = worry_foodexpe if period == 1
	replace 	worry_foodexp_comp = worry_foodexpe if period == 2
	tab 		worry_foodexp_comp
	ranksum	 	worry_foodexp_comp, by (period)
	*** statistically different
	*** z =  -5.600, Prob > |z| =   0.0000

**** FOOD UNSAFE ****	
	
* create variables to compare two time periods 		
	gen 		worry_foodunsafe_comp = . 
	destring	worry_foodunsafe, generate(worry_foodunsafee)
	label 		var worry_enoughfoode "destrung version of worry_foodunsafe"
	replace 	worry_foodunsafe_comp = worry_foodunsafee if period == 1
	replace 	worry_foodunsafe_comp = worry_foodunsafee if period == 2
	tab 		worry_foodunsafe_comp
	ranksum	 	worry_foodunsafe_comp, by (period)
	*** statistically different
	*** z =   6.664, Prob > |z| =   0.0000
 
**** PROGRAMS ****	
	
* create variables to compare two time periods 		
	gen 		worry_programs_comp = . 
	destring	worry_programs, generate(worry_programse)
	label 		var worry_enoughfoode "destrung version of worry_programs"
	replace 	worry_programs_comp = worry_programse if period == 1
	replace 	worry_programs_comp = worry_programse if period == 2
	tab 		worry_programs_comp
	ranksum	 	worry_programs_comp, by (period)
	*** statistically different
	*** z =  -5.770, Prob > |z| =   0.0000

**** INCOME ****	
	
* create variables to compare two time periods 		
	gen 		worry_income_comp = . 
	destring	worry_income, generate(worry_incomee)
	label 		var worry_incomee "destrung version of worry_income"
	replace 	worry_income_comp = worry_incomee if period == 1
	replace 	worry_income_comp = worry_incomee if period == 2
	tab 		worry_income_comp
	ranksum	 	worry_income_comp, by (period)
	*** statistically different
	*** z =   3.530, Prob > |z| =   0.0004

**** HOUSE FOOD ****	
	
* create variables to compare two time periods 		
	gen 		worry_housefood_comp = . 
	destring	worry_housefood, generate(worry_housefoode)
	label 		var worry_housefoode "destrung version of worry_housefood"
	replace 	worry_housefood_comp = worry_housefoode if period == 1
	replace 	worry_housefood_comp = worry_housefoode if period == 2
	tab 		worry_housefood_comp
	ranksum	 	worry_housefood_comp, by (period)
	*** statistically different
	*** z =   8.269, Prob > |z| =   0.0000

* save 	
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_25July.dta", replace 

* **********************************************************************
* 2 - programs variables (wide)
* **********************************************************************

* using wide data set 

	use 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_25July_wide.dta", clear
	*** this is the "wide" dataset where T1 and T2 are next to each other - like in Excel data  

**** ENOUGH FOOD ****		

* need to destring
	destring 	worry_enoughfood_T1, generate (worry_enoughfood_T1e)
	destring	worry_enoughfood_T2, generate (worry_enoughfood_T2e)
	
* non-respondents to these questions in all periods	
	count 		if worry_enoughfood_T1e != . & worry_enoughfood_T2e != .
	*** 1,206 respond to both periods 
	tab 		worry_enoughfood_T1e, missing
	*** 1 indicate question not relevant
	*** 1,236 respondents 
	*** 3 non-respondents
	tab 		worry_enoughfood_T2e, missing
	*** 2 indicate question not relevant
	*** 1,236 respondents 
	*** 27 non-respondents
	
* create variable to determine movement in status between T1 and T2	
* variable not able to be created in the same way
* since not binary questions are different - how would grouping be most appropriate? 
* will not create this movement variable at this time

**** FOOD EXP ****		

* need to destring
	destring	worry_foodexp_T1, generate (worry_foodexp_T1e)
	destring	worry_foodexp_T2, generate (worry_foodexp_T2e)
	
* non-respondents to these questions in all periods	
	count 		if worry_foodexp_T1e != . & worry_foodexp_T2e != .
	*** 1,207 respond to both periods 
	tab 		worry_foodexp_T1e, missing
	*** 5 indicate question not relevant
	*** 1,236 respondents 
	*** 3 non-respondents
	tab 		worry_foodexp_T2e, missing
	*** 4 indicate question not relevant
	*** 1,236 respondents 
	*** 26 non-respondents
	
* create variable to determine movement in status between T1 and T2	
* variable not able to be created in the same way
* since not binary questions are different - how would grouping be most appropriate? 
* will not create this movement variable at this time

**** FOOD UNSAFE ****		

* need to destring
	destring	worry_foodunsafe_T1, generate (worry_foodunsafe_T1e)
	destring	worry_foodunsafe_T2, generate (worry_foodunsafe_T2e)
	
* non-respondents to these questions in all periods	
	count 		if worry_foodunsafe_T1e != . & worry_foodunsafe_T2e != .
	*** 1,207 respond to both periods 
	tab 		worry_foodunsafe_T1e, missing
	*** 2 indicate question not relevant
	*** 1,236 respondents 
	*** 3 non-respondents
	tab 		worry_foodunsafe_T2e, missing
	*** 2 indicate question not relevant
	*** 1,236 respondents 
	*** 26 non-respondents
	
* create variable to determine movement in status between T1 and T2	
* variable not able to be created in the same way
* since not binary questions are different - how would grouping be most appropriate? 
* will not create this movement variable at this time

**** PROGRAMS ****		

* need to destring
	destring	worry_programs_T1, generate (worry_programs_T1e)
	destring	worry_programs_T2, generate (worry_programs_T2e)
	
* non-respondents to these questions in all periods	
	count 		if worry_programs_T1e != . & worry_programs_T2e != .
	*** 1,196 respond to both periods 
	tab 		worry_programs_T1e, missing
	*** 749 indicate question not relevant: much higher than previous, but makes sense given question
	*** 1,236 respondents 
	*** 16 non-respondents
	tab 		worry_programs_T2e, missing
	*** 617 indicate question not relevant
	*** 1,236 respondents 
	*** 25 non-respondents
	
**** INCOME ****		

* need to destring
	destring	worry_income_T1, generate (worry_income_T1e)
	destring	worry_income_T2, generate (worry_income_T2e)
	
* non-respondents to these questions in all periods	
	count 		if worry_income_T1e != . & worry_income_T2e != .
	*** 1,196 respond to both periods 
	tab 		worry_income_T1e, missing
	*** 187 indicate question not relevant: much higher than previous
	*** 1,236 respondents 
	*** 14 non-respondents
	tab 		worry_income_T2e, missing
	*** 168 indicate question not relevant
	*** 1,236 respondents 
	*** 27 non-respondents
	
* create variable to determine movement in status between T1 and T2	
* variable not able to be created in the same way
* since not binary questions are different - how would grouping be most appropriate? 
* will not create this movement variable at this time

**** HOUSE FOOD ****		

* need to destring
	destring	worry_housefood_T1, generate (worry_housefood_T1e)
	destring	worry_housefood_T2, generate (worry_housefood_T2e)
	
* non-respondents to these questions in all periods	
	count 		if worry_housefood_T1e != . & worry_housefood_T2e != .
	*** 1,205 respond to both periods 
	tab 		worry_housefood_T1e, missing
	*** 73 indicate question not relevant: much higher than previous
	*** 1,236 respondents 
	*** 5 non-respondents
	tab 		worry_housefood_T2e, missing
	*** 77 indicate question not relevant
	*** 1,236 respondents 
	*** 26 non-respondents
	
* create variable to determine movement in status between T1 and T2	
* variable not able to be created in the same way
* since not binary questions are different - how would grouping be most appropriate? 
* will not create this movement variable at this time
	
* save again 
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_25July_wide.dta", replace

* **********************************************************************
* 3 - preliminary attrition analysis 
* **********************************************************************

**** ENOUGH FOOD ****		

* generate variable for attriters
* people who do not respond to all periods 
	gen 		non_respon_worryenoughfood = 0 if worry_enoughfood_T1e != . & worry_enoughfood_T1e != . 
	replace 	non_respon_worryenoughfood = 1 if non_respon_worryenoughfood == .
	replace		non_respon_worryenoughfood = . if worry_enoughfood_T1e == 1 & worry_enoughfood_T2e == 1
 	*** indicates that question does not apply to that person
	tab			non_respon_worryenoughfood, missing
	*** 3 non responders
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_worryenoughfood female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** statistically significant difference by race: non-white = less likely to not respond 

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_worryenoughfood female white year_born_T1 race_white_T1 income_T1 
	*** no change from above 

* include female, white Hispanic, white race, year born
	reg 		non_respon_worryenoughfood female white year_born_T1 race_white_T1 
	*** no change from above 
	
**** FOOD EXP ****		

* generate variable for attriters
* people who do not respond to all periods 
	gen 		non_respon_worryfoodexp = 0 if worry_foodexp_T1e != . & worry_foodexp_T2e != . 
	replace 	non_respon_worryfoodexp = 1 if non_respon_worryfoodexp == .
	replace		non_respon_worryfoodexp = . if worry_foodexp_T1e == 1 & worry_foodexp_T2e == 1
 	*** indicates that question does not apply to that person
	tab			non_respon_worryenoughfood, missing
	*** 3 non responders
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_worryfoodexp female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** no statistically significant difference  

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_worryfoodexp female white year_born_T1 race_white_T1 income_T1 
	*** no change from above 

* include female, white Hispanic, white race, year born
	reg 		non_respon_worryfoodexp female white year_born_T1 race_white_T1 
	*** no change from above 
	
**** FOOD EXP ****		

* generate variable for attriters
* people who do not respond to all periods 
	gen 		non_respon_worryfoodunsafe = 0 if worry_foodunsafe_T1e != . & worry_foodunsafe_T2e != . 
	replace 	non_respon_worryfoodunsafe = 1 if non_respon_worryfoodunsafe == .
	replace		non_respon_worryfoodunsafe = . if worry_foodunsafe_T1e == 1 & worry_foodunsafe_T2e == 1
 	*** indicates that question does not apply to that person
	tab			non_respon_worryfoodunsafe, missing
	*** 29 non responders
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_worryfoodunsafe female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** no statistically significant difference  

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_worryfoodunsafe female white year_born_T1 race_white_T1 income_T1 
	*** no change from above 

* include female, white Hispanic, white race, year born
	reg 		non_respon_worryfoodunsafe female white year_born_T1 race_white_T1 
	*** no change from above 

**** PROGRAMS ****		

* generate variable for attriters
* people who do not respond to all periods 
	gen 		non_respon_worryprog = 0 if worry_programs_T1e != . & worry_programs_T2e != . 
	replace 	non_respon_worryprog = 1 if non_respon_worryprog == .
	replace		non_respon_worryprog = . if worry_programs_T1e == 1 & worry_programs_T2e == 1
 	*** indicates that question does not apply to that person
	tab			non_respon_worryprog, missing
	*** 40 non responders
	*** 517 does not apply in either period
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_worryprog female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** statistically significant difference by year born: older = less likely to respond 
	*** coefficient is extremely small

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_worryprog female white year_born_T1 race_white_T1 income_T1 
	*** statistically significant difference by gender: women = less likely to respond 
	*** strange - first time observed change between specifications like this

* include female, white Hispanic, white race, year born
	reg 		non_respon_worryprog female white year_born_T1 race_white_T1 
	*** no statistically significant difference
	*** again: strange 
	

**** INCOME ****		

* generate variable for attriters
* people who do not respond to all periods 
	gen 		non_respon_worryincome = 0 if worry_income_T1e != . & worry_income_T2e != . 
	replace 	non_respon_worryincome = 1 if non_respon_worryincome == .
	replace		non_respon_worryincome = . if worry_income_T1e == 1 & worry_income_T2e == 1
 	*** indicates that question does not apply to that person
	tab			non_respon_worryincome, missing
	*** 40 non responders
	*** 75 does not apply in either period
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_worryincome female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** statistically significant difference by year born: older = less likely to respond 
	*** statistically significant difference by gender: women = less likely to respond 

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_worryincome female white year_born_T1 race_white_T1 income_T1 
	*** statistically significant difference by gender: women = less likely to respond 

* include female, white Hispanic, white race, year born
	reg 		non_respon_worryincome female white year_born_T1 race_white_T1 
	*** no change from above 
	
**** HOUSE FOOD ****		

* generate variable for attriters
* people who do not respond to all periods 
	gen 		non_respon_worryhfood = 0 if worry_housefood_T1e != . & worry_housefood_T2e != . 
	replace 	non_respon_worryhfood = 1 if non_respon_worryhfood == .
	replace		non_respon_worryhfood = . if worry_housefood_T1e == 1 & worry_housefood_T2e == 1
 	*** indicates that question does not apply to that person
	tab			non_respon_worryhfood, missing
	*** 31 non responders
	*** 21 does not apply in either period
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_worryhfood female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** no statistically significant difference

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_worryhfood female white year_born_T1 race_white_T1 income_T1 
	*** statistically significant difference by gender: women = less likely to respond 

* include female, white Hispanic, white race, year born
	reg 		non_respon_worryhfood female white year_born_T1 race_white_T1 
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