if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

clear
forv i = 2010(1)2022{
	ap using "$wdata/IPEDS/head`i'.dta", force
}

keep if control == 2 //keep nonprofit college

egen count = count(year), by(unitid)
keep if count == 13
drop count

gen matchedfd = 0 //Finance Data
gen matchedenroll = 0 //Enrollment
gen matchedracial = 0 //Racial Composition
gen matchedenrollfy = 0 //Enrollment Full Year
gen matchedracialfy = 0 //Racial Composition Full Year
gen matchedenrollia = 0 //Enrollment Credit Hour
gen matchedfa = 0 //Financial Aids
gen matchedch = 0 //Charge
gen matchedad = 0 //Admission
gen matchedgr = 0 //Graduation

merge 1:1 year unitid using "$wdata/IPEDS/finance_all.dta"
drop if _m == 2
replace matchedfd = 1 if _m >= 3
drop _m

egen count = sum(matchedfd), by(unitid)
keep if count == 13
tab year
drop count

forv i = 2010(1)2022{
	merge 1:1 year unitid using "$wdata/IPEDS/enroll`i'.dta", update
	drop if _m == 2
	replace matchedenroll = 1 if _m >= 3
	drop _m
	merge 1:1 year unitid using "$wdata/IPEDS/enroll_race`i'.dta", update
	drop if _m == 2
	replace matchedracial = 1 if _m >= 3
	drop _m
}

egen count = sum(matchedenroll), by(unitid)
keep if count == 13
tab year
drop count
egen count = sum(matchedracial), by(unitid)
keep if count == 13
tab year
drop count

forv i = 2010(1)2022{
	merge 1:1 year unitid using "$wdata/IPEDS/enrollfy`i'.dta", update
	drop if _m == 2
	replace matchedenrollfy = 1 if _m >= 3
	drop _m
	
	merge 1:1 year unitid using "$wdata/IPEDS/enrollfy_race`i'.dta", update
	drop if _m == 2
	replace matchedracialfy = 1 if _m >= 3
	drop _m
	
	merge 1:1 year unitid using "$wdata/IPEDS/enroll_ia`i'.dta", update
	drop if _m == 2
	replace matchedenrollia = 1 if _m >= 3
	drop _m
}

egen count = sum(matchedenrollfy), by(unitid)
keep if count == 13
drop count
tab year


forv i = 2010(1)2022{
	merge 1:1 year unitid using "$wdata/IPEDS/charge`i'.dta", update
	drop if _m == 2
	replace matchedch = 1 if _m >= 3
	drop _m
}

egen count = sum(matchedch), by(unitid)
keep if count == 13
drop count
tab year

forv i = 2010(1)2022{
	merge 1:1 year unitid using "$wdata/IPEDS/sfa`i'.dta", update replace
	drop if _m == 2
	replace matchedfa = 1 if _m >= 3
	drop _m
}

egen count = sum(matchedfa), by(unitid)
//keep if count == 13
drop count
tab year

sort unitid year

order unitid instnm year fybegyr fyendyr fybegm fyendm city stabbr zip fips carnegie iclevel hloffer ugoffer groffer deggrant hbcu hospital medical tribal locale obereg enroll* efte* fte* efy* *_IPEDS tuition* fee3 hrchg3 fee7 hrchg7 chg3ay3 chg5ay3 uag* upg* ufl* anyaid* fgrnt* sgrnt* igrnt* loan* priinc* npist2

keep unitid instnm year fybegyr fyendyr fybegm fyendm city stabbr zip fips carnegie iclevel hloffer ugoffer groffer deggrant hbcu hospital medical tribal locale obereg enroll* efte* fte* efy* *_IPEDS tuition* fee3 hrchg3 fee7 hrchg7 chg3ay3 chg5ay3 uag* upg* ufl* anyaid* fgrnt* sgrnt* igrnt* loan* priinc* npist2

save "$wdata/IPEDS_2010to2022_panel.dta", replace
