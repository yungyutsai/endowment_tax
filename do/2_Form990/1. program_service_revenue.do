if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

foreach data in xml 2324{
	import delim "$rdata/Form990/propublica/form990_`data'.csv", clear

	keep ein taxyr returnts programservicerevenuegrp*

	gen id = _n
	reshape long programservicerevenuegrpdesc programservicerevenuegrpbusicd programservicerevenuegrpamt, i(id ein taxyr returnts) j(row)
		
	foreach x in desc busicd amt{
		rename programservicerevenuegrp`x' `x'
	}

	destring amt, replace force

	drop if desc == "NA" & busicd == "NA"
	drop if desc == "" & busicd == ""
	drop if amt == .

	gen category = ""

	replace category = "Hospital & Health" if 	strpos(desc,"340(B)") ~= 0 | ///
												strpos(desc,"340B") ~= 0
	replace category = "Hospital & Health" if 	strpos(lower(desc),"hospital") ~= 0 | ///
												strpos(lower(desc),"medical") ~= 0 | ///
												strpos(lower(desc),"clinic") ~= 0 | ///
												strpos(lower(desc),"acupuncture") ~= 0 | ///
												strpos(lower(desc),"health") ~= 0 | ///
												strpos(lower(desc),"physiologic") ~= 0 | ///
												strpos(lower(desc),"amblatory") ~= 0 | ///
												strpos(lower(desc),"ambulatory") ~= 0 | ///
												strpos(lower(desc),"physician") ~= 0 | ///
												strpos(lower(desc),"pharmacy") ~= 0 | ///
												strpos(lower(desc),"balance and mobility center") ~= 0 | ///
												strpos(lower(desc),"therapy") ~= 0 | ///
												strpos(lower(desc),"client") ~= 0 | ///
												strpos(lower(desc),"cyclotron") ~= 0 | ///
												strpos(lower(desc),"cytology") ~= 0 | ///
												strpos(lower(desc),"dental") ~= 0 | ///
												strpos(lower(desc),"nurs") ~= 0 | ///
												strpos(lower(desc),"dialysis") ~= 0 | ///
												strpos(lower(desc),"emergency") ~= 0 | ///
												strpos(lower(desc),"inspection") ~= 0 | ///
												strpos(lower(desc),"eye") ~= 0 | ///
												strpos(lower(desc),"hemophilia") ~= 0 | ///
												strpos(lower(desc),"patient") ~= 0 | ///
												strpos(lower(desc),"lab") ~= 0 | ///
												strpos(lower(desc),"psychologi") ~= 0 | ///
												strpos(lower(desc),"medicare") ~= 0 | ///
												strpos(lower(desc),"medicaid") ~= 0
												
												
	replace category = "Hospital & Health" if 	busi == "622110" | busi == "621400" | ///
												busi == "622200"



	replace category = "Auxiliary Services" if 	busi == "722100" | busi == "711110" | ///
												busi == "721000" | busi == "713990"
	replace category = "Auxiliary Services" if 	strpos(lower(desc),"ancillary") ~= 0 | ///
												strpos(lower(desc),"auxiliary") ~= 0 | ///
												strpos(lower(desc),"aux ent") ~= 0 | ///
												strpos(lower(desc),"aux. ent") ~= 0 | ///
												strpos(lower(desc),"aux. act") ~= 0 | ///
												strpos(lower(desc),"aux. sales") ~= 0 | ///
												strpos(lower(desc),"aux serv") ~= 0 | ///
												strpos(lower(desc),"aux srvc") ~= 0 | ///
												strpos(lower(desc),"auxil") ~= 0 | ///
												strpos(lower(desc),"food") ~= 0 | ///
												strpos(lower(desc),"dining") ~= 0 | ///
												strpos(lower(desc),"cafeteria") ~= 0 | ///
												strpos(lower(desc),"meal") ~= 0 | ///
												strpos(lower(desc),"store") ~= 0 | ///
												strpos(lower(desc),"vending") ~= 0 | ///
												strpos(lower(desc),"vendor") ~= 0 | ///
												strpos(lower(desc),"day care") ~= 0 | ///
												strpos(lower(desc),"daycare") ~= 0 | ///
												strpos(lower(desc),"child") ~= 0 | ///
												strpos(lower(desc),"early learn") ~= 0 | ///
												strpos(lower(desc),"facilit") ~= 0 | ///
												strpos(lower(desc),"parking") ~= 0 | ///
												strpos(lower(desc),"fitness") ~= 0     


	replace category = "Acade. Services" if 	strpos(lower(desc),"academic") ~= 0 | ///
												strpos(lower(desc),"conferenc") ~= 0 | ///
												strpos(lower(desc),"worksho") ~= 0 | ///
												strpos(lower(desc),"library") ~= 0 | ///
												strpos(lower(desc),"examination") ~= 0 | ///
												(strpos(lower(desc),"depart") ~= 0 & strpos(lower(desc),"service") ~= 0)

	replace category = "Grants and Contract" if strpos(lower(desc),"grant") ~= 0 | ///
												strpos(lower(desc),"contract") ~= 0 | ///
												strpos(lower(desc),"research") ~= 0 | ///
												strpos(lower(desc),"aid") ~= 0 | ///
												strpos(lower(desc),"fund") ~= 0 | ///
												strpos(lower(desc),"work study") ~= 0 | ///
												strpos(lower(desc),"workstudy") ~= 0 | ///
												strpos(lower(desc),"govt") ~= 0 | ///
												strpos(lower(desc),"government") ~= 0



	replace category = "Income from Wealth" if busi == "531390"
	replace category = "Income from Wealth" if 	strpos(lower(desc),"rent") ~= 0 | ///
												strpos(lower(desc),"hotel") ~= 0 | ///
												strpos(lower(desc),"endowment") ~= 0 | ///
												strpos(lower(desc),"interest") ~= 0 | ///
												strpos(lower(desc),"equity") ~= 0 | ///
												strpos(lower(desc),"leas") ~= 0

	replace category = "Adminstration" if 	strpos(lower(desc),"admin") ~= 0 | ///
											strpos(lower(desc),"managem") ~= 0 | ///
											strpos(lower(desc),"staff") ~= 0 
											
	replace category = "Information and Publishers" if busi == "511120"
	replace category = "Information and Publishers" if strpos(lower(desc),"advertising") ~= 0 | ///
												strpos(lower(desc),"press") ~= 0 | ///
												strpos(lower(desc),"book") ~= 0 | ///
												strpos(lower(desc),"print") ~= 0 | ///
												strpos(lower(desc),"video") ~= 0 | ///
												strpos(lower(desc),"broadcast") ~= 0 
												
	replace category = "Affliation" if strpos(lower(desc),"affiliat") ~= 0

	replace category = "Alumni" if strpos(lower(desc),"alumni") ~= 0

	replace category = "Admission" if 	strpos(lower(desc),"admission") ~= 0 | ///
										strpos(lower(desc),"application") ~= 0


	replace category = "Activities & Community" if 	strpos(lower(desc),"athlet") ~= 0 | ///
													strpos(lower(desc),"game") ~= 0 | ///
													strpos(lower(desc),"concert") ~= 0 | ///
													strpos(lower(desc),"museum") ~= 0 | ///
													strpos(lower(desc),"community") ~= 0 | ///
													strpos(lower(desc),"gallery") ~= 0 | ///
													strpos(lower(desc),"film") ~= 0 | ///
													strpos(lower(desc),"activit") ~= 0 | ///
													strpos(lower(desc),"theater") ~= 0 | ///
													strpos(lower(desc),"sport") ~= 0 | ///
													strpos(lower(desc),"box office") ~= 0 | ///
													strpos(lower(desc),"event") ~= 0 | ///
													strpos(lower(desc),"exhib") ~= 0 | ///
													strpos(lower(desc),"camp") ~= 0

	replace category = "Room and Board" if 	strpos(lower(desc),"room") ~= 0 | ///
											strpos(lower(desc),"board") ~= 0 | ///
											strpos(lower(desc),"dorm") ~= 0 | ///
											strpos(lower(desc),"residenc") ~= 0 | ///
											strpos(lower(desc),"housin") ~= 0
	replace category = "Room and Board" if busi == "721110"

	replace category = "Tuition and Fee" if (busi == "611310" | busi == "611600") & (strpos(lower(desc),"edu") | strpos(lower(desc),"registra"))
	replace category = "Tuition and Fee" if strpos(lower(desc),"tuition") ~= 0 | ///
											strpos(lower(desc),"tution") ~= 0 | ///
											strpos(lower(desc),"tuiton") ~= 0 | ///
											strpos(lower(desc),"education") ~= 0 | ///
											strpos(lower(desc),"course") ~= 0 | ///
											strpos(lower(desc),"class") ~= 0 | ///
											strpos(lower(desc),"registration") ~= 0 | ///
											strpos(lower(desc),"commencement") ~= 0 | ///
											strpos(lower(desc),"comprehensive") ~= 0 | ///
											strpos(lower(desc),"matriculation") ~= 0 | ///
											strpos(lower(desc),"degree") ~= 0 | ///
											strpos(lower(desc),"college") ~= 0 | ///
											strpos(lower(desc),"bachelor") ~= 0 | ///
											strpos(lower(desc),"dept program") ~= 0 | ///
											strpos(lower(desc),"department program") ~= 0 | ///
											strpos(lower(desc),"department rev") ~= 0 | ///
											strpos(lower(desc),"department inc") ~= 0 | ///
											strpos(lower(desc),"departmental inc") ~= 0 | ///
											strpos(lower(desc),"student") ~= 0 | ///
											strpos(lower(desc),"school") ~= 0 | ///
											strpos(lower(desc),"instruction") ~= 0 | ///
											strpos(lower(desc),"graduat") ~= 0 | ///
											strpos(lower(desc),"master") ~= 0 | ///
											strpos(lower(desc),"institut") ~= 0 | ///
											strpos(lower(desc),"university") ~= 0 | ///
											strpos(lower(desc),"post second") ~= 0 | ///
											strpos(lower(desc),"adult education") ~= 0 | ///
											strpos(lower(desc),"cont. education") ~= 0| ///
											strpos(lower(desc),"continued ed") ~= 0 | ///
											strpos(lower(desc),"continuing ed") ~= 0 | ///
											strpos(lower(desc),"exchange prog") ~= 0 | ///
											strpos(lower(desc),"study abr") ~= 0 | ///
											(strpos(lower(desc),"intern") ~= 0 & strpos(lower(desc),"prog") ~= 0) | ///
											(strpos(lower(desc),"cont") ~= 0 & strpos(lower(desc),"edu") ~= 0) | ///
											(strpos(lower(desc),"ed") ~= 0 & strpos(lower(desc),"prog") ~= 0)


	replace category = "Tuition and Fee" if category == "Room and Board" 

	replace category = "Others" if category == "" 

	gen cat = .
	replace cat = 1 if category == "Tuition and Fee"
	replace cat = 2 if category == "Auxiliary Services"
	replace cat = 3 if category == "Grants and Contract"
	replace cat = 4 if cat == .

	collapse (sum)amt, by(id ein taxyr returnts cat)
	reshape wide amt, i(id ein taxyr returnts) j(cat)

	rename amt1 proserrev_tuition
	rename amt2 proserrev_auxser
	rename amt3 proserrev_grantcontract
	rename amt4 proserrev_other

	save "$wdata/Form990/Form990_ProgramServiceRevenue_`data'.dta", replace
}
