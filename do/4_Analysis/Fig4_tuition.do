if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Library/CloudStorage/Dropbox/02 Research/education/endowment_tax/rdata"
	global wdata "/Users/yungyu/Library/CloudStorage/Dropbox/02 Research/education/endowment_tax/wdata"
	global figure "/Users/yungyu/Library/CloudStorage/Dropbox/02 Research/education/endowment_tax/content/figures"
	global table "/Users/yungyu/Library/CloudStorage/Dropbox/02 Research/education/endowment_tax/table"
	global tex "/Users/yungyu/Library/CloudStorage/Dropbox/02 Research/education/endowment_tax/content/tables"
	global do "/Users/yungyu/Library/CloudStorage/Dropbox/02 Research/education/endowment_tax/do"
	adopath + "$do/ado"
}
graph set eps fontface Times

use "$wdata/endowment_tax_main_sample.dta", clear

cap rm "$table/Fig4.xls"
cap rm "$table/Fig4.txt"

foreach y in tuition2 tuition3 tuition6 tuition7 chg5ay3{
	
	reghdfe ln`y' LargeWealthy20*, a(large#year wealthy#year unitid) cl(unitid)
	outreg2 using "$table/Fig4.xls", append dec(3) nocon
	
}

import delimited using "$table/Fig4.txt",clear

forv i = 2(1)6{
	loc var: dis v`i'[2]
	rename v`i' `var'
}

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

replace year = year - 0.1 if var == "tuition2"
replace year = year + 0.1 if var == "tuition3"

twoway 	(connect b year if var == "tuition2", color(black)) ///
		(rspike upper lower year if var == "tuition2", color(black)) ///
		(connect b year if var == "tuition3", color(gs8) ms(Oh)) ///
		(rspike upper lower year if var == "tuition3", color(gs8)), ///
		legend(order(1 "In-State" 3 "Out-of-State")) ///
		ylabel(, angle(0) format(%4.1f)) ///
		ytitle(Estimated Effect) ///
		scheme(s1color) yline(0, lc(black)) xline(2016.5, lc(black)) ///
		xlabel(2010(1)2022) xtitle(Year)
graph export "$figure/Fig4_tuition_under.jpg", as(jpg) replace width(2400)


replace year = year - 0.1 if var == "tuition6"
replace year = year + 0.1 if var == "tuition7"

twoway 	(connect b year if var == "tuition6", color(black)) ///
		(rspike upper lower year if var == "tuition6", color(black)) ///
		(connect b year if var == "tuition7", color(gs8) ms(Oh)) ///
		(rspike upper lower year if var == "tuition7", color(gs8)), ///
		legend(order(1 "In-State" 3 "Out-of-State")) ///
		ylabel(, angle(0) format(%4.1f)) ///
		ytitle(Estimated Effect) ///
		scheme(s1color) yline(0, lc(black)) xline(2016.5, lc(black)) ///
		xlabel(2010(1)2022) xtitle(Year)
graph export "$figure/Fig4_tuition_grad.jpg", as(jpg) replace width(2400)



twoway 	(connect b year if var == "chg5ay3", color(black)) ///
		(rspike upper lower year if var == "chg5ay3", color(black)), ///
		legend(order(1 "In-State" 3 "Out-of-State")) ///
		ylabel(, angle(0) format(%4.1f)) ///
		ytitle(Estimated Effect) ///
		scheme(s1color) yline(0, lc(black)) xline(2016.5, lc(black)) ///
		xlabel(2010(1)2022) xtitle(Year)
graph export "$figure/Fig4_chg5ay3.jpg", as(jpg) replace width(2400)
