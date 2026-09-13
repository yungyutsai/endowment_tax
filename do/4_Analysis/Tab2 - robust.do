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

cap rm "$table/Tab2R_DDD_A.xls"
cap rm "$table/Tab2R_DDD_A.txt"
cap rm "$table/Tab2R_DDD_B.xls"
cap rm "$table/Tab2R_DDD_B.txt"

gen lnrevtotnm = lnrevtot if lnrevtot != 0
gen lnrevtotnmpers = lnrevtotpers if lnrevtotpers != 0
gen ashrevtot = asinh(revtot_IPEDS)
gen ashrevtotpers = asinh(revtot_IPEDS) / enrollfte


foreach y in lnrevtotnm ashrevtot{

	sum `y' if large == 1 & wealthy == 1 & year == 2016
	loc m: dis %15.0fc r(mean)/1000000
	
	reghdfe `y' LargeWealthyPost, a(large#year wealthy#year unitid) cl(unitid)
	outreg2 using "$table/Tab2R_DDD_A.xls", append dec(3) nocon addtext(baseline,"`m'") alpha(0.001, 0.01, 0.05)
	
	sum `y'pers if large == 1 & wealthy == 1 & year == 2016
	loc m: dis %15.0fc r(mean)/1000
	reghdfe `y'pers LargeWealthyPost, a(large#year wealthy#year unitid) cl(unitid)
	outreg2 using "$table/Tab2R_DDD_B.xls", append dec(3) nocon addtext(baseline,"`m'") alpha(0.001, 0.01, 0.05)
	
}

import delimited using "$table/Tab2R_DDD_B.txt",clear
save "$table/temp/Tab2.dta", replace
import delimited using "$table/Tab2R_DDD_A.txt",clear
ap using "$table/temp/Tab2.dta"
save "$table/temp/Tab2.dta", replace

drop if v1 == "R-squared"
drop if v1 == "Observations"
keep if inrange(_n,3,5) | _n == 7 | inrange(_n,12,14) | _n == 16

replace v1 = "\multicolumn{7}{@{}l}{\bfseries Panel A: Total Expenditure/Revenue}" in 1
replace v1 = "\multicolumn{7}{@{}l}{\bfseries Panel B: Expenditure/Revenue per FTE Student}" in 5
replace v1 = "$ Large\times Wealthy \times Post $" in 2
replace v1 = "$ Large\times Wealthy \times Post $" in 6
replace v1 = "Baseline Mean (\\$1M)" in 4
replace v1 = "Baseline Mean (\\$1K)" in 8

loc title = "The Impact of Endowment Tax on College Expenditure and Revenue"
loc head = " & (1) & (2) & (3) & (4) & (5) & (6) \\ \cmidrule(l){2-7} & \multicolumn{4}{c}{Expenditure} & \multicolumn{2}{c}{Revenue} \\ \cmidrule(rl){2-5} \cmidrule(l){6-7} Outcome Variables: & Total & Instruction & Research & Grants & Total & Tuition"
loc bottom = "Number of Observations & \multicolumn{6}{c}{16,800} \\"

texsaveyt 	_all using "$tex/Tab2_temp.tex", replace ///
				title ("`title'") nonames ///
				headerlines("`head'") ///
				bottomlines("`bottom'") ///
				hlines(0 4 8 8) nofix size(footnotesize) align(@{}lcccccc@{}) ///
				label(tab.main) frag rh(1.2) cs(2) ///
				footnote("Standard error in parentheses. \\ ***$$p<0.001$, **$$p<0.01$, *$$p<0.05$")
				
filefilter "$tex/Tab2_temp.tex" "$tex/Tab2.tex", from("&&&&&&") to("") replace
rm "$tex/Tab2_temp.tex"
