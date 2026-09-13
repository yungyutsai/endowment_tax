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

cap rm "$table/TabC2_A.xls"
cap rm "$table/TabC2_A.txt"
cap rm "$table/TabC2_B.xls"
cap rm "$table/TabC2_B.txt"

foreach y in revaux revpri revgov revhos revind revedu revinv revoth{

	sum `y' if large == 1 & wealthy == 1 & year == 2016
	loc m: dis %15.0fc r(mean)/1000000
	
	reghdfe ln`y' LargeWealthyPost, a(large#year wealthy#year unitid) cl(unitid)
	outreg2 using "$table/TabC2_A.xls", append dec(3) nocon addtext(baseline,"`m'") alpha(0.001, 0.01, 0.05)
	
	sum `y'pers if large == 1 & wealthy == 1 & year == 2016
	loc m: dis %15.0fc r(mean)/1000
	reghdfe ln`y'pers LargeWealthyPost, a(large#year wealthy#year unitid) cl(unitid)
	outreg2 using "$table/TabC2_B.xls", append dec(3) nocon addtext(baseline,"`m'") alpha(0.001, 0.01, 0.05)
}

import delimited using "$table/TabC2_B.txt",clear
save "$table/temp/TabC2.dta", replace
import delimited using "$table/TabC2_A.txt",clear
ap using "$table/temp/TabC2.dta"
save "$table/temp/TabC2.dta", replace

drop if v1 == "R-squared"
drop if v1 == "Observations"
keep if inrange(_n,3,5) | _n == 7 | inrange(_n,12,14) | _n == 16

replace v1 = "\multicolumn{9}{@{}l}{\bfseries Panel A: Total Revenue}" in 1
replace v1 = "\multicolumn{9}{@{}l}{\bfseries Panel B: Revenue per FTE Student}" in 5
replace v1 = "$ Large\times Wealthy \times Post $" in 2
replace v1 = "$ Large\times Wealthy \times Post $" in 6
replace v1 = "Baseline Mean (\\$1M)" in 4
replace v1 = "Baseline Mean (\\$1K)" in 8

loc title = "The Impact of Endowment Tax on College Revenue"
loc head = " & (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8) \\ \cmidrule(l){2-9} Outcome Variables: & \begin{tabular}{c}Aux.\\Enterprise\end{tabular} & \begin{tabular}{c}Private\\Contribution\end{tabular} & \begin{tabular}{c}Gov.\\Grants\end{tabular} & \begin{tabular}{c}Hospital\end{tabular} & \begin{tabular}{c}Indep.\\Operation\end{tabular} & \begin{tabular}{c}Edu. \\Service\end{tabular} & \begin{tabular}{c}Invest.\\Return\end{tabular} & \begin{tabular}{c}Other\end{tabular}" 
loc bottom = "Number of Observations & \multicolumn{8}{c}{16,800} \\"

texsaveyt 	_all using "$tex/TabC2_temp.tex", replace ///
				title ("`title'") nonames ///
				headerlines("`head'") ///
				bottomlines("`bottom'") ///
				hlines(0 4 8 8) nofix size(footnotesize) align(@{}lcccccccc@{}) ///
				label(tab.rev) frag rh(1.2) cs(1) ///
				footnote("Standard error in parentheses. \\ ***$$p<0.001$, **$$p<0.01$, *$$p<0.05$")
				
filefilter "$tex/TabC2_temp.tex" "$tex/TabC2.tex", from("&&&&&&&&") to("") replace
rm "$tex/TabC2_temp.tex"
