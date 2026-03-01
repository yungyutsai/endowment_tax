if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

forv i = 2000(1)2022{
	
	import delimited "$rdata/IPEDS/HD`i'.csv", clear
	
	cap rename hdegoffr hdegofr1
	cap gen instcat = .

	keep unitid instnm city stabbr zip fips obereg opeid opeflag sector iclevel control hloffer ugoffer groffer hdegofr1 deggrant hbcu hospital medical tribal locale act cyactive instcat carnegie
	gen year = `i' //Use fall semester to define year
	order unitid year
		
	label variable unitid   "Unique identification number of the institution"
	label variable instnm   "Institution (entity) name"
	label variable city     "City location of institution"
	label variable stabbr   "State abbreviation"
	label variable zip      "ZIP code"
	label variable fips     "FIPS state code"
	label variable obereg   "Bureau of Economic Analysis (BEA) regions"
	label variable opeid    "Office of Postsecondary Education (OPE) ID Number"
	label variable opeflag  "OPE Title IV eligibility indicator code"
	label variable sector   "Sector of institution"
	label variable iclevel  "Level of institution"
	label variable control  "Control of institution"
	label variable hloffer  "Highest level of offering"
	label variable ugoffer  "Undergraduate offering"
	label variable groffer  "Graduate offering"
	label variable hdegofr1 "Highest degree offered"
	label variable deggrant "Degree-granting status"
	label variable hbcu     "Historically Black College or University"
	label variable hospital "Institution has hospital"
	label variable medical  "Institution grants a medical degree"
	label variable tribal   "Tribal college"
	label variable locale   "Degree of urbanization (Urban-centric locale)"
	label variable act      "Status of institution"
	label variable cyactive "Institution is active in current year"
	label variable instcat  "Institutional category"
	
	label define label_fips 1 "Alabama"
	label define label_fips 2 "Alaska",add
	label define label_fips 4 "Arizona",add
	label define label_fips 5 "Arkansas",add
	label define label_fips 6 "California",add
	label define label_fips 8 "Colorado",add
	label define label_fips 9 "Connecticut",add
	label define label_fips 10 "Delaware",add
	label define label_fips 11 "District of Columbia",add
	label define label_fips 12 "Florida",add
	label define label_fips 13 "Georgia",add
	label define label_fips 15 "Hawaii",add
	label define label_fips 16 "Idaho",add
	label define label_fips 17 "Illinois",add
	label define label_fips 18 "Indiana",add
	label define label_fips 19 "Iowa",add
	label define label_fips 20 "Kansas",add
	label define label_fips 21 "Kentucky",add
	label define label_fips 22 "Louisiana",add
	label define label_fips 23 "Maine",add
	label define label_fips 24 "Maryland",add
	label define label_fips 25 "Massachusetts",add
	label define label_fips 26 "Michigan",add
	label define label_fips 27 "Minnesota",add
	label define label_fips 28 "Mississippi",add
	label define label_fips 29 "Missouri",add
	label define label_fips 30 "Montana",add
	label define label_fips 31 "Nebraska",add
	label define label_fips 32 "Nevada",add
	label define label_fips 33 "New Hampshire",add
	label define label_fips 34 "New Jersey",add
	label define label_fips 35 "New Mexico",add
	label define label_fips 36 "New York",add
	label define label_fips 37 "North Carolina",add
	label define label_fips 38 "North Dakota",add
	label define label_fips 39 "Ohio",add
	label define label_fips 40 "Oklahoma",add
	label define label_fips 41 "Oregon",add
	label define label_fips 42 "Pennsylvania",add
	label define label_fips 44 "Rhode Island",add
	label define label_fips 45 "South Carolina",add
	label define label_fips 46 "South Dakota",add
	label define label_fips 47 "Tennessee",add
	label define label_fips 48 "Texas",add
	label define label_fips 49 "Utah",add
	label define label_fips 50 "Vermont",add
	label define label_fips 51 "Virginia",add
	label define label_fips 53 "Washington",add
	label define label_fips 54 "West Virginia",add
	label define label_fips 55 "Wisconsin",add
	label define label_fips 56 "Wyoming",add
	label define label_fips 60 "American Samoa",add
	label define label_fips 64 "Federated States of Micronesia",add
	label define label_fips 66 "Guam",add
	label define label_fips 68 "Marshall Islands",add
	label define label_fips 69 "Northern Marianas",add
	label define label_fips 70 "Palau",add
	label define label_fips 72 "Puerto Rico",add
	label define label_fips 78 "Virgin Islands",add
	label values fips label_fips
	label define label_obereg 0 "U.S. Service schools"
	label define label_obereg 1 "New England (CT, ME, MA, NH, RI, VT)",add
	label define label_obereg 2 "Mid East (DE, DC, MD, NJ, NY, PA)",add
	label define label_obereg 3 "Great Lakes (IL, IN, MI, OH, WI)",add
	label define label_obereg 4 "Plains (IA, KS, MN, MO, NE, ND, SD)",add
	label define label_obereg 5 "Southeast (AL, AR, FL, GA, KY, LA, MS, NC, SC, TN, VA, WV)",add
	label define label_obereg 6 "Southwest (AZ, NM, OK, TX)",add
	label define label_obereg 7 "Rocky Mountains (CO, ID, MT, UT, WY)",add
	label define label_obereg 8 "Far West (AK, CA, HI, NV, OR, WA)",add
	label define label_obereg 9 "Other U.S. jurisdictions (AS, FM, GU, MH, MP, PR, PW, VI)",add
	label values obereg label_obereg
	label define label_opeflag 1 "Participates in Title IV federal financial aid programs"
	label define label_opeflag 2 "Branch campus of a main campus that participates in Title IV",add
	label define label_opeflag 3 "Deferment only - limited participation",add
	label define label_opeflag 8 "New participants (became eligible during spring collection)",add
	label define label_opeflag 4 "New participants (became eligible during the winter collection period)",add
	label define label_opeflag 5 "Not currently participating in Title IV, has an OPE ID number",add
	label define label_opeflag 6 "Not currently participating in Title IV, does not have OPE ID number",add
	label define label_opeflag 7 "Stopped participating during the survey year",add
	label values opeflag label_opeflag
	label define label_sector 0 "Administrative Unit"
	label define label_sector 1 "Public, 4-year or above",add
	label define label_sector 2 "Private not-for-profit, 4-year or above",add
	label define label_sector 3 "Private for-profit, 4-year or above",add
	label define label_sector 4 "Public, 2-year",add
	label define label_sector 5 "Private not-for-profit, 2-year",add
	label define label_sector 6 "Private for-profit, 2-year",add
	label define label_sector 7 "Public, less-than 2-year",add
	label define label_sector 8 "Private not-for-profit, less-than 2-year",add
	label define label_sector 9 "Private for-profit, less-than 2-year",add
	label define label_sector 99 "Sector unknown (not active)",add
	label values sector label_sector
	label define label_iclevel 1 "Four or more years"
	label define label_iclevel 2 "At least 2 but less than 4 years",add
	label define label_iclevel 3 "Less than 2 years (below associate)",add
	label define label_iclevel -3 "{Not available}",add
	label values iclevel label_iclevel
	label define label_control 1 "Public"
	label define label_control 2 "Private not-for-profit",add
	label define label_control 3 "Private for-profit",add
	label define label_control -3 "{Not available}",add
	label values control label_control
	label define label_hloffer 1 "Award of less than one academic year"
	label define label_hloffer 2 "At least 1, but less than 2 academic yrs",add
	label define label_hloffer 3 "Associate's degree",add
	label define label_hloffer 4 "At least 2, but less than 4 academic yrs",add
	label define label_hloffer 5 "Bachelor's degree",add
	label define label_hloffer 6 "Postbaccalaureate certificate",add
	label define label_hloffer 7 "Master's degree",add
	label define label_hloffer 8 "Post-master's certificate",add
	label define label_hloffer 9 "Doctor's degree",add
	label define label_hloffer -2 "Not applicable, first-professional only",add
	label define label_hloffer -3 "{Not available}",add
	label values hloffer label_hloffer
	label define label_ugoffer 1 "Undergraduate degree or certificate offering"
	label define label_ugoffer 2 "No undergraduate offering",add
	label define label_ugoffer -3 "{Not available}",add
	label values ugoffer label_ugoffer
	label define label_groffer 1 "Graduate degree or certificate offering"
	label define label_groffer 2 "No graduate offering",add
	label define label_groffer -3 "{Not available}",add
	label values groffer label_groffer
	
	label define label_hdegofr1 1 "First-professional only"
	label define label_hdegofr1 10 "Doctoral",add
	label define label_hdegofr1 11 "Doctor's degree - research/scholarship and professional practice",add
	label define label_hdegofr1 12 "Doctor's degree - research/scholarship",add
	label define label_hdegofr1 13 "Doctor's degree -  professional practice",add
	label define label_hdegofr1 14 "Doctor's degree - other",add
	label define label_hdegofr1 20 "Master's degree",add
	label define label_hdegofr1 21 "Master's and first-professional",add
	label define label_hdegofr1 30 "Bachelor's degree",add
	label define label_hdegofr1 31 "Bachelor's and first-professional",add
	label define label_hdegofr1 40 "Associate's degree",add
	label define label_hdegofr1 0 "Non-degree granting",add
	label define label_hdegofr1 -3 "{Not available}",add
	label values hdegofr1 label_hdegofr1
	label define label_deggrant 1 "Degree-granting"
	label define label_deggrant 2 "Nondegree-granting, primarily postsecondary",add
	label define label_deggrant -3 "{Not available}",add
	label values deggrant label_deggrant
	label define label_hbcu 1 "Yes"
	label define label_hbcu 2 "No",add
	label define label_hbcu -3 "{Not available}",add
	label values hbcu label_hbcu
	label define label_hospital 1 "Yes"
	label define label_hospital 2 "No",add
	label define label_hospital -1 "Not reported",add
	label define label_hospital -2 "Not applicable",add
	label define label_hospital -3 "{Not available}",add
	label values hospital label_hospital
	label define label_medical 1 "Yes"
	label define label_medical 2 "No",add
	label define label_medical -1 "Not reported",add
	label define label_medical -2 "Not applicable",add
	label values medical label_medical
	label define label_tribal 1 "Yes"
	label define label_tribal 2 "No",add
	label define label_tribal -3 "{Not available}",add
	label values tribal label_tribal
	
	label define label_locale 1 "Large city"
	label define label_locale 2 "Mid-size city",add
	label define label_locale 3 "Urban fringe of large city",add
	label define label_locale 4 "Urban fringe of mid-size city",add
	label define label_locale 5 "Large town",add
	label define label_locale 6 "Small town",add
	label define label_locale 7 "Rural",add
	label define label_locale 9 "Not assigned",add
	label define label_locale 11 "City: Large",add
	label define label_locale 12 "City: Midsize",add
	label define label_locale 13 "City: Small",add
	label define label_locale 21 "Suburb: Large",add
	label define label_locale 22 "Suburb: Midsize",add
	label define label_locale 23 "Suburb: Small",add
	label define label_locale 31 "Town: Fringe",add
	label define label_locale 32 "Town: Distant",add
	label define label_locale 33 "Town: Remote",add
	label define label_locale 41 "Rural: Fringe",add
	label define label_locale 42 "Rural: Distant",add
	label define label_locale 43 "Rural: Remote",add
	label define label_locale -3 "{Not available}",add
	label values locale label_locale
	label define label_cyactive 1 "Yes"
	label define label_cyactive 2 "No, potential add or restore",add
	label define label_cyactive 3 "No, closed, combined, or out-of-scope",add
	label values cyactive label_cyactive
	label define label_instcat 1 "Degree-granting, graduate with no undergraduate degrees"
	label define label_instcat 2 "Degree-granting, primarily baccalaureate or above",add
	label define label_instcat 3 "Degree-granting, not primarily baccalaureate or above",add
	label define label_instcat 4 "Degree-granting, associate's and certificates",add
	label define label_instcat 5 "Nondegree-granting, above the baccalaureate",add
	label define label_instcat 6 "Nondegree-granting, sub-baccalaureate",add
	label define label_instcat -1 "Not reported",add
	label define label_instcat -2 "Not applicable",add
	label values instcat label_instcat
	
	
	label define label_carnegie 15 "Doctoral/Research Universities--Extensive"
	label define label_carnegie 16 "Doctoral/Research Universities--Intensive",add
	label define label_carnegie 21 "Masters Colleges and Universities I",add
	label define label_carnegie 22 "Masters Colleges and Universities II",add
	label define label_carnegie 31 "Baccalaureate Colleges--Liberal Arts",add
	label define label_carnegie 32 "Baccalaureate Colleges--General",add
	label define label_carnegie 33 "Baccalaureate/Associates Colleges",add
	label define label_carnegie 40 "Associates Colleges",add
	label define label_carnegie 51 "Theological seminaries and other specialized faith-related institutions",add
	label define label_carnegie 52 "Medical schools and medical centers",add
	label define label_carnegie 53 "Other separate health profession schools",add
	label define label_carnegie 54 "Schools of engineering and technology",add
	label define label_carnegie 55 "Schools of business and management",add
	label define label_carnegie 56 "Schools of art, music, and design",add
	label define label_carnegie 57 "Schools of law",add
	label define label_carnegie 58 "Teachers colleges",add
	label define label_carnegie 59 "Other specialized institutions",add
	label define label_carnegie 60 "Tribal colleges",add
	label define label_carnegie -2 "Not applicable, not in Carnegie universe (not accredited or nondegree-granting)",add
	label values carnegie label_carnegie
	
	save "$wdata/IPEDS/head`i'.dta", replace
}
