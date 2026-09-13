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

use "$wdata/endowment_tax_final_sample.dta", clear

sort unitid year

* Fall Enrollment in t
replace large = enrollfte >= 500
replace endowmentpers = endowment / enrollfte
replace wealthy = endowmentpers >= 500000
cap gen treat = .
replace treat = large == 1 & wealthy == 1
cap gen accurate = .
replace accurate = treat == excisetax_990
tab treat excisetax_990 if year >= 2018
tab accurate if year >= 2018



* Fall Enrollment in t-1
replace large = enrollfte[_n-1] >= 500
replace endowmentpers = endowment[_n-1] / enrollfte[_n-1]
replace wealthy = endowmentpers >= 500000
cap gen treat = .
replace treat = large == 1 & wealthy == 1
cap gen accurate = .
replace accurate = treat == excisetax_990
tab treat excisetax_990 if year >= 2018
tab accurate if year >= 2018


* 12-Month Enrollment in t
replace large = fte >= 500
replace endowmentpers = endowment / fte
replace wealthy = endowmentpers >= 500000
cap gen treat = .
replace treat = large == 1 & wealthy == 1
cap gen accurate = .
replace accurate = treat == excisetax_990
tab treat excisetax_990 if year >= 2018
tab accurate if year >= 2018


* 12-Month Enrollment in t-1
replace large = fte[_n-1] >= 500
replace endowmentpers = endowment[_n-1] / fte[_n-1]
replace wealthy = endowmentpers >= 500000
cap gen treat = .
replace treat = large == 1 & wealthy == 1
cap gen accurate = .
replace accurate = treat == excisetax_990
tab treat excisetax_990 if year >= 2018
tab accurate if year >= 2018


* 12-Month Enrollment in t-2
replace large = fte[_n-2] >= 500
replace endowmentpers = endowment[_n-2] / fte[_n-2]
replace wealthy = endowmentpers >= 500000
cap gen treat = .
replace treat = large == 1 & wealthy == 1
cap gen accurate = .
replace accurate = treat == excisetax_990
tab treat excisetax_990 if year >= 2018
tab accurate if year >= 2018


replace endowmenteoy_990 = 0 if endowmenteoy_990 == .
* Fall Enrollment in t
replace large = enrollfte >= 500
replace endowmentpers = endowmenteoy_990 / enrollfte
replace wealthy = endowmentpers >= 500000
cap gen treat = .
replace treat = large == 1 & wealthy == 1
cap gen accurate = .
replace accurate = treat == excisetax_990
tab treat excisetax_990 if year >= 2018
tab accurate if year >= 2018



* Fall Enrollment in t-1
replace large = enrollfte[_n-1] >= 500
replace endowmentpers = endowmenteoy_990[_n-1] / enrollfte[_n-1]
replace wealthy = endowmentpers >= 500000
cap gen treat = .
replace treat = large == 1 & wealthy == 1
cap gen accurate = .
replace accurate = treat == excisetax_990
tab treat excisetax_990 if year >= 2018
tab accurate if year >= 2018


* 12-Month Enrollment in t
replace large = fte >= 500
replace endowmentpers = endowmenteoy_990 / fte
replace wealthy = endowmentpers >= 500000
cap gen treat = .
replace treat = large == 1 & wealthy == 1
cap gen accurate = .
replace accurate = treat == excisetax_990
tab treat excisetax_990 if year >= 2018
tab accurate if year >= 2018


* 12-Month Enrollment in t-1
replace large = fte[_n-1] >= 500
replace endowmentpers = endowmenteoy_990[_n-1] / fte[_n-1]
replace wealthy = endowmentpers >= 500000
cap gen treat = .
replace treat = large == 1 & wealthy == 1
cap gen accurate = .
replace accurate = treat == excisetax_990
tab treat excisetax_990 if year >= 2018
tab accurate if year >= 2018


* 12-Month Enrollment in t-2
replace large = fte[_n-2] >= 500
replace endowmentpers = endowmenteoy_990[_n-2] / fte[_n-2]
replace wealthy = endowmentpers >= 500000
cap gen treat = .
replace treat = large == 1 & wealthy == 1
cap gen accurate = .
replace accurate = treat == excisetax_990
tab treat excisetax_990 if year >= 2018
tab accurate if year >= 2018
