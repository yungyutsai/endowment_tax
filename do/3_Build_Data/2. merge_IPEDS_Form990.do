if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

use "$wdata/IPEDS_2010to2022_panel.dta", clear
merge m:1 unitid using "$wdata/unitid_ein.dta"
drop if _m == 2
drop _m

merge m:1 year ein using "$wdata/Form990_2009to2022_full.dta"
drop if _m == 2
gen form990 = _m == 3
drop _m
egen count990 = sum(form990), by(unitid)

** College merged and expanded
drop if unitid == 173957 //Mayo Clinic Alix School of Medicine: expanded its four-year medical school class to the Mayo Clinic Arizona campus in 2017
drop if unitid == 216366 //Thomas Jefferson University: combined with Philadelphia University in 2017
drop if unitid == 129428 //Rensselaer at Hartford: the distance learning center in Groton, Connecticut, the latter of which was closed in 2018; changed name from Rensselaer Hartford Graduate Center Inc -> Rensselaer at Hartford
drop if unitid == 221999 //Vanderbilt University: opened a new innovation center, the Wond'ry, as part of its Academic Strategic Plan in 2015
drop if unitid == 233842 //Union Presbyterian Seminary: open new campus in 2012

** U.S. Territories and Freely Associated
//drop if obereg == 9

** College with no tuition
drop if unitid == 156295 //Berea College (exempt from tax becasue no tuition)
drop if unitid == 178697 //College of the Ozarks 
drop if unitid == 211893 //Curtis Institute of Music
drop if unitid == 199865 //Warren Wilson College
drop if unitid == 197221 //Webb Institute

compress

gen endowmenteoy = endowmenteoy_IPEDS

save "$wdata/IPEDS_Form990_2010to2022.dta", replace
