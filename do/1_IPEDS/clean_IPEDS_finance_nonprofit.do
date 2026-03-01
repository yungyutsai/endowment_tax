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

forv i = 2004(1)2022{
	loc j = `i' + 1
	loc x = substr("`i'",-2,2)
	loc y = substr("`j'",-2,2)
	loc z = "`x'" + "`y'"
	
	import delimited "$rdata/IPEDS/f`z'_f2.csv", clear
	
	cap gen revtot_IPEDS = f2d16
	cap gen revconpri_IPEDS = f2d08a
	cap gen revggcpri_IPEDS = f2d08
	cap gen revgiftpri_IPEDS = f2d08a
	cap gen revconaff_IPEDS = f2d09
	cap gen revcongov_IPEDS = f2c01+f2c02+f2c03+f2c04
	cap gen revgrantpell_IPEDS = f2c01
	cap gen revgrantfed_IPEDS = f2c02
	cap gen revgrantst_IPEDS = f2c03
	cap gen revgrantloc_IPEDS = f2c04
	cap gen revtuition_IPEDS = f2d01
	cap gen revauxiliary_IPEDS = f2d12
	cap gen revcontract_IPEDS = f2d05+f2d06+f2d07+f2d08b
	cap gen revgcfed_IPEDS = f2d05
	cap gen revgcst_IPEDS = f2d06
	cap gen revgcloc_IPEDS = f2d07
	cap gen revgcpri_IPEDS = f2d08b
	cap gen revapp_IPEDS = f2d02+f2d03+f2d04
	cap gen revappfed_IPEDS = f2d02
	cap gen revappst_IPEDS = f2d03
	cap gen revapploc_IPEDS = f2d04
	cap gen reveduservice_IPEDS = f2d11
	cap gen revhospital_IPEDS = f2d13
	cap gen revindope_IPEDS = f2d14
	cap gen revother_IPEDS = f2d15
	cap gen revinvestment_IPEDS = f2d10
	cap gen exptot_IPEDS = f2e131
	cap gen netinc_IPEDS = f2d16-f2e131
	cap gen expstdgrant_IPEDS = f2c05+f2c06
	cap gen expinsgrantfunded_IPEDS = f2c05
	cap gen expinsgrantunfunded_IPEDS = f2c06
	cap gen expsalben_IPEDS = f2e132+f2e133
	cap gen expsal_IPEDS = f2e132
	cap gen expbenefit_IPEDS = f2e133
	cap gen expinterest_IPEDS = f2e136
	cap gen expdepreciation_IPEDS = f2e135
	cap gen expoperation_IPEDS = f2e134
	cap gen expotherobject_IPEDS = f2e137
	cap gen expinstructiontot_IPEDS = f2e011
	cap gen expinstructionsal_IPEDS = f2e012
	cap gen expresearchtot_IPEDS = f2e021
	cap gen expresearchsal_IPEDS = f2e022
	cap gen exppubservicetot_IPEDS = f2e031
	cap gen exppubservicesal_IPEDS = f2e032
	cap gen expacsupporttot_IPEDS = f2e041
	cap gen expacsupportsal_IPEDS = f2e042
	cap gen expstuservicetot_IPEDS = f2e051
	cap gen expstuservicesal_IPEDS = f2e052
	cap gen expinssupporttot_IPEDS = f2e061
	cap gen expinssupportsal_IPEDS = f2e062
	cap gen expauxiliarytot_IPEDS = f2e071
	cap gen expauxiliarysal_IPEDS = f2e072
	cap gen expnetgrantsal_IPEDS = f2e081
	cap gen exphospitaltot_IPEDS = f2e091
	cap gen exphospitalsal_IPEDS = f2e092
	cap gen expindopetot_IPEDS = f2e101
	cap gen expindopesal_IPEDS = f2e102
	cap gen expopemaitot_IPEDS = f2e111
	cap gen expopemaisal_IPEDS = f2e112
	cap gen expotherfunctiontot_IPEDS = f2e121
	cap gen expotherfunctionsal_IPEDS = f2e122
	cap gen asstot_IPEDS = f2a02
	cap gen asscapital_IPEDS = f2a17
	cap gen assland_IPEDS = f2a11
	cap gen assbuilding_IPEDS = f2a12
	cap gen assequipment_IPEDS = f2a13
	cap gen assproperty_IPEDS = f2a14
	cap gen assconstruction_IPEDS = f2a15
	cap gen assotherppe_IPEDS = f2a16
	cap gen assinvestment_IPEDS = f2a01
	cap gen assintangible_IPEDS = f2a20
	cap gen liatot_IPEDS = f2a03
	cap gen netassboy_IPEDS = f2b05
	cap gen netass_IPEDS = f2b07
	cap gen netasstemres_IPEDS = f2a05b
	cap gen netassperres_IPEDS = f2a05a
	cap gen netassunres_IPEDS = f2a04
	cap gen netassres_IPEDS = f2a05
	cap gen havingendowment_IPEDS = f2fha
	cap gen endowmentboy_IPEDS = f2h01
	cap gen endowmentcon_IPEDS = f2h03a
	cap gen endowmentinv_IPEDS = f2h03b
	cap gen endowmentexp_IPEDS = f2h03c
	cap gen endowmentotherchange_IPEDS = f2h03d
	cap gen endowmenteoy_IPEDS = f2h02
	
	cap lab var revtot_IPEDS "Total revenues and investment return - Total"
	cap lab var revconpri_IPEDS "Total private contribution"
	cap lab var revggcpri_IPEDS "Private gifts, grants, and contracts - Total"
	cap lab var revgiftpri_IPEDS "Private gifts - Total"
	cap lab var revconaff_IPEDS "Contributions from affiliated entities - Total"
	cap lab var revcongov_IPEDS "Total government contribution"
	cap lab var revgrantpell_IPEDS "Pell grants"
	cap lab var revgrantfed_IPEDS "Other federal grants"
	cap lab var revgrantst_IPEDS "State grants"
	cap lab var revgrantloc_IPEDS "Local grants"
	cap lab var revtuition_IPEDS "Tuition and fees - Total"
	cap lab var revauxiliary_IPEDS "Sales and services of auxiliary enterprises - Total"
	cap lab var revcontract_IPEDS "Total grants and contracts"
	cap lab var revgcfed_IPEDS "Federal grants and contracts - Total"
	cap lab var revgcst_IPEDS "State grants and contracts - Total"
	cap lab var revgcloc_IPEDS "Local grants and contracts - Total"
	cap lab var revgcpri_IPEDS "Private grants and contracts - Total"
	cap lab var revapp_IPEDS "Total appropriations"
	cap lab var revappfed_IPEDS "Federal appropriations - Total"
	cap lab var revappst_IPEDS "State appropriations - Total"
	cap lab var revapploc_IPEDS "Local appropriations - Total"
	cap lab var reveduservice_IPEDS "Sales and services of educational activities - Total"
	cap lab var revhospital_IPEDS "Hospital revenue - Total"
	cap lab var revindope_IPEDS "Independent operations revenue - Total"
	cap lab var revother_IPEDS "Other revenue - Total"
	cap lab var revinvestment_IPEDS "Investment return - Total"
	cap lab var exptot_IPEDS "Total expenses-Total amount"
	cap lab var netinc_IPEDS "Net income"
	cap lab var expstdgrant_IPEDS "Institution grants"
	cap lab var expinsgrantfunded_IPEDS "Institutional grants (funded)"
	cap lab var expinsgrantunfunded_IPEDS "Institutional grants (unfunded)"
	cap lab var expsalben_IPEDS "Total expenses-Salaries, wages, and Benefits"
	cap lab var expsal_IPEDS "Total expenses-Salaries and wages"
	cap lab var expbenefit_IPEDS "Total expenses-Benefits"
	cap lab var expinterest_IPEDS "Total expenses-Interest"
	cap lab var expdepreciation_IPEDS "Total expenses-Depreciation"
	cap lab var expoperation_IPEDS "Total expenses-Operation and maintenance of plant"
	cap lab var expotherobject_IPEDS "Total expenses-All other natural classification"
	cap lab var expinstructiontot_IPEDS "Instruction-Total amount"
	cap lab var expinstructionsal_IPEDS "Instruction-Salaries and wages"
	cap lab var expresearchtot_IPEDS "Research-Total amount"
	cap lab var expresearchsal_IPEDS "Research-Salaries and wages"
	cap lab var exppubservicetot_IPEDS "Public service-Total amount"
	cap lab var exppubservicesal_IPEDS "Public service-Salaries and wages"
	cap lab var expacsupporttot_IPEDS "Academic support-Total amount"
	cap lab var expacsupportsal_IPEDS "Academic support-Salaries and wages"
	cap lab var expstuservicetot_IPEDS "Student service-Total amount"
	cap lab var expstuservicesal_IPEDS "Student service-Salaries and wages"
	cap lab var expinssupporttot_IPEDS "Institutional support-Total amount"
	cap lab var expinssupportsal_IPEDS "Institutional support-Salaries and wages"
	cap lab var expauxiliarytot_IPEDS "Auxiliary enterprises-Total amount"
	cap lab var expauxiliarysal_IPEDS "Auxiliary enterprises-Salaries and wages"
	cap lab var expnetgrantsal_IPEDS "Net grant aid to students-Total amount"
	cap lab var exphospitaltot_IPEDS "Hospital services-Total amount"
	cap lab var exphospitalsal_IPEDS "Hospital services-Salaries and wages"
	cap lab var expindopetot_IPEDS "Independent operations-Total Amount"
	cap lab var expindopesal_IPEDS "Independent operations-Salaries and wages"
	cap lab var expopemaitot_IPEDS "Operation and maintenance of plant-Total amount "
	cap lab var expopemaisal_IPEDS "Operation and maintenance of plant-Salaries and wages "
	cap lab var expotherfunctiontot_IPEDS "Other expenses-Total amount"
	cap lab var expotherfunctionsal_IPEDS "Other expenses-Salaries and wages"
	cap lab var asstot_IPEDS "Total assets"
	cap lab var asscapital_IPEDS "Total Plant, Property, and Equipment"
	cap lab var assland_IPEDS "Land  improvements - End of year"
	cap lab var assbuilding_IPEDS "Buildings - End of year"
	cap lab var assequipment_IPEDS "Equipment, including art and library collections - End of year"
	cap lab var assproperty_IPEDS "Property obtained under capital leases"
	cap lab var assconstruction_IPEDS "Construction in Progress"
	cap lab var assotherppe_IPEDS "Other plant, property and equipment"
	cap lab var assinvestment_IPEDS "Long-term investments"
	cap lab var assintangible_IPEDS "Intangible Assets, net of accumulated amortization"
	cap lab var liatot_IPEDS "Total liabilities"
	cap lab var netassboy_IPEDS "Net assets, beginning of the year"
	cap lab var netass_IPEDS "Net assets, end of the year"
	cap lab var netasstemres_IPEDS "Temporarily restricted net assets"
	cap lab var netassperres_IPEDS "Permanently restricted net assets"
	cap lab var netassunres_IPEDS "Total unrestricted net assets"
	cap lab var netassres_IPEDS "Total restricted net assets"
	cap lab var havingendowment_IPEDS "Institution or affiliated organizations own endowment assets"
	cap lab var endowmentboy_IPEDS "Value of endowment assets at the beginning of the fiscal year"
	cap lab var endowmentcon_IPEDS "New gifts and additions"
	cap lab var endowmentinv_IPEDS "Endowment net investment return"
	cap lab var endowmentexp_IPEDS "Spending distribution for current use"
	cap lab var endowmentotherchange_IPEDS "Other changes in value of endowment net assets"
	cap lab var endowmenteoy_IPEDS "Value of endowment assets at the end of the fiscal year"
	
	gen year = `i' //Use the start year to define year
	order year 
	cap drop f2* 
	cap drop xf*
	
	save "$wdata/IPEDS/finance`i'.dta", replace //Use the start year to define year
}

