if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

forv i = 2002(1)2022{
	
	import delimited "$rdata/IPEDS/ef`i'a.csv", clear
	
	cap rename efrace17 efnralt
	cap rename efrace18 efbkaat
	cap rename efrace19 efaiant
	cap rename efrace20 efaspit //Asian and Pacific Islander
	cap rename efrace21 efhispt
	cap rename efrace22 efwhitt
	cap rename efrace23 efunknt
	cap rename efrace24 eftotlt
	
	cap replace efbkaat = efrace18 if (efbkaat == . | efbkaat == 0) & (efrace18 ~= . & efrace18 ~= 0)
	cap replace efaiant = efrace19 if (efaiant == . | efaiant == 0) & (efrace19 ~= . & efrace19 ~= 0)
	cap replace efaspit = efrace20 if (efaspit == . | efaspit == 0) & (efrace20 ~= . & efrace20 ~= 0)
	cap replace efhispt = efrace21 if (efhispt == . | efhispt == 0) & (efrace21 ~= . & efrace21 ~= 0)
	cap replace efwhitt = efrace22 if (efwhitt == . | efwhitt == 0) & (efrace22 ~= . & efrace22 ~= 0)
	
	keep unitid section lstudy ef*t
	
	gen year = `i' //Use fall semester to define year
	order unitid year
		
	label variable unitid   "Unique identification number of the institution"
	label variable section  "Attendance status of student"
	label variable lstudy   "Level of student"
	label variable eftotlt  "Enrollment total"
	
	label define label_section 1 "Full-time"
	label define label_section 2 "Part-time",add
	label define label_section 3 "All students",add
	label values section label_section
	label define label_lstudy 1 "Undergraduate"
	label define label_lstudy 3 "Graduate",add
	label define label_lstudy 4 "All students",add
	label values lstudy label_lstudy
	
	keep if lstudy == 4
	keep if section == 1 | section == 2
	
	gen type = "ft" if section == 1
	replace type = "pt" if section == 2
	
	keep year unitid type ef*
	reshape wide ef*, i(year unitid) j(type) string
	
	foreach x in totl whit bkaa hisp asia nhpi aspi aian 2mor nral unkn{
		cap recode ef`x'tft . = 0
		cap recode ef`x'tpt . = 0
		cap rename ef`x'tft ft`x'
		cap rename ef`x'tpt pt`x'
		cap gen fte`x' = ft`x' + 1/3 * pt`x'
		cap gen tot`x' = ft`x' + pt`x'
	}
		
	save "$wdata/IPEDS/enroll_race`i'.dta", replace
}
