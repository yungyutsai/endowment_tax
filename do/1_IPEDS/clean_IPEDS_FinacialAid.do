if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

forv i = 2000(1)2022{
	loc j = `i' + 1
	loc x = substr("`i'",-2,2)
	loc y = substr("`j'",-2,2)
	loc z = "`x'" + "`y'"
	
	import delimited "$rdata/IPEDS/sfa`z'.csv", clear
		
	gen year = `i' //Use fall semester to define year
	
	order unitid year
	foreach x in uagrnt upgrnt ufloan{
		foreach y in n p t a{
			cap gen `x'`y' = .
		}
	}
	foreach x in fgrnt_t sgrnt_t igrnt_t loan_t npist0 npist1 npist2{
		cap gen `x' = .
	}
	foreach x in gis4n grn4n{
		foreach y in 2 12 22 32 42 52{
			cap gen `x'`y' = .
		}
	}
	
	keep unitid year uag* upg* ufl* anyaid* fgrnt* sgrnt* igrnt* loan* gis4n* grn4n* npist*
		
	label variable unitid   "Unique identification number of the institution"


	label variable uagrntn  "Number of undergraduate students awarded federal, state, local, institutional or other sources of grant aid"
	label variable uagrntp  "Percent of undergraduate students awarded federal, state, local, institutional or other sources of grant aid"
	label variable uagrntt  "Total amount of federal, state, local, institutional or other sources of grant aid awarded to undergraduate students"
	label variable uagrnta  "Average amount of federal, state, local, institutional or other sources of grant aid awarded to undergraduate students"

	label variable upgrntn  "Number of undergraduate students awarded Pell grants"
	label variable upgrntp  "Percent of undergraduate students awarded Pell grants"
	label variable upgrntt  "Total amount of Pell grant aid awarded to undergraduate students"
	label variable upgrnta  "Average amount Pell grant aid awarded to undergraduate students"

	label variable ufloann  "Number of undergraduate students awarded federal student loans"
	label variable ufloanp  "Percent of undergraduate students awarded federal student loans"
	label variable ufloant  "Total amount of federal student loans awarded to undergraduate students"
	label variable ufloana  "Average amount of federal student loans awarded to undergraduate students"	
	
	
	label variable anyaidn  "Number of full-time first-time undergraduates awarded any financial aid"
	label variable anyaidp  "Percent of full-time first-time undergraduates awarded any financial aid"

	label variable fgrnt_n  "Number of full-time first-time undergraduates awarded federal grant aid"
	label variable fgrnt_p  "Percent of full-time first-time undergraduates awarded federal grant aid"
	label variable fgrnt_a  "Average amount of federal grant aid awarded to full-time first-time undergraduates"
	label variable fgrnt_t  "Total amount of Federal grant aid received by full-time first-time undergraduates"

	label variable sgrnt_n  "Number of full-time first-time undergraduates awarded state/local grant aid"
	label variable sgrnt_p  "Percent of full-time first-time undergraduates awarded state/local grant aid"
	label variable sgrnt_a  "Average amount of state/local grant aid awarded to full-time first-time undergraduates"
	label variable sgrnt_t  "Total amount of state/local grant aid received by full-time first-time undergraduates"

	label variable igrnt_n  "Number of full-time first-time undergraduates awarded  institutional grant aid"
	label variable igrnt_p  "Percent of full-time first-time undergraduates awarded institutional grant aid"
	label variable igrnt_a  "Average amount of institutional grant aid awarded to full-time first-time undergraduates"
	label variable igrnt_t  "Total amount of institutional grant aid received by full-time first-time undergraduates"

	label variable loan_n   "Number of full-time first-time undergraduates awarded student loans"
	label variable loan_p   "Percent of full-time first-time undergraduates awarded student loans"
	label variable loan_a   "Average amount of student loans awarded to full-time first-time undergraduates"
	label variable loan_t   "Total amount of student loan aid received by full-time first-time undergraduates"
	
	label variable npist0 "Average net price-students awarded grant or scholarship aid"
	label variable npist1 "Average net price-students awarded grant or scholarship aid"
	label variable npist2 "Average net price-students awarded grant or scholarship aid"
	
	label variable gis4n2   "Public: All income levels"
	label variable gis4n12  "Public: 0-30,000"
	label variable gis4n22  "Public: 30,001-48,000"
	label variable gis4n32  "Public: 48,001-75,000"
	label variable gis4n42  "Public: 75,001-110,000"
	label variable gis4n52  "Public: 110,001 or more"

	label variable grn4n2   "Private: All income levels"
	label variable grn4n12  "Private: 0-30,000"
	label variable grn4n22  "Private: 30,001-48,000"
	label variable grn4n32  "Private: 48,001-75,000"
	label variable grn4n42  "Private: 75,001-110,000"
	label variable grn4n52  "Private: 110,001 or more"
	
	rename gis4n2 pubinctot
	rename gis4n12 pubinc0
	rename gis4n22 pubinc1
	rename gis4n32 pubinc2
	rename gis4n42 pubinc3
	rename gis4n52 pubinc4
	
	rename grn4n2 priinctot
	rename grn4n12 priinc0
	rename grn4n22 priinc1
	rename grn4n32 priinc2
	rename grn4n42 priinc3
	rename grn4n52 priinc4
	
	save "$wdata/IPEDS/sfa`i'.dta", replace
}
