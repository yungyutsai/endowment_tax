if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Library/CloudStorage/Dropbox/02 Research/education/endowment_tax/rdata"
	global wdata "/Users/yungyu/Library/CloudStorage/Dropbox/02 Research/education/endowment_tax/wdata"
	global figure "/Users/yungyu/Library/CloudStorage/Dropbox/02 Research/education/endowment_tax/content/figures"
	global table "/Users/yungyu/Library/CloudStorage/Dropbox/02 Research/education/endowment_tax/table"
	global tex "/Users/yungyu/Library/CloudStorage/Dropbox/02 Research/education/endowment_tax/content/tables"
	global do "/Users/yungyu/Library/CloudStorage/Dropbox/02 Research/education/endowment_tax/do"
	adopath + "$do/ado"
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

foreach x in lnrevtui lnrevtuipers lnexptot lnexptotpers lnrevtot lnrevtotpers lnenrollfte { 
	loc ylabel = ", format(%4.1f)"
	if ("`x'"=="lnexptot") loc ylabel = "-0.3(0.1)0.3, format(%4.1f)"
	if ("`x'"=="lnexptotpers") loc ylabel = "-0.25(0.05)0.15, format(%4.2f)"
	if ("`x'"=="lnrevtot") loc ylabel = "-7(1)1, format(%4.0f)"
	if ("`x'"=="lnrevtotpers") loc ylabel = "-5(1)1, format(%4.0f)"
	if ("`x'"=="lnenrollfte") loc ylabel = "-0.10(0.02)0.12, format(%4.2f)"
	if ("`x'"=="lnrevtui") loc ylabel = "-0.8(0.2)0.2, format(%4.2f)"
	if ("`x'"=="lnrevtuipers") loc ylabel = "-0.8(0.2)0.2, format(%4.1f)"
 
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
		
	graph export "$figure/Fig2_large_`x'.jpg", as(jpg) replace width(2400)
	
	twoway 	(line `x' year if large == 0 & wealthy == 0, lp(dash) lc(navy)) ///
			(line `x' year if large == 0 & wealthy == 1, lw(medthick) lc(maroon)), ///
			xline(2016, lc(black)) scheme(s1color) xlabel(2010(1)2022) ///
			ylabel(`ylabel' angle(0)) ///
			legend(order(2 "Small & Wealthy" 1 "Small & Non-Wealthy") symx(8)) ///
			ytitle(Change from Pre-treatment Period) xtitle(Academic Year)
		
	graph export "$figure/Fig2_small_`x'.jpg", as(jpg) replace width(2400)
}

keep year wealthy large lnexptot lnexptotpers lnrevtot lnrevtotpers lnenrollfte lnrevtui lnrevtuipers
reshape wide lnexptot lnexptotpers lnrevtot lnrevtotpers lnenrollfte lnrevtui lnrevtuipers, i(large year) j(wealthy)

foreach x in revtui revtuipers enrollfte exptot exptotpers revtot revtotpers{ 
	loc yl = "-0.2(0.05)0.2, format(%4.2f)"
	if ("`x'"=="enrollfte")  loc yl = "-0.12(0.04)0.20, format(%4.2f)"
	if ("`x'"=="revtui")     loc yl = "-0.8(0.2)0.4, format(%4.1f)"
	if ("`x'"=="revtuipers") loc yl = "-0.8(0.2)0.4, format(%4.1f)"
	if ("`x'"=="revtot")     loc yl = ", format(%4.0f)"
	if ("`x'"=="revtotpers") loc yl = ", format(%4.0f)"

	cap gen `x' = ln`x'1 - ln`x'0
	forv i = 0(1)1{
		sum `x' if year == 2016 & large == `i'
		replace `x' = `x' - r(mean) if large == `i'
	}
	
	twoway 	(line `x' year if large == 0, lp(dash) lc(navy)) ///
			(line `x' year if large == 1, lw(medthick) lc(maroon)), ///
			xline(2016, lc(black)) scheme(s1color) xlabel(2010(1)2022) ///
			ylabel(`yl' angle(0)) ///
			legend(order(2 "Large (Diff in Wealthy and Non-wealthy)" ///
			1 "Small (Diff in Wealthy and Non-wealthy)") symx(6) size(small)) ///
			ytitle(Change from Pre-treatment Period) xtitle(Academic Year)
		
	graph export "$figure/Fig2_ddd_`x'.jpg", as(jpg) replace width(2400)
}
