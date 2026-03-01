if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

forv i = 2000(1)2022{
	
	import delimited "$rdata/IPEDS/gr`i'_data_stata.csv", clear
	keep if grtype == 2 | grtype == 3 | grtype == 29 | grtype == 30
	cap rename grrace24 grtotlt
	
	keep unitid grtype grtotlt
	sort unitid grtype
	
	reshape wide grtotlt, i(unitid) j(grtype)
	
	gen c150_4 = grtotlt3 / grtotlt2 
	gen c150_2 = grtotlt30 / grtotlt29
	
	keep unitid c150_2 c150_4
	gen c150 = c150_4
	replace c150 = c150_2 if c150_4 == .
	replace c150 = (c150_2+c150_4)/2 if c150_4 != . & c150_2 !=.
	
	gen year = `i'
	order year unitid c150 c150_4 c150_2
	
	save "$wdata/IPEDS/graduation`i'.dta", replace
}
