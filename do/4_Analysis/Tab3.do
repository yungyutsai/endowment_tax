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

cap rm "$table/Tab3.xls"
cap rm "$table/Tab3.txt"

foreach y in tuition2 tuition3 tuition6 tuition7 chg5ay3 {

	sum `y' if large == 1 & wealthy == 1 & year == 2016
	loc m: dis %15.1fc r(mean)/1000
	
	reghdfe ln`y' LargeWealthyPost, a(large#year wealthy#year unitid) cl(unitid)
	outreg2 using "$table/Tab3.xls", append dec(3) nocon addtext(baseline,"`m'") alpha(0.001, 0.01, 0.05)
}

import delimited using "$table/Tab3.txt",clear

drop if v1 == "R-squared"
keep if inrange(_n,4,5) | inrange(_n,7,8)
gen order = _n
recode order 3=5
sort order
drop order

replace v1 = "$ Large\times Wealthy \times Post $" in 1
replace v1 = "Baseline Mean (\\$1K)" in 3
replace v1 = "Number of Observations" in 4

loc title = "The Impact of Endowment Tax on Tuition and Charge"
loc head = " & (1) & (2) & (3) & (4) & (5) \\ \cmidrule(l){2-6} Outcome Variables: & \multicolumn{4}{c}{Tuition}   & \multirow{3}{*}{\shortstack[c]{Room \&\\Board\\Charge}} \\ \cmidrule(rl){2-5} & \multicolumn{2}{c}{Undergraduate} & \multicolumn{2}{c}{Graduate} &  \\ \cmidrule(rl){2-3} \cmidrule(l){4-5} & In-State & Out-of-State & In-State & Out-of-State & "

texsaveyt 	_all using "$tex/Tab3_temp.tex", replace ///
				title ("`title'") nonames ///
				headerlines("`head'") ///
				hlines(0 2) nofix size(footnotesize) align(@{}lccccc@{}) ///
				label(tab.tuition) frag rh(1.2) cs(2) ///
				footnote("Standard error in parentheses. \\ ***$$p<0.001$, **$$p<0.01$, *$$p<0.05$")
				
filefilter "$tex/Tab3_temp.tex" "$tex/Tab3.tex", from("&&&&&") to("") replace
rm "$tex/Tab3_temp.tex"
