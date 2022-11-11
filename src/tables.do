/*==============================================================================
	                   TABLES					   					   
==============================================================================*/

// threshold
local min_nobs = 100  // at least min_nobs workers in a given cell

// concentration of education within occupation
// note: we create a table, with the row indicating the occupation and columns 
// - modal education, and its share
// - average number of workers in a month occupation / education (mode) cell   
// - Herfindahl index, averaged across periods 
use ${data}/hhi_edu_3_within_occ_4.dta if freq_occ > `min_nobs', clear // 
collapse (mean) hhi [fw=freq_occ], by(occ_4)
merge 1:1 occ_4       using ${data}/mode_edu_3_within_occ_4.dta, keep(master match) nogen
merge 1:1 occ_4 edu_3 using ${data}/nobs_occ_4_edu_3.dta, keep(master match) nogen
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
export excel using ${tables}/concentration.xls, sheet("edu_3_within_occ_4", replace) first(varlabels)

// concentration of education within occupation, alternative education groups
use ${data}/hhi_edu_3alt_within_occ_4.dta if freq_occ > `min_nobs', clear // 
collapse (mean) hhi [fw=freq_occ], by(occ_4)
merge 1:1 occ_4       using ${data}/mode_edu_3alt_within_occ_4.dta, keep(master match) nogen
merge 1:1 occ_4 edu_3 using ${data}/nobs_occ_4_edu_3alt.dta, keep(master match) nogen
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
export excel using ${tables}/concentration.xls, sheet("edu_3alt_within_occ_4", replace) first(varlabels)

// concentration of education within occupation, by industries
use ${data}/hhi_edu_3_within_occ_4_nace_1.dta if freq_occ_nace > `min_nobs', clear
collapse (mean) hhi [fw=freq_occ_nace], by(occ_4 nace_1)
merge 1:1 occ_4 nace_1       using ${data}/mode_edu_3_within_occ_4_nace_1.dta, keep(master match) nogen
merge 1:1 occ_4 edu_3 nace_1 using ${data}/nobs_occ_4_edu_3_nace_1.dta, keep(master match) nogen
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
	export excel using ${tables}/concentration_by_industry.xls if nace_1 == "`i'", sheet("edu_3_within_occ_4_nace_`i'", replace) first(varlabels) 
}
		
// concentration of occupation within education
use ${data}/hhi_occ_4_within_edu_3.dta if freq_edu > `min_nobs', clear
collapse (mean) hhi [fw=freq_edu], by(edu_3)
merge 1:1 edu_3 using ${data}/mode_occ_4_within_edu_3.dta, keep(master match) nogen
merge 1:1 occ_4 edu_3 using ${data}/nobs_occ_4_edu_3.dta, keep(master match) nogen
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
export excel using ${tables}/concentration.xls, sheet("occ_4_within_edu_3", replace) first(varlabels)

// concentration of occupation within education, alternative education groups
use ${data}/hhi_occ_4_within_edu_3alt.dta if freq_edu > `min_nobs', clear
collapse (mean) hhi [fw=freq_edu], by(edu_3)
merge 1:1 edu_3 using ${data}/mode_occ_4_within_edu_3alt.dta, keep(master match) nogen
merge 1:1 occ_4 edu_3 using ${data}/nobs_occ_4_edu_3alt.dta, keep(master match) nogen
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
export excel using ${tables}/concentration.xls, sheet("occ_4_within_edu_3alt", replace) first(varlabels)

// concentration of occupation within education, by industries
use ${data}/hhi_occ_4_within_edu_3_nace_1.dta if freq_edu_nace > `min_nobs', clear
collapse (mean) hhi [fw=freq_edu_nace], by(edu_3 nace_1)
merge 1:1 edu_3 nace_1 using ${data}/mode_occ_4_within_edu_3_nace_1.dta, keep(master match) nogen
merge 1:1 occ_4 edu_3 nace_1 using ${data}/nobs_occ_4_edu_3_nace_1.dta, keep(master match) nogen
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
	export excel using ${tables}/concentration_by_industry.xls if nace_1 == "`i'", sheet("occ_4_within_edu_3_nace_1_`i'", replace) first(varlabels) 
}


