if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

foreach x in  xml 2324{ //
	clear
	import delim "$rdata/Form990/propublica/form990_ScheduleD_`x'.csv", clear

	foreach var of varlist _all{
		cap replace `var' = "" if `var' == "NA"
		destring `var', replace
	}
	
	save "$wdata/Form990/Form990_ScheduleD_`x'.dta", replace
}

clear
use "$wdata/Form990/Form990_ScheduleD_xml.dta", clear
ap using "$wdata/Form990/Form990_ScheduleD_2324.dta", force

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

rename investmentearningsorlossesamtpre investmentearningspre1
rename v17 investmentearningspre2
rename v18 investmentearningspre3
rename v19 investmentearningspre4

keep ein year beginningyearbalanceamt* contributionsamt* investmentearnings* grantsorscholarshipsamt* otherexpendituresamt* administrativeexpensesamt* endyearbalanceamt*

reshape long beginningyearbalanceamt contributionsamt investmentearnings grantsorscholarshipsamt otherexpendituresamt administrativeexpensesamt endyearbalanceamt, i(ein year) j(recordyr) string

replace record = subinstr(record,"pre","",.)
destring record, replace
drop if beginningyearbalanceamt == .

rename year datayear
gen year = datayear - record

order datayear year
sort ein year datayear
duplicates drop ein year, force //for multiple record, keep the newest one

drop record 

save "$wdata/Form990/Form990_ScheduleD_PriorYear.dta", replace
