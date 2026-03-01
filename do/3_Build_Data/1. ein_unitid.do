if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

import delimited "$rdata/Form990/Urban Institute/colleges_nccs_all.csv", clear varn(1)

keep unitid ein year
drop if year < 2010

duplicates tag unitid ein, gen(dup)
gsort unitid -dup -year
duplicates drop unitid, force

gsort ein -dup -year
duplicates drop unitid, force

keep unitid ein
save "$wdata/unitid_ein.dta", replace

import excel using "$rdata/Form990/Paper_Form_990.xlsx", sheet(unit_ein_updated) clear first

keep unitid ein
ap using "$wdata/unitid_ein.dta"

sort unitid
format unitid ein %15.0f
duplicates drop
save "$wdata/unitid_ein.dta", replace
