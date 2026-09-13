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

use "$wdata/endowment_tax_final_sample.dta", clear

cap rm "$table/TabB1.xls"
cap rm "$table/TabB1.txt"

foreach y in exptotpers expgrtpers revtotpers revtuipers tuition3 tuition7{

	sum `y' if large == 1 & wealthy == 1 & year == 2016
	loc m: dis %15.1fc r(mean)/1000
	reghdfe ln`y' LargeWealthyPost, a(large#year wealthy#year unitid) cl(unitid)
	outreg2 using "$table/TabB1.xls", append dec(3) nocon addtext(baseline,"`m'") alpha(0.001, 0.01, 0.05)
	
}

import delimited using "$table/TabB1.txt",clear

drop if v1 == "R-squared"
keep if inrange(_n,4,5) | inrange(_n,7,8)

replace v1 = "$ Large\times Wealthy \times Post $" in 1
replace v1 = "Baseline Mean (\\1,000)" in 4

loc title = "Alternative Sample: Not Dropping Switcher"
loc head = " & (1) & (2) & (3) & (4) & (5) & (6) \\ \cmidrule(l){2-7} & \multicolumn{2}{c}{Log Exp. per Student} & \multicolumn{2}{c}{Log Rev. per Student} & \multicolumn{2}{c}{Listed Tuition} \\ \cmidrule(rl){2-3} \cmidrule(rl){4-5} \cmidrule(l){6-7} Outcome Variables: & Total & Grants & Total & Tuition & Undergrad & Graduate"

texsaveyt 	_all using "$tex/TabB1_temp.tex", replace ///
				title ("`title'") nonames ///
				headerlines("`head'") ///
				bottomlines("`bottom'") ///
				hlines(0 2 2) nofix size(footnotesize) align(@{}lcccccc@{}) ///
				label(tab.main) frag rh(1.2) cs(2.5) ///
				footnote("Standard error in parentheses. \\ ***$$p<0.001$, **$$p<0.01$, *$$p<0.05$")
				
filefilter "$tex/TabB1_temp.tex" "$tex/TabB1.tex", from("&&&&&&") to("") replace
rm "$tex/TabB1_temp.tex"
