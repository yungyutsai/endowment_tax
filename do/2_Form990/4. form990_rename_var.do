if "`c(username)'" == "yungyu"{
	global rdata "/Users/yungyu/Dropbox/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/yungyu/dropbox/02 Research/dissertation/Project/endowment_tax/wdata"
}
if "`c(username)'" == "ytvxq"{
	global rdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/rdata"
	global wdata "/Users/ytvxq/OneDrive - University of Missouri/02 Research/dissertation/Project/endowment_tax/wdata"
}

use "$wdata/Form990/Form990.dta", clear

keep if inrange(year,2010,2022)
keep ein
duplicates drop
expand 13
sort ein
by ein: gen year = 2009 + [_n]

gen matched = 0

merge 1:1 ein year using "$wdata/Form990/Form990.dta"
drop if _m == 2
replace matched = 1 if _m == 3
drop _m

merge 1:1 ein year using "$wdata/Form990/Form990_PriorYear.dta", update
drop if _m == 2
replace matched = 1 if _m >= 3
drop _m

merge 1:1 ein year using "$wdata/Form990/Form990_ScheduleD_PriorYear.dta", update
drop if _m == 2
replace matched = 1 if _m >= 3
drop _m

drop if matched == 0

gen tybegyr = substr(taxperiodbegindt,1,4)
gen tyendyr = substr(taxperiodenddt,1,4)

replace taxperiodbegindt = subinstr(taxperiodbegindt,"/","-",.)
replace taxperiodenddt = subinstr(taxperiodenddt,"/","-",.)

gen tybegm = substr(taxperiodbegindt,strpos(taxperiodbegindt,"-")+1,2)
replace tybegm = subinstr(tybegm,"-","",.)

gen tyendm = substr(taxperiodenddt,strpos(taxperiodenddt,"-")+1,2)
replace tyendm = subinstr(tyendm,"-","",.)

destring tybegyr-tyendm, replace

** Impute data by use next year report of "prior year data"
sort ein year
foreach x in contributionsgrantsamt programservicerevenueamt investmentincomeamt otherrevenueamt totalrevenueamt grantsandsimilarpaidamt benefitspaidtomembersamt salariescompempbnftpaidamt totalproffndrsngexpnsamt otherexpensesamt totalexpensesamt revenueslessexpensesamt{
	by ein: replace cy`x' = py`x'[_n+1] if cy`x' == . & py`x'[_n+1] != .
}
foreach x in totalliabilities netassetsorfundbalances cashnoninterestbearing savingsandtempcashinvst pledgesandgrantsreceivable accountsreceivable receivablesfromofficersetc rcvblfromdisqualifiedprsn othnotesloansreceivablenet inventoriesforsaleoruse prepaidexpensesdefrdcharges landbldgequipbasisnet investmentspubtradedsec investmentsothersecurities investmentsprogramrelated intangibleassets otherassetstotal accountspayableaccrexpnss grantspayable deferredrevenue taxexemptbondliabilities escrowaccountliability loansfromofficersdirectors mortgnotespyblscrdinvstprop unsecurednotesloanspayable otherliabilities unrestrictednetassets temporarilyrstrnetassets permanentlyrstrnetassets nodonorrestrictionnetassets donorrestrictionnetassets totalnetassetsfundbalance totliabnetassetsfundbalance{
	by ein: replace `x'boy = `x'eoy[_n-1] if `x'boy == . & `x'eoy[_n-1] != .
	by ein: replace `x'eoy = `x'boy[_n+1] if `x'eoy == . & `x'boy[_n+1] != .
}

by ein: replace beginningyearbalanceamt = endyearbalanceamt[_n-1] if beginningyearbalanceamt == . & endyearbalanceamt[_n-1] != .
by ein: replace endyearbalanceamt = beginningyearbalanceamt[_n-1] if endyearbalanceamt == . & beginningyearbalanceamt[_n-1] != .

cap gen revtot_990 = cytotalrevenueamt
cap gen revcon_990 = cycontributionsgrantsamt
cap gen revconpri_990 = =federatedcampaignsamt+membershipduesamt+fundraisingamt+allothercontributionsamt
cap gen revconcampaign_990 = federatedcampaignsamt
cap gen revconmember_990 = membershipduesamt
cap gen revconfundraising_990 = fundraisingamt
cap gen revconother_990 = allothercontributionsamt
cap gen revconaff_990 = relatedorganizationsamt
cap gen revcongov_990 = governmentgrantsamt
cap gen revproser_990 = cyprogramservicerevenueamt
cap gen revtuition_990 = proserrev_tuition
cap gen revauxiliary_990 = proserrev_auxser
cap gen revcontract_990 = proserrev_grantcontract
cap gen revotherproser_990 = proserrev_other
cap gen revinvestment_990 = cyinvestmentincomeamt
cap gen revothercat_990 = cyotherrevenueamt
cap gen exptot_990 = cytotalexpensesamt
cap gen netinc_990 = cyrevenueslessexpensesamt
cap gen expgrant_990 = cygrantsandsimilarpaidamt
cap gen expstdgrant_990 = grantstodomesticindividuals
cap gen expdorggrant_990 = grantstodomesticorgs
cap gen expforeigngrant_990 = foreigngrants
cap gen expsalarybenefit_990 = cysalariescompempbnftpaidamt
cap gen expsalary_990 = compcurrentofcrdirectors+compdisqualpersons+othersalariesandwages+payrolltaxes
cap gen expsalarytop_990 = compcurrentofcrdirectors
cap gen expsalarydis_990 = compdisqualpersons
cap gen expsalaryother_990 = othersalariesandwages
cap gen expsalarypayroll_990 = payrolltaxes
cap gen expbenefit_990 = pensionplancontributions+otheremployeebenefits
cap gen exppension_990 = pensionplancontributions
cap gen expotherbenefit_990 = otheremployeebenefits
cap gen expnonemployee_990 = feesforservicesmanagement+feesforserviceslegal+feesforservicesaccounting+feesforserviceslobbying+feesforservicesproffundraising+feesforsrvcinvstmgmntfees+feesforservicesother
cap gen expadvertising_990 = advertising
cap gen expoffice_990 = officeexpenses
cap gen expit_990 = informationtechnology
cap gen exproyalties_990 = royalties
cap gen expoccupancy_990 = occupancy
cap gen exptravel_990 = travel
cap gen expgovtravel_990 = pymttravelentrtnmntpubofcl
cap gen expconference_990 = conferencesmeetings
cap gen expinterest_990 = interest
cap gen expaffliates_990 = paymentstoaffiliates
cap gen expdepreciation_990 = depreciationdepletion
cap gen expinsurance_990 = insurance
cap gen asstot_990 = totalassetseoyamt
cap gen asscashsavings_990 = cashnoninterestbearingeoyamt+savingsandtempcashinvsteoyamt
cap gen asscash_990 = cashnoninterestbearingeoyamt
cap gen asssaving_990 = savingsandtempcashinvsteoyamt
cap gen asscapital_990 = landbldgequipbasisneteoyamt
cap gen assinvestment_990 = investmentspubtradedseceoyamt+investmentsothersecuritieseoyamt+investmentsprogramrelatedeoyamt
cap gen assinvestmentpub_990 = investmentspubtradedseceoyamt
cap gen assinvestmentsecurities_990 = investmentsothersecuritieseoyamt
cap gen assinvestmentprogram_990 = investmentsprogramrelatedeoyamt
cap gen assintangible_990 = intangibleassetseoyamt
cap gen liatot_990 = totalliabilitieseoyamt
cap gen netassboy_990 = netassetsorfundbalancesboyamt
cap gen netass_990 = netassetsorfundbalanceseoyamt
cap gen netasstemres_990 = temporarilyrstrnetassetseoyamt
cap gen netassperres_990 = permanentlyrstrnetassetseoyamt
cap gen netassunres_990 = unrestrictednetassetseoyamt
cap replace netassunres_990 = nodonorrestrictionnetassetseoyam if nodonorrestrictionnetassetseoyam ~= .
recode temporarilyrstrnetassetseoyamt . = 0
recode permanentlyrstrnetassetseoyamt . = 0
cap gen netassres_990 = temporarilyrstrnetassetseoyamt + permanentlyrstrnetassetseoyamt
cap replace netassres_990 = donorrestrictionnetassetseoyamt if donorrestrictionnetassetseoyamt ~= .
cap gen havingendowment_990 = donorrstrorquasiendowmentsind
cap gen endowmentboy_990 = beginningyearbalanceamt
cap gen endowmentcon_990 = contributionsamt
cap gen endowmentinv_990 = investmentearningsorlossesamt
cap gen endowmentexp_990 = grantsorscholarshipsamt+otherexpendituresamt+administrativeexpensesamt
cap gen endowmentgrants_990 = grantsorscholarshipsamt
cap gen endowmentotherexp_990 = otherexpendituresamt
cap gen endowmentadminexp_990 = administrativeexpensesamt
cap gen endowmenteoy_990 = endyearbalanceamt
cap gen boarddesignated_990 = boarddesignatedbalanceeoypct
cap gen perendowment_990 = prmnntendowmentbalanceeoypct
cap gen temendowment_990 = termendowmentbalanceeoypct
cap gen excisetax_990 = subjecttoexcstaxnetinvstincind

cap lab var revtot_990 "Revenue: Total revenue (Current Year)"
cap lab var revcon_990 "Revenue: Contributions and grants (Current Year)"
cap lab var revconpri_990 ""
cap lab var revconcampaign_990 "Contributions: Federated campaigns"
cap lab var revconmember_990 "Contributions: Membership dues"
cap lab var revconfundraising_990 "Contributions: Fundraising events"
cap lab var revconother_990 "Contributions: All other contributions, gifts, grants, and similar amounts not included above"
cap lab var revconaff_990 "Contributions: Related organizations"
cap lab var revcongov_990 "Contributions: Government grants (contributions)"
cap lab var revproser_990 "Revenue: Program service revenue (Current Year)"
cap lab var revtuition_990 "Program Service Revenue: Tuition and Fees"
cap lab var revauxiliary_990 "Program Service Revenue: Axuliary Service"
cap lab var revcontract_990 "Program Service Revenue: Grants and Contract"
cap lab var revotherproser_990 "Program Service Revenue: Other"
cap lab var revinvestment_990 "Revenue: Investment income (Current Year)"
cap lab var revothercat_990 "Revenue: Other revenue (Current Year)"
cap lab var exptot_990 "Expenses: Total expenses (Current Year)"
cap lab var netinc_990 "Expenses: Revenue less expenses (Current Year)"
cap lab var expgrant_990 "Expenses: Grants and similar amounts paid (Current Year)"
cap lab var expstdgrant_990 "Expenses: Grants and other assistance to domestic individuals"
cap lab var expdorggrant_990 "Expenses: Grants and other assistance to domestic organizations and domestic governments"
cap lab var expforeigngrant_990 "Expenses: Grants and other assistance to foreign organizations, foreign governments, and foreign individuals"
cap lab var expsalarybenefit_990 "Expenses: Salaries, other compensation, employee benefits (Current Year)"
cap lab var expsalary_990 ""
cap lab var expsalarytop_990 "Expenses: Compensation of current officers, directors,trustees, and key employees"
cap lab var expsalarydis_990 "Expenses: Compensation not included above, to disqualified persons"
cap lab var expsalaryother_990 "Expenses: Other salaries and wages"
cap lab var expsalarypayroll_990 "Expenses: Payroll taxes"
cap lab var expbenefit_990 ""
cap lab var exppension_990 "Expenses: Pension plan accruals and contributions"
cap lab var expotherbenefit_990 "Expenses: Other employee benefits"
cap lab var expnonemployee_990 ""
cap lab var expadvertising_990 "Expenses: Advertising and promotion"
cap lab var expoffice_990 "Expenses: Office expenses"
cap lab var expit_990 "Expenses: Information technology"
cap lab var exproyalties_990 "Expenses: Royalties"
cap lab var expoccupancy_990 "Expenses: Occupancy"
cap lab var exptravel_990 "Expenses: Travel"
cap lab var expgovtravel_990 "Expenses: Payments of travel or entertainment expenses for any federal, state, or local public officials"
cap lab var expconference_990 "Expenses: Conferences, conventions, and meetings"
cap lab var expinterest_990 "Expenses: Interest"
cap lab var expaffliates_990 "Expenses: Payments to affiliates"
cap lab var expdepreciation_990 "Expenses: Depreciation, depletion, and amortization"
cap lab var expinsurance_990 "Expenses: Insurance"
cap lab var asstot_990 "Assets: Total assets (End of Year)"
cap lab var asscashsavings_990 "Assets: Cash and Savings"
cap lab var asscash_990 "Assets: Cash–non-interest-bearing (End of year)"
cap lab var asssaving_990 "Assets: Savings and temporary cash investments (End of year)"
cap lab var asscapital_990 "Assets: Land, buildings, and equipment (End of year)"
cap lab var assinvestment_990 "Assets: Investments"
cap lab var assinvestmentpub_990 "Assets: Investments—publicly traded securities (End of year)"
cap lab var assinvestmentsecurities_990 "Assets: Investments—other securities (End of year)"
cap lab var assinvestmentprogram_990 "Assets: Investments—program-related (End of year)"
cap lab var assintangible_990 "Assets: Intangible assets (End of year)"
cap lab var liatot_990 "Assets: Total liabilities (End of Year)"
cap lab var netassboy_990 "Assets: Net assets or fund balances (Beginning of Current Year)"
cap lab var netass_990 "Assets: Net assets or fund balances (End of Year)"
cap lab var netasstemres_990 "Net Assets: Temporarily restricted net assets (End of year)"
cap lab var netassperres_990 "Net Assets: Permanently restricted net assets (End of year)"
cap lab var netassunres_990 "Net Assets: Net assets without donor restrictions (End of year)"
cap lab var netassres_990 "Net Assets: Net assets with donor restrictions (End of year)"
cap lab var havingendowment_990 "Having endowment?"
cap lab var endowmentboy_990 "Endowment Funds: beginning of year balance"
cap lab var endowmentcon_990 "Endowment Funds: contribution"
cap lab var endowmentinv_990 "Endowment Funds: net investment earnings, gains, and losses"
cap lab var endowmentexp_990 "Endowment Funds: expenditure"
cap lab var endowmentgrants_990 "Endowment Funds: grants or scholarship"
cap lab var endowmentotherexp_990 "Endowment Funds: other expenditure for facilities or programs"
cap lab var endowmentadminexp_990 "Endowment Funds: adminstrative expenses"
cap lab var endowmenteoy_990 "Endowment Funds: enf of year balance"
cap lab var boarddesignated_990 "Board desginated or quasi-endowment"
cap lab var perendowment_990 "Permanent endowment"
cap lab var temendowment_990 "Temporary restricted endowment"
cap lab var excisetax_990 "Subject to the excise tax on net investment income?"

keep ein name year tybegyr-tyendm *990

foreach x of varlist _all{
	cap replace `x' = subinstr(`x',"false","0",.)
	cap replace `x' = subinstr(`x',"FALSE","0",.)
	cap replace `x' = subinstr(`x',"true","1",.)
	cap replace `x' = subinstr(`x',"TRUE","1",.)
	cap destring, replace
}

compress

duplicates drop ein year, force

save "$wdata/Form990_2009to2022_full.dta", replace
