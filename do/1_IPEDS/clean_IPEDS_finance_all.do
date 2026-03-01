if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}


forv i = 2004(1)2023{
	loc j = `i' - 1
	import delimited "$rdata/IPEDS/flags`i'.csv", clear
	keep unitid fybeg fyend
	gen year = `j'
	order year
	save "$wdata/IPEDS/fy`j'.dta", replace //Use the start year to define year
}

** Public
forv i = 2000(1)2021{
	loc j = `i' - 1
	loc x = substr("`i'",-2,2)
	loc y = substr("`j'",-2,2)
	loc z = "`y'" + "`x'"
	
	import delimited "$rdata/IPEDS/f`z'_f1a.csv", clear
	
	cap gen revtot = f1d01
	cap gen revtot = j083 //for Year 1999-2000
	cap gen revprigift = f1b16
	cap gen revprigift = a093 //for Year 1999-2000	
	cap gen revcontract = f1b04b
	cap gen revtuition = f1b01
	cap gen revtuition = a013 //for Year 1999-2000	
	cap gen revauxiliary = f1b05
	cap gen revauxiliary = a123 //for Year 1999-2000	
	cap gen reveduservice = f1b26
	cap gen reveduservice = a113 //for Year 1999-2000	
	cap gen revhospital = f1b06
	cap gen revhospital = a133 //for Year 1999-2000	
	cap gen exptot = f1c191
	cap gen exptot = b123 //for Year 1999-2000	
	cap gen expstdgrant = f1e05+f1e06
	cap gen expstdgrant = b093 //for Year 1999-2000	
	cap gen expinsgrantrestricted = f1e05
	cap gen expinsgrantunrestricted = f1e06
	cap gen expsalben = f1c192+f1c193
	cap gen expsalben = b274 //for Year 1999-2000	
	cap gen expsal = f1c192
	cap gen expsal = b234 //for Year 1999-2000	
	cap gen expbenefit = f1c193
	cap gen expbenefit = b244 //for Year 1999-2000	
	cap gen expinstructiontot = f1c011
	cap gen expinstructiontot = b013 //for Year 1999-2000	
	cap gen expinstructionsal = f1c012
	cap gen expresearchtot = f1c021
	cap gen expresearchtot = b023 //for Year 1999-2000
	cap gen expresearchsal = f1c022
	cap gen exppubservicetot = f1c031
	cap gen exppubservicetot = b033 //for Year 1999-2000	
	cap gen exppubservicesal = f1c032
	cap gen expacsupporttot = f1c051
	cap gen expacsupporttot = b043 //for Year 1999-2000
	cap gen expacsupportsal = f1c052
	cap gen expstuservicetot = f1c061
	cap gen expstuservicetot = b063 //for Year 1999-2000
	cap gen expstuservicesal = f1c062
	cap gen expinssupporttot = f1c071
	cap gen expinssupporttot = b073 //for Year 1999-2000
	cap gen expinssupportsal = f1c072
	cap gen expauxiliarytot = f1c111
	cap gen expauxiliarytot = b133 //for Year 1999-2000	
	cap gen expauxiliarysal = f1c112
	cap gen expnetgrant = f1c101
	cap gen expnetgrant = b093 //for Year 1999-2000	
	cap gen exphospitaltot = f1c121
	cap gen exphospitaltot = b163 //for Year 1999-2000	
	cap gen exphospitalsal = f1c122
	cap gen asstot = f1a06
	cap gen liatot = f1a13
	cap gen netassboy = f2b05
	cap gen netass = f1a18
	
	cap gen land = f1a214
	cap gen building = f1a234
	cap gen equipment = f1a324
	cap gen construction = f1a274
	cap gen othercapital = f1a344
	cap gen investment = f2a01
	cap gen intangible = f1a334
	cap gen liabilities = f1a13
	
	cap lab var revtot "Total revenues and investment return - Total"
	cap lab var revprigift "Gifts, including contributions from affiliated organizations"
	cap lab var revcontract "Total grants and contracts"
	cap lab var revtuition "Tuition and fees - Total"
	cap lab var revauxiliary "Sales and services of auxiliary enterprises - Total"
	cap lab var reveduservice "Sales and services of educational activities - Total"
	cap lab var revhospital "Hospital revenue - Total"
	cap lab var exptot "Total expenses-Total amount"
	cap lab var expstdgrant "Institution grants"
	cap lab var expinsgrantrestricted "Institutional grants (restricted)"
	cap lab var expinsgrantunrestricted "Institutional grants (unrestricted)"
	cap lab var expsalben "Total expenses-Salaries, wages, and Benefits"
	cap lab var expsal "Total expenses-Salaries and wages"
	cap lab var expbenefit "Total expenses-Benefits"
	cap lab var expinstructiontot "Instruction-Total amount"
	cap lab var expinstructionsal "Instruction-Salaries and wages"
	cap lab var expresearchtot "Research-Total amount"
	cap lab var expresearchsal "Research-Salaries and wages"
	cap lab var exppubservicetot "Public service-Total amount"
	cap lab var exppubservicesal "Public service-Salaries and wages"
	cap lab var expacsupporttot "academic support-Total amount"
	cap lab var expacsupportsal "academic support-Salaries and wages"
	cap lab var expstuservicetot "Student service-Total amount"
	cap lab var expstuservicesal "Student service-Salaries and wages"
	cap lab var expinssupporttot "Institutional support-Total amount"
	cap lab var expinssupportsal "Institutional support-Salaries and wages"
	cap lab var expauxiliarytot "auxiliary enterprises-Total amount"
	cap lab var expauxiliarysal "auxiliary enterprises-Salaries and wages"
	cap lab var expnetgrant "Net grant aid to students-Total amount"
	cap lab var exphospitaltot "Hospital services-Total amount"
	cap lab var exphospitalsal "Hospital services-Salaries and wages"
	cap lab var asstot "Total assets"
	cap lab var liatot "Total liabilities"
	cap lab var netass "Net assets, end of the year"
	
	gen type = 1
	gen year = `j'
	order year type 
	cap drop f1* 
	cap drop xf*
	cap drop xa013-k035

	save "$wdata/IPEDS/finance_public_`j'.dta", replace
}

** Private non-profit
forv i = 2000(1)2021{
	loc j = `i' - 1
	loc x = substr("`i'",-2,2)
	loc y = substr("`j'",-2,2)
	loc z = "`y'" + "`x'"
	
	import delimited "$rdata/IPEDS/f`z'_f2.csv", clear
	
	cap gen revtot = f2d16
	cap gen revprigift = f2d08a
	cap gen revcontract = f2d08b
	cap gen revtuition = f2d01
	cap gen revauxiliary = f2d12
	cap gen reveduservice = f2d11
	cap gen revhospital = f2d13
	cap gen exptot = f2e131
	cap gen expstdgrant = f2c05+f2c06
	cap gen expinsgrantfunded = f2c05
	cap gen expinsgrantunfunded = f2c06
	cap gen expsalben = f2e132+f2e133
	cap gen expsal = f2e132
	cap gen expbenefit = f2e133
	cap gen expinstructiontot = f2e011
	cap gen expinstructionsal = f2e012
	cap gen expresearchtot = f2e021
	cap gen expresearchsal = f2e022
	cap gen exppubservicetot = f2e031
	cap gen exppubservicesal = f2e032
	cap gen expacsupporttot = f2e041
	cap gen expacsupportsal = f2e042
	cap gen expstuservicetot = f2e051
	cap gen expstuservicesal = f2e052
	cap gen expinssupporttot = f2e061
	cap gen expinssupportsal = f2e062
	cap gen expauxiliarytot = f2e071
	cap gen expauxiliarysal = f2e072
	cap gen expnetgrant = f2e081
	cap gen exphospitaltot = f2e091
	cap gen exphospitalsal = f2e092
	cap gen asstot = f2a02
	cap gen liatot = f2a03
	cap gen netass = f2b07
	cap gen land = f2a11
	cap gen building = f2a12
	cap gen equipment = f2a13
	cap gen construction = f2a15
	cap gen othercapital = f2a16
	cap gen investment = f2a01
	cap gen intangible = f2a20
	cap gen liabilities = f2a03
	
	cap lab var revtot "Total revenues and investment return - Total"
	cap lab var revprigift "Private gifts - Total"
	cap lab var revcontract "Private grants and contracts - Total"
	cap lab var revtuition "Tuition and fees - Total"
	cap lab var revauxiliary "Sales and services of auxiliary enterprises - Total"
	cap lab var reveduservice "Sales and services of educational activities - Total"
	cap lab var revhospital "Hospital revenue - Total"
	cap lab var revindope "Independent operations revenue - Total"
	cap lab var exptot "Total expenses-Total amount"
	cap lab var expstdgrant "Institution grants"
	cap lab var expinsgrantfunded "Institutional grants (funded)"
	cap lab var expinsgrantunfunded "Institutional grants (unfunded)"
	cap lab var expsalben "Total expenses-Salaries, wages, and Benefits"
	cap lab var expsal "Total expenses-Salaries and wages"
	cap lab var expbenefit "Total expenses-Benefits"
	cap lab var expinstructiontot "Instruction-Total amount"
	cap lab var expinstructionsal "Instruction-Salaries and wages"
	cap lab var expresearchtot "Research-Total amount"
	cap lab var expresearchsal "Research-Salaries and wages"
	cap lab var exppubservicetot "Public service-Total amount"
	cap lab var exppubservicesal "Public service-Salaries and wages"
	cap lab var expacsupporttot "academic support-Total amount"
	cap lab var expacsupportsal "academic support-Salaries and wages"
	cap lab var expstuservicetot "Student service-Total amount"
	cap lab var expstuservicesal "Student service-Salaries and wages"
	cap lab var expinssupporttot "Institutional support-Total amount"
	cap lab var expinssupportsal "Institutional support-Salaries and wages"
	cap lab var expauxiliarytot "auxiliary enterprises-Total amount"
	cap lab var expauxiliarysal "auxiliary enterprises-Salaries and wages"
	cap lab var expnetgrant "Net grant aid to students-Total amount"
	cap lab var exphospitaltot "Hospital services-Total amount"
	cap lab var exphospitalsal "Hospital services-Salaries and wages"
	cap lab var asstot "Total assets"
	cap lab var liatot "Total liabilities"
	cap lab var netass "Net assets, end of the year"
	
	gen type = 2
	gen year = `j'
	order year type 
	cap drop f2* 
	cap drop xf*
	
	save "$wdata/IPEDS/finance_nonprofit_`j'.dta", replace
}


forv i = 2000(1)2021{
	loc j = `i' - 1
	loc x = substr("`i'",-2,2)
	loc y = substr("`j'",-2,2)
	loc z = "`y'" + "`x'"
	
	import delimited "$rdata/IPEDS/f`z'_f3.csv", clear
	
	cap gen revtot = f3g02
	cap gen revtot = f3b01 //Early year
	
	cap gen revprigiftcontract = f3d04
	cap gen revtuition = f3d01
	cap gen revauxiliary = f3d07
	cap gen reveduservice = f3d06
	cap gen revhospital = f3d12
	cap gen exptot = f3b02
	cap gen expsalben = f3e072+f3e073
	cap gen expsal = f3e072
	cap gen expbenefit = f3e073
	cap gen expinstructiontot = f3e011
	cap gen expinstructiontot = f3e01 //Early year
	cap gen expinstructionsal = f3e012
	cap gen expresearchtot = f3e02a1
	cap gen expresearchtot = f3e02 //Early year (research + public service)
	
	cap gen expresearchsal = f3e02a2
	cap gen exppubservicetot = f3e02b1
	cap gen exppubservicesal = f3e02b2
	cap gen expacsupporttot = f3e03a1
	cap gen expacsupporttot = f3e03 //Early year (aC sup. + Inst. sup. + Stu. Sev.)
	
	cap gen expacsupportsal = f3e03a2
	cap gen expstuservicetot = f3e03b1
	cap gen expstuservicesal = f3e03b2
	cap gen expinssupporttot = f3e03c1
	cap gen expinssupportsal = f3e03c2
	cap gen expauxiliarytot = f3e041
	cap gen expauxiliarytot = f3e04 //Early year
	
	cap gen expauxiliarysal = f3e042
	cap gen expnetgrant = f3e051
	cap gen exphospitaltot = f3e101
	cap gen exphospitalsal = f3e102
	cap gen asstot = f3a01
	cap gen liatot = f3a02
	cap gen netass = f2b07
	
	cap lab var revtot "Total revenues and investment return - Total"
	cap lab var revprigiftcontract "Private gifts, grants and contracts - Total"
	cap lab var revprigift "Private gifts - Total"
	cap lab var revcontract "Private grants and contracts - Total"
	cap lab var revtuition "Tuition and fees - Total"
	cap lab var revauxiliary "Sales and services of auxiliary enterprises - Total"
	cap lab var reveduservice "Sales and services of educational activities - Total"
	cap lab var revhospital "Hospital revenue - Total"
	cap lab var revindope "Independent operations revenue - Total"
	cap lab var exptot "Total expenses-Total amount"
	cap lab var expstdgrant "Institution grants"
	cap lab var expinsgrantfunded "Institutional grants (funded)"
	cap lab var expinsgrantunfunded "Institutional grants (unfunded)"
	cap lab var expsalben "Total expenses-Salaries, wages, and Benefits"
	cap lab var expsal "Total expenses-Salaries and wages"
	cap lab var expbenefit "Total expenses-Benefits"
	cap lab var expinstructiontot "Instruction-Total amount"
	cap lab var expinstructionsal "Instruction-Salaries and wages"
	cap lab var expresearchtot "Research-Total amount"
	cap lab var expresearchsal "Research-Salaries and wages"
	cap lab var exppubservicetot "Public service-Total amount"
	cap lab var exppubservicesal "Public service-Salaries and wages"
	cap lab var expacsupporttot "academic support-Total amount"
	cap lab var expacsupportsal "academic support-Salaries and wages"
	cap lab var expstuservicetot "Student service-Total amount"
	cap lab var expstuservicesal "Student service-Salaries and wages"
	cap lab var expinssupporttot "Institutional support-Total amount"
	cap lab var expinssupportsal "Institutional support-Salaries and wages"
	cap lab var expauxiliarytot "auxiliary enterprises-Total amount"
	cap lab var expauxiliarysal "auxiliary enterprises-Salaries and wages"
	cap lab var expnetgrant "Net grant aid to students-Total amount"
	cap lab var exphospitaltot "Hospital services-Total amount"
	cap lab var exphospitalsal "Hospital services-Salaries and wages"
	cap lab var asstot "Total assets"
	cap lab var liatot "Total liabilities"
	cap lab var netass "Net assets, end of the year"
	
	gen type = 3
	gen year = `j'
	order year type 
	cap drop f3* 
	cap drop xf*
	
	save "$wdata/IPEDS/finance_forprofit_`j'.dta", replace
}
