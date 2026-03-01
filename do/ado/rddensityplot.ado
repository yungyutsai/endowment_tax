capture program drop rddensityplot
program define rddensityplot, eclass
	syntax anything [if] [, c(real 0) p(integer 4) color(string) barw(real 10) bondu(string) bondl(string) t(string) t2(string) SAVEname(string) Graph_options(string)]
	
	quiet{
	
	** Keep sample
	preserve	
	marksample touse
	keep if `touse'
		
	** Variables
	tokenize "`anything'"
	local depvar `1'
	local runvar `2'

	** default setting
	if ("`color'"=="") local color "gs12"
	
	** estimate the function
	local covlist ""
	gen r = `runvar' - `c' //recneter
	gen abovecutoff = r >= 0
	gen se = .
	gen ciupper = .
	gen cilower = .
	
	if `p' == 0{
		sum `depvar' if abovecutoff == 0
		local bellow = r(mean)
		local FunL "y = `bellow'"
		replace se = r(sd)/sqrt(r(N)-1) if abovecutoff == 0
		replace ciupper = `bellow' + 1.96 * se if abovecutoff == 0
		replace cilower = `bellow' - 1.96 * se if abovecutoff == 0
		
		if "`bondu'" != "" {
			replace ciupper = . if ciupper > `bondu'
			replace cilower = . if cilower > `bondu'
		}
		if "`bondl'" != "" {
			replace ciupper = . if ciupper < `bondl'
			replace cilower = . if cilower < `bondl'
		}
		
		sum `depvar' if abovecutoff == 1
		local above = r(mean)
		local FunR "y = `above'"
		replace se = r(sd)/sqrt(r(N)-1) if abovecutoff == 1
		replace ciupper = `above' + 1.96 * se if abovecutoff == 1
		replace cilower = `above' - 1.96 * se if abovecutoff == 1
		if "`bondu'" != "" {
			replace ciupper = . if ciupper > `bondu'
		}
		if "`bondl'" != "" {
			replace cilower = . if cilower < `bondl'
		}
	}
	if `p' > 0{
		forv i = 1(1)`p'{
			gen r`i' = r^`i'		
			local covlist "`covlist' r`i'"
		}
		reg `depvar' `covlist' if abovecutoff == 0
		local bellow = _b[_cons] //the fitted value of just bellow the cut-off
		local b = `bellow'
		local FunL "y = `b'"
		forv i = 1(1)`p'{
			local b = _b[r`i']
			local FunL "`FunL' + `b' * (x - `c')^`i'"
		}

		predict yhat
		predict yhatse, stdp
		replace se = yhatse if abovecutoff == 0
		replace ciupper = yhat + 1.96 * se if abovecutoff == 0
		replace cilower = yhat - 1.96 * se if abovecutoff == 0
		
		if "`bondu'" != "" {
			replace ciupper = . if ciupper > `bondu'
			replace cilower = . if cilower > `bondu'
		}
		if "`bondl'" != "" {
			replace ciupper = . if ciupper < `bondl'
			replace cilower = . if cilower < `bondl'
		}
		
		drop yhat yhatse
		
		reg `depvar' `covlist' if abovecutoff == 1
		local above = _b[_cons] //the fitted value of just above the cut-off
		local b = `above'
		local FunR "y = `b'"
		forv i = 1(1)`p'{
			local b = _b[r`i']
			local FunR "`FunR' + `b' * (x - `c')^`i'"
		}
		predict yhat
		predict yhatse, stdp
		replace se = yhatse if abovecutoff == 1
		replace ciupper = yhat + 1.96 * se if abovecutoff == 1
		replace cilower = yhat - 1.96 * se if abovecutoff == 1

		if "`bondu'" != "" {
			replace ciupper = . if ciupper > `bondu'
			replace cilower = . if cilower > `bondu'
		}
		if "`bondl'" != "" {
			replace ciupper = . if ciupper < `bondl'
			replace cilower = . if cilower < `bondl'
		}
		
		drop yhat yhatse
	}
	capture drop `covlist' se
		
	** parameters for graphing
	sum `runvar'
	local x_min = r(min)
	local x_max = r(max)
	sum `depvar'
	local y_min = r(min)
	local y_max = r(max)
	local xtitle : variable label `runvar'
	local ytitle : variable label `depvar'
	
	** graphing the figure
	twoway	(bar `depvar' `runvar', barw(`barw') fc(`color') lc(black)) ///
			(function `FunL', ra(`x_min' `c') lc(black) lw(medthick)) /// 
			(function `FunR', ra(`c' `x_max') lc(black) lw(medthick)) ///
			(rline ciupper cilower `runvar' if `runvar' < `c', lc(black) lp(dash) lw(thin)) ///
			(rline ciupper cilower `runvar' if `runvar' >= `c', lc(black) lp(dash) lw(thin)), ///
			yscale(r(`y_min' `y_max')) xscale(r(`x_min' `x_max')) ylabel(, nogrid)  ///
			title("`t'" "`t2'", pos(6) size(medium) c(black)) ///
			ytitle("`ytitle'") xtitle("`xtitle'") legend(off) ///
			xline(`c', lc(black)) ///
			graphregion(fc(white) lc(white) ifc(white) ilc(white)) ///
			plotregion(fc(white) lc(white) ifc(white) ilco(white)) `graph_options'		
	}
	
	** Save the figure (if specified)
	if ("`savename'"~="") {
		graph export "`savename'", as(png) replace
	}
	
	dis `bondu'
	dis `bondl'
	** Restore data
	restore
	
end
