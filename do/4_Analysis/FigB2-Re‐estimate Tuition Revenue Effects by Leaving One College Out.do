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

clear

gen dropid = ""
gen depvar = ""

save "$wdata/FigB2.dta", replace

use "$wdata/endowment_tax_main_sample.dta", clear

levelsof unitid if wealthy == 1, local(idlist)

loc i = 1
foreach x of local idlist{
foreach y in revtui revtuipers{
	
	if `i' == 1 {
		dis "Estimation (110)"
		dis "----+--- 1 ---+--- 2 ---+--- 3 ---+--- 4 ---+--- 5"
	}
	_dots `i' 0
	loc i = `i'+1
	
	qui{
	reghdfe ln`y' LargeWealthyPost if unitid != `x', a(large#year wealthy#year unitid) cl(unitid)
	parmest , saving("$wdata/FigB2_temp.dta", replace) idstr("`y',ddd") idnum(`x')
	
	preserve
	use "$wdata/FigB2.dta", clear
	ap using "$wdata/FigB2_temp.dta"
	save "$wdata/FigB2.dta", replace
	restore
	
	reghdfe ln`y' LargeWealthy20* if unitid != `x', a(large#year wealthy#year unitid) cl(unitid)
	parmest , saving("$wdata/FigB2_temp.dta", replace) idstr("`y',eventstudy") idnum(`x')
	
	preserve
	use "$wdata/FigB2.dta", clear
	ap using "$wdata/FigB2_temp.dta"
	save "$wdata/FigB2.dta", replace
	restore
	}
}
}


use "$wdata/FigB2.dta", clear

drop if parm == "_cons"

replace depvar = substr(idstr,1,strpos(idstr,",")-1)
gen year = substr(parm,13,4)
destring year, replace force

sort depvar parm estimate

by depvar parm: gen id = _n


twoway 	(sc estimate id if parm == "LargeWealthyPost" & depvar == "revtui", color(black)) ///
		(rcap max95 min95 id if parm == "LargeWealthyPost" & depvar == "revtui", color(black)) , ///
		legend(off) ///
		ylabel(0(0.2)1, angle(0) format(%4.1f)) ///
		ytitle(Estimated Effect) ///
		scheme(s1color) xtitle("") ///
		xscale(range(0 56)) xlabel(0(10)50,nolabels)
graph export "$figure/FigB2_revtui.jpg", as(jpg) replace


twoway 	(sc estimate id if parm == "LargeWealthyPost" & depvar == "revtuipers", color(black)) ///
		(rcap max95 min95 id if parm == "LargeWealthyPost" & depvar == "revtuipers", color(black)) , ///
		legend(off) ///
		ylabel(0(0.2)1, angle(0) format(%4.1f)) ///
		ytitle(Estimated Effect) ///
		scheme(s1color) xtitle("") ///
		xscale(range(0 56)) xlabel(0(10)50,nolabels)
graph export "$figure/FigB2_revtuipers.jpg", as(jpg) replace


levelsof idn, local(idlist) clean

local code ""
foreach x of local idlist {
    local code "`code' (line estimate year if idn == `x' & depvar == "revtui", color(gs8))"
}

twoway `code', ///
    legend(off) ///
    ylabel(0(0.1)0.2, angle(0) format(%4.1f)) ///
    ytitle(Estimated Effect) ///
    scheme(s1color) yline(0, lc(black)) xline(2016.5, lc(black)) ///
    xlabel(2010(1)2022) xtitle(Year)

graph export "$figure/FigB2b_revtuipers.jpg", as(jpg) replace
