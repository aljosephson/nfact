
**COVID-19 Consumer Survey**
**Preliminary Analysis***

**********************
*    DATA CLEANING   *
**********************


*Duration - Dropped if Response Time Less than 400 seconds* 
destring Durationinseconds, replace
summarize Durationinseconds
stem Durationinseconds
browse if Durationinseconds <400 

*Internal Consistency A.* 
*Creates variables that check for consitency between screener demographic questions and more detailed demographic questions* 

*Race
*NOTE: JHU Race Variables: Screener Section is Qs9;  Demographics Section is Q25 
*I AM NOT SURE IF SCREENING BASED ON CONSITENCY OF REPORTED RACE MAKES SENSE, CAN WE  DISCUSS THIS FURTHER?  

encode Qs9, generate(race_scr)
recode race_scr (1 = 1 "Asian") (2 =2 "Black or African American") (3= 3 "Native American") (4 = 4 "White") (5 = 5 "Other") (else = 6 "Mixed Race"), prefix(new_)

encode Q25, generate(race_demo)
recode race_demo (1=1 "American Indian Alaskan Native") (2=2 "Asian Indian") (3=3 "Black or African American") (4=4 "Chamorro") (5=5 "Chinese") (6=6 "Filipino") (7=7 "Japanese") (8=8 "Korean") (9=9 "Native Hawaiian") (10=10 "Samoan") (11=11 "Vietnameses") (12=12 "White") (13=13 "Other") (else = 14 "Mixed Race"), prefix(new_)



*INCOME - Screener vs. Demographics* 
*NOTE: JHU Income Variables: Screener Section is Qs11;  Demographics Section is Q27 
destring Qs11,replace
generate income_scr = Qs11 
label variable income_scr "Qs11 Income in Screener Section"
label define Income_Screener 1 "Less than $10,000"2 "$10,000-$24,999" 3 "$25,000-$49,999" 4 "$50,000-$74,999" 5 "$75,000-$99,999" 6 "$100,000 or more" 
label values income_scr Income_Screener 

destring Q27, replace 
generate income_demo = Q27
label variable income_demo "Q27 -Income in Demographic Section" 
label define Income_Demo 1 "Less than $10,000"2 "$10,000-$14,999" 3 "$15,000-$24,999" 4 "$25,000-$34,999" 5 "$35,000-$49,999" 6 "$50,000-$74,999" 7 "$75,000-$99,999" 8 "$100,000-$149,000" 9 "$150,000-$199,999" 10 "$200,000 or more" 
label values income_demo Income_Demo 

tab income_demo income_scr, m 

generate incomequality =. 
replace incomequality = 1 if income_scr==1 & income_demo==1  
replace incomequality = 2 if income_scr==2 & income_demo==2 | income_demo==3 
replace incomequality = 3 if income_scr==3 & income_demo==4 | income_demo==5 
replace incomequality = 4 if income_scr==4 & income_demo==6 
replace incomequality = 5 if income_scr==5 & income_demo==7 
replace incomequality = 6 if income_scr==6 & income_demo==8 | income_demo==9 | income_demo==10 
replace incomequality = 7 if income_scr==. | income_demo==. 
recode incomequality (1/6=1) (7=3) (.=2) 
label variable incomequality "Income Variables Data Quality Check" 
label define data_quality_match 1 "Matched" 2 "No-Match" 3 "Some Missing"
label values incomequality data_quality_match
tab incomequality
*Compare responses the do not match for screeer variables (incom_scr) vs. demographic variable (income_deom) to identify potential flags* 
*Make note of participant ID* 
sort income_scr 
browse if incomequality==2 
tab income_demo income_scr if incomequality==2

 
****AGE - Screener vs. Demographics***** 
*NOTE: JHU Income Variables: Screener Section is Qs6;  Demographics Section is Q22 

destring Qs6, replace 
generate age_scr = Qs6 
label variable age_scr "Qs6 Age Categories in Screener" 
label define Age_Scr 1 "< 18 yrs" 2" 18-34 yrs" 3 "35-54 yrs" 4 "55 yrs+" 
label values age_scr Age_Scr 

destring Q22, replace 
generate age = 2020 - Q22 
recode age (18/34=1)(35/54=2) (55/100=3), prefix(new_) 

tab age_scr new_age, m 

generate age_qualcheck =. 
replace age_qualcheck = 1 if age_scr==2 & new_age==1
replace age_qualcheck = 2 if age_scr==3 & new_age==2 
replace age_qualcheck = 3 if age_scr==4 & new_age==3
replace age_qualcheck = 4 if age_scr==1 & age <18 
replace age_qualcheck = 5 if age_scr==. | age==. 
recode age_qualcheck (1/3=1) (4 =2) (5=3) (.=4) 
label variable age_qualcheck "Age Data Quality Check" 
label define data_quality_match_age 1 "Matched" 2 "Under 18/Ineglbibe" 3 "Some Missing" 4 "No Match" 
label values age_qualcheck data_quality_match_age
tab age_qualcheck
*Compare responses the do not match for screeer variables (age_scr) vs. demographic variable (income_deom) to identify potential flags* 
*Make note of participant ID's* 
sort age 
browse if age_qualcheck== 4
tab age age_scr if age_qualcheck==4 



*Internal Consistency B.* 
***PROGRAM PARTICIPATION***
 
*Any Children in Household* 
*NOTE!!!: there seem to be two set of variables in the JHU data for household composition, not sure which one is correct. Will need to revisit. 




*Generate Flagging Variable*
*Create variable to identifies responses where any of the above inconsenticies are true, to flag for further examination* 
generate flag=.
replace flag =1 if Durationinseconds <400 |  incomequality==2 | age_qualcheck== 4 | program_qualcheck =X 
list ResponseId if flag ==1 
browse if flag ==1  

*Review Text Entries from Flagged Data Points for Random Absurd or Out of Context Text* 










******************************************************************
* RECODING KEY VARIABLES TO INDCIATED CHANGES PRE AND POST COVID *
******************************************************************

*Recode of Food Acquisition/Source Variables* 
**Note: "No Change" incicates use both in the year before and since COVID" 

generate source_groc_recode=. 
replace source_groc_recode=1 if source_groc== "1,2" 
replace source_groc_recode=2 if source_groc== "1"
replace source_groc_recode=3 if source_groc== "2"
replace source_groc_recode=4 if source_groc== "3"
label variable source_groc_recode "Source Grocery Recode"
label define Change  1 "No Change" 2 "Stopped Since COVID" 3 "Started Since COVID" 4 "Never Used" 
label values source_groc_recode Change

generate source_conv_recode=. 
replace source_conv_recode=1 if source_conv== "1,2" 
replace source_conv_recode=2 if source_conv== "1"
replace source_conv_recode=3 if source_conv== "2"
replace source_conv_recode=4 if source_conv== "3"
label variable source_conv_recode "Source Convienience Recode"
label values source_conv_recode Change

generate source_spec_recode=. 
replace source_spec_recode=1 if source_spec== "1,2" 
replace source_spec_recode=2 if source_spec== "1"
replace source_spec_recode=3 if source_spec== "2"
replace source_spec_recode=4 if source_spec== "3"
label variable source_spec_recode "Source Specialty Recode"
label values source_spec_recode Change

generate source_grocdel_recode=. 
replace source_grocdel_recode=1 if source_grocdel== "1,2" 
replace source_grocdel_recode=2 if source_grocdel== "1"
replace source_grocdel_recode=3 if source_grocdel== "2"
replace source_grocdel_recode=4 if source_grocdel== "3"
label variable source_grocdel_recode "Source Grocery Delivery Recode"
label values source_grocdel_recode Change

generate source_mealdel_recode=. 
replace source_mealdel_recode=1 if source_mealdel== "1,2" 
replace source_mealdel_recode=2 if source_mealdel== "1"
replace source_mealdel_recode=3 if source_mealdel== "2"
replace source_mealdel_recode=4 if source_mealdel== "3"
label variable source_mealdel_recode "Source Meal Kit Delivery Recode"
label values source_mealdel_recode Change

generate source_MoW_recode=. 
replace source_MoW_recode=1 if source_MoW== "1,2" 
replace source_MoW_recode=2 if source_MoW== "1"
replace source_MoW_recode=3 if source_MoW== "2"
replace source_MoW_recode=4 if source_MoW== "3"
label variable source_MoW_recode "Source Meals on Wheels Recode"
label values source_MoW_recode Change

generate source_restdel_recode=. 
replace source_restdel_recode=1 if source_restdel== "1,2" 
replace source_restdel_recode=2 if source_restdel== "1"
replace source_restdel_recode=3 if source_restdel== "2"
replace source_restdel_recode=4 if source_restdel== "3"
label variable source_restdel_recode "Source Resturant Delivery Recode"
label values source_restdel_recode Change

generate source_restin_recode=. 
replace source_restin_recode=1 if source_restin== "1,2" 
replace source_restin_recode=2 if source_restin== "1"
replace source_restin_recode=3 if source_restin== "2"
replace source_restin_recode=4 if source_restin== "3"
label variable source_restin_recode "Source Resturant Eat In Recode"
label values source_restin_recode Change

generate source_prog_recode=. 
replace source_prog_recode=1 if source_prog== "1,2" 
replace source_prog_recode=2 if source_prog== "1"
replace source_prog_recode=3 if source_prog== "2"
replace source_prog_recode=4 if source_prog== "3"
label variable source_prog_recode "Source Food Programs Recode"
label values source_prog_recode Change

generate source_group_recode=. 
replace source_group_recode=1 if source_group== "1,2" 
replace source_group_recode=2 if source_group== "1"
replace source_group_recode=3 if source_group== "2"
replace source_group_recode=4 if source_group== "3"
label variable source_group_recode "Source Congregate Recode"
label values source_group_recode Change

generate source_farmmkt_recode=. 
replace source_farmmkt_recode=1 if source_farmmkt== "1,2" 
replace source_farmmkt_recode=2 if source_farmmkt== "1"
replace source_farmmkt_recode=3 if source_farmmkt== "2"
replace source_farmmkt_recode=4 if source_farmmkt== "3"
label variable source_farmmkt_recode "Source Farm Market Recode"
label values source_farmmkt_recode Change

generate source_localfrm_recode=. 
replace source_localfrm_recode=1 if source_localfrm== "1,2" 
replace source_localfrm_recode=2 if source_localfrm== "1"
replace source_localfrm_recode=3 if source_localfrm== "2"
replace source_localfrm_recode=4 if source_localfrm== "3"
label variable source_localfrm_recode "Source CSA Recode"
label values source_localfrm_recode Change

generate source_garden_recode=. 
replace source_garden_recode=1 if source_garden== "1,2" 
replace source_garden_recode=2 if source_garden== "1"
replace source_garden_recode=3 if source_garden== "2"
replace source_garden_recode=4 if source_garden== "3"
label variable source_garden_recode "Source CSA Recode"
label values source_garden_recode Change

generate source_fish_recode=. 
replace source_fish_recode=1 if source_fish== "1,2" 
replace source_fish_recode=2 if source_fish== "1"
replace source_fish_recode=3 if source_fish== "2"
replace source_fish_recode=4 if source_fish== "3"
label variable source_fish_recode "Source Fish Recode"
label values source_fish_recode Change

generate source_hunt_recode=. 
replace source_hunt_recode=1 if source_hunt== "1,2" 
replace source_hunt_recode=2 if source_hunt== "1"
replace source_hunt_recode=3 if source_hunt== "2"
replace source_hunt_recode=4 if source_hunt== "3"
label variable source_hunt_recode "Source Fish Recode"
label values source_hunt_recode Change

generate source_forage_recode=. 
replace source_forage_recode=1 if source_forage== "1,2" 
replace source_forage_recode=2 if source_forage== "1"
replace source_forage_recode=3 if source_forage== "2"
replace source_forage_recode=4 if source_forage== "3"
label variable source_forage_recode "Source Forage Recode"
label values source_forage_recode Change



*Recode of Tranportation  Variables* *

generate trans_bus_recode=. 
replace trans_bus_recode=1 if trans_bus=="1,2" 
replace trans_bus_recode=2 if trans_bus=="1"
replace trans_bus_recode=3 if trans_bus=="2"
replace trans_bus_recode=4 if trans_bus=="3"
label variable trans_bus_recode "Transportation Bus Recode"
label values trans_bus_recode Change

generate trans_vehicle_recode=. 
replace trans_vehicle_recode=1 if trans_vehicle=="1,2" 
replace trans_vehicle_recode=2 if trans_vehicle=="1"
replace trans_vehicle_recode=3 if trans_vehicle=="2"
replace trans_vehicle_recode=4 if trans_vehicle=="3"
label variable trans_vehicle_recode "Transportation Own Vehicle Recode"
label values trans_vehicle_recode Change

generate trans_friend_recode=. 
replace trans_friend_recode=1 if trans_friend=="1,2" 
replace trans_friend_recode=2 if trans_friend=="1"
replace trans_friend_recode=3 if trans_friend=="2"
replace trans_friend_recode=4 if trans_friend=="3"
label variable trans_friend_recode "Transportation Friend/Family/Neighbor Recode"
label values trans_friend_recode Change

generate trans_taxi_recode=. 
replace trans_taxi_recode=1 if trans_taxi=="1,2" 
replace trans_taxi_recode=2 if trans_taxi=="1"
replace trans_taxi_recode=3 if trans_taxi=="2"
replace trans_taxi_recode=4 if trans_taxi=="3"
label variable trans_taxi_recode "Transportation Taxi/Lyft Recode"
label values trans_taxi_recode Change

generate trans_bringfood_recode=. 
replace trans_bringfood_recode=1 if trans_bringfood=="1,2" 
replace trans_bringfood_recode=2 if trans_bringfood=="1"
replace trans_bringfood_recode=3 if trans_bringfood=="2"
replace trans_bringfood_recode=4 if trans_bringfood=="3"
label variable trans_bringfood_recode "Transportation Someone Brings Food  Recode"
label values trans_bringfood_recode Change

generate trans_walk_recode=. 
replace trans_walk_recode=1 if trans_walk=="1,2" 
replace trans_walk_recode=2 if trans_walk=="1"
replace trans_walk_recode=3 if trans_walk=="2"
replace trans_walk_recode=4 if trans_walk=="3"
label variable trans_walk_recode "Transportation Walk/Bike Recode"
label values trans_walk_recode Change



****Recode Food Access Challenge Variables***

destring challenge_asmuch challenge_kinds challenge_findhelp challenge_moreplaces challenge_close challenge_reducgroc, replace
label define Challenge 1 "Never" 2 "Sometimes" 3 "Usually" 4 "Every Time" 88 "Not Applicable" 
label values challenge_asmuch Challenge 
label values challenge_kinds Challenge 
label values challenge_findhelp Challenge 
label values challenge_moreplaces Challenge 
label values challenge_close Challenge 
label values challenge_reducgroc Challenge 

generate challenge_asmuch_ever=.
replace challenge_asmuch_ever=1 if challenge_asmuch==1 
replace challenge_asmuch_ever=2 if challenge_asmuch==2| challenge_asmuch==3| challenge_asmuch==4 
label variable challenge_asmuch_ever "Not Finding As Much Food Ever"
label define NeverEver 1 "Never" 2 "Ever" 
label values challenge_asmuch_ever NeverEver

generate challenge_kinds_ever=.
replace challenge_kinds_ever=1 if challenge_kinds==1 
replace challenge_kinds_ever=2 if challenge_kinds==2| challenge_kinds==3| challenge_kinds==4 
label variable challenge_kinds_ever "Not Finding Kinds of Food Ever"
label values challenge_kinds_ever NeverEver

generate challenge_findhelp_ever=.
replace challenge_findhelp_ever=1 if challenge_findhelp==1 
replace challenge_findhelp_ever=2 if challenge_findhelp==2| challenge_findhelp==3| challenge_findhelp==4 
label variable challenge_findhelp_ever "Knowing Where to Find Help for Food"
label values challenge_findhelp_ever NeverEver

generate challenge_moreplaces_ever=.
replace challenge_moreplaces_ever=1 if challenge_moreplaces==1 
replace challenge_moreplaces_ever=2 if challenge_moreplaces==2| challenge_moreplaces==3| challenge_moreplaces==4 
label variable challenge_moreplaces_ever "Had to Go to More Places for Food"
label values challenge_moreplaces_ever NeverEver

generate challenge_close_ever=.
replace challenge_close_ever=1 if challenge_close==1 
replace challenge_close_ever=2 if challenge_close==2| challenge_close==3| challenge_close==4 
label variable challenge_close_ever "Had to Stand Too Close"
label values challenge_close_ever NeverEver

generate challenge_reducgroc_ever=.
replace challenge_reducgroc_ever=1 if challenge_reducgroc==1 
replace challenge_reducgroc_ever=2 if challenge_reducgroc==2| challenge_reducgroc==3| challenge_reducgroc==4 
label variable challenge_reducgroc_ever "Had to Stand Too Close"
label values challenge_reducgroc_ever NeverEver


****Recode Worries About Food Variables***

destring worry_enoughfood worry_countryfood worry_foodexp worry_foodunsafe worry_programs worry_income worry_housefood, replace 


***Recode Program Participation Variables*** 
generate prog_snap_recode=. 
replace prog_snap_recode=1 if prog_snap=="1,2" 
replace prog_snap_recode=2 if prog_snap=="1"
replace prog_snap_recode=3 if prog_snap=="2"
replace prog_snap_recode=4 if prog_snap=="3"
label variable prog_snap_recode "SNAP Participation"
label values prog_snap_recode Change

generate prog_wic_recode=. 
replace prog_wic_recode=1 if prog_wic=="1,2" 
replace prog_wic_recode=2 if prog_wic=="1"
replace prog_wic_recode=3 if prog_wic=="2"
replace prog_wic_recode=4 if prog_wic=="3"
label variable prog_wic_recode "WIC Participation"
label values prog_wic_recode Change

generate prog_school_recode=. 
replace prog_school_recode=1 if prog_school=="1,2" 
replace prog_school_recode=2 if prog_school=="1"
replace prog_school_recode=3 if prog_school=="2"
replace prog_school_recode=4 if prog_school=="3"
label variable prog_school_recode "School Foods Participation"
label values prog_school_recode Change

generate prog_pantry_recode=. 
replace prog_pantry_recode=1 if prog_pantry=="1,2" 
replace prog_pantry_recode=2 if prog_pantry=="1"
replace prog_pantry_recode=3 if prog_pantry=="2"
replace prog_pantry_recode=4 if prog_pantry=="3"
label variable prog_pantry_recode "Food Pantry Participation"
label values prog_pantry_recode Change


***Food Security***





***Recode Deomgraphic Variables***

*RACE* 

*AGE* 

*JOB STABILITY* 

*INCOME* 

*HOUSEHOLD COMPOSITION* 




