/*==============================================================================
	                   SET UP ANALYSIS DATASETS					   					   
==============================================================================*/

// Worker-month level observations --------------------------------------------- 

forvalues t = 2015 / 2022 {
	forvalues m = 1 / 12 {

		// load data
		noi di "Year = " `t' ", Month = " `m' 
		cap use fnr pers_alder arb_arbmark_status arb_hovedarbeid pers_bosett_status ///
		pers_invkat pers_kjoenn arb_arbeidstid virk_nace1_sn07 pers_bu_nus2000 ///
		arb_yrke_styrk08 lonn_fmlonn  if   ///
			!missing(fnr) &                /// non-missing identifier
			arb_arbmark_status == "1" &    /// wage earner
			arb_hovedarbeid == "1" &       /// main employment    
			inrange(pers_alder, 16, 74) &  /// age 16 - 74
			pers_bosett_status == 1 &      /// resident in Norway
			arb_arbeidstid >= 30           /// at least 30 hours per week
		using ${raw}/s312/aordning/ameld_statdata_`t'_m`m', clear 
		if _rc continue
		drop arb_arbmark_status arb_hovedarbeid pers_bosett_status arb_arbeidstid
		
		// recode variables
		tostring fnr, replace format(%17.0g)
		destring pers_kjoenn,  replace
		cap label drop kjonn
		lab define kjonn 1 "male" 2 "female"
		label values pers_kjoenn kjonn
		replace arb_yrke_styrk08 = "" if arb_yrke_styrk08 == "0000" 
		replace virk_nace1_sn07  = "" if virk_nace1_sn07 == "00.000" | substr(virk_nace1_sn07,1,1) == "-"
		replace pers_bu_nus2000  = "" if substr(pers_bu_nus2000,1,1) == "-" | substr(pers_bu_nus2000,1,1) == "9" | ///
			substr(pers_bu_nus2000,1,3) == "119" | substr(pers_bu_nus2000,1,3) == "129" | ///
			substr(pers_bu_nus2000,1,3) == "159" | substr(pers_bu_nus2000,1,3) == "189" 
			
		// salary, base year 2020
		gen year = `t'
		gen month = `m'
		cpi month year
		gen lonn = lonn_fmlonn * (112.2 / cpi)
		drop cpi year month lonn_fmlonn
		
		// date
		gen date  = mofd(mdy(`m', 15, `t'))
		format date %tm
		
		// save data
		order fnr date pers_kjoenn pers_alder pers_invkat pers_bu_nus2000 arb_yrke_styrk08 virk_nace1_sn07 lonn
		compress
		save ${data}/workers_`t'_m`m'.dta, replace
		
	}
}

// append files 
clear all
save ${data}/workers.dta, emptyok replace
forvalues t = 2015 / 2022 {
	forvalues m = 1 / 12 {
		cap append using ${data}/workers_`t'_m`m'.dta
		if _rc continue
		! rm ${data}/workers_`t'_m`m'.dta
	}
}

// impute missing obs on education using within-person mode
preserve		
	keep fnr pers_bu_nus2000
	bys fnr: egen mode_pers_bu_nus2000 = mode(pers_bu_nus2000), maxmode	
	drop pers_bu_nus2000 
	rename mode_* *
	duplicates drop
	tempfile edu_update
	save `edu_update', replace 
restore
merge m:1 fnr using `edu_update', update
drop _merge

// create a 3-digit education code, with the first digit being aggregated in 
// a meaningful way for our analysis: for example, we take together the 
// digits 6, 7, and 8. This implies that we group together those with 
// and undergraduate, graduate and post-graduate degree.
gen nus = substr(pers_bu_nus2000, 1, 3)
replace nus = "7" + substr(nus, 2, 3) if (substr(nus, 1, 1) == "6" | substr(nus, 1, 1) == "8") 
replace nus = "4" + substr(nus, 2, 3) if (substr(nus, 1, 1) == "3" | substr(nus, 1, 1) == "5") 		 
label var nus "education code, modified 3 digits"

// document missing information on education, occupation and industry
preserve 			
	gen mi_edu  = missing(pers_bu_nus2000)
	gen mi_occ  = missing(arb_yrke_styrk08)
	gen mi_nace = missing(virk_nace1_sn07)
	collapse (mean) mi_edu mi_occ mi_nace, by(date)
	label var mi_edu  "Education"
	label var mi_occ  "Occupation"
	label var mi_nace "Industry"
	sort date
	export excel using ${tables}/summary.xls, sheet("missings", replace) firstrow(varl) datestring("%tm")

	twoway (connected mi_edu  date, msize(small) mcol(black)) ///
	(connected mi_occ  date, msize(small) mcol(black)) ///
	(connected mi_nace date, msize(small) mcol(black)), ///
	graphregion(color(white)) scheme(s2mono) ///
	xlabel(660(12)745, format(%tmCY) grid) ///
	ylabel(, format(%9.2f) grid) ///
	xtitle("Year") ///
	ytitle("Share of missing observations")
	graph export ${figures}/missings.pdf, replace
restore	
local N0 = _N
drop if missing(pers_bu_nus2000) | missing(arb_yrke_styrk08) | missing(virk_nace1_sn07)
local N1 = _N 
di "Missings dropped: " ((`N0' - `N1') / `N0') * 100 " %" 
compress
save ${data}/workers.dta, replace
	
// Education, occupation and industry codes ------------------------------------

// occupational licensing
// note: we use the the NOR-Database financed by the Research Council of Norway 
// (grant no. 237039). The data are collected and distributed by OsloMet. 
// The database provides a mapping from the 7 digit Styrk 98 occupation classifications
// to a binary indicator for licensed occupations.
// We then do two steps to get a binary indicator for the Styrk08 4 digits 
// occupations. First, we use a mapping between the Styrk98 to Styrk08 
// classifications provided by SSB. Second, we use the mode to indicate 
// a licensed occupation, since for any styrk08 occupation, there may exist
// more than one Styrk98 occupation.  
use yrk_kode licence_dummy using ${data}/nordatabase_lic.dta, clear
rename yrk_kode styrk98
keep if strlen(styrk98) == 7
tempfile lic_database
save `lic_database', replace 
use ${data}/codes_styrk98_08.dta, clear
merge 1:1 styrk98 using `lic_database', keep(master match) nogen 
replace licence_dummy = 0 if licence_dummy != 1
bys styrk08: egen licensed = mode(licence_dummy), maxmode
duplicates drop styrk08, force
keep styrk08 licensed
rename styrk08 occ_4
save `lic_database', replace	

// occupation codes: 1 and 4 digit level  
foreach l of numlist 1 4 {
	use ${data}/codes_styrk08.dta, clear
	keep if strlen(styrk08) == `l'
	gen occ_`l' = styrk08
	gen occ_`l'_label = name_nor
	keep occ*
	if `l' == 4 { // add license dummy
		merge 1:1 occ_4 using `lic_database', nogen 
		replace licensed = 0 if missing(licensed) == 1  // code as non-licensed if not matched
	}	
	save ${data}/occ_`l'_digits, replace
}


// education codes: 1 and 3 digit level
foreach l of numlist 1 3 {
	use ${data}/codes_nus.dta, clear
	keep if strlen(nus) == `l'
	gen edu_`l' = nus
	gen edu_`l'_label = name_nor
	keep edu*
	save ${data}/edu_`l'_digits, replace
}

// industry classifications
use ${data}/codes_sn2007.dta, clear
keep if inrange(substr(code,1,1), "A","Z")
keep code shortname 
rename shortname nace_1_label
save ${data}/nace_1_digits, replace
use ${data}/codes_sn2007.dta, clear
keep if inrange(substr(parentcode,1,1), "A","Z")
keep code parentcode
rename code code_child
rename parentcode code
merge m:1 code using ${data}/nace_1_digits, assert(match) nogen noreport
rename code nace_1 
rename code_child nace_2
save ${data}/nace_1_digits, replace


