* Project: UVM 
* Created on: July 2020
* Created by: alj
* Stata v.16

* does
	* inspects variables related to: perspectives 
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
	log 		using 	"C:\Users\aljosephson\Dropbox\COVID\UVM/perspectives-log", append

* **********************************************************************
* 1 - program uses variables (long)
* **********************************************************************

* looking at worry variables
* using long data set 		
* only have T1 and T2 (not T1 year and T1 covid)

use 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_25July.dta", clear 
	*** this is the "long" dataset where T1 and T2 are stacked 
	
**** FLU ****	
	
* create variables to compare two time periods 		
	gen 		persp_flu_comp = . 
	destring	persp_flu, generate(persp_flue)
	label 		var persp_flue "destrung version of worry_enoughfood"
	replace 	persp_flu_comp = persp_flue if period == 1
	replace 	persp_flu_comp = persp_flue if period == 2
	tab 		persp_flu_comp
	ranksum	 	persp_flu_comp, by (period)
	*** statistically different
	*** z =  -2.647, Prob > |z| =   0.0081

**** VT ****	
	
* create variables to compare two time periods 		
	gen 		persp_vt_comp = . 
	destring	persp_VT, generate(persp_vte)
	label 		var persp_vte "destrung version of worry_enoughfood"
	replace 	persp_vt_comp = persp_vte if period == 1
	replace 	persp_vt_comp = persp_vte if period == 2
	tab 		persp_vt_comp
	ranksum	 	persp_vt_comp, by (period)
	*** statistically different
	*** z = -13.453, Prob > |z| =   0.0000
	
**** USA ****	
	
* create variables to compare two time periods 		
	gen 		persp_usa_comp = . 
	destring	persp_US, generate(persp_usae)
	label 		var persp_usae "destrung version of worry_enoughfood"
	replace 	persp_usa_comp = persp_usae if period == 1
	replace 	persp_usa_comp = persp_usae if period == 2
	tab 		persp_usa_comp
	ranksum	 	persp_usa_comp, by (period)
	*** statistically different
	***  z =  -1.745, Prob > |z| =   0.0809

**** me ****	
	
* create variables to compare two time periods 		
	gen 		persp_me_comp = . 
	destring	persp_me, generate(persp_mee)
	label 		var persp_mee "destrung version of worry_enoughfood"
	replace 	persp_me_comp = persp_mee if period == 1
	replace 	persp_me_comp = persp_mee if period == 2
	tab 		persp_me_comp
	ranksum	 	persp_me_comp, by (period)
	*** statistically different
	***  z =   2.984, Prob > |z| =   0.0028

**** econ ****	
	
* create variables to compare two time periods 		
	gen 		persp_econ_comp = . 
	destring	persp_econ, generate(persp_econe)
	label 		var persp_econe "destrung version of worry_enoughfood"
	replace 	persp_econ_comp = persp_econe if period == 1
	replace 	persp_econ_comp = persp_econe if period == 2
	tab 		persp_econ_comp
	ranksum	 	persp_econ_comp, by (period)
	*** statistically different
	***  z =  -9.538, Prob > |z| =   0.0000

**** action ****	
	
* create variables to compare two time periods 		
	gen 		persp_action_comp = . 
	destring	persp_action, generate(persp_actione)
	label 		var persp_actione "destrung version of worry_enoughfood"
	replace 	persp_action_comp = persp_actione if period == 1
	replace 	persp_action_comp = persp_actione if period == 2
	tab 		persp_action_comp
	ranksum	 	persp_action_comp, by (period)
	*** statistically different
	***  z =  16.397, Prob > |z| =   0.0000

**** prepared ****	
	
* create variables to compare two time periods 		
	gen 		persp_prepared_comp = . 
	destring	persp_prepared, generate(persp_preparede)
	label 		var persp_actione "destrung version of worry_enoughfood"
	replace 	persp_prepared_comp = persp_preparede if period == 1
	replace 	persp_prepared_comp = persp_preparede if period == 2
	tab 		persp_prepared_comp
	ranksum	 	persp_prepared_comp, by (period)
	*** not statistically different
	*** z =   0.940, Prob > |z| =   0.3474

**** packages ****	
	
* create variables to compare two time periods 		
	gen 		persp_packages_comp = . 
	destring	persp_packages, generate(persp_packagese)
	label 		var persp_actione "destrung version of worry_enoughfood"
	replace 	persp_packages_comp = persp_packagese if period == 1
	replace 	persp_packages_comp = persp_packagese if period == 2
	tab 		persp_packages_comp
	ranksum	 	persp_packages_comp, by (period)
	*** statistically different
	*** z =  -9.103, Prob > |z| =   0.0000

* save 	
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_25July.dta", replace 

* **********************************************************************
* 2 - programs variables (wide)
* **********************************************************************

* using wide data set 

	use 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_25July_wide.dta", clear
	*** this is the "wide" dataset where T1 and T2 are next to each other - like in Excel data  

**** FLU ****		

* need to destring
	destring	persp_flu_T1, generate (persp_flu_T1e)
	destring	persp_flu_T2, generate (persp_flu_T2e)
	
* non-respondents to these questions in all periods	
	count 		if persp_flu_T1e != . & persp_flu_T2e != .
	*** 1,185 respond to both periods 
	tab 		persp_flu_T1e, missing
	*** 19 indicate question not relevant
	*** 1,236 respondents 
	*** 2 non-respondents
	tab 		persp_flu_T2e, missing
	*** 17 indicate question not relevant
	*** 1,236 respondents 
	*** 49 non-respondents
	
* create variable to determine movement in status between T1 and T2	
* variable not able to be created in the same way
* since not binary questions are different - how would grouping be most appropriate? 
* will not create this movement variable at this time

**** VT ****		

* need to destring
	destring	persp_VT_T1, generate (persp_vt_T1e)
	destring	persp_VT_T2, generate (persp_vt_T2e)
	
* non-respondents to these questions in all periods	
	count 		if persp_vt_T1e != . & persp_vt_T2e != .
	*** 1,185 respond to both periods 
	tab 		persp_vt_T1e, missing
	*** 139 indicate question not relevant
	*** 1,236 respondents 
	*** 1 non-respondents
	tab 		persp_vt_T2e, missing
	*** 61 indicate question not relevant
	*** 1,236 respondents 
	*** 50 non-respondents
	
* create variable to determine movement in status between T1 and T2	
* variable not able to be created in the same way
* since not binary questions are different - how would grouping be most appropriate? 
* will not create this movement variable at this time

**** USA ****		

* need to destring
	destring	persp_US_T1, generate (persp_us_T1e)
	destring	persp_US_T2, generate (persp_us_T2e)
	
* non-respondents to these questions in all periods	
	count 		if persp_us_T1e != . & persp_us_T2e != .
	*** 1,185 respond to both periods 
	tab 		persp_us_T1e, missing
	*** 151 indicate question not relevant
	*** 1,236 respondents 
	*** 1 non-respondents
	tab 		persp_us_T2e, missing
	*** 144 indicate question not relevant
	*** 1,236 respondents 
	*** 50 non-respondents
	
* create variable to determine movement in status between T1 and T2	
* variable not able to be created in the same way
* since not binary questions are different - how would grouping be most appropriate? 
* will not create this movement variable at this time

**** me ****		

* need to destring
	destring	persp_me_T1, generate (persp_me_T1e)
	destring	persp_me_T2, generate (persp_me_T2e)
	
* non-respondents to these questions in all periods	
	count 		if persp_me_T1e != . & persp_me_T2e != .
	*** 1,181 respond to both periods 
	tab 		persp_me_T1e, missing
	*** 59 indicate question not relevant
	*** 1,236 respondents 
	*** 3 non-respondents
	tab 		persp_me_T2e, missing
	*** 54 indicate question not relevant
	*** 1,236 respondents 
	*** 52 non-respondents
	
* create variable to determine movement in status between T1 and T2	
* variable not able to be created in the same way
* since not binary questions are different - how would grouping be most appropriate? 
* will not create this movement variable at this time

**** econ ****		

* need to destring
	destring	persp_econ_T1, generate (persp_econ_T1e)
	destring	persp_econ_T2, generate (persp_econ_T2e)
	
* non-respondents to these questions in all periods	
	count 		if persp_econ_T1e != . & persp_econ_T2e != .
	*** 1,160 respond to both periods 
	tab 		persp_econ_T1e, missing
	*** 25 indicate question not relevant
	*** 1,236 respondents 
	*** 24 non-respondents
	tab 		persp_econ_T2e, missing
	*** 36 indicate question not relevant
	*** 1,236 respondents 
	*** 54 non-respondents
	
* create variable to determine movement in status between T1 and T2	
* variable not able to be created in the same way
* since not binary questions are different - how would grouping be most appropriate? 
* will not create this movement variable at this time

**** action ****		

* need to destring
	destring	persp_action_T1, generate (persp_action_T1e)
	destring	persp_action_T2, generate (persp_action_T2e)
	
* non-respondents to these questions in all periods	
	count 		if persp_action_T1e != . & persp_action_T2e != .
	*** 1,184 respond to both periods 
	tab 		persp_action_T1e, missing
	*** 13 indicate question not relevant
	*** 1,236 respondents 
	*** 1 non-respondents
	tab 		persp_action_T2e, missing
	*** 13 indicate question not relevant
	*** 1,236 respondents 
	*** 54 non-respondents
	
* create variable to determine movement in status between T1 and T2	
* variable not able to be created in the same way
* since not binary questions are different - how would grouping be most appropriate? 
* will not create this movement variable at this time

**** prepared ****		

* need to destring
	destring	persp_prepared_T1, generate (persp_prepared_T1e)
	destring	persp_prepared_T2, generate (persp_prepared_T2e)
	
* non-respondents to these questions in all periods	
	count 		if persp_prepared_T1e != . & persp_prepared_T2e != .
	*** 1,178 respond to both periods 
	tab 		persp_prepared_T1e, missing
	*** 30 indicate question not relevant
	*** 1,236 respondents 
	*** 4 non-respondents
	tab 		persp_prepared_T2e, missing
	*** 23 indicate question not relevant
	*** 1,236 respondents 
	*** 54 non-respondents
	
* create variable to determine movement in status between T1 and T2	
* variable not able to be created in the same way
* since not binary questions are different - how would grouping be most appropriate? 
* will not create this movement variable at this time

**** packages ****		

* need to destring
	destring	persp_packages_T1, generate (persp_packages_T1e)
	destring	persp_packages_T2, generate (persp_packages_T2e)
	
* non-respondents to these questions in all periods	
	count 		if persp_packages_T1e != . & persp_packages_T2e != .
	*** 1,179 respond to both periods 
	tab 		persp_packages_T1e, missing
	*** 179 indicate question not relevant
	*** 1,236 respondents 
	*** 2 non-respondents
	tab 		persp_packages_T2e, missing
	*** 183 indicate question not relevant
	*** 1,236 respondents 
	*** 56 non-respondents
	
* create variable to determine movement in status between T1 and T2	
* variable not able to be created in the same way
* since not binary questions are different - how would grouping be most appropriate? 
* will not create this movement variable at this time

* save again 
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_25July_wide.dta", replace

* **********************************************************************
* 3 - preliminary attrition analysis 
* **********************************************************************

**** FLU ****		

* generate variable for attriters
* people who do not respond to all periods 
	gen 		non_respon_perspflu = 0 if persp_flu_T1e != . & persp_flu_T2e != . 
	replace 	non_respon_perspflu = 1 if non_respon_perspflu == .
	replace		non_respon_perspflu = . if persp_flu_T1e == 1 & persp_flu_T2e == 1
 	*** indicates that question does not apply to that person
	tab			non_respon_worryenoughfood, missing
	*** 3 non responders
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_perspflu female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** no statistically significant difference 

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_perspflu female white year_born_T1 race_white_T1 income_T1 
	*** statistically significant difference by female: women less likely to respond 

* include female, white Hispanic, white race, year born
	reg 		non_respon_perspflu female white year_born_T1 race_white_T1 
	*** no change from above 
	
**** VT ****		

* generate variable for attriters
* people who do not respond to all periods 
	gen 		non_respon_perspvt = 0 if persp_vt_T1e != . & persp_vt_T2e != . 
	replace 	non_respon_perspvt = 1 if non_respon_perspvt == .
	replace		non_respon_perspvt = . if persp_vt_T1e == 1 & persp_vt_T2e == 1
 	*** indicates that question does not apply to that person
	tab			non_respon_perspvt, missing
	*** 51 non responders
	*** 17 do not apply - could there be people not living in VT?? 
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_perspvt female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** no statistically significant difference 

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_perspvt female white year_born_T1 race_white_T1 income_T1 
	*** statistically significant difference by female: women less likely to respond 

* include female, white Hispanic, white race, year born
	reg 		non_respon_perspvt female white year_born_T1 race_white_T1 
	*** no change from above 
	
**** USA ****		

* generate variable for attriters
* people who do not respond to all periods 
	gen 		non_respon_perspusa = 0 if persp_us_T1e != . & persp_us_T2e != . 
	replace 	non_respon_perspusa = 1 if non_respon_perspusa == .
	replace		non_respon_perspusa = . if persp_us_T1e == 1 & persp_us_T2e == 1
 	*** indicates that question does not apply to that person
	tab			non_respon_perspusa, missing
	*** 51 non responders
	*** 41 do not apply - could there be people not living in USA?? Or just don't have thoughts about it?? 
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_perspusa female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** no statistically significant difference 

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_perspusa female white year_born_T1 race_white_T1 income_T1 
	*** statistically significant difference by female: women less likely to respond 

* include female, white Hispanic, white race, year born
	reg 		non_respon_perspusa female white year_born_T1 race_white_T1 
	*** no change from above 
	
**** me ****		

* generate variable for attriters
* people who do not respond to all periods 
	gen 		non_respon_perspme = 0 if persp_me_T1e != . & persp_me_T2e != . 
	replace 	non_respon_perspme = 1 if non_respon_perspme == .
	replace		non_respon_perspme = . if persp_me_T1e == 1 & persp_me_T2e == 1
 	*** indicates that question does not apply to that person
	tab			non_respon_perspme, missing
	*** 55 non responders
	*** 9 do not apply 
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_perspme female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** no statistically significant difference 

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_perspme female white year_born_T1 race_white_T1 income_T1 
	*** statistically significant difference by female: women less likely to respond 

* include female, white Hispanic, white race, year born
	reg 		non_respon_perspme female white year_born_T1 race_white_T1 
	*** no change from above 
	
**** econ ****		

* generate variable for attriters
* people who do not respond to all periods 
	gen 		non_respon_perspecon = 0 if persp_econ_T1e != . & persp_econ_T2e != . 
	replace 	non_respon_perspecon = 1 if non_respon_perspecon == .
	replace		non_respon_perspecon = . if persp_econ_T1e == 1 & persp_econ_T2e == 1
 	*** indicates that question does not apply to that person
	tab			non_respon_perspecon, missing
	*** 85 non responders
	*** 8 do not apply 
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_perspecon female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** statistically significant difference by race: white people less likely to respond

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_perspecon female white year_born_T1 race_white_T1 income_T1 
	*** no statistically significant difference

* include female, white Hispanic, white race, year born
	reg 		non_respon_perspecon female white year_born_T1 race_white_T1 
	*** no change from above 
	
**** action ****		

* generate variable for attriters
* people who do not respond to all periods 
	gen 		non_respon_perspaction = 0 if persp_action_T1e != . & persp_action_T2e != . 
	replace 	non_respon_perspaction = 1 if non_respon_perspaction == .
	replace		non_respon_perspaction = . if persp_action_T1e == 1 & persp_action_T2e == 1
 	*** indicates that question does not apply to that person
	tab			non_respon_perspaction, missing
	*** 52 non responders
	*** 1 do not apply 
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_perspaction female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** no statistically significant difference 

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_perspaction female white year_born_T1 race_white_T1 income_T1 
	*** statistically significant difference by gender: women less likely to respond

* include female, white Hispanic, white race, year born
	reg 		non_respon_perspaction female white year_born_T1 race_white_T1 
	*** no change from above 
	
**** prepared ****		

* generate variable for attriters
* people who do not respond to all periods 
	gen 		non_respon_perspprep = 0 if persp_prepared_T1e != . & persp_prepared_T2e != . 
	replace 	non_respon_perspprep = 1 if non_respon_perspprep == .
	replace		non_respon_perspprep = . if persp_prepared_T1e == 1 & persp_prepared_T2e == 1
 	*** indicates that question does not apply to that person
	tab			non_respon_perspprep, missing
	*** 58 non responders
	*** 6 do not apply 
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_perspprep female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** statistically significant difference by ethnicity: non-white (hispanic) less likely to respond

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_perspprep female white year_born_T1 race_white_T1 income_T1 
	*** statistically significant difference by gender: women less likely to respond
	*** bit strange to change from above

* include female, white Hispanic, white race, year born
	reg 		non_respon_perspprep female white year_born_T1 race_white_T1 
	*** no change from above

	
**** packages ****		

* generate variable for attriters
* people who do not respond to all periods 
	gen 		non_respon_persppack = 0 if persp_packages_T1e != . & persp_packages_T2e != . 
	replace 	non_respon_persppack = 1 if non_respon_persppack == .
	replace		non_respon_persppack = . if persp_packages_T1e == 1 & persp_packages_T2e == 1
 	*** indicates that question does not apply to that person
	tab			non_respon_persppack, missing
	*** 57 non responders
	*** 64 do not apply 
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_persppack female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** statistically significant difference by race: white less likely to respond

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_persppack female white year_born_T1 race_white_T1 income_T1 
	*** statistically significant difference by gender: women less likely to respond
	*** bit strange to change from above

* include female, white Hispanic, white race, year born
	reg 		non_respon_persppack female white year_born_T1 race_white_T1 
	*** no change from above
	
	*** stray thought across all of these - there are more women, so it could simply be that more women are dropping as there are more of them? unclear.

* save again 
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_19July_wide.dta", replace

* **********************************************************************
* 3 - end matter
* **********************************************************************

* save new datasets as appropriate 
* should be saved above 

* close the log
	log	close

/* END */