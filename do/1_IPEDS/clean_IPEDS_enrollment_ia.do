if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

forv i = 2003(1)2023{
	// data 2023 = July 1 2022 - June 30, 2023
	import delimited "$rdata/IPEDS/efia`i'.csv", clear
	
	keep unitid cdactua cdactga
	loc j = `i' - 1
	gen year = `j' //Use fall semester to define year
	order unitid year
		
	label variable unitid   "Unique identification number of the institution"
	label variable cdactua  "12-month instructional activity credit hours: undergraduates"
	label variable cdactga	"12-month instructional activity credit hours: graduates"
	
	recode cdactua . = 0 
	recode cdactga . = 0 
	gen cdact = cdactua + cdactga
	
	label variable cdactga	"12-month instructional activity credit hours: undergraduates + graduates"

	save "$wdata/IPEDS/enroll_ia`j'.dta", replace
	
}
