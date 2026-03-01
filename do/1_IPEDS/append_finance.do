if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
	global figure "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/figure"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

clear

forv i = 2004(1)2022{
	ap using "$wdata/IPEDS/finance`i'.dta", force
}

forv i = 2004(1)2022{
	merge 1:1 year unitid using "$wdata/IPEDS/fy`i'.dta", update
	drop if _m == 2
	drop _m
}

gen fybegyr = mod(fybeg,10000)
replace fybegyr = year if fybeg == -1 | fybeg == -2
gen fyendyr = mod(fyend,10000)
replace fyendyr = year + 1 if fyend == -1 | fyend == -2
gen fybegm = floor(fybeg/10000)
replace fybegm = 7 if fybegm == -1
gen fyendm = floor(fyend/10000)
replace fyendm = 6 if fyendm == -1

gen fyleng = ym(fyendyr,fyendm) - ym(fybegyr,fybegm) + 1

gen year2 = fybegyr if fybegyr != .
replace year2 = year if year2 == .
gen priority = fyleng == 12

gsort unitid year2 -priority -year

duplicates drop unitid year2, force

replace year = year2 //only 0.15% of cases made this revision
drop year2

save "$wdata/IPEDS/finance_all.dta", replace
