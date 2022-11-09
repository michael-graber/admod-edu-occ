/*==============================================================================
	                    CONCENTRATION
==============================================================================*/

// Worker-month level observations
use ${data}/workers, clear

// education, occupation, and industry
gen edu_3  = substr(pers_bu_nus2000,1,3)
gen occ_4  = substr(arb_yrke_styrk08,1,4)
gen nace_2 = substr(virk_nace1_sn07,1,2)  

// aggregate education
// note: aggregate first digit, taking together, for example, digits 6, 7, and 8
// implies that we group together those with and undergraduate, graduate and post-graduate degree.
replace edu_3 = "7" + substr(edu_3, 2, 3) if (substr(edu_3, 1, 1) == "6" | substr(edu_3, 1, 1) == "8") 
replace edu_3 = "4" + substr(edu_3, 2, 3) if (substr(edu_3, 1, 1) == "3" | substr(edu_3, 1, 1) == "5")

// aggregate industries
merge m:1 nace_2 using ${data}/nace_1_digits.dta, nogen keepusing(nace_1) keep(master match)
drop nace_2

// concentration of education within occupations, Herfindahl index
preserve
	contract date edu_3 occ_4, freq(freq)
	egen freq_occ = sum(freq), by(date occ_4)  
	gen s2 = (100 * (freq / freq_occ))^2
	collapse (sum) hhi = s2 (last) freq_occ, by(date occ_4) 
	merge m:1 occ_4  using ${data}/occ_4_digits, keep(master match) keepusing(occ_4_label licensed) nogen
	gen concentrated = cond(hhi >= 2500, 1, 0)
	order date occ_4 occ_4_label licensed hhi concentrated freq_occ
	sort occ_4 date
	save ${data}/hhi_edu_within_occ.dta, replace
restore 

// concentration of education within occupations / industries, Herfindahl index
preserve
	contract date edu_3 occ_4 nace_1, freq(freq)
	egen freq_occ_nace = sum(freq), by(date occ_4 nace_1)
	gen s2 = (100 * (freq / freq_occ_nace))^2
	collapse (sum) hhi = s2 (last) freq_occ_nace, by(date occ_4 nace_1) 
	merge m:1 occ_4  using ${data}/occ_4_digits,  keep(master match) keepusing(occ_4_label licensed) nogen
	merge m:m nace_1 using ${data}/nace_1_digits, keep(master match) keepusing(nace_1_label) nogen // m:m merge is ok here
	gen concentrated = cond(hhi >= 2500, 1, 0)
	order date nace_1 nace_1_label occ_4 occ_4_label licensed hhi concentrated freq_occ_nace
	sort occ_4 nace_1 date
	save ${data}/hhi_edu_within_occ_nace.dta, replace
restore 

// concentration of occupation within education, Herfindahl index
preserve
	contract date edu_3 occ_4, freq(freq)
	egen freq_edu = sum(freq), by(date edu_3)
	gen s2 = (100 * (freq / freq_edu))^2
	collapse (sum) hhi = s2 (last) freq_edu, by(date edu_3)
	merge m:1 edu_3 using ${data}/edu_3_digits, keep(master match) keepusing(edu_3_label) nogen 
	gen concentrated = cond(hhi >= 2500, 1, 0)
	order date edu_3 edu_3_label hhi concentrated freq_edu
	sort edu_3 date
	save ${data}/hhi_occ_within_edu.dta, replace
restore 

// concentration of occupation within education / industries, Herfindahl index
preserve
	contract date edu_3 occ_4 nace_1, freq(freq)
	egen freq_edu_nace = sum(freq), by(date edu_3 nace_1)
	gen s2 = (100 * (freq / freq_edu_nace))^2
	collapse (sum) hhi = s2 (last) freq_edu_nace, by(date edu_3 nace_1)
	merge m:1 edu_3  using ${data}/edu_3_digits, keep(master match) keepusing(edu_3_label) nogen
	merge m:m nace_1 using ${data}/nace_1_digits, keep(master match) keepusing(nace_1_label) nogen // m:m merge is ok here
	gen concentrated = cond(hhi >= 2500, 1, 0)
	order date nace_1 nace_1_label edu_3 edu_3_label hhi concentrated freq_edu_nace
	sort edu_3 nace_1 date
	save ${data}/hhi_occ_within_edu_nace.dta, replace
restore 

exit
 
