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

cap rm "$table/TabB5_A.xls"
cap rm "$table/TabB5_A.txt"
cap rm "$table/TabB5_B.xls"
cap rm "$table/TabB5_B.txt"
cap rm "$table/TabB5_C.xls"
cap rm "$table/TabB5_C.txt"
cap rm "$table/TabB5_D.xls"
cap rm "$table/TabB5_D.txt"

foreach y in exptotpers expgrtpers revtotpers revtuipers tuition3 tuition7{

	sum `y' if large == 1 & wealthy == 1 & year == 2016
	loc m: dis %15.1fc r(mean)/1000
	reghdfe ln`y' LargeWealthyPost, a(large#year wealthy#year unitid fips#year) cl(unitid) keepsing
	outreg2 using "$table/TabB5_A.xls", append dec(3) nocon addtext(baseline,"`m'") alpha(0.001, 0.01, 0.05)
	
	reghdfe ln`y' LargeWealthyPost, a(large#year wealthy#year unitid hospital#year) cl(unitid) keepsing
	outreg2 using "$table/TabB5_B.xls", append dec(3) nocon addtext(baseline,"`m'") alpha(0.001, 0.01, 0.05)
	
	reghdfe ln`y' LargeWealthyPost, a(large#year wealthy#year unitid carnegie#year) cl(unitid) keepsing
	outreg2 using "$table/TabB5_C.xls", append dec(3) nocon addtext(baseline,"`m'") alpha(0.001, 0.01, 0.05)
	
	reghdfe ln`y' LargeWealthyPost, a(large#year wealthy#year unitid fips#year hospital#year carnegie#year) cl(unitid) keepsing
	outreg2 using "$table/TabB5_D.xls", append dec(3) nocon addtext(baseline,"`m'") alpha(0.001, 0.01, 0.05)
	
}

import delimited using "$table/TabB5_D.txt",clear
save "$table/dta/TableB3.dta", replace
import delimited using "$table/TabB5_C.txt",clear
ap using "$table/dta/TableB3.dta"
save "$table/dta/TableB3.dta", replace
import delimited using "$table/TabB5_B.txt",clear
ap using "$table/dta/TableB3.dta"
save "$table/dta/TableB3.dta", replace
import delimited using "$table/TabB5_A.txt",clear
ap using "$table/dta/TableB3.dta"
save "$table/dta/TableB3.dta", replace

drop if v1 == "R-squared"
keep if inrange(_n,3,5) | inrange(_n,13,15) | inrange(_n,23,25)  | inrange(_n,33,35) | inrange(_n,37,38)

replace v1 = "\multicolumn{7}{@{}l}{\bfseries Panel A: Add State-by-Year Fixed Effect}" in 1
replace v1 = "\multicolumn{7}{@{}l}{\bfseries Panel B: Add HavingHospital-by-Year Fixed Effect}" in 4
replace v1 = "\multicolumn{7}{@{}l}{\bfseries Panel C: Add Carnegie Category-by-Year Fixed Effect}" in 7
replace v1 = "\multicolumn{7}{@{}l}{\bfseries Panel D: Add All}" in 10

replace v1 = "$ Large\times Wealthy \times Post $" in 2
replace v1 = "$ Large\times Wealthy \times Post $" in 5
replace v1 = "$ Large\times Wealthy \times Post $" in 8
replace v1 = "$ Large\times Wealthy \times Post $" in 11
replace v1 = "Baseline Mean (1,000)" in 14
replace v1 = "Number of Observations" in 13

loc title = "Robustness Check: Additional Specific Time Trend"
loc head = " & (1) & (2) & (3) & (4) & (5) & (6) \\ \cmidrule(l){2-7} & \multicolumn{2}{c}{Log Exp. per Student} & \multicolumn{2}{c}{Log Rev. per Student} & \multicolumn{2}{c}{Listed Tuition} \\ \cmidrule(rl){2-3} \cmidrule(rl){4-5} \cmidrule(l){6-7} Outcome Variables: & Total & Grants & Total & Tuition & Undergrad & Graduate"

texsaveyt 	_all using "$tex/TabB5_temp.tex", replace ///
				title ("`title'") nonames ///
				headerlines("`head'") ///
				bottomlines("`bottom'") ///
				hlines(0 3 6 9 12 12) nofix size(footnotesize) align(@{}lcccccc@{}) ///
				label(tab.robust) frag rh(1.2) cs(2.5) ///
				footnote("Standard error in parentheses. \\ ***$$p<0.001$, **$$p<0.01$, *$$p<0.05$")
				
filefilter "$tex/TabB5_temp.tex" "$tex/TabB5.tex", from("&&&&&&") to("") replace
rm "$tex/TabB5_temp.tex"
