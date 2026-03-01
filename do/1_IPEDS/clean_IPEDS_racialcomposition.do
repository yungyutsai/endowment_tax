if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}


use "$wdata/IPEDS/IPEDS_Merged_All_Imputed.dta", clear

** Calculate composition (make % sum up as 100%)
foreach var in ft pt fte{
	dis "Adjust for `var'..."
	replace `var'totl = `var'whit + `var'bkaa + `var'hisp + `var'asia +  `var'nhpi + `var'aian + `var'2mor  + `var'unkn + `var'nral
	foreach category in whit bkaa hisp asia nhpi aian 2mor nral{
		dis "--Calculate proportion for `category'..."
		gen prop`var'`category' = `var'`category' / `var'totl
	}
}

keep unitid year prop*

compress

save "$wdata/IPEDS/enroll_racial_prop.dta", replace
