if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

forv i = 2001(1)2022{ //Year of fall semester
	
	cap import delimited "$rdata/IPEDS/ic`i'.csv", clear
	cap import delimited "$rdata/IPEDS/adm`i'.csv", clear
	
	foreach x in applcnm applcnw admssnm admssnw enrlftm enrlftw enrlftm enrlftw{
		cap recode `x' . = 0
	}
	cap gen applcn = applcnm + applcnw
	cap gen admssn = admssnm + admssnw
	cap gen enrlt = enrlftm + enrlftw + enrlftm + enrlftw
	
	keep unitid applcn admssn enrlt satvr* satmt* actcm* acten* actmt*
	gen year = `i' //Use fall semester to define year
	order unitid year
		
	label variable applcn "Applicants total"
	label variable admssn "Admissions total"
	label variable enrlt "Enrolled total"
	lab var satvr25 "SAT Critical Reading 25th percentile score"
	lab var satvr75 "SAT Critical Reading 75th percentile score"
	lab var satmt25 "SAT Math 25th percentile score"
	lab var satmt75 "SAT Math 75th percentile score"
	lab var actcm25 "ACT Composite 25th percentile score"
	lab var actcm75 "ACT Composite 75th percentile score"
	lab var acten25 "ACT English 25th percentile score"
	lab var acten75 "ACT English 75th percentile score"
	lab var actmt25 "ACT Math 25th percentile score"
	lab var actmt75 "ACT Math 75th percentile score"
		
	save "$wdata/IPEDS/admission`i'.dta", replace
}
