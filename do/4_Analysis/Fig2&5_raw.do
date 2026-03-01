if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
	global figure "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/content/figures"
	global table "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/table"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
	global figure "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/figure"
	global table "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/table"
}
graph set eps fontface Times

use "$wdata/endowment_tax_main_sample.dta", clear

collapse (mean)lnexptot lnexptotpers lnrevtot lnrevtotpers lnrevtui lnrevtuipers lntuition3 lntuition7 lnenrollfte, by(wealthy large year)

foreach x in lnenrollfte /*lnexptot lnexptotpers lnrevtot lnrevtotpers*/ { 
	loc ylabel = ", format(%4.1f)"
	if ("`x'"=="lnexptot") loc ylabel = "-0.3(0.1)0.3, format(%4.1f)"
	if ("`x'"=="lnexptotpers") loc ylabel = "-0.25(0.05)0.15, format(%4.2f)"
	if ("`x'"=="lnrevtot") loc ylabel = "-7(1)1, format(%4.0f)"
	if ("`x'"=="lnrevtotpers") loc ylabel = "-5(1)1, format(%4.0f)"
	if ("`x'"=="lnenrollfte") loc ylabel = "-0.10(0.02)0.12, format(%4.2f)"
 
	forv i = 0(1)1{
	forv j = 0(1)1{
		sum `x' if year == 2016 & large == `i' & wealthy == `j'
		replace `x' = `x' - r(mean) if large == `i' & wealthy == `j'
	}
	}

	twoway 	(line `x' year if large == 1 & wealthy == 0, lp(dash) lc(navy)) ///
			(line `x' year if large == 1 & wealthy == 1, lw(medthick) lc(maroon)), ///
			xline(2016, lc(black)) scheme(s1color) xlabel(2010(1)2022) ///
			ylabel(`ylabel' angle(0)) ///
			legend(order(2 "Large & Wealthy" 1 "Large & Non-Wealthy") symx(8)) ///
			ytitle(Change from Pre-treatment Period) xtitle(Academic Year)
		
	graph export "$figure/Fig2_large_`x'.jpg", as(jpg) replace
	
	twoway 	(line `x' year if large == 0 & wealthy == 0, lp(dash) lc(navy)) ///
			(line `x' year if large == 0 & wealthy == 1, lw(medthick) lc(maroon)), ///
			xline(2016, lc(black)) scheme(s1color) xlabel(2010(1)2022) ///
			ylabel(`ylabel' angle(0)) ///
			legend(order(2 "Small & Wealthy" 1 "Small & Non-Wealthy") symx(8)) ///
			ytitle(Change from Pre-treatment Period) xtitle(Academic Year)
		
	graph export "$figure/Fig2_small_`x'.jpg", as(jpg) replace
}

keep year wealthy large lnexptot lnexptotpers lnrevtot lnrevtotpers lnenrollfte
reshape wide lnexptot lnexptotpers lnrevtot lnrevtotpers lnenrollfte, i(large year) j(wealthy)

foreach x in enrollfte /*exptot exptotpers revtot revtotpers*/ { 
	loc yf = "format(%4.2f)"
	if ("`x'"=="revtot") loc yf = "format(%4.0f)"
	if ("`x'"=="revtotpers") loc yf = "format(%4.0f)"
	if ("`x'"=="enrollfte") loc yf = "format(%4.1f)"

	cap gen `x' = ln`x'1 - ln`x'0
	forv i = 0(1)1{
		sum `x' if year == 2016 & large == `i'
		replace `x' = `x' - r(mean) if large == `i'
	}
	
	twoway 	(line `x' year if large == 0, lp(dash) lc(navy)) ///
			(line `x' year if large == 1, lw(medthick) lc(maroon)), ///
			xline(2016, lc(black)) scheme(s1color) xlabel(2010(1)2022) ///
			ylabel(, angle(0) `yf') ///
			legend(order(2 "Large (Diff in Wealthy and Non-wealthy)" ///
			1 "Small (Diff in Wealthy and Non-wealthy)") symx(6) size(small)) ///
			ytitle(Change from Pre-treatment Period) xtitle(Academic Year)
		
	graph export "$figure/Fig2_ddd_`x'.jpg", as(jpg) replace
}
