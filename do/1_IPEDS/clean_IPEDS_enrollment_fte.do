if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

forv i = 2003(1)2023{
	
	import delimited "$rdata/IPEDS/effy`i'.csv", clear
	
	cap rename fyrace24 efytot
	cap rename efytotlt efytot

	keep unitid effylev efytot
	gen year = `i' //Use fall semester to define year
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
	recode effylev 3=4
	collapse (sum)efytot, by(effylev year unitid)
	keep year unitid effylev efytot
	
	keep if inrange(effylev,1,4)
	reshape wide efytot, i(year unitid) j(effylev)
	
	foreach j in 1 2 4{
		rename efytot`j' enrollfy`j'
	}
	
	rename enrollfy1 enrollfy
	rename enrollfy2 enrollfyu
	rename enrollfy4 enrollfyg
	
	label variable enrollfy "Unduplicated Head Count of Students Enrollment"
	label variable enrollfyu "Unduplicated Head Count of Undergraduate Students Enrollment"
	label variable enrollfyg "Unduplicated Head Count of Graduate Students Enrollment"
	
	order unitid year enrollfy enrollfyu enrollfyg
	
	foreach x in enrollfy enrollfyu enrollfyg{
		recode `x' . = 0
	}
	
	save "$wdata/IPEDS/enrollfy`i'.dta", replace	
}
