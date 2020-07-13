* Project: UVM 
* Created on: July 2020
* Created by: alj
* Stata v.16

* does
	* cleans UVM two ways: long, wide (saves files)
	* inspects food security variables 
	* attrition basic analysis on food security variables 

* assumes
	* standard - Stata v.16
	
* TO DO:
	* adjust directiories for universal use - right now set to alj 
	* adjust labels in wide data set - too long currently 

* **********************************************************************
* 0 - setup
* **********************************************************************

* open log
	cap 		log close
	log 		using 	"C:\Users\aljosephson\Dropbox\COVID\UVM/9July_foodsecurity-log", append

* read in excel 
	clear
	import 		excel "C:\Users\aljosephson\Dropbox\COVID\UVM\data_clean_joinT1andT2_0617_deidentified.xlsx", sheet("data_clean_joinT1andT2_0617") firstrow
	
* save into two files to create long data set 	
	keep 		A UNIQUE_ID *_T1
	rename 		*_T1 *
	gen 		period = 1
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_T1_9July.dta", replace
	
	clear
	import 		excel "C:\Users\aljosephson\Dropbox\COVID\UVM\data_clean_joinT1andT2_0617_deidentified.xlsx", sheet("data_clean_joinT1andT2_0617") firstrow
	keep 		A UNIQUE_ID *_T2
	rename 		*_T2 *
	gen 		period = 2
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_T2_9July.dta", replace

* append together 	
	use 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_T1_9July.dta", clear
	append 		using "C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_T2_9July.dta", force
	
	rename 		UNIQUE_ID id
	rename 		A idobs

	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_9July.dta", replace 
	*** this is the "long" dataset where T1 and T2 are stacked 

* **********************************************************************
* 1 - food security variables (long)
* **********************************************************************

* looking at food security variables
* using long data set 			

* create variables to compare year and last 30 	
* non - binary variable: food_sec_year food_sec_last30		
	gen 		food_sec_comp_year30 = . 
	replace 	food_sec_comp_year30 = food_sec_year if period == 1
	replace 	food_sec_comp_year30 = food_sec_last30 if period == 2
	tab 		food_sec_comp_year30
	ranksum 	food_sec_comp_year30, by (period)
	*** not statistically different
	*** z =  -0.685, Prob > |z| =   0.4932

* create variables to compare covid and last 30
* non - binary variable: food_sec_covid food_sec_last30 
	gen 		food_sec_comp_covid30 = .
	replace 	food_sec_comp_covid30 = food_sec_covid if period == 1
	replace 	food_sec_comp_covid30 = food_sec_last30 if period == 2
	tab 		food_sec_comp_covid30
	ranksum 	food_sec_comp_covid30, by (period)
	***  statistically different
	*** z =   3.376, Prob > |z| =   0.0007
	ttest 		food_sec_comp_covid30, by (period) 
	*** just for comparsion - ranksum seems to be more correct in terms of data structure
	*** also statistically different 
	*** Pr(|T| > |t|) = 0.0008 

* repeat above comparisons but for bin variables 	
* create variables to compare covid and last 30
* binary variable: food_sec_covid_bin food_sec_last30_bin 
	gen 		food_sec_bin_comp_year30 = .
	replace 	food_sec_bin_comp_year30 = food_sec_year_bin if period == 1
	replace 	food_sec_bin_comp_year30 = food_sec_last30_bin if period == 2
	tab 		food_sec_bin_comp_year30
	ttest 		food_sec_bin_comp_year30, by (period)
	*** not statistically different
	*** Pr(|T| > |t|) = 0.3893 
	
* create variables to compare covid and last 30
* binary variable: food_sec_covid_bin food_sec_last30_bin  	
	gen 		food_sec_bin_comp_covid30 = .
	replace 	food_sec_bin_comp_covid30 = food_sec_covid_bin if period == 1
	replace 	food_sec_bin_comp_covid30 = food_sec_last30_bin if period == 2
	ttest 		food_sec_bin_comp_covid30, by (period)
	*** statistically different
	*** Pr(|T| > |t|) = 0.0002 
	*** mean covid = 0.259, mean last30 = 0.187

* non-respondents to these questions in all periods	
	count 		if food_sec_year_bin != . & food_sec_covid_bin != . & food_sec_last30_bin != .
	*** 43 did not respond to all three periods
	*** 1193 responded to all
	*** 1236 total observations 
	
* create non-respondent variable 
	gen 		non_respon_food_sec = 0 if food_sec_year_bin != . & food_sec_covid_bin != . & food_sec_last30_bin != .
	replace 	non_respon_food_sec = 0 if food_sec_year_bin != . & food_sec_covid_bin != . & period == 1
	replace 	non_respon_food_sec = 0 if food_sec_last30_bin != . & period == 2
	replace 	non_respon_food_sec = 1 if non_respon_food_sec == . 

* do non-respondents differ in food security outcomes
* examine binary variables
	ttest 		food_sec_bin_comp_year30, by (non_respon_food_sec)
	*** only 21 included in comparison 
	*** not statistically different 
	*** Pr(|T| > |t|) = 0.9041
	*ttest 		food_sec_bin_comp_covid30, by (non_respon_food_sec) 
	*** can't do other comparisons due to non-responses 

* save again	
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_9July.dta", replace 

* **********************************************************************
* 2 - food security variables (wide)
* **********************************************************************

* looking at food security variables
* using wide data set 

* recreate new dataset, leaving things wide
	clear
	import 		excel "C:\Users\aljosephson\Dropbox\COVID\UVM\data_clean_joinT1andT2_0617_deidentified.xlsx", sheet("data_clean_joinT1andT2_0617") firstrow
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_9July_wide.dta", replace
	*** this is the "wide" dataset where T1 and T2 are next to each other - like in Excel data  

* non-respondents to these questions in all periods	
	count 		if food_sec_year_bin_T1 != . & food_sec_covid_bin_T1 != . & food_sec_last30_bin_T2 != .
	*** 43 did not respond to all three periods
	*** 1193 responded to all
	*** 1236 total observations
	
* create variable to determine movement in status between year and covid 	
	gen 		food_sec_yearcov = 1 if food_sec_covid_bin_T1 == 1 & food_sec_year_bin_T1 == 0
	replace 	food_sec_yearcov = 0 if food_sec_covid_bin_T1 == 0 & food_sec_year_bin_T1 == 0
	replace 	food_sec_yearcov = 2 if food_sec_covid_bin_T1 == 1 & food_sec_year_bin_T1 == 1
	replace 	food_sec_yearcov = -1 if food_sec_covid_bin_T1 == 0 & food_sec_year_bin_T1 == 1
	label 		var food_sec_yearcov "-1 if become secure in covid, 0 if food secure both periods, 1 if become insecure in covid, 2 if always insecure"
	*** label ends up truncated, need to adjust

* create variable to determine movement in status between covid and last 30 	
	tab 		food_sec_covid_bin
	gen 		food_sec_cov30 = 1 if food_sec_last30_bin_T2 == 1 & food_sec_covid_bin_T1 == 0
	replace 	food_sec_cov30 = 0 if food_sec_last30_bin_T2 == 0 & food_sec_covid_bin_T1 == 0
	replace 	food_sec_cov30 = 2 if food_sec_last30_bin_T2 == 1 & food_sec_covid_bin_T1 == 1
	replace 	food_sec_cov30 = -1 if food_sec_last30_bin_T2 == 0 & food_sec_covid_bin_T1 == 1
	label 		var food_sec_cov30 "-1 if become secure in covid, 0 if food secure both periods, 1 if become insecure in covid, 2 if always insecure"
	*** label ends up truncated, need to adjust
	
	*** from analysis in this part, put into excel file `following_panel_analysis_alj-food_insecure', not many differences
	*** seem to be dropping from food secure folks (?)
	
* save again 
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_9July_wide.dta", replace

* **********************************************************************
* 3 - preliminary attrition analysis 
* **********************************************************************

* generate variable for attriters
* people who do not respond to all three 
	gen 		non_respon_food_sec = 0 if food_sec_year_bin_T1 != . & food_sec_covid_bin_T1 != . & food_sec_last30_bin_T2 != .
	replace 	non_respon_food_sec = 1 if non_respon_food_sec == .
	*** 43 did not respond to all three periods
	*** 1193 responded to all
	*** 1236 total observations 

* examine set of sociodemo variables 	
	tab 		ethnicity_T1
	tab 		year_born_T1
	tab 		gender_id_T1
	tab 		income_T1
	tab 		income_T2
	
* encode, adjust variables as necessary 
	encode 		gender_id_T1, generate (gender_id_encode)
	gen 		female = 1 if gender_id_encode == 2
	replace 	female = 0 if gender_id_encode != 2
	*** variable = 1 if female, 0 otherwise 
	tab 		ethnicity_T1
	gen 		white = 1 if ethnicity_T1 == 0
	replace 	white = 0 if ethnicity_T1 != 0
	*** variable = 1 if non-hispanic white, 0 otherwise 
	
* basic regs to test for attrition 	

* include female, white Hispanic, white race, year born, income, income change 
* something odd happens with income T2 - unsure - so just use T1 
	reg 		non_respon_food_sec female white year_born_T1 race_white_T1 income_T1 income_change_T2
	*** income_T1 and income_change_T2 have non-responses - so maybe not included in subsequent 
	*** some bias in attrition: female, white, year born
	*** female = 0.028 (0.013) - significant at 5 percent level - women are more likely to not respond to all three 
	*** white ethnicity = -0.080 (0.035) - significant at 5 percent level - Hispanics more likely to not respond to all three 
	*** year born = -0.001 (0.0003) - significant at 1 percent level - older folks more likely to not respond to all three 

* include female, white Hispanic, white race, year born, income 
	reg 		non_respon_food_sec female white year_born_T1 race_white_T1 income_T1 
	*** little change from above 
	*** some bias in attrition: female, white, year born
	*** female = 0.029 (0.013) - significant at 5 percent level - women are more likely to not respond to all three 
	*** white ethnicity = -0.071 (0.034) - significant at 5 percent level - Hispanics more likely to not respond to all three 
	*** year born = -0.002 (0.0003) - significant at 1 percent level - older folks more likely to not respond to all three 

* include female, white Hispanic, white race, year born
	reg 		non_respon_food_sec female white year_born_T1 race_white_T1 
	*** little change from above (magnitude but not conclusion) 
	*** some bias in attrition: female, white, year born
	*** female = 0.028 (0.013) - significant at 5 percent level - women are more likely to not respond to all three 
	*** white ethnicity = -0.062 (0.032) - significant at 10 (5.1) percent level - Hispanics more likely to not respond to all three 
	*** year born = -0.001 (0.0003) - significant at 1 percent level - older folks more likely to not respond to all three 

* save again 
	save 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_9July_wide.dta", replace

* **********************************************************************
* 3 - end matter
* **********************************************************************

* save new datasets as appropriate 
* should be saved above 

* close the log
	log	close

/* END */