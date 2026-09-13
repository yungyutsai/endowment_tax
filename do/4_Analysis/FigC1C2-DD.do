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

keep if large == 1

cap rm "$table/FigC1.xls"
cap rm "$table/FigC1.txt"

foreach y in exptot expins expres expgrt revtot revtui{
	
	reghdfe ln`y' LargeWealthy20*, a(year unitid) cl(unitid)
	outreg2 using "$table/FigC1.xls", append dec(3) nocon
	
	reghdfe ln`y'pers LargeWealthy20*, a(year unitid) cl(unitid)
	outreg2 using "$table/FigC1.xls", append dec(3) nocon
}


foreach y in tuition2 tuition3 tuition6 tuition7 chg5ay3{
	
	reghdfe ln`y' LargeWealthy20*, a(year unitid) cl(unitid)
	outreg2 using "$table/FigC1.xls", append dec(3) nocon

}



import delimited using "$table/FigC1.txt",clear

forv i = 2(1)18{
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

replace year = year - 0.1 if var == "exptot"
replace year = year + 0.1 if var == "exptotpers"

twoway 	(connect b year if var == "exptot", color(black)) ///
		(rspike upper lower year if var == "exptot", color(black)) ///
		(connect b year if var == "exptotpers", color(gs8) ms(Oh)) ///
		(rspike upper lower year if var == "exptotpers", color(gs8)), ///
		legend(order(1 "Tot Exp." 3 "Exp. per Student")) ///
		ylabel(-0.15(0.05)0.2, angle(0) format(%4.2f)) ///
		ytitle(Estimated Effect) ///
		scheme(s1color) yline(0, lc(black)) xline(2016.5, lc(black)) ///
		xlabel(2010(1)2022) xtitle(Year)
graph export "$figure/FigC1_exptot.jpg", as(jpg) replace


replace year = year - 0.1 if var == "expgrt"
replace year = year + 0.1 if var == "expgrtpers"

twoway 	(connect b year if var == "expgrt", color(black)) ///
		(rspike upper lower year if var == "expgrt", color(black)) ///
		(connect b year if var == "expgrtpers", color(gs8) ms(Oh)) ///
		(rspike upper lower year if var == "expgrtpers", color(gs8)), ///
		legend(order(1 "Tot Exp." 3 "Exp. per Student")) ///
		ylabel(-2(0.5)2.5, angle(0) format(%4.1f)) ///
		ytitle(Estimated Effect) ///
		scheme(s1color) yline(0, lc(black)) xline(2016.5, lc(black)) ///
		xlabel(2010(1)2022) xtitle(Year)
graph export "$figure/FigC1_expgrt.jpg", as(jpg) replace



replace year = year - 0.1 if var == "expres"
replace year = year + 0.1 if var == "exprespers"

twoway 	(connect b year if var == "expres", color(black)) ///
		(rspike upper lower year if var == "expres", color(black)) ///
		(connect b year if var == "exprespers", color(gs8) ms(Oh)) ///
		(rspike upper lower year if var == "exprespers", color(gs8)), ///
		legend(order(1 "Tot Exp." 3 "Exp. per Student")) ///
		ylabel(, angle(0) format(%4.1f)) ///
		ytitle(Estimated Effect) ///
		scheme(s1color) yline(0, lc(black)) xline(2016.5, lc(black)) ///
		xlabel(2010(1)2022) xtitle(Year)
graph export "$figure/FigC1_expres.jpg", as(jpg) replace


replace year = year - 0.1 if var == "expins"
replace year = year + 0.1 if var == "expinspers"

twoway 	(connect b year if var == "expins", color(black)) ///
		(rspike upper lower year if var == "expins", color(black)) ///
		(connect b year if var == "expinspers", color(gs8) ms(Oh)) ///
		(rspike upper lower year if var == "expinspers", color(gs8)), ///
		legend(order(1 "Tot Exp." 3 "Exp. per Student")) ///
		ylabel(-0.15(0.05)0.2, angle(0) format(%4.2f)) ///
		ytitle(Estimated Effect) ///
		scheme(s1color) yline(0, lc(black)) xline(2016.5, lc(black)) ///
		xlabel(2010(1)2022) xtitle(Year)
graph export "$figure/FigC1_expins.jpg", as(jpg) replace



replace year = year - 0.1 if var == "revtot"
replace year = year + 0.1 if var == "revtotpers"

twoway 	(connect b year if var == "revtot", color(black)) ///
		(rspike upper lower year if var == "revtot", color(black)) ///
		(connect b year if var == "revtotpers", color(gs8) ms(Oh)) ///
		(rspike upper lower year if var == "revtotpers", color(gs8)), ///
		legend(order(1 "Tot Rev." 3 "Rev. per Student")) ///
		ylabel(, angle(0) format(%4.0f)) ///
		ytitle(Estimated Effect) ///
		scheme(s1color) yline(0, lc(black)) xline(2016.5, lc(black)) ///
		xlabel(2010(1)2022) xtitle(Year)
graph export "$figure/FigC1_revtot.jpg", as(jpg) replace


replace year = year - 0.1 if var == "revtui"
replace year = year + 0.1 if var == "revtuipers"

twoway 	(connect b year if var == "revtui", color(black)) ///
		(rspike upper lower year if var == "revtui", color(black)) ///
		(connect b year if var == "revtuipers", color(gs8) ms(Oh)) ///
		(rspike upper lower year if var == "revtuipers", color(gs8)), ///
		legend(order(1 "Tot Rev." 3 "Rev. per Student")) ///
		ylabel(, angle(0) format(%4.1f)) ///
		ytitle(Estimated Effect) ///
		scheme(s1color) yline(0, lc(black)) xline(2016.5, lc(black)) ///
		xlabel(2010(1)2022) xtitle(Year)
graph export "$figure/FigC1_revtui.jpg", as(jpg) replace



replace year = year - 0.1 if var == "tuition2"
replace year = year + 0.1 if var == "tuition3"

twoway 	(connect b year if var == "tuition2", color(black)) ///
		(rspike upper lower year if var == "tuition2", color(black)) ///
		(connect b year if var == "tuition3", color(gs8) ms(Oh)) ///
		(rspike upper lower year if var == "tuition3", color(gs8)), ///
		legend(order(1 "In-State" 3 "Out-of-State")) ///
		ylabel(, angle(0) format(%4.2f)) ///
		ytitle(Estimated Effect) ///
		scheme(s1color) yline(0, lc(black)) xline(2016.5, lc(black)) ///
		xlabel(2010(1)2022) xtitle(Year)
graph export "$figure/FigC1_tuition_under.jpg", as(jpg) replace


replace year = year - 0.1 if var == "tuition6"
replace year = year + 0.1 if var == "tuition7"

twoway 	(connect b year if var == "tuition6", color(black)) ///
		(rspike upper lower year if var == "tuition6", color(black)) ///
		(connect b year if var == "tuition7", color(gs8) ms(Oh)) ///
		(rspike upper lower year if var == "tuition7", color(gs8)), ///
		legend(order(1 "In-State" 3 "Out-of-State")) ///
		ylabel(, angle(0) format(%4.2f)) ///
		ytitle(Estimated Effect) ///
		scheme(s1color) yline(0, lc(black)) xline(2016.5, lc(black)) ///
		xlabel(2010(1)2022) xtitle(Year)
graph export "$figure/FigC1_tuition_grad.jpg", as(jpg) replace
