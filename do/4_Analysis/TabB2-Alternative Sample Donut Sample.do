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

gen sampleA = ~inrange(endowmentpers2016,400000,600000)
gen sampleB = ~inrange(enrollfte2016,400,600)
gen sampleC = ~inrange(endowmentpers2016,400000,600000) & ~inrange(enrollfte2016,400,600)

cap rm "$table/TabB2_A.xls"
cap rm "$table/TabB2_A.txt"
cap rm "$table/TabB2_B.xls"
cap rm "$table/TabB2_B.txt"
cap rm "$table/TabB2_C.xls"
cap rm "$table/TabB2_C.txt"

foreach y in exptotpers expgrtpers revtotpers revtuipers tuition3 tuition7{

	foreach x in A B C{
		sum `y' if large == 1 & wealthy == 1 & year == 2016 & sample`x' == 1
		loc m: dis %15.1fc r(mean)/1000
		reghdfe ln`y' LargeWealthyPost if sample`x' == 1, a(large#year wealthy#year unitid) cl(unitid)
		outreg2 using "$table/TabB2_`x'.xls", append dec(3) nocon addtext(baseline,"`m'") alpha(0.001, 0.01, 0.05)
	}
	
}

import delimited using "$table/TabB2_C.txt",clear
save "$table/dta/TableB2.dta", replace
import delimited using "$table/TabB2_B.txt",clear
ap using "$table/dta/TableB2.dta"
save "$table/dta/TableB2.dta", replace
import delimited using "$table/TabB2_A.txt",clear
ap using "$table/dta/TableB2.dta"
save "$table/dta/TableB2.dta", replace

drop if v1 == "R-squared"
keep if inrange(mod(_n,10),3,5) | inrange(mod(_n,10),7,8)


replace v1 = "\multicolumn{7}{@{}l}{\bfseries Panel A: Exclude Colleges with Endow. Asset per Stu. b/w \\$400,000 to \\$600,000}" in 1
replace v1 = "\multicolumn{7}{@{}l}{\bfseries Panel B: Exclude Colleges with FTE Student b/w 400 to 600}" in 6
replace v1 = "\multicolumn{7}{@{}l}{\bfseries Panel C: Exclude Both}" in 11

replace v1 = "$ Large\times Wealthy \times Post $" in 2
replace v1 = "$ Large\times Wealthy \times Post $" in 7
replace v1 = "$ Large\times Wealthy \times Post $" in 12
replace v1 = "Baseline Mean (1,000)" if v1 == "baseline"
replace v1 = "Number of Observations" if v1 == "Observations"

loc title = "Alternative Sample: Donut Sample"
loc head = " & (1) & (2) & (3) & (4) & (5) & (6) \\ \cmidrule(l){2-7} & \multicolumn{2}{c}{Log Exp. per Student} & \multicolumn{2}{c}{Log Rev. per Student} & \multicolumn{2}{c}{Listed Tuition} \\ \cmidrule(rl){2-3} \cmidrule(rl){4-5} \cmidrule(l){6-7} Outcome Variables: & Total & Grants & Total & Tuition & Undergrad & Graduate"

texsaveyt 	_all using "$tex/TabB2_temp.tex", replace ///
				title ("`title'") nonames ///
				headerlines("`head'") ///
				bottomlines("`bottom'") ///
				hlines(0 5 10) nofix size(footnotesize) align(@{}lcccccc@{}) ///
				label(tab.main) frag rh(1.2) cs(2.5) ///
				footnote("Standard error in parentheses. \\ ***$$p<0.001$, **$$p<0.01$, *$$p<0.05$")
				
filefilter "$tex/TabB2_temp.tex" "$tex/TabB2.tex", from("&&&&&&") to("") replace
rm "$tex/TabB2_temp.tex"
