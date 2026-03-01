if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

import delimited "$rdata/IPEDS/ef2016a_dist_data_stata.csv", clear
		
save "$wdata/IPEDS/admission`i'.dta", replace

label variable unitid   "Unique identification number of the institution"
label variable efdelev  "Level of student"
label variable xefdetot "Imputation field for efdetot - All students enrolled"
label variable efdetot  "All students enrolled"
label variable xefdeexc "Imputation field for efdeexc - Students enrolled exclusively in distance education courses"
label variable efdeexc  "Students enrolled exclusively in distance education courses"
label variable xefdesom "Imputation field for efdesom - Students enrolled in some but not all distance education courses"
label variable efdesom  "Students enrolled in some but not all distance education courses"
label variable xefdenon "Imputation field for efdenon - Student not enrolled in any distance education courses"
label variable efdenon  "Student not enrolled in any distance education courses"
label variable xefdeex1 "Imputation field for efdeex1 - Students enrolled exclusively in distance education courses and are located in same state/jurisdiction as institution"
label variable efdeex1  "Students enrolled exclusively in distance education courses and are located in same state/jurisdiction as institution"
label variable xefdeex2 "Imputation field for efdeex2 - Students enrolled exclusively in distance education courses and are located in U.S., not in same state/jurisdiction as institution"
label variable efdeex2  "Students enrolled exclusively in distance education courses and are located in U.S., not in same state/jurisdiction as institution"
label variable xefdeex3 "Imputation field for efdeex3 - Students enrolled exclusively in distance education courses and are located in U.S., state/jurisdiction unknown"
label variable efdeex3  "Students enrolled exclusively in distance education courses and are located in U.S., state/jurisdiction unknown"
label variable xefdeex4 "Imputation field for efdeex4 - Students enrolled exclusively in distance education courses and are located outside U.S."
label variable efdeex4  "Students enrolled exclusively in distance education courses and are located outside U.S."
label variable xefdeex5 "Imputation field for efdeex5 - Students enrolled exclusively in distance education courses and location of student unknown/not reported"
label variable efdeex5  "Students enrolled exclusively in distance education courses and location of student unknown/not reported"
label define label_efdelev 1 "All students total"
label define label_efdelev 2 "Undergraduate total",add
label define label_efdelev 3 "Degree/certificate-seeking total",add
label define label_efdelev 11 "Non-degree/certificate-seeking",add
label define label_efdelev 12 "Graduate",add
label values efdelev label_efdelev

keep if efdelev == 1 // All Students

gen prop_distance = efdeexc / efdetot
gen prop_outus = efdeex4 / efdetot

keep unitid prop_distance prop_outus

save "$wdata/IPEDS/distance_education_2016.dta", replace
