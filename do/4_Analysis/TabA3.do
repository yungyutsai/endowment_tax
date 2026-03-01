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

keep if drop == 1
gsort group -persendowment
 
by group: gen row = _n

loc N = _N + 3
set obs `N'
recode row . = 0
replace group = mod(_n,3) if group == .
recode group 0=3
recode group 4=3

gsort group row

replace instnm = "\multicolumn{4}{@{}l}{\textbf{Panel A: Large \& Wealthy}}" if group == 1 & row == 0
replace instnm = "\multicolumn{4}{@{}l}{\textbf{Panel B: Large \& Non-Wealthy}}" if group == 2 & row == 0
replace instnm = "\multicolumn{4}{@{}l}{\textbf{Panel C: Small \& Non-Wealthy}}" if group == 3 & row == 0

keep instnm fte endowment persendowment tax*

tostring _all, replace force format(%15.0fc)


forv i = 2018(1)2022{
	replace tax`i' = "Y" if tax`i' == "1"
	replace tax`i' = "N" if tax`i' == "0"
	replace tax`i' = "" if tax`i' == "."
}


foreach x in fte endowment persendowment{
	replace `x' = "" if `x' == "."
}

loc title = "List of Treatment Status Switcher"
loc head = " Institution Name & & \multicolumn{1}{c}{\multirow{2}[0]{*}{\begin{tabular}{c}FTE \\Student \\Enrollment\end{tabular}}} & \multicolumn{1}{c}{\multirow{2}[0]{*}{\begin{tabular}{c}Endowment \\Assets\\(\$ Million) \end{tabular}}} & \multicolumn{1}{c}{\multirow{2}[0]{*}{\begin{tabular}{c}Asset per \\Student\\(\$ Thousand) \end{tabular}}} & \multicolumn{5}{c}{Tax Status} \\ \\[-1em] \cmidrule(){5-9}  & & & & 2018 & 2019 & 2020 & 2021 & 2022 \\ \\[-1em]" 

texsaveyt 	_all using "$tex/TabC2_temp.tex", replace ///
				title ("`title'") nonames ///
				headerlines("`head'") ///
				bottomlines("`bottom'") ///
				hlines(0 2 24) nofix size(footnotesize) align(@{}lcccccccc@{}) ///
				label(tab.exp) frag rh(1.2) cs(1) ///
				footnote("")
				
filefilter "$tex/TabC2_temp.tex" "$tex/TabC2.tex", from("&&&&&&&&") to("") replace
rm "$tex/TabC2_temp.tex"
