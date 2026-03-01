if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
	global figure "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/content/figures"
	global table "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/table"
	global tex "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/content/tables"
	global do "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/do"
	adopath + "$do/ado"
}
graph set eps fontface Times

use "$wdata/endowment_tax_main_sample.dta", clear

cap rm "$table/Fig4.xls"
cap rm "$table/Fig4.txt"

foreach y in enrollfte{
	
	reghdfe ln`y' LargeWealthy20*, a(large#year wealthy#year unitid) cl(unitid)
	outreg2 using "$table/Fig4.xls", append dec(3) nocon
	
}

keep if large == 1

foreach y in enrollfte{
	
	reghdfe ln`y' LargeWealthy20*, a(year unitid) cl(unitid)
	outreg2 using "$table/Fig4.xls", append dec(3) nocon
	
}


import delimited using "$table/Fig4.txt",clear

rename v2 lnDDD
rename v3 lnDD


keep in 4/27
gen year = 2009+ceil(_n/2)
replace year = year + 1 if year >= 2016
set obs 26
recode year . = 2016

drop v1

gen type = "b" if mod(_n,2)==1
replace type = "se" if mod(_n,2)==0

reshape long ln, i(year type) j(var) string

reshape wide ln, i(year var) j(type) string

rename lnb b
rename lnse se

replace b = subinstr(b,"*","",.)
replace se = subinstr(se,"(","",.)
replace se = subinstr(se,")","",.)

destring b se, replace

recode b . = 0
recode se . = 0
gen upper = b + 1.96 * se
gen lower = b - 1.96 * se

twoway 	(connect b year if var == "DD", color(black)) ///
		(rspike upper lower year if var == "DD", color(black)), ///
		legend(off) ///
		ylabel(, angle(0) format(%4.2f)) ///
		ytitle(Estimated Effect) ///
		scheme(s1color) yline(0, lc(black)) xline(2016.5, lc(black)) ///
		xlabel(2010(1)2022) xtitle(Year)
graph export "$figure/Fig4_DD.jpg", as(jpg) replace


twoway 	(connect b year if var == "DDD", color(black)) ///
		(rspike upper lower year if var == "DDD", color(black)), ///
		legend(off) ///
		ylabel(-0.2(0.1)0.4, angle(0) format(%4.1f)) ///
		ytitle(Estimated Effect) ///
		scheme(s1color) yline(0, lc(black)) xline(2016.5, lc(black)) ///
		xlabel(2010(1)2022) xtitle(Year)
graph export "$figure/Fig4_DDD.jpg", as(jpg) replace

