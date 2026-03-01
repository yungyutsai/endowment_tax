if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}


forv i = 2000(1)2003{
	loc j = `i' + 1
	loc x = substr("`i'",-2,2)
	loc y = substr("`j'",-2,2)
	loc z = "`x'" + "`y'"
	
	import delimited "$rdata/IPEDS/f`z'_f1a.csv", clear
	
	cap gen endowmentboy_IPEDS = f1h01
	cap gen endowmenteoy_IPEDS = f1h02
	
	cap lab var endowmentboy_IPEDS "Value of endowment assets at the beginning of the fiscal year"
	cap lab var endowmenteoy_IPEDS "Value of endowment assets at the end of the fiscal year"
	
	gen year = `i' //Use the start year to define year
	order year 
	cap drop f1* 
	cap drop xf*
	
	save "$wdata/IPEDS/finance`i'_public.dta", replace //Use the start year to define year
}

