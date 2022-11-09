/*==============================================================================
	                         TABLES					   					   
==============================================================================*/

// concentration of education within occupation
// table with modal education, and the share;
// average number of workers in occupation / education (mode) cell   
// average Herfindahl index 
use ${data}/hhi_edu_within_occ.dta, clear
collapse (mean) hhi [fw=freq_occ], by(occ_4)
merge 1:1 occ_4 using ${data}/mode_edu_within_occ.dta, assert(match) nogen
drop if freq < 100 // minimum threshold
order occ_4 occ_4_label edu_3 edu_3_label freq percent hhi 
gsort -percent  
label var occ_4       "Yrke code"
label var occ_4_label "Yrke"
label var edu_3       "Mode utdanning code"
label var edu_3_label "Mode utdanning"
label var freq        "Antall"
label var percent     "Prosentandel"
label var hhi         "HHI"
export excel using ${tables}/concentration.xls, sheet("occ", replace) first(varlabels)

// Concentration of occupation within education
// table with modal occupation and its share, and average HHI. 
use ${data}/hhi_edu_m1_2015_m2_2022.dta, clear
collapse (mean) hhi [fw=freq_edu], by(edu_3)
merge 1:1 edu_3 using ${data}/mode_occ_m1_2015_m2_2022.dta, assert(match) nogen
drop if freq < 100 // minimum threshold
order edu_3 edu_3_label occ_4 occ_4_label freq percent hhi 
gsort -percent  
label var edu_3       "Utdanning code"
label var edu_3_label "Utdanning"
label var occ_4       "Yrke code (mode)"
label var occ_4_label "Yrke (mode)"
label var freq        "Antall"
label var percent     "Prosentandel"
label var hhi         "HHI"
export excel using ${tables}/concentration.xls, sheet("edu", replace) first(varlabels)



