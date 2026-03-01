if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

forv i = 2000(1)2022{	
	import delimited "$rdata/IPEDS/ic`i'_ay.csv", clear
	
	keep unitid tuition* fee* hrchg* chg*
	gen year = `i'
	order unitid year //Use fall semester to define year

	label variable unitid   "Unique identification number of the institution"

	
	label variable tuition2 "In-state average tuition for full-time undergraduates"
	label variable fee2     "In-state required fees for full-time undergraduates"
	label variable hrchg2   "In-state per credit hour charge for part-time undergraduates"
	
	label variable tuition3 "Out-of-state average tuition for full-time undergraduates"
	label variable fee3     "Out-of-state required fees for full-time undergraduates"
	label variable hrchg3   "Out-of-state per credit hour charge for part-time undergraduates"
	
	label variable chg5ay3 "On campus, room and board"
	
	label variable tuition6 "In-state average tuition full-time graduates"
	label variable fee6     "In-state required fees for full-time graduates"
	label variable hrchg6   "In-state per credit hour charge part-time graduates"
	
	label variable tuition7 "Out-of-state average tuition full-time graduates"
	label variable fee7     "Out-of-state required fees for full-time graduates"
	label variable hrchg7   "Out-of-state per credit hour charge part-time graduates"
	
	keep unitid year tuition2 fee2 hrchg2 tuition3 fee3 hrchg3 chg3ay3 chg5ay3 tuition6 fee6 hrchg6 tuition7 fee7 hrchg7
	
	save "$wdata/IPEDS/charge`i'.dta", replace
}
