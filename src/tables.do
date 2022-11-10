/*==============================================================================
	                   TABLES					   					   
==============================================================================*/

// threshold
local min_nobs = 100  // at least min_nobs workers in a given cell

// concentration of education within occupation
// note: we create a table for each occupation with 
// - modal education, and its share
// - average number of workers in a month occupation / education (mode) cell   
// - Herfindahl index, averaged across periods 
use ${data}/hhi_edu_within_occ.dta if freq_occ > `min_nobs', clear // 
collapse (mean) hhi [fw=freq_occ], by(occ_4)
merge 1:1 occ_4       using ${data}/mode_edu_within_occ.dta, keep(master match) nogen
merge 1:1 occ_4 edu_3 using ${data}/nobs_occ_edu.dta, keep(master match) nogen
drop freq              // drop total number of obs in occupation / education (mode) cell   
order occ_4 occ_4_label licensed edu_3 edu_3_label nobs percent hhi 
gsort -percent  
label var occ_4       "Yrke code"
label var occ_4_label "Yrke"
label var licensed    "Lisensiert"
label var edu_3       "Mode utdanning code"
label var edu_3_label "Mode utdanning"
label var nobs        "Antall, gjennomsnitt"
label var percent     "Prosentandel"
label var hhi         "HHI"
export excel using ${tables}/concentration.xls, sheet("edu_within_occ", replace) first(varlabels)

// concentration of education within occupation, by industries
// note: we create a table for each occupation within an industry 
// - modal education, and its share
// - average number of workers in a month occupation / industry / education (mode) cell   
// - Herfindahl index, averaged across periods 
use ${data}/hhi_edu_within_occ_nace.dta if freq_occ_nace > `min_nobs', clear
collapse (mean) hhi [fw=freq_occ_nace], by(occ_4 nace_1)
merge 1:1 occ_4 nace_1       using ${data}/mode_edu_within_occ_nace.dta, keep(master match) nogen
merge 1:1 occ_4 edu_3 nace_1 using ${data}/nobs_occ_edu_nace.dta, keep(master match) nogen
drop if nobs < 5      // minimum threshold, mode is based on at least 5 obs per month on average
drop freq             // drop total number of obs in occupation / industry / education (mode) cell   
order occ_4 occ_4_label licensed edu_3 edu_3_label nobs percent hhi nace_1 nace_1_label 
gsort nace_1 -percent  
label var occ_4        "Yrke code"
label var occ_4_label  "Yrke"
label var licensed     "Lisensiert"
label var edu_3        "Mode utdanning code"
label var edu_3_label  "Mode utdanning"
label var nobs         "Antall, gjennomsnitt"
label var percent      "Prosentandel"
label var hhi          "HHI"
label var nace_1       "Industri code"
label var nace_1_label "Industri"

levelsof nace_1, local(nace_codes) 
foreach i of local nace_codes {
	export excel using ${tables}/concentration.xls if nace_1 == "`i'", sheet("edu_within_occ_nace_`i'", replace) first(varlabels) 
}
		
// concentration of occupation within education
// note: we create a table for each education
// - modal occupation, and its share
// - average number of workers in a month education / occupation (mode) cell   
// - Herfindahl index, averaged across periods 
use ${data}/hhi_occ_within_edu.dta if freq_edu > `min_nobs', clear
collapse (mean) hhi [fw=freq_edu], by(edu_3)
merge 1:1 edu_3 using ${data}/mode_occ_within_edu.dta, keep(master match) nogen
merge 1:1 occ_4 edu_3 using ${data}/nobs_occ_edu.dta, keep(master match) nogen
drop if nobs < 5      // minimum threshold, mode is based on at least 5 obs per month on average
drop freq             // drop total number of obs in occupation / education (mode) cell   
order edu_3 edu_3_label occ_4 occ_4_label licensed nobs percent hhi 
gsort -percent  
label var edu_3       "Utdanning code"
label var edu_3_label "Utdanning"
label var occ_4       "Yrke code (mode)"
label var occ_4_label "Yrke (mode)"
label var nobs        "Antall, gjennomsnitt"
label var percent     "Prosentandel"
label var hhi         "HHI"
export excel using ${tables}/concentration.xls, sheet("occ_within_edu", replace) first(varlabels)

// concentration of occupation within education, by industries
// note: we create a table for each education within an industry
// - modal occupation, and its share
// - average number of workers in a month education / industry / occupation (mode) cell   
// - Herfindahl index, averaged across periods 
use ${data}/hhi_occ_within_edu_nace.dta if freq_edu_nace > `min_nobs', clear
collapse (mean) hhi [fw=freq_edu_nace], by(edu_3 nace_1)
merge 1:1 edu_3 nace_1 using ${data}/mode_occ_within_edu_nace.dta, keep(master match) nogen
merge 1:1 occ_4 edu_3 nace_1 using ${data}/nobs_occ_edu_nace.dta, keep(master match) nogen
drop if nobs < 5      // minimum threshold, mode is based on at least 5 obs per month on average
drop freq             // drop total number of obs in education / industry / occupation (mode) cell   
order edu_3 edu_3_label occ_4 occ_4_label licensed nobs percent hhi nace_1 nace_1_label
gsort -percent  
label var edu_3        "Utdanning code"
label var edu_3_label  "Utdanning"
label var occ_4        "Yrke code (mode)"
label var occ_4_label  "Yrke (mode)"
label var nobs         "Antall, gjennomsnitt"
label var percent      "Prosentandel"
label var hhi          "HHI"
label var nace_1       "Industri code"
label var nace_1_label "Industri"

levelsof nace_1, local(nace_codes) 
foreach i of local nace_codes {
	export excel using ${tables}/concentration.xls if nace_1 == "`i'", sheet("occ_within_edu_nace_`i'", replace) first(varlabels) 
}


