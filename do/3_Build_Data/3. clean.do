if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

use "$wdata/IPEDS_Form990_2010to2022.dta", clear

global func1 = "instruction research pubservice acsupport stuservice inssupport auxiliary hospital indope"
global var1 = "exptot_IPEDS"
foreach y in $func1{
	global var1 = "$var1 exp`y'tot_IPEDS exp`y'sal_IPEDS exp`y'nos_IPEDS"
}
global func2 = "tot tuition auxiliary giftpri conaff gcpri gcst appst investment"
global var2 = ""
foreach y in $func2{
	global var2 = "$var2 rev`y'_IPEDS"
}

global var3 = "expstdgrant_IPEDS"
global var4 = "netass_IPEDS netassunres_IPEDS netassres_IPEDS asstot_IPEDS liatot_IPEDS asscapital_IPEDS assinvestment_IPEDS endowmenteoy_IPEDS tuition3 fee3 hrchg3 tuition7 fee7 hrchg7 chg5ay3"
global var5 = "uagrntn uagrntp upgrntn upgrntp ufloann ufloanp igrnt_n igrnt_p whit bkaa hisp asia nhpi aian tmor nral inc0 inc1 inc2 inc3 inc4"
global var6 = "netass_990 netassunres_990 netassres_990 endowmenteoy_990 boarddesignated_990 perendowment_990 temendowment_990"

global var = "$var1 $var2 $var3 $var4 $var5 $var6"

sort unitid year

* Rename variable
rename fte2mor ftetmor
foreach x in whit bkaa hisp asia nhpi aian tmor nral{
	rename fte`x' `x'
}

* Calculate non-sal spending
foreach y in $func1{
	gen exp`y'nos_IPEDS = exp`y'tot_IPEDS - exp`y'sal_IPEDS
	order exp`y'nos_IPEDS, a(exp`y'sal_IPEDS)
}

* Income proportion
forv i = 0(1)4{
	gen inc`i' = priinc`i' / priinctot
}

format $var %15.0fc
format $var5 %4.3fc

** Change region iclevel and locale to time invariant
sort unitid year
foreach x in fips obereg iclevel locale carnegie{
	by unitid: replace `x' = `x'[_n-1] if _n > 1
}

recode carnegie -3=-2

sort unitid year
merge m:1 year using "$wdata/CPI.dta"
drop if _m == 2
drop _m

foreach x in exptot_IPEDS expinstructiontot_IPEDS expresearchtot_IPEDS exppubservicetot_IPEDS expauxiliarytot_IPEDS expstuservicetot_IPEDS expacsupporttot_IPEDS expinssupporttot_IPEDS expotherfunctiontot_IPEDS expnetgrantsal_IPEDS exphospitaltot_IPEDS expindopetot_IPEDS{
	recode `x' . = 0
}
 
gen exptot = exptot_IPEDS
gen expins = expinstructiontot_IPEDS 
gen expres = expresearchtot_IPEDS
gen exppub = exppubservicetot_IPEDS
gen expgrt = expnetgrantsal_IPEDS
gen expaux = expauxiliarytot_IPEDS
gen expser = expstuservicetot_IPEDS
gen expacs = expacsupporttot_IPEDS
gen expisp = expinssupporttot_IPEDS
gen exphos = exphospitaltot_IPEDS
gen expind = expindopetot_IPEDS
gen expoth = expotherfunctiontot_IPEDS

gen expgrtend = abs(endowmentgrants_990)
recode expgrtend . = 0

foreach x in endowmentgrants_990 endowmentotherexp_990 endowmentadminexp_990{
	recode `x' . = 0
}
gen expend = abs(endowmentgrants_990) + abs(endowmentotherexp_990) + abs(endowmentadminexp_990)


foreach x in revtot_IPEDS revtuition_IPEDS revauxiliary_IPEDS revconaff_IPEDS revggcpri_IPEDS revgcfed_IPEDS revgcst_IPEDS revgcloc_IPEDS revappfed_IPEDS revappst_IPEDS revapploc_IPEDS revhospital_IPEDS revindope_IPEDS reveduservice_IPEDS revother_IPEDS revinvestment_IPEDS{
	recode `x' . = 0
}
 
gen revtot = revtot_IPEDS 
gen revtui = revtuition_IPEDS  
gen revaux = revauxiliary_IPEDS 
gen revpri = revgiftpri_IPEDS + revconaff_IPEDS + revggcpri_IPEDS
gen revgov = revgcfed_IPEDS + revgcst_IPEDS + revgcloc_IPEDS + revappfed_IPEDS + revappst_IPEDS + revapploc_IPEDS
gen revhos = revhospital_IPEDS
gen revind = revindope_IPEDS
gen revedu = reveduservice_IPEDS
gen revinv = revinvestment_IPEDS
gen revoth = revother_IPEDS

gen endowment = endowmenteoy_IPEDS
replace endowment = endowmenteoy_990 if endowment == .
recode endowment . = 0

gen persendowment = endowment / enrollfte

gen netass = netass_IPEDS
gen unrass = netassunres_IPEDS
gen resass = netassres_IPEDS
gen asstot = asstot_IPEDS
gen liatot = liatot_IPEDS
gen asscap = asscapital_IPEDS
gen assinv = assinvestment_IPEDS
gen assother_IPEDS = asstot_IPEDS - asscapital_IPEDS - assinvestment_IPEDS
replace assother_IPEDS = 0 if assother_IPEDS < 0
gen assoth = assother_IPEDS

gen quaendowment = boarddesignated_990 * endowmenteoy_990
gen perendowment = perendowment_990 * endowmenteoy_990
gen temendowment = temendowment_990 * endowmenteoy_990

replace quaendowment = 0 if boarddesignated_990 == . & endowmenteoy_990 != .
replace perendowment = 0 if perendowment_990 == . & endowmenteoy_990 != .
replace temendowment = 0 if temendowment_990 == . & endowmenteoy_990 != .

foreach x in fee3 hrchg3 fee7 hrchg7{
	recode `x' . = 0
}
gen totcharge3 = tuition3 + fee3
gen totcharge7 = tuition7 + fee7

cap drop v1
foreach x in 	exptot expins expres exppub expgrt expaux expser expacs expisp exphos expind expoth expgrtend expend ///
				revtot revtui revaux revpri revgov revhos revind revedu revinv revoth ///
				enrollfte enrollft enrollpt enrollufte enrollgfte ///
				efteug eftegd ftetotl fteunkn fteug ftegd ftedpp fte ///
				endowment persendowment ///
				quaendowment perendowment temendowment ///
				netass unrass resass asstot liatot asscap assinv assoth ///
				tuition2 tuition3 fee3 hrchg3 tuition6 tuition7 fee7 hrchg7 chg5ay3 totcharge3 totcharge7 ///
				whit bkaa hisp asia nhpi aian tmor nral ///
				uagrntn upgrntn ufloann igrnt_n ///
				{
	
	egen count = count(`x'), by(unitid)
	sum count
	//replace `x' = . if count != r(max)
	drop count
	gen zero = `x'==0
	egen count = sum(zero), by(unitid)
	//replace `x' = . if count == 13
	drop zero count
	gen ln`x' = ln(`x'+1)
	replace ln`x' = 0 if `x' < 0
}

recode excise . = 0 if year >= 2018
recode endowment . = 0
gen endowmentpers = endowment / enrollfte
gen a = endowmentpers if year == 2016
egen endowmentpers2016 = mean(a), by(unitid)
drop a
gen a = enrollfte if year == 2016
egen enrollfte2016 = mean(a), by(unitid)
drop a

gen lnendowmentpers = ln(endowmentpers+1)
replace lnendowment = ln(endowment+1)
replace lnenrollfte = ln(enrollfte+1)

recode carnegie 10/19=1 20/29=2 30/39=3 40/49=4 50/69=5 -2=5

gen endowment_payout = 0
foreach x in endowmentexp_990 endowmentgrants_990 endowmentotherexp_990 endowmentadminexp_990{
	replace endowment_payout = endowment_payout + abs(`x')
}
gen lnendowment_payout = ln(endowment_payout+1)
gen endowment_payout_rate = endowment_payout / endowmentboy_990
recode endowment_payout_rate . = 0

gen region = ""
replace region = "West" if stabbr == "AK"
replace region = "South" if stabbr == "AL"
replace region = "South" if stabbr == "AR"
replace region = "West" if stabbr == "AZ"
replace region = "West" if stabbr == "CA"
replace region = "West" if stabbr == "CO"
replace region = "Northeast" if stabbr == "CT"
replace region = "South" if stabbr == "DC"
replace region = "South" if stabbr == "DE"
replace region = "South" if stabbr == "FL"
replace region = "South" if stabbr == "GA"
replace region = "West" if stabbr == "HI"
replace region = "Midwest" if stabbr == "IA"
replace region = "West" if stabbr == "ID"
replace region = "Midwest" if stabbr == "IL"
replace region = "Midwest" if stabbr == "IN"
replace region = "Midwest" if stabbr == "KS"
replace region = "South" if stabbr == "KY"
replace region = "South" if stabbr == "LA"
replace region = "Northeast" if stabbr == "MA"
replace region = "South" if stabbr == "MD"
replace region = "Northeast" if stabbr == "ME"
replace region = "Midwest" if stabbr == "MI"
replace region = "Midwest" if stabbr == "MN"
replace region = "Midwest" if stabbr == "MO"
replace region = "South" if stabbr == "MS"
replace region = "West" if stabbr == "MT"
replace region = "South" if stabbr == "NC"
replace region = "Midwest" if stabbr == "ND"
replace region = "Midwest" if stabbr == "NE"
replace region = "Northeast" if stabbr == "NH"
replace region = "Northeast" if stabbr == "NJ"
replace region = "West" if stabbr == "NM"
replace region = "West" if stabbr == "NV"
replace region = "Northeast" if stabbr == "NY"
replace region = "Midwest" if stabbr == "OH"
replace region = "South" if stabbr == "OK"
replace region = "West" if stabbr == "OR"
replace region = "Northeast" if stabbr == "PA"
replace region = "Northeast" if stabbr == "RI"
replace region = "South" if stabbr == "SC"
replace region = "Midwest" if stabbr == "SD"
replace region = "South" if stabbr == "TN"
replace region = "South" if stabbr == "TX"
replace region = "West" if stabbr == "UT"
replace region = "South" if stabbr == "VA"
replace region = "Northeast" if stabbr == "VT"
replace region = "West" if stabbr == "WA"
replace region = "Midwest" if stabbr == "WI"
replace region = "South" if stabbr == "WV"
replace region = "West" if stabbr == "WY"
replace region = "Other" if stabbr == "PR" | stabbr == "GU"

encode region, gen(region_cd)
drop region
rename region region
order region, a(stabbr)

gen wealthy = endowmentpers2016 >= 500000
gen large = enrollfte2016 >= 500
gen post = year > 2017 if year != 2017 //set post to be missing for year 2017

foreach x in exptot expins expres exppub expgrt expaux expser expacs expisp exphos expind expoth expgrtend expend revtot revtui revaux revpri revgov revhos revind revedu revinv revoth{
	replace `x' = `x' / cpi * 100
	gen `x'pers = `x' / enrollfte
	gen ln`x'pers = ln(`x'pers+1)
	replace ln`x'pers = 0 if `x' < 0
}

foreach x in tuition2 tuition3 fee3 hrchg3 tuition6 tuition7 fee7 hrchg7 chg5ay3{
	replace `x' = `x' / cpi * 100
	cap drop ln`x'
	gen ln`x' = ln(`x'+1)
}

forv i = 2010(1)2022{
	gen LargeWealthy`i' = large == 1 & wealthy == 1 & year == `i'
}
drop LargeWealthy2016

gen LargeWealthyPost = large == 1 & wealthy == 1 & post == 1 if year != 2017

cap drop v1
gen v1 = year if excisetax_990 == 1
egen tryear = min(v1), by(unitid)

save "$wdata/endowment_tax_final_sample.dta", replace

use "$wdata/endowment_tax_final_sample.dta", clear

unique unitid
unique unitid if tryear != 2018 & tryear != .

tab instnm if tryear != 2018 & tryear != .

drop if tryear != 2018 & tryear != .
unique unitid

//unique unitid if large == 1 & wealthy == 1 & tryear != 2018

unique unitid if (large != 1 | wealthy != 1) & tryear != .
unique unitid if (large == 1 & wealthy == 1) & tryear == .

tab instnm if ((large != 1 | wealthy != 1) & tryear != .) | ((large == 1 & wealthy == 1) & tryear == .)

drop if (large != 1 | wealthy != 1) & tryear != .
drop if (large == 1 & wealthy == 1) & tryear == .
unique unitid

save "$wdata/endowment_tax_main_sample.dta", replace
