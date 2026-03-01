if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}
foreach x in xml 2324 pdf 2324{
	clear
	import delim "$rdata/Form990/propublica/form990_`x'.csv", clear

	foreach var of varlist _all{
		cap replace `var' = "" if `var' == "NA"
		destring `var', replace
	}
	
	if "`x'" == "xml" | "`x'" == "2324"{
		drop programservicerevenuegrp*
		merge 1:1 ein taxyr returnts using "$wdata/Form990/Form990_ProgramServiceRevenue_`x'.dta", nogen
		order proserrev*, after(totalcontributionsamt)
	}
	
	save "$wdata/Form990/Form990_`x'.dta", replace
}

use "$wdata/Form990/Form990_xml.dta", clear
ap using "$wdata/Form990/Form990_pdf.dta", force
ap using "$wdata/Form990/Form990_2324.dta", force

duplicates drop

gen year = substr(taxperiodbegindt,1,4) //Use the begin year as year
tab year
destring year, replace
replace year = taxyr if year == .

gsort ein taxperiodbegindt taxperiodenddt -returnts
duplicates drop
duplicates t ein taxperiodbegindt taxperiodenddt, gen(dup)
duplicates drop ein taxperiodbegindt taxperiodenddt, force //for multiple record, keep the newest one
drop dup
duplicates t ein year, gen(dup)
duplicates drop ein year, force //for multiple record, keep the newest one
drop dup

save "$wdata/Form990/Form990.dta", replace

use "$wdata/Form990/Form990.dta", clear

keep ein year py* *boy*
rename year datayear
gen year = datayear - 1

foreach x of varlist py*{
	loc varn = "cy" + substr("`x'",3,.)
	rename `x' `varn'
}
foreach x of varlist *boy*{
	loc varn = subinstr("`x'","boy","eoy",.)
	rename `x' `varn'
}

order ein datayear year

save "$wdata/Form990/Form990_PriorYear.dta", replace
