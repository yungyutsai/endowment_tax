if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

use "$wdata/Form990/Form990.dta", clear

keep ein
duplicates drop

save "$wdata/all_ein.dta", replace

use "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/wdata/Form990/unitid_ein.dta", clear

keep ein
duplicates drop

ap using "$wdata/all_ein.dta"
save "$wdata/all_ein.dta", replace

duplicates drop
sort ein

export delim using "$wdata/all_ein.csv", replace
