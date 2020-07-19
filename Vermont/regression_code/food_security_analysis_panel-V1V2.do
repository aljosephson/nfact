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
	log 		using 	"C:\Users\aljosephson\Dropbox\COVID\UVM/13July_foodsecreg", append

* **********************************************************************
* 1 - 
* **********************************************************************

* looking at food security variables
* using long data set 		

use 		"C:\Users\aljosephson\Dropbox\COVID\UVM\UVM_10July_wide.dta", clear 
	*** this is the "wide" dataset 
	
* **********************************************************************
* 3 - end matter
* **********************************************************************

* save new datasets as appropriate 
* should be saved above 

* close the log
	log	close

/* END */