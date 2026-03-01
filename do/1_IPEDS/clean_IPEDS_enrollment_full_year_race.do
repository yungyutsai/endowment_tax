if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

forv i = 2003(1)2023{
	//2023 data = July 1, 2022 - June 30, 2023
	
	import delimited "$rdata/IPEDS/effy`i'.csv", clear
	
	cap rename fyrace17 efynralt
	cap rename fyrace18 efybkaat
	cap rename fyrace19 efyaiant
	cap rename fyrace20 efyasiat
	cap rename fyrace21 efyhispt
	cap rename fyrace22 efywhitt
	cap rename fyrace23 efyunknt
	cap rename fyrace24 efytotlt
		
	cap replace efybkaat = fyrace18 if (efybkaat == . | efybkaat == 0) & (fyrace18 ~= . & fyrace18 ~= 0)
	cap replace efaiant = fyrace19 if (efyaiant == . | efyaiant == 0) & (fyrace19 ~= . & fyrace19 ~= 0)
	cap replace efaspit = fyrace20 if (efyaspit == . | efyaspit == 0) & (fyrace20 ~= . & fyrace20 ~= 0)
	cap replace efhispt = fyrace21 if (efyhispt == . | efyhispt == 0) & (fyrace21 ~= . & fyrace21 ~= 0)
	cap replace efwhitt = fyrace22 if (efywhitt == . | efywhitt == 0) & (fyrace22 ~= . & fyrace22 ~= 0)
	
	keep unitid effylev efy*t
	loc j = `i'-1
	gen year = `j' //Use fall semester to define year
	order unitid year
		
	label variable unitid   "Unique identification number of the institution"
	label variable effylev   "Level of student"
	label variable efytot  "Enrollment total"
	
	label define label_effylev 1 "All students total" 
	label define label_effylev 2 "Undergraduate", add 
	label define label_effylev 3 "First professional", add 
	label define label_effylev 4 "Graduate", add 
	label values effylev label_effylev
	
	recode efytot . = 0
	keep if effylev == 1 //All students
	collapse (sum)ef*, by(year unitid)
	
	save "$wdata/IPEDS/enrollfy_race`j'.dta", replace	
}
