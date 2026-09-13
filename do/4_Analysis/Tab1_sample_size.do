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

use "$wdata/endowment_tax_final_sample.dta", clear

gen v1 = enrollfte if year == 2016
egen enrollfte2016 = mean(v1), by(unitid)
gen wealthy = endowmentpers2016 >= 500000
gen large = enrollfte2016 >= 500
gen post = year > 2017

foreach x in exptot expgrt expins revtot revtui endowment_payout{
	replace `x' = `x' / cpi * 100
	gen `x'pers = `x' / enrollfte
	gen ln`x'pers = ln(`x'pers+1)
}

replace tuition3 = tuition3 / cpi * 100
replace tuition7 = tuition7 / cpi * 100
replace lntuition3 = ln(tuition3)
replace lntuition7 = ln(tuition7)

forv i = 2010(1)2022{
	gen LargeWealthy`i' = large == 1 & wealthy == 1 & year == `i'
}
drop LargeWealthy2016

//drop if enrollfte2016 < 100
//drop if endowmentpers2016 < 100000

cap drop v1
gen v1 = year if excisetax_990 == 1
egen tryear = min(v1), by(unitid)
drop if large == 1 & wealthy == 1 & tryear != 2018
drop if (large != 1 | wealthy != 1) & tryear != .

cap rm "$table/FigF3_Shifting_DDD.xls"
cap rm "$table/FigF3_Shifting_DDD.txt"

foreach y in exptotpers expgrtpers endowment_payoutpers revtuipers tuition3 tuition7   {
	sum `y' if large == 1 & wealthy == 1 & year == 2016
	loc m: dis %15.3fc r(mean)/1000
	reghdfe ln`y' LargeWealthy*, a(large#year wealthy#year unitid) cl(unitid)
	outreg2 using "$table/FigF3_Shifting_DDD.xls", append dec(3) nocon addtext(baseline,"`m'")
}

import delimited using "$table/FigF3_Shifting_DDD.txt",clear

keep in 4/27
gen year = 2009+ceil(_n/2)
replace year = year + 1 if year >= 2016
set obs 26
recode year . = 2016

drop v1

gen type = "b" if mod(_n,2)==1
replace type = "se" if mod(_n,2)==0

reshape long v, i(year type) j(var)
tostring var, replace
replace var = "exptotpers" if var == "2"
replace var = "expgrtpers" if var == "3"
replace var = "revtuipers" if var == "5"
replace var = "payoutrate" if var == "4"
replace var = "tuition3" if var == "6"
replace var = "tuition7" if var == "7"

reshape wide v, i(year var) j(type) string

rename vb b
rename vse se

replace b = subinstr(b,"*","",.)
replace se = subinstr(se,"(","",.)
replace se = subinstr(se,")","",.)

destring b se, replace

recode b . = 0
recode se . = 0
gen upper = b + 1.96 * se
gen lower = b - 1.96 * se

sum upper if var == "tuition3"
sum lower if var == "tuition3"
sum upper if var == "tuition7"
sum lower if var == "tuition7"

twoway 	(connect b year if var == "tuition3", color(navy)) ///
		(rcap upper lower year if var == "tuition3", color(navy)) , ///
		legend(order(1 "Point Estimates" 2 "95% CI")) ///
		ylabel(-0.3(0.1)0.4, angle(0) format(%4.1f)) ///
		ytitle(Estimated Effect) ///
		scheme(s1color) yline(0, lc(black)) xline(2016.5, lc(black)) ///
		xlabel(2010(1)2022) xtitle(Year)
graph export "$figure/FigF3_tuition3.jpg", as(jpg) replace

twoway 	(connect b year if var == "tuition7", color(navy)) ///
		(rcap upper lower year if var == "tuition7", color(navy)) , ///
		legend(order(1 "Point Estimates" 2 "95% CI")) ///
		ylabel(-0.3(0.1)0.4, angle(0) format(%4.1f)) ///
		ytitle(Estimated Effect) ///
		scheme(s1color) yline(0, lc(black)) xline(2016.5, lc(black)) ///
		xlabel(2010(1)2022) xtitle(Year)
graph export "$figure/FigF3_tuition7.jpg", as(jpg) replace




sum upper if var == "exptotpers"
sum lower if var == "exptotpers"
sum upper if var == "revtuipers"
sum lower if var == "revtuipers"

twoway 	(connect b year if var == "exptotpers", color(navy)) ///
		(rcap upper lower year if var == "exptotpers", color(navy)), ///
		legend(order(1 "Point Estimates" 2 "95% CI")) ///
		ylabel(, angle(0) format(%4.1f)) ///
		ytitle(Estimated Effect) ///
		scheme(s1color) yline(0, lc(black)) xline(2016.5, lc(black)) ///
		xlabel(2010(1)2022) xtitle(Year)
graph export "$figure/FigF3_exptotpers.jpg", as(jpg) replace


twoway 	(connect b year if var == "revtuipers", color(navy)) ///
		(rcap upper lower year if var == "revtuipers", color(navy)), ///
		legend(order(1 "Point Estimates" 2 "95% CI")) ///
		ylabel(, angle(0) format(%4.1f)) ///
		ytitle(Estimated Effect) ///
		scheme(s1color) yline(0, lc(black)) xline(2016.5, lc(black)) ///
		xlabel(2010(1)2022) xtitle(Year)
graph export "$figure/FigF3_revtuipers.jpg", as(jpg) replace


twoway 	(connect b year if var == "expgrtpers", color(navy)) ///
		(rcap upper lower year if var == "expgrtpers", color(navy)), ///
		legend(order(1 "Point Estimates" 2 "95% CI")) ///
		ylabel(, angle(0) format(%4.1f)) ///
		ytitle(Estimated Effect) ///
		scheme(s1color) yline(0, lc(black)) xline(2016.5, lc(black)) ///
		xlabel(2010(1)2022) xtitle(Year)
graph export "$figure/FigF3_expgrtpers.jpg", as(jpg) replace

twoway 	(connect b year if var == "payoutrate", color(navy)) ///
		(rcap upper lower year if var == "payoutrate", color(navy)), ///
		legend(order(1 "Point Estimates" 2 "95% CI")) ///
		ylabel(, angle(0) format(%4.1f)) ///
		ytitle(Estimated Effect) ///
		scheme(s1color) yline(0, lc(black)) xline(2016.5, lc(black)) ///
		xlabel(2010(1)2022) xtitle(Year)
graph export "$figure/FigF3_payoutrate.jpg", as(jpg) replace

