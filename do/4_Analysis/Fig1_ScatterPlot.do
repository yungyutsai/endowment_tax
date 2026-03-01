if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
	global figure "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/content/figures"
	global table "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/table"
	global tex "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/content/tables"
	global do "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/do"
	adopath + "$do/ado"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

use "$wdata/endowment_tax_final_sample.dta", clear

keep if year == 2016

cap drop v1
gen v1 = ln(enrollfte)
gen v2 = ln(persendowment)

gen studentabove = enrollfte >= 500
gen endowmentgroup = 0
replace endowmentgroup = 1 if persendowment < 400000 
replace endowmentgroup = 2 if inrange(persendowment,400000,500000)
replace endowmentgroup = 3 if inrange(persendowment,500000,600000)
replace endowmentgroup = 4 if persendowment >= 600000 & persendowment != .


twoway 	(scatteri 17.8 6.24 17.8 11.35 13.18 11.35 13.18 6.24, recast(area) lw(0) fc(maroon*0.3)) ///
		(sc v2 v1 if year == 2016, msize(vsmall) mcolor(gs8)) ///
		(sc v2 v1 if year == 2016 & studentabove == 1 & endowmentgroup >= 3, msize(vsmall) mcolor(maroon)), ///
		xline(6.2146081, lc(black)) yline(13.122363, lc(black)) ///
		scheme(s1color) ///
		xlabel(1.6094379 "5" 3.91 "50" 6.21 "500" 8.52 "5K" 10.82 "50K") ///
		ylabel(-.69 "0.5" 1.61 "5" 3.91 "50" 6.21 "500" 8.52 "5K" 10.82 "50K" 13.12 "500K" 15.42 "5M" 17.73 "50M", angle(0)) ///
		legend(off) ///
		xtitle(Student Enrollment (log scale)) ytitle(Endowment Assets Per-student (log scale)) ///
		text(15.8 8.8 "Subjected to the Tax", color(maroon))
graph export "$figure/Fig1.jpg", as(jpg) replace
