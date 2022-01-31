//data cleaning
**base file with suspension incidents
	clear
	import delimited "/Users/lacm/Documents/Stanford/SOC 381/Project/EducationDataPortal_11.01.2021_schools.csv", delimiter(comma) bindquote(strict) 
	drop state_name 
	drop year 
	drop if school_name =="Kimmel Alternative School"
	keep if school_type =="Regular school" | school_type =="Vocational school"
	replace charter = "1" if charter  =="Yes"
	replace charter = "0" if charter =="No"
	replace magnet = "1" if magnet =="Yes"
	replace magnet = "0" if magnet =="No"
	destring charter magnet ,force replace
	replace school_level = "" if school_level =="Missing/not reported"
	replace school_level ="300" if school_level =="Other"
	replace school_level ="200" if school_level =="High" | school_level =="Secondary"
	replace school_level ="100" if school_level =="Middle" |school_level =="Primary"
	drop if school_level =="Prekindergarten"
	destring school_level ,force replace
	label define school_level 100 "Elementary" 200 "High School" 300 "K-12"
	label values school_level school_level  
	drop if enrollment ==0
	gen pct_free_lunch = free_lunch /enrollment *100 if !mi(free_lunch)
	gen pct_rp_lunch = reduced_price_lunch/ enrollment*100 if !mi(reduced_price_lunch)
	gen frp_lunch =free_lunch + reduced_price_lunch
	gen pct_frp_lunch = frp_lunch /enrollment *100 if !mi(frp_lunch)
	destring students_susp_in_sch students_susp_out_sch_single students_susp_out_sch_multiple, force replace
	drop students_susp_in_sch
	gen students_oos_suspension = students_susp_out_sch_single + students_susp_out_sch_multiple
	gen pct_students_oos_suspension = students_oos_suspension /enrollment *100 if !mi(students_oos_suspension)
	drop students_susp_out_sch_multiple students_susp_out_sch_single firearm_incident_ind 
	replace suspensions_instances = . if suspensions_instances ==-2
	gen suspension_rate = suspensions_instances /enrollment*100 if !mi(suspensions_instances)
	replace robbery_w_firearm_incidents = . if robbery_w_firearm_incidents ==-3
	replace attack_w_firearm_incidents = . if attack_w_firearm_incidents ==-3
	replace attack_no_weapon_incidents =. if attack_no_weapon_incidents ==-3
	replace possession_firearm_incidents = . if possession_firearm_incidents ==-3
	gen num_incidents = homicide_ind +rape_incidents +sexual_battery_incidents+robbery_w_weapon_incidents + robbery_w_firearm_incidents + robbery_no_weapon_incidents + attack_w_weapon_incidents + attack_w_firearm_incidents + attack_no_weapon_incidents + threats_w_weapon_incidents + threats_w_firearm_incidents
	gen incident_rate = num_incidents /enrollment *100 if !mi(num_incidents)
	gen counselors_per_student = counselors_fte/enrollment *100 if !mi(counselors_fte)
	gen socialworkers_per_student = social_workers_fte /enrollment *100 if !mi(social_workers_fte)
	gen student_suspension_rate = students_oos_suspension /enrollment *100 if !mi(students_oos_suspension)
	xtile counselor_quartile=counselors_per_student ,n(4)
	gen enrollment_by_1000 = enrollment /1000
	order ncessch school_name lea_name school_level school_type charter magnet enrollment free_lunch pct_free_lunch reduced_price_lunch pct_rp_lunch frp_lunch pct_frp_lunch students_oos_suspension student_suspension_rate suspensions_instances students_oos_suspension homicide_ind rape_incidents sexual_battery_incidents robbery_w_weapon_incidents robbery_w_firearm_incidents robbery_no_weapon_incidents attack_w_weapon_incidents attack_w_firearm_incidents attack_no_weapon_incidents threats_w_weapon_incidents threats_w_firearm_incidents threats_no_weapon_incidents possession_firearm_incidents num_incidents incident_rate counselors_fte counselors_per_student social_workers_fte socialworkers_per_student
	tempfile base
	save `base'


**race data
	clear
	import delimited "/Users/lacm/Documents/Stanford/SOC 381/Project/EducationDataPortal_11.14.2021_race.csv", delimiter(comma) bindquote(strict) varnames(1) 
	drop state_name  year school_name
	replace race = lower(race)
	replace race = subinstr(race, " ","_",.)
	keep if race == "black" | race == "hispanic" |race =="total" | race =="white"
	reshape wide enrollment ,i(ncessch ) j(race)s
	gen pct_black = enrollmentblack /enrollmenttotal *100
	gen pct_hispanic = enrollmenthispanic /enrollmenttotal *100
	gen pct_white = enrollmentwhite /enrollmenttotal *100
	replace pct_black =0 if enrollmentblack ==0
	replace pct_hispanic =0 if enrollmenthispanic ==0
	replace pct_white =0 if enrollmentwhite ==0
	drop if enrollmenttotal ==0
	drop enrollmentblack enrollmenthispanic enrollmenttotal 


**merging suspension with race
	merge 1:1 ncessch using `base'
	keep if _merge ==3
	drop _merge
	tempfile base2
	save `base2'

**virtual school data
	clear
	import delimited "/Users/lacm/Documents/Stanford/SOC 381/Project/virtual school data.csv", delimiter(comma) bindquote(strict) varnames(1) 
	keep ncessch virtual 

**merging all 3 datasets and saving
	merge 1:1 ncessch using `base2'
	keep if virtual =="No"
	drop virtual
	keep if _merge ==3
	drop _merge
	order ncessch school_name lea_name school_type school_level charter magnet suspension_rate counselors_per_student counselor_quartile pct_black pct_hispanic pct_white pct_frp_lunch
	save "/Users/lacm/Documents/Stanford/SOC 381/Project/Project Dataset.dta", replace
