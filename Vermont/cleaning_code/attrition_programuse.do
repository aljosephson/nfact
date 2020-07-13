* Project: UVM 
* Created on: July 2020
* Created by: alj
* Stata v.16

* does
	* inspects variables related to: program use
	* attrition basic analysis on variables above

* assumes
	* standard - Stata v.16
	
* TO DO:
	* adjust directiories for universal use - right now set to alj 

* **********************************************************************
* 0 - setup
* **********************************************************************

* open log
	cap 		log close
	log 		using 	"C:\Users\aljosephson\Dropbox\COVID\UVM/10July_progchalworrypersp-log", append

* **********************************************************************
* 1 - program uses variables (long)
* **********************************************************************

* looking at food security variables
* using long data set 		

use 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_9July.dta", clear 
	*** this is the "long" dataset where T1 and T2 are stacked 
	
**** SNAP ****	
	
* create variables to compare year and last 30 		
	gen 		source_snap_comp_year30 = . 
	replace 	source_snap_comp_year30 = source_snap_year if period == 1
	replace 	source_snap_comp_year30 = prog_snap if period == 2
	tab 		source_snap_comp_year30
	ttest	 	source_snap_comp_year30, by (period)
	*** marginally statistically different
	*** Pr(|T| > |t|) = 0.0957  

* create variables to compare covid and last 30
	gen 		source_snap_comp_covid30 = . 
	replace 	source_snap_comp_covid30 = source_snap_covid if period == 1
	replace 	source_snap_comp_covid30 = prog_snap if period == 2
	tab 		source_snap_comp_covid30
	ttest	 	source_snap_comp_covid30, by (period)
	*** statistically different
	*** Pr(|T| > |t|) = 0.0003
		
* non-respondents to these questions in all periods	
	count 		if source_snap_year != . & source_snap_covid != . & prog_snap != .
	*** 0 did not respond to all three periods
	*** this is as expected - we assume that non-respond corresponds with 0
	*** could investgiate this assumption more deeply, perhaps 
	
* create non-respondent variable 
	gen 		non_respon_snap = 0 if source_snap_year != . & source_snap_covid != . & prog_snap != .
	replace 	non_respon_snap = 0 if source_snap_year != . & source_snap_covid != . & period == 1
	replace 	non_respon_snap = 0 if prog_snap != . & period == 2
	replace 	non_respon_snap = 1 if non_respon_snap == . 
	*** 4 do not respond to all three questions 
	
* do non-respondents differ in food security outcomes
	*ttest 		source_snap_comp_year30, by (non_respon_snap)
	*ttest 		source_snap_comp_covid30, by (non_respon_snap) 
	*** not enough variation to do this 

**** WIC ****	
	
* create variables to compare year and last 30 		
	gen 		source_wic_comp_year30 = . 
	replace 	source_wic_comp_year30 = source_wic_year if period == 1
	replace 	source_wic_comp_year30 = prog_wic if period == 2
	tab 		source_wic_comp_year30
	ttest	 	source_wic_comp_year30, by (period)
	*** not statistically different
	*** Pr(|T| > |t|) = 0.5757 

* create variables to compare covid and last 30
	gen 		source_wic_comp_covid30 = . 
	replace 	source_wic_comp_covid30 = source_wic_covid if period == 1
	replace 	source_wic_comp_covid30 = prog_wic if period == 2
	tab 		source_wic_comp_covid30
	ttest	 	source_wic_comp_covid30, by (period)
	*** not statistically different
	*** Pr(|T| > |t|) = 0.2556 

* non-respondents to these questions in all periods	
	count 		if source_wic_year != . & source_wic_covid != . & prog_wic != .
	*** 0 did not respond to all three periods
	*** this is as expected - we assume that non-respond corresponds with 0
	*** could investgiate this assumption more deeply, perhaps 
	
* create non-respondent variable 
	gen 		non_respon_wic = 0 if source_wic_year != . & source_wic_covid != . & prog_wic != .
	replace 	non_respon_wic = 0 if source_wic_year != . & source_wic_covid != . & period == 1
	replace 	non_respon_wic = 0 if prog_wic != . & period == 2
	replace 	non_respon_wic = 1 if non_respon_wic == . 
	*** 4 do not respond to all three
	*** aligns with above
	
* do non-respondents differ in wic outcomes
	*ttest 		source_wic_comp_year30, by (non_respon_snap)
	*ttest 		source_wic_comp_covid30, by (non_respon_snap) 
	*** not enough variation to do this 
	
**** SCHOOL ****	
	
* create variables to compare year and last 30 		
	gen 		source_school_comp_year30 = . 
	replace 	source_school_comp_year30 = source_school_year if period == 1
	replace 	source_school_comp_year30 = prog_school if period == 2
	tab 		source_school_comp_year30
	ttest	 	source_school_comp_year30, by (period)
	*** statistically different
	*** Pr(|T| > |t|) = 0.0075 

* create variables to compare covid and last 30
	gen 		source_school_comp_covid30 = . 
	replace 	source_school_comp_covid30 = source_school_covid if period == 1
	replace 	source_school_comp_covid30 = prog_school if period == 2
	tab 		source_school_comp_covid30
	ttest	 	source_school_comp_covid30, by (period)
	*** statistically different
	*** Pr(|T| > |t|) = 0.0075 

* non-respondents to these questions in all periods	
	count 		if source_school_year != . & source_school_covid != . & prog_school != .
	*** 0 did not respond to all three periods
	*** this is as expected - we assume that non-respond corresponds with 0
	*** could investgiate this assumption more deeply, perhaps 
	
* create non-respondent variable 
	gen 		non_respon_school = 0 if source_school_year != . & source_school_covid != . & prog_school != .
	replace 	non_respon_school = 0 if source_school_year != . & source_school_covid != . & period == 1
	replace 	non_respon_school = 0 if prog_school != . & period == 2
	replace 	non_respon_school = 1 if non_respon_school == . 
	*** 3 do not respond to all three
	
* do non-respondents differ in school outcomes
	*ttest 		source_school_comp_year30, by (non_respon_school)
	*ttest 		source_school_comp_covid30, by (non_respon_school) 
	*** not enough variation to do this 

	
**** PANTRY ****	
	
* create variables to compare year and last 30 		
	gen 		source_pantry_comp_year30 = . 
	replace 	source_pantry_comp_year30 = source_pantry_year if period == 1
	replace 	source_pantry_comp_year30 = prog_pantry if period == 2
	tab 		source_pantry_comp_year30
	ttest	 	source_pantry_comp_year30, by (period)
	*** not statistically different
	*** Pr(|T| > |t|) = 0.9518  

* create variables to compare covid and last 30
	gen 		source_pantry_comp_covid30 = . 
	replace 	source_pantry_comp_covid30 = source_pantry_covid if period == 1
	replace 	source_pantry_comp_covid30 = prog_pantry if period == 2
	tab 		source_pantry_comp_covid30
	ttest	 	source_pantry_comp_covid30, by (period)
	*** statistically different
	*** Pr(|T| > |t|) = 0.0005 

* non-respondents to these questions in all periods	
	count 		if source_pantry_year != . & source_pantry_covid != . & prog_pantry != .
	*** 0 did not respond to all three periods
	*** this is as expected - we assume that non-respond corresponds with 0
	*** could investgiate this assumption more deeply, perhaps 
	
* create non-respondent variable 
	gen 		non_respon_pantry = 0 if source_pantry_year != . & source_pantry_covid != . & prog_pantry != .
	replace 	non_respon_pantry = 0 if source_pantry_year != . & source_pantry_covid != . & period == 1
	replace 	non_respon_pantry = 0 if prog_pantry != . & period == 2
	replace 	non_respon_pantry = 1 if non_respon_pantry == . 
	*** 4 do not respond to all three
	
* do non-respondents differ in school outcomes
	*ttest 		source_pantry_comp_year30, by (non_respon_pantry)
	*ttest 		source_pantry_comp_covid30, by (non_respon_pantry) 
	*** not enough variation to do this 
	
* save again	
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_10July.dta", replace 

* **********************************************************************
* 2 - programs variables (wide)
* **********************************************************************

* using wide data set 

	use 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_9July_wide.dta", clear
	*** this is the "wide" dataset where T1 and T2 are next to each other - like in Excel data  

**** SNAP ****		
	
* non-respondents to these questions in all periods	
	count 		if source_snap_year_T1 != . & source_snap_covid_T1 != . & prog_snap_T2 != .
	*** 1232 did not respond to all three periods
	*** likely related to non-responses / non-use of programs
	*** could replace with 0, in line with long data 
	
* create variable to determine movement in status between year and covid 	
	gen 		source_snap_yearcov = 1 if source_snap_year_T1 == 0 & source_snap_covid_T1 == 1
	replace 	source_snap_yearcov = 0 if source_snap_year_T1 == 0 & source_snap_covid_T1 == 0
	replace 	source_snap_yearcov = 2 if source_snap_year_T1 == 1 & source_snap_covid_T1 == 1
	replace 	source_snap_yearcov = -1 if source_snap_year_T1 == 1 & source_snap_covid_T1 == 0
	label 		var source_snap_yearcov "-1 if become stop use, 0 if use both periods, 1 if begin use, 2 if always use"

* create variable to determine movement in status between covid and last 30 	
	gen 		source_snap_cov30 = 1 if prog_snap_T2 == 1 & source_snap_covid_T1 == 0
	replace 	source_snap_cov30 = 0 if prog_snap_T2 == 0 & source_snap_covid_T1 == 0
	replace 	source_snap_cov30 = 2 if prog_snap_T2 == 1 & source_snap_covid_T1 == 1
	replace 	source_snap_cov30 = -1 if prog_snap_T2 == 0 & source_snap_covid_T1 == 1
	label 		var source_snap_cov30 "-1 if become stop use, 0 if use both periods, 1 if begin use, 2 if always use"
	
**** WIC ****		
	
* non-respondents to these questions in all periods	
	count 		if source_wic_year_T1 != . & source_wic_covid_T1 != . & prog_wic_T2 != .
	*** 1232 did not respond to all three periods, same as above
	*** likely related to non-responses / non-use of programs
	*** could replace with 0, in line with long data 
	
* create variable to determine movement in status between year and covid 	
	gen 		source_wic_yearcov = 1 if source_wic_covid_T1 == 1 & source_wic_year_T1 == 0
	replace 	source_wic_yearcov = 0 if source_wic_covid_T1 == 0 & source_wic_year_T1 == 0
	replace 	source_wic_yearcov = 2 if source_wic_covid_T1 == 1 & source_wic_year_T1 == 1
	replace 	source_wic_yearcov = -1 if source_wic_covid_T1 == 0 & source_wic_year_T1 == 1
	label 		var source_wic_yearcov "-1 if become stop use, 0 if use both periods, 1 if begin use, 2 if always use"

* create variable to determine movement in status between covid and last 30 	
	gen 		source_wic_cov30 = 1 if prog_wic_T2 == 1 & source_wic_covid_T1 == 0
	replace 	source_wic_cov30 = 0 if prog_wic_T2 == 0 & source_wic_covid_T1 == 0
	replace 	source_wic_cov30 = 2 if prog_wic_T2 == 1 & source_wic_covid_T1 == 1
	replace 	source_wic_cov30 = -1 if prog_wic_T2 == 0 & source_wic_covid_T1 == 1
	label 		var source_wic_cov30 "-1 if become stop use, 0 if use both periods, 1 if begin use, 2 if always use"

**** SCHOOL ****		
	
* non-respondents to these questions in all periods	
	count 		if source_school_year_T1 != . & source_school_covid_T1 != . & prog_school_T2 != .
	*** 1233 did not respond to all three periods, similar to above
	*** likely related to non-responses / non-use of programs
	*** could replace with 0, in line with long data 
	
* create variable to determine movement in status between year and covid 	
	gen 		source_school_yearcov = 1 if source_school_covid_T1 == 1 & source_school_year_T1 == 0
	replace 	source_school_yearcov = 0 if source_school_covid_T1 == 0 & source_school_year_T1 == 0
	replace 	source_school_yearcov = 2 if source_school_covid_T1 == 1 & source_school_year_T1 == 1
	replace 	source_school_yearcov = -1 if source_school_covid_T1 == 0 & source_school_year_T1 == 1
	label 		var source_school_yearcov "-1 if become stop use, 0 if use both periods, 1 if begin use, 2 if always use"

* create variable to determine movement in status between covid and last 30 	
	gen 		source_school_cov30 = 1 if prog_school_T2 == 1 & source_school_covid_T1 == 0
	replace 	source_school_cov30 = 0 if prog_school_T2 == 0 & source_school_covid_T1 == 0
	replace 	source_school_cov30 = 2 if prog_school_T2 == 1 & source_school_covid_T1 == 1
	replace 	source_school_cov30 = -1 if prog_school_T2 == 0 & source_school_covid_T1 == 1
	label 		var source_school_cov30 "-1 if become stop use, 0 if use both periods, 1 if begin use, 2 if always use"

**** PANTRY ****		
	
* non-respondents to these questions in all periods	
	count 		if source_pantry_year_T1 != . & source_pantry_covid_T1 != . & prog_pantry_T2 != .
	*** 1232 did not respond to all three periods, same as above
	*** likely related to non-responses / non-use of programs
	*** could replace with 0, in line with long data 
	
* create variable to determine movement in status between year and covid 	
	gen 		source_pantry_yearcov = 1 if source_pantry_covid_T1 == 1 & source_pantry_year_T1 == 0
	replace 	source_pantry_yearcov = 0 if source_pantry_covid_T1 == 0 & source_pantry_year_T1 == 0
	replace 	source_pantry_yearcov = 2 if source_pantry_covid_T1 == 1 & source_pantry_year_T1 == 1
	replace 	source_pantry_yearcov = -1 if source_pantry_covid_T1 == 0 & source_pantry_year_T1 == 1
	label 		var source_pantry_yearcov "-1 if become stop use, 0 if use both periods, 1 if begin use, 2 if always use"

* create variable to determine movement in status between covid and last 30 	
	gen 		source_pantry_cov30 = 1 if prog_pantry_T2 == 1 & source_pantry_covid_T1 == 0
	replace 	source_pantry_cov30 = 0 if prog_pantry_T2 == 0 & source_pantry_covid_T1 == 0
	replace 	source_pantry_cov30 = 2 if prog_pantry_T2 == 1 & source_pantry_covid_T1 == 1
	replace 	source_pantry_cov30 = -1 if prog_pantry_T2 == 0 & source_pantry_covid_T1 == 1
	label 		var source_pantry_cov30 "-1 if become stop use, 0 if use both periods, 1 if begin use, 2 if always use"
	
* save again 
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_10July_wide.dta", replace

* **********************************************************************
* 3 - preliminary attrition analysis 
* **********************************************************************

**** SNAP ****		

* generate variable for attriters
* people who do not respond to all three 
	gen 		non_respon_snap = 0 if source_snap_year_T1 != . & source_snap_covid_T1 != . & prog_snap_T2 != .
	replace 	non_respon_snap = 1 if non_respon_snap == .
	tab			non_respon_snap
	*** 4
	*** some differences in phrasing / asking of questions across rounds, which might cause some of the differences
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_snap female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** no wild about this regression - not a lot of variation with only four non-respondents
	*** no significant bias 

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_snap female white year_born_T1 race_white_T1 income_T1 
	*** no change from above 
	*** no significant bias

* include female, white Hispanic, white race, year born
	reg 		non_respon_snap female white year_born_T1 race_white_T1 
	*** no change from above 
	*** no significant bias
	
* save again 
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_10July_wide.dta", replace

* **********************************************************************
* 3 - end matter
* **********************************************************************

* save new datasets as appropriate 
* should be saved above 

* close the log
	log	close

/* END */