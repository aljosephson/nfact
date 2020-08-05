
**COVID-19 Consumer Survey**
*JHU QUALTRICS PANEL DATASET 8.1.20 

****************************
*    DATA QUALITY CHECKS   *
****************************

***NOTE DOWNLOAD DATA IN QUALTRICS AS NUMERIC***

*Keep if Qualtrics Identified at Good Completed Response* 
*Those with a gc value equal to 1 designate the Good Completes.
*Those with a gc value equal to 2 are Screen Out responses.
*Those with a gc value equal to 3 are Over Quota responses which are complete responses that came in after the Total sample size quota was filled.  
*Those with a gc value equal to 4 are those that have failed a quality check.
*Those that  don't have a gc value are either responses that were gathered previously, or responses in progress that never finished the survey on their own

destring gc, replace 
keep if gc==1 | gc==3

*Create Observation ID variable - to easily identify data point for potential removal* 
generate obs_Id= _n

*To Examine Additional Replacement Responses Provided After Initial Quality Check//*
*Exclude Responses in Dataset Obtained before a Specified Date* 
*In this case I only wanted to examine reponses collected on and after 7/27/20* 
split StartDate
keep if StartDate1 == "7/27/2020" | StartDate1 == "7/28/2020" | StartDate1 == "7/29/2020" | StartDate1 == "7/30/2020" 



***BEGIN DATA QUALITY CHECKS FOLLOWING GUIDANCE FROM AZ TEAM***

*Duration - Flagg if Response Time Less than 400 seconds* 
destring Durationinseconds, replace
summarize Durationinseconds
tab Durationinseconds if Durationinseconds <400 
browse if Durationinseconds <400 
tab obs_Id if Durationinseconds <400 
generate DurationFlag=.
replace DurationFlag =1 if Durationinseconds <400 


******Internal Consistency A.******
*Creates variables that check for consitency between screener demographic questions and more detailed demographic questions* 

*INCOME - Screener vs. Demographics*
*NOTE: JHU Income Variables in the Screener Section is Qs11, and in the Demographics Section is Q27 

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
tab incomequality
recode incomequality (1/6=1) (7=3) (.=2) 
label variable incomequality "Income Variables Data Quality Check" 
label define data_quality_match 1 "Matched" 2 "No-Match" 3 "Some Missing"
label values incomequality data_quality_match
*Compare responses the do not match for screeer variables (incom_scr) vs. demographic variable (income_deom) to identify potential flags* 
*Make note of participant ID* 
tab incomequality
tab income_demo income_scr if incomequality==2
browse if incomequality==2
tab obs_Id if incomequality==2


 
****AGE - Screener vs. Demographic***** 
*NOTE: JHU Income Variables: Screener Section is Qs6;  Demographics Section is Q22 

destring Qs6, replace  
generate age_scr = Qs6  
label variable age_scr "Qs6 Age Categories in Screener" 
recode age_scr (1=1 "< 18 yrs") (2= 2 " 18-34 yrs") (3=3 "35-54 yrs") (4= 4 "55 yrs+"), prefix (new_) 
codebook age_scr 

destring Q22, replace 
generate age = 2020 - Q22 
summarize age 
recode age (18/34=1)(35/54=2) (55/100=3), prefix(new_) 
browse if age <=1 | age >=100

tab new_age_scr new_age, m 

generate age_qualcheck =. 
replace age_qualcheck = 1 if new_age_scr==2 & new_age==1
replace age_qualcheck = 2 if new_age_scr==3 & new_age==2 
replace age_qualcheck = 3 if new_age_scr==4 & new_age==3
replace age_qualcheck = 4 if new_age_scr==1 & age <18 & age >0
replace age_qualcheck = 5 if new_age_scr==. | age==. 
recode age_qualcheck (1/3=1) (4 =2) (5=3) (.=4) 
label variable age_qualcheck "Age Data Quality Check" 
label define data_quality_match_age 1 "Matched" 2 "Under 18/Ineglbibe" 3 "Some Missing" 4 "No Match" 
label values age_qualcheck data_quality_match_age
tab age_qualcheck
*Compare responses the do not match for screeer variables (age_scr) vs. demographic variable (income_deom) to identify potential flags* 
*Make note of participant ID's* 
sort age 
browse if age_qualcheck== 4 
tab age new_age_scr if age_qualcheck==4 
*Excluded responsed who were 35 or 55 years old and indicated in screener that they were in the 18-34 or 35-54 age groups respectively 
browse if age_qualcheck== 4 & age !=35 & age!=55 
 
 
****RACE: Screener vs. Demographic***** 
*NOTE: JHU Race Variables: Screener Section is Qs9;  Demographics Section is Q25 
***IMPORTANT NOTE: THIS CODE NEEDS TO BE DONE USING THE DATA THAT WILL BE ANAYIZED BECAUSE THE ENCODE COMMAND CREATES NUMBERS BASED ON RESPONSES--
*THIS WILL NOT TRANSLATE UNIVERSALLY; 
*PAY ATTENTION TO HOW VARIABEL NUMBERED/LABLED WHEN USING ENCODE COMMAND; USE codebook COMMAND TO CHECK THIS TO ENSURE PROPER RECODING OF VARIBLE*  

*Code for 7.21.20 Data 
encode Qs9, generate(race_scr)
codebook race_scr, tabulate (25) 
recode race_scr (1 = 1 "Asian") (4 = 2 "Black or African American") (7 = 3 "Native American") (8 = 4 "White") (10 = 5 "Other") (else = 6 "Mixed Race"), prefix(new_)
tab new_race_scr 


encode Q25, generate(race_demo)
codebook race_demo, tabulate (50) 
recode race_demo (1=1 "American Indian Alaskan Native") (9=2 "Asian Indian") (11=3 "Black or African American") (14=4 "Chamorro") (15=5 "Chinese") (17=6 "Filipino") (19=7 "Japanese") (20=8 "Korean") (22=9 "Native Hawaiian") (30=10 "Samoan") (4=11 "Vietnameses") (6=12 "White") (8=13 "Other") (else = 14 "Mixed Race"), prefix(new_)
tab new_race_demo 

tab new_race_demo new_race_scr 

*Code for 8.1.20 Additional Respondent Data Only 
encode Qs9, generate(race_scr)
codebook race_scr, tabulate (25)
recode race_scr (1 =1 "Asian") (3 =2 "Black or African American") (6 = 3 "Native American") (7 = 4 "White") (8= 5 "Other") (else = 6 "Mixed Race"), prefix (new_)
tab new_race_scr 

encode Q25, generate(race_demo)
codebook race_demo, tabulate (50)
recode race_demo (1 =1 "American Indian/Alaskan Native") (3 = 10 "Samoan") (4 = 12 "White") (5 =13 "Other") (6 =2 "Asian Indian") (8=3 "Black of African American") (10=5 "Chinese") (11=6 "Filipino") (12=7 "Japanese") (13=8 "Korean") (else =14 "Mixed Race"), prefix(new_) 
tab new_race_demo


*Generate Quality Check Variable:  
*Asian in Screener and Asain Indian, Chamorro, Chinese, Filipino, Japanes, Korean, Native Hawiian, Samoan, or Vientames = 1  
*Black in Screener and Black = 2 
*Native American in screener and AI/AN, Chamorro, Native Hawwian, or Samoan = 3  
*White in Sceener and White = 4 
*Other in Screener and Other or Mixed Race = 5 
*Mixed Race in Screener and Mixed Race or Other =6 
*Missing values in screener or in demographic section = 7 

*Detailed Race 
generate racequality=. 
replace racequality=1 if new_race_scr==1 & new_race_demo==2 | new_race_demo==4| new_race_demo==5 | new_race_demo==6 | new_race_demo==7 | new_race_demo==8 | new_race_demo== 9 | new_race_demo== 10 |  new_race_demo== 11
replace racequality=2 if new_race_scr==2 & new_race_demo==3 
replace racequality=3 if new_race_scr==3 & new_race_demo==1 | new_race_demo==4 | new_race_demo== 9 | new_race_demo== 10 
replace racequality=4 if new_race_scr==4 & new_race_demo==12
replace racequality=5 if new_race_scr==5 & new_race_demo==13 | new_race_demo==14
replace racequality=6 if new_race_scr==6 & new_race_demo==14 | new_race_demo==13
replace racequality=7 if new_race_scr==.| new_race_scr==.
tab racequality, m 
recode racequality (1/6=1) (7=3) (.=2) 
label values racequality data_quality_match
label variable racequality "Race Variables Data Quality Check" 
browse if racequality==2


*Internal Consistency B.* 
***PROGRAM PARTICIPATION***
 
*Any Children in Household* 
*NOTE!!!: See Code Below on Variable Creation for Household Composition & Other Program Participation Variable Recodes 

*Browse data for observations with total household number greater than 10 
tab total_hh_num
browse if total_hh_num >10 

*Compare Household Composition to School Food Programs 
*Flag adult only households reporting participation in school foods 
tab hhcomposition, m 
tab obs_Id if hhcomposition !=1 & hhcomposition !=. & prog_school !="3" 
tab obs_Id if hhcomposition !=1 & hhcomposition !=. & prog_school_recode !=4 & prog_school_recode !=. 
generate schoolfood_qualcheck = 1 if hhcomposition !=1 & hhcomposition !=. & prog_school !="3" 

generate schoolfood_qualcheck2 =. 
replace schoolfood_qualcheck2 = 1 if hhcomposition !=1 & prog_school =="1"
replace schoolfood_qualcheck2 = 2 if hhcomposition !=1 & prog_school =="1,2"
replace schoolfood_qualcheck2 = 3 if hhcomposition !=1 & prog_school =="2"
label define schoolfood_qualcheck 1 "no children & pre covid school food participation" 2 "no children & pre/post covid school food participation" 3 "no children & post covid school food participation" 
label values schoolfood_qualcheck2 schoolfood_qualcheck
tab obs_Id if schoolfood_qualcheck2 !=.

*Compare Household Composition to WIC participation 
*Flag 65+ oonly hh reporting participation in WIC 
tab hhcomposition prog_wic, m 
tab hhcomposition prog_wic_recode 
generate seniorWIC_qualcheck = 1 if  hhcomposition ==3 & prog_wic !="3" 

generate seniorWIC_qualcheck2 = . 
replace seniorWIC_qualcheck2 = 1 if hhcomposition ==3 & prog_wic =="1" 
replace seniorWIC_qualcheck2 = 2 if hhcomposition ==3 & prog_wic =="1,2"
replace seniorWIC_qualcheck2 = 3 if hhcomposition ==3 & prog_wic =="2"
label define seniorWIC_qualcheck 1 "seniors only & pre covid WIC participation" 2 "seniors only & pre/post covid WIC participation" 3 "seniors only & post covid WIC participation" 
label values seniorWIC_qualcheck2 seniorWIC_qualcheck
tab obs_Id if seniorWIC_qualcheck2 !=.

browse if hhcomposition ==3 & ever_prog_wic ==1
tab obs_Id if hhcomposition ==3 & ever_prog_wic ==1


*If Male only adult household in WIC
*Note: See Code in Demogrphics Variables Below for Gender Variable
browse if gender==1 & total_hh_num==1 & ever_prog_wic ==1 & hhcomposition !=1 
tab obs_Id if gender==1 & total_hh_num==1 & ever_prog_wic ==1 & hhcomposition !=1 
generate singlemaleWIC_flag = 1 if gender==1 & total_hh_num==1 & ever_prog_wic ==1 & hhcomposition !=1 


****ABSURD TEXT & STRAIGHT LINE RESPONSE***
*Review Text Entries from Flagged Data Points for Random Absurd or Out of Context Text* visually inspect all responses for such cases
format  Q3atxt Q3btxt Q3ctxt Q3dtxt Q4txt_1_1 Q8txt Q9txt othertxt_1 othertxt_2 Q20txt %12s
browse  Q3atxt Q3btxt Q3ctxt Q3dtxt Q4txt_1_1 Q8txt Q9txt othertxt_1 othertxt_2 Q20txt


* Straight Line Responses*  
destring persp_flu persp_VT persp_US persp_me persp_econ persp_action persp_foodsource persp_prepared persp_packages persp_open_econ persp_foodsupply persp_strike, replace 
generate perception_straightline=. 
replace perception_straightline=1 if persp_flu==1 & persp_VT==1 & persp_US==1 & persp_me==1 & persp_econ==1 & persp_action==1 & persp_foodsource==1 &  persp_prepared==1 &  persp_packages==1 & persp_open_econ==1 & persp_foodsupply==1 & persp_strike==1
replace perception_straightline=2 if persp_flu==2 & persp_VT==2 & persp_US==2 & persp_me==2 & persp_econ==2 & persp_action==2 & persp_foodsource==2 &  persp_prepared==2 &  persp_packages==2 & persp_open_econ==2 & persp_foodsupply==2 & persp_strike==2
replace perception_straightline=3 if persp_flu==3 & persp_VT==3 & persp_US==3 & persp_me==3 & persp_econ==3 & persp_action==3 & persp_foodsource==3 &  persp_prepared==3 &  persp_packages==3 & persp_open_econ==3 & persp_foodsupply==3 & persp_strike==3
replace perception_straightline=4 if persp_flu==4 & persp_VT==4 & persp_US==4 & persp_me==4 & persp_econ==4 & persp_action==4 & persp_foodsource==4 &  persp_prepared==4 &  persp_packages==4 & persp_open_econ==4 & persp_foodsupply==4 & persp_strike==4
replace perception_straightline=5 if persp_flu==5 & persp_VT==5 & persp_US==5 & persp_me==5 & persp_econ==5 & persp_action==5 & persp_foodsource==5 &  persp_prepared==5 &  persp_packages==5 & persp_open_econ==5 & persp_foodsupply==5 & persp_strike==5
replace perception_straightline=6 if persp_flu==6 & persp_VT==6 & persp_US==6 & persp_me==6 & persp_econ==6 & persp_action==6 & persp_foodsource==6 &  persp_prepared==6 &  persp_packages==6 & persp_open_econ==6 & persp_foodsupply==6 & persp_strike==6
replace perception_straightline=7 if persp_flu==99 & persp_VT==99 & persp_US==99 & persp_me==99 & persp_econ==99 & persp_action==99 & persp_foodsource==99 &  persp_prepared==99 &  persp_packages==99 & persp_open_econ==99 & persp_foodsupply==99 & persp_strike==99
recode perception_straightline (1/7 = 1) (missing = 2)
label define straightline 1 "Flagged for Straight Line Response" 2 "Not Flagged" 
label values perception_straightline straightline
tab perception_straightline
browse if perception_straightline ==1 
tab obs_Id if perception_straightline ==1 



*****Examine Responses with Data Quality Flags*****
*Note: Absurd Text Entries Inspected Visually and not included in code below  

browse obs_Id ResponseId Durationinseconds if DurationFlag ==1
browse obs_Id ResponseId income_scr income_demo incomequality if incomequality==2
browse obs_Id ResponseId Qs6 Q22 age new_age_scr new_age age_qualcheck if age_qualcheck== 4 
browse obs_Id ResponseId Qs6 Q22 age new_age_scr new_age age_qualcheck if age <=1 | age >=100
browse obs_Id ResponseId  Qs9 Q9txt new_race_scr new_race_demo if racequality==2
browse obs_Id ResponseId age prog_school new_under5 new_5to17 new_18to65 new_65andolder total_hh_num hhcomposition if schoolfood_qualcheck1 == 1 
browse obs_Id ResponseId age prog_wic new_under5 new_5to17 new_18to65 new_65andolder total_hh_num hhcomposition if seniorWIC_qualcheck == 1
browse obs_Id ResponseId age prog_wic new_under5 new_5to17 new_18to65 new_65andolder total_hh_num hhcomposition if singlemaleWIC_flag == 1
browse obs_Id ResponseId persp_flu persp_VT persp_US persp_me persp_econ persp_action persp_foodsource persp_prepared persp_packages persp_open_econ persp_foodsupply persp_strike perception_straightline if perception_straightline ==1

*Create variable for to identify responses with any data quality flag 
*Note: Some reponses may have multiple quality flags so it will be useful inspect each quality check separately
generate AnyQualityFlag =. 
replace AnyQualityFlag = 1 if DurationFlag ==1
replace AnyQualityFlag = 2 if incomequality==2
replace AnyQualityFlag = 3 if age_qualcheck== 4 
replace AnyQualityFlag = 4 if age <=1 | age >=100
replace AnyQualityFlag = 5 if racequality==2
replace AnyQualityFlag = 6 if schoolfood_qualcheck == 1 
replace AnyQualityFlag = 7 if seniorWIC_qualcheck == 1
replace AnyQualityFlag = 8 if singlemaleWIC_flag == 1
replace AnyQualityFlag = 9 if perception_straightline ==1
label define AnyQualityFlag 1 "Duration < 400sec" 2 "Income Discordance" 3 "Age Discordance" 4 "Age Extreem" 5 "Race Discordance" 6 "School Foods" 7 "Senior WIC" 8 "Single Male WIC" 9 "Straight-Line Responses" 
label values AnyQualityFlag AnyQualityFlag
tab AnyQualityFlag



******************************************************************
* RECODING KEY VARIABLES TO INDCIATED CHANGES PRE AND POST COVID *
******************************************************************


*Recode of Food Acquisition/Source Variables* 
generate source_groc_recode=. 
replace source_groc_recode=1 if source_groc== "1,2" 
replace source_groc_recode=2 if source_groc== "1"
replace source_groc_recode=3 if source_groc== "2"
replace source_groc_recode=4 if source_groc== "3"
label variable source_groc_recode "Source Grocery Recode"
label define Change  1 "Used Before & During Covid" 2 "Stopped Since COVID" 3 "Started Since COVID" 4 "Never Used" 
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


*Ever v. Never Program Participation* 
generate ever_prog_snap=. 
replace ever_prog_snap=1 if prog_snap=="1" | prog_snap=="2" | prog_snap=="1,2"
replace ever_prog_snap=0 if prog_snap=="3"
label variable ever_prog_snap "SNAP Ever v. Never"
label define Ever  1 "Ever Used" 0 "Never Used" 
label values ever_prog_snap Ever

generate ever_prog_wic=. 
replace ever_prog_wic=1 if prog_wic=="1" | prog_wic=="2" | prog_wic=="1,2"
replace ever_prog_wic=0 if prog_wic=="3"
label variable ever_prog_wic "WIC Ever v. Never"
label define Ever  1 "Ever Used" 0 "Never Used" 
label values ever_prog_wic Ever

*Current Participation (Since COVID)* 
generate current_prog_snap=. 
replace current_prog_snap=1 if prog_snap=="2" | prog_snap=="1,2"
replace current_prog_snap=0 if prog_snap=="3" | prog_snap=="1"
label variable current_prog_snap "SNAP Current v. Non"
label define Current  1 "Current Use" 0 "Non-Use" 
label values current_prog_snap Current





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
label variable challenge_reducgroc_ever "Had to Reduce Grocerty Trips"
label values challenge_reducgroc_ever NeverEver


****Recode Worries About Food Variables***

destring worry_enoughfood worry_countryfood worry_foodexp worry_foodunsafe worry_programs worry_income worry_housefood, replace 



***Food Security***





***Recode Deomgraphic Variables***

*RACE/ETHNICITY* 
*use new_race_scr variable* 

*JOB STABILITY* 

*INCOME* 

*AGE* 
recode age (18/29 = 1 "18-29") (30/45 = 2 "30-45") (46/60 = 3 "46-60") (61/100 = 4 "61+"), generate (agecat) 

*GENDER* 
generate gender =. 
replace gender =1 if Qs7=="1" 
replace gender =2 if Qs7=="2"
replace gender =3 if Qs7=="3" | Qs7=="1,3" 
replace gender =4 if Qs7=="4" 
replace gender =5 if Qs7=="5" 
label define Gender 1"Male" 2"Female" 3"Transgender" 4"Non-Binary" 5"Self-Describe"  
label values gender Gender 


*HOUSEHOLD COMPOSITION* 
*Note: the JHU data has two variables for household composition. New hh composition variable was created combining these data  


*create new combined variable for under 5 age group 
generate new_under5 = num_people_under5 + HR
destring new_under5, replace 

*convert string variables to numeric and create a new variable for 5-17 age group 
destring num_people_517 num_people_511  num_people_1217, replace 
egen new_5to17 = rowtotal(num_people_517 num_people_511  num_people_1217)

*convert string variables to numeric and create a new variable for 18-65 age group 
destring HU num_people_1865, replace 
egen new_18to65 = rowtotal(HU num_people_1865) 

*convert string variables to numeric and create a new variable for 65+ age group 
destring HV num_people_65up, replace 
egen new_65andolder = rowtotal(HV num_people_65up) 

*Create New Variable for Total Householde Number 
egen total_hh_num = rowtotal(new_under5 new_5to17 new_18to65 new_65andolder)
tab total_hh_num 

*Create New Household Composition Variable 
generate hhcomposition=. 
replace hhcomposition=1 if new_under5 >=1  | new_5to17 >=1 
replace hhcomposition=2 if new_18to65 >=1  & new_under5 <1 & new_5to17 <1 & new_65andolder <1 
replace hhcomposition=3 if new_65andolder >=1 & new_under5 <1 & new_5to17 <1 & new_18to65 <1 
replace hhcomposition=4 if new_18to65 >=1 & new_65andolder >=1 & new_under5 <1 & new_5to17 <1 
label variable hhcomposition "General Household Composition" 
label define hhcomposition_general 1 "any children" 2 "adults 18-65 only" 3 "65+ seniors only" 4 "adults only 18-65 and 65+" 
label values hhcomposition hhcomposition_general
