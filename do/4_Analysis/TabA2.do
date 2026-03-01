if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
	global figure "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/content/figures"
	global table "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/table"
	global tex "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/content/tables"
	global do "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/do"
	adopath + "$do/ado"
}

use "$wdata/endowment_tax_final_sample.dta", clear

sort unitid year

cap drop v1
forv i = 2018(1)2022{
	gen v1 = excise == 1 & year == `i'
	egen tax`i' = max(v1), by(unitid)
	drop v1
}

keep if year == 2016

gen drop = 0
replace drop = 1 if large == 1 & wealthy == 1 & tryear != 2018
replace drop = 1 if (large != 1 | wealthy != 1) & tryear != .

keep instnm enrollfte endowment persendowment tax* drop
rename enrollfte fte

replace persendowment = endowment / fte if persendowment == .
replace endowment = endowment/1000000
replace persendowment = persendowment/1000

format fte %15.0fc
format endowment persendowment %15.2fc

order instnm fte endowment persendowment
drop if endowment == . | endowment == 0
gsort -persendowment

gen group = .
replace group = 1 if fte >= 500 & persendowment >= 500
replace group = 2 if fte >= 500 & persendowment < 500
replace group = 3 if fte < 500 & persendowment >= 500
replace group = 4 if fte < 500 & persendowment < 500


keep if group == 1 | group == 3
drop if drop == 1
gsort group -persendowment
 
by group: gen row = _n

loc N = _N + 2
set obs `N'
recode row . = 0
replace group = mod(_n,2) if group == .
recode group 0=2

gsort group row

replace instnm = "\multicolumn{4}{@{}l}{\textbf{Panel A: Large \& Wealthy}}" if group == 1 & row == 0
replace instnm = "\multicolumn{4}{@{}l}{\textbf{Panel B: Small \& Wealthy}}" if group == 2 & row == 0

keep instnm fte endowment persendowment

tostring _all, replace force format(%15.0fc)

foreach x in fte endowment persendowment{
	replace `x' = "" if `x' == "."
}

loc title = "List of Wealthy Colleges in Sample"
loc head = " Institution Name & FTE Student & Endowment (\$1M) & Endowment per Studnet (\$1K)" 

texsaveyt 	_all using "$tex/TabC1_temp.tex", replace ///
				title ("`title'") nonames ///
				headerlines("`head'") ///
				bottomlines("`bottom'") ///
				hlines(0 32) nofix size(scriptsize) align(@{}lccc@{}) ///
				label(tab.exp) frag rh(1.2) cs(1) ///
				footnote("")
				
filefilter "$tex/TabC1_temp.tex" "$tex/TabC1.tex", from("&&&") to("") replace
rm "$tex/TabC1_temp.tex"
