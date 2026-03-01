if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

import excel "$rdata/CPI/SeriesReport-20250805024328_b59100.xlsx", clear first
keep in 12/37

destring _all, replace

rename ConsumerPriceIndexforAllUrb year

loc i = 1
foreach x in `c(ALPHA)'{
	if inrange(`i',2,13){
		loc j = `i' - 1
		rename `x' cpi`j'
	}
	loc i = `i' + 1
}

keep year cpi1-cpi12

reshape long cpi, i(year) j(month)  

collapse (mean)cpi, by(year)

keep year cpi
sum cpi if year == 2022
replace cpi = cpi / r(mean)*100

save "$wdata/CPI.dta", replace
