* Project: AZ 
* Created on: July 2020
* Created by: alj
* Stata v.16

* does
	* shows dummy code

* assumes
	* standard - Stata v.16
	
* TO DO:
	* adjust directiories for universal use 
		*** define paths below 
	* settle on log location - data file location
		*** dropbox?
		*** google drive? 

* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	* loc root 	 = "$data/household_data/tanzania/wave_2/raw"
	* loc export = "$data/household_data/tanzania/wave_2/refined"
	* loc logout = "$data/household_data/tanzania/logs"

* open log
	cap 		log close
	*log 		using 	update location, append

* **********************************************************************
* 1 - 
* **********************************************************************

* import partial data set	
* from excel

	import 		excel "C:\Users\aljosephson\Dropbox\COVID\COVID AZ Analysis and Briefs\Data\Incomplete data (for cleaning purposes)\AZ Temporary Dataset (7_2_20).xlsx", sheet("Sheet0") firstrow
	*** going to have issues with this naming convention
	*** for stata - no spaces in names
	drop 		in 1	
	*** weird file issue here where first row imported twice 
	
* **********************************************************************
* 3 - end matter
* **********************************************************************

* prepare for export
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