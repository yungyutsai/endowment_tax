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

cap rm "$table/Tab4_A.xls"
cap rm "$table/Tab4_A.txt"
cap rm "$table/Tab4_B.xls"
cap rm "$table/Tab4_B.txt"

gen othe = nhpi+aian+tmor
gen lnothe = ln(othe+1)

foreach y in enrollfte whit bkaa hisp asia othe nral {

	sum `y' if large == 1 & wealthy == 1 & year == 2016
	loc m: dis %15.0fc r(mean)
	
	reghdfe ln`y' LargeWealthyPost, a(large#year wealthy#year unitid) cl(unitid)
	outreg2 using "$table/Tab4_A.xls", append dec(3) nocon addtext(baseline,"`m'") alpha(0.001, 0.01, 0.05)
	
	reghdfe ln`y' LargeWealthyPost if large == 1, a(year unitid) cl(unitid)
	outreg2 using "$table/Tab4_B.xls", append dec(3) nocon addtext(baseline,"`m'") alpha(0.001, 0.01, 0.05)
}

import delimited using "$table/Tab4_B.txt",clear
save "$table/dta/Tab4.dta", replace
import delimited using "$table/Tab4_A.txt",clear
ap using "$table/dta/Tab4.dta"
save "$table/dta/Tab4.dta", replace

drop if v1 == "R-squared"
keep if inrange(_n,3,5) | inrange(_n,7,7) | inrange(_n,13,15) | inrange(_n,17,18)


replace v1 = "\multicolumn{8}{@{}l}{\bfseries Panel A: Triple-Difference}" in 1
replace v1 = "\multicolumn{8}{@{}l}{\bfseries Panel B: Difference-in-Differences}" in 5

replace v1 = "$ Large\times Wealthy \times Post $" in 2
replace v1 = "$ Wealthy \times Post $" in 6
replace v1 = "Baseline Mean" in 9
replace v1 = "Number of Observations" in 4
replace v1 = "Number of Observations" in 8

loc title = "The Impact of Endowment Tax on Student Enrollment"
loc head = "& (1) & (2) & (3) & (4) & (5) & (6) & (7) \\  \midrule Outcome Variables: & \multicolumn{7}{c}{Log Student Enrollment} \\ \cmidrule(l){2-8} & Total & White & Black & Hispanic & Asian & Others & NRA"

texsaveyt 	_all using "$tex/Tab4_temp.tex", replace ///
				title ("`title'") nonames ///
				headerlines("`head'") ///
				hlines(0 4 8 8) nofix size(footnotesize) align(@{}lccccccc@{}) ///
				label(tab.tuition) frag rh(1.2) cs(2.5) ///
				footnote("Standard error in parentheses. \\ ***$$p<0.001$, **$$p<0.01$, *$$p<0.05$")
				
filefilter "$tex/Tab4_temp.tex" "$tex/Tab4.tex", from("&&&&&&&") to("") replace
rm "$tex/Tab4_temp.tex"
