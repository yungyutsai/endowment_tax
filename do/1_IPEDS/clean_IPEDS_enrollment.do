if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

forv i = 2000(1)2022{
	
	import delimited "$rdata/IPEDS/ef`i'a.csv", clear
	
	cap rename efrace24 eftotlt
	cap gen eftotlt = efrace15 + efrace16
	keep unitid section lstudy eftotlt line
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
	
	keep if lstudy == 1 | lstudy == 2 | lstudy == 3 | lstudy == 4
	keep if section == 1 | section == 2
	
	keep if line == 8 | line == 9 | line == 11 | line == 14 | ///
			line == 22 | line == 23 | line == 25 | line == 28
	
	gen type = ""
	replace type = "ft" if section == 1 & lstudy == 4
	replace type = "pt" if section == 2 & lstudy == 4
	replace type = "uft" if section == 1 & lstudy == 1
	replace type = "upt" if section == 2 & lstudy == 1
	replace type = "gft" if section == 1 & (lstudy == 2 | lstudy == 3)
	replace type = "gpt" if section == 2 & (lstudy == 2 | lstudy == 3)
	
	recode eftotlt . = 0
	collapse (sum)eftotlt, by(type year unitid)
	keep year unitid type eftotlt
	drop if type == ""
	reshape wide eftotlt, i(year unitid) j(type) string
	
	foreach x in ft pt uft upt gft gpt{
		rename eftotlt`x' enroll`x'
	}
	
	foreach x in ft pt uft upt gft gpt{
		recode enroll`x' . = 0
	}
	
	foreach x in "" "u" "g"{
		gen enroll`x'fte = enroll`x'ft + 1/3 * enroll`x'pt
	}
	
	label variable enrollfte "Total enrollment of full-time equivalent (FTE) students"
	
	order unitid year enrollft enrolluft enrollgft enrollpt enrollupt enrolluft enrollfte enrollufte enrollgfte
	save "$wdata/IPEDS/enroll`i'.dta", replace
	
}

use "$wdata/IPEDS/enroll2009.dta", clear
keep unitid enrollfte
rename enrollfte enrollfte2009

save "$wdata/IPEDS/enroll2009_2.dta", replace
