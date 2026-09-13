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

cap rm "$table/TabB6_A.xls"
cap rm "$table/TabB6_A.txt"
cap rm "$table/TabB6_B.xls"
cap rm "$table/TabB6_B.txt"

//drop if year == 2019
drop if year == 2020
//drop if year == 2021

foreach y in exptot expins expres expgrt revtot revtui{

	sum `y' if large == 1 & wealthy == 1 & year == 2016
	loc m: dis %15.0fc r(mean)/1000000
	
	reghdfe ln`y' LargeWealthyPost, a(large#year wealthy#year unitid) cl(unitid)
	outreg2 using "$table/TabB6_A.xls", append dec(3) nocon addtext(baseline,"`m'") alpha(0.001, 0.01, 0.05)
	
	sum `y'pers if large == 1 & wealthy == 1 & year == 2016
	loc m: dis %15.0fc r(mean)/1000
	reghdfe ln`y'pers LargeWealthyPost, a(large#year wealthy#year unitid) cl(unitid)
	outreg2 using "$table/TabB6_B.xls", append dec(3) nocon addtext(baseline,"`m'") alpha(0.001, 0.01, 0.05)
	
}

import delimited using "$table/TabB6_B.txt",clear
save "$table/temp/TabB6.dta", replace
import delimited using "$table/TabB6_A.txt",clear
ap using "$table/temp/TabB6.dta"
save "$table/temp/TabB6.dta", replace

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

texsaveyt 	_all using "$tex/TabB6_temp.tex", replace ///
				title ("`title'") nonames ///
				headerlines("`head'") ///
				bottomlines("`bottom'") ///
				hlines(0 4 8 8) nofix size(footnotesize) align(@{}lcccccc@{}) ///
				label(tab.main) frag rh(1.2) cs(2) ///
				footnote("Standard error in parentheses. \\ ***$$p<0.001$, **$$p<0.01$, *$$p<0.05$")
				
filefilter "$tex/TabB6_temp.tex" "$tex/TabB6.tex", from("&&&&&&") to("") replace
rm "$tex/TabB6_temp.tex"



use "$wdata/endowment_tax_main_sample.dta", clear

cap rm "$table/TabB7_A.xls"
cap rm "$table/TabB7_A.txt"
cap rm "$table/TabB7_B.xls"
cap rm "$table/TabB7_B.txt"

drop if year == 2019
drop if year == 2020
drop if year == 2021

foreach y in exptot expins expres expgrt revtot revtui{

	sum `y' if large == 1 & wealthy == 1 & year == 2016
	loc m: dis %15.0fc r(mean)/1000000
	
	reghdfe ln`y' LargeWealthyPost, a(large#year wealthy#year unitid) cl(unitid)
	outreg2 using "$table/TabB7_A.xls", append dec(3) nocon addtext(baseline,"`m'") alpha(0.001, 0.01, 0.05)
	
	sum `y'pers if large == 1 & wealthy == 1 & year == 2016
	loc m: dis %15.0fc r(mean)/1000
	reghdfe ln`y'pers LargeWealthyPost, a(large#year wealthy#year unitid) cl(unitid)
	outreg2 using "$table/TabB7_B.xls", append dec(3) nocon addtext(baseline,"`m'") alpha(0.001, 0.01, 0.05)
	
}

import delimited using "$table/TabB7_B.txt",clear
save "$table/temp/TabB7.dta", replace
import delimited using "$table/TabB7_A.txt",clear
ap using "$table/temp/TabB7.dta"
save "$table/temp/TabB7.dta", replace

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

texsaveyt 	_all using "$tex/TabB7_temp.tex", replace ///
				title ("`title'") nonames ///
				headerlines("`head'") ///
				bottomlines("`bottom'") ///
				hlines(0 4 8 8) nofix size(footnotesize) align(@{}lcccccc@{}) ///
				label(tab.main) frag rh(1.2) cs(2) ///
				footnote("Standard error in parentheses. \\ ***$$p<0.001$, **$$p<0.01$, *$$p<0.05$")
				
filefilter "$tex/TabB7_temp.tex" "$tex/TabB7.tex", from("&&&&&&") to("") replace
rm "$tex/TabB7_temp.tex"
