/*==============================================================================
	                    MODES
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

// modal education within occupation
preserve 
	contract edu_3 occ_4, freq(freq) 
	egen freq_occ    = sum(freq), by(occ_4)
	gen percent      = (freq / freq_occ) * 100 
	egen max_percent = max(percent), by(occ_4)
	gen mode         = cond(max_percent == percent, 1, 0)
	keep if mode == 1
	keep occ_4 edu_3 freq percent
	merge m:1 edu_3  using ${data}/edu_3_digits,  keep(master match) keepusing(edu_3_label) nogen 
	merge m:1 occ_4  using ${data}/occ_4_digits,  keep(master match) keepusing(occ_4_label licensed) nogen
	order occ_4 occ_4_label licensed edu_3 edu_3_label freq percent
	gsort -percent
	save ${data}/mode_edu_within_occ.dta, replace
restore

// modal education within occupation / industry cells
preserve 
	contract edu_3 occ_4 nace_1, freq(freq) 
	egen freq_occ_nace = sum(freq), by(occ_4 nace_1)
	gen percent        = (freq / freq_occ_nace) * 100 
	egen max_percent   = max(percent), by(occ_4 nace_1)
	gen mode           = cond(max_percent == percent, 1, 0)
	keep if mode == 1
	keep occ_4 nace_1 edu_3 freq percent
	merge m:1 edu_3  using ${data}/edu_3_digits,  keep(master match) keepusing(edu_3_label) nogen 
	merge m:1 occ_4  using ${data}/occ_4_digits,  keep(master match) keepusing(occ_4_label licensed) nogen
	merge m:m nace_1 using ${data}/nace_1_digits, keep(master match) keepusing(nace_1_label) nogen // m:m merge is ok here
	order occ_4 occ_4_label licensed nace_1 nace_1_label edu_3 edu_3_label freq percent
	gsort -percent
	save ${data}/mode_edu_within_occ_nace.dta, replace
restore

// modal occupation within education
preserve 
	contract edu_3 occ_4, freq(freq) 
	egen freq_edu    = sum(freq), by(edu_3)
	gen percent      = (freq / freq_edu) * 100 
	egen max_percent = max(percent), by(edu_3)
	gen mode         = cond(max_percent == percent, 1, 0)
	keep if mode == 1
	keep occ_4 edu_3 freq percent
	merge m:1 edu_3  using ${data}/edu_3_digits,  keep(master match) keepusing(edu_3_label) nogen 
	merge m:1 occ_4  using ${data}/occ_4_digits,  keep(master match) keepusing(occ_4_label licensed) nogen
	order edu_3 edu_3_label occ_4 occ_4_label licensed freq percent
	gsort -percent
	save ${data}/mode_occ_within_edu.dta, replace
restore

// modal occupation within education / industry cells
preserve 
	contract edu_3 occ_4 nace_1, freq(freq) 
	egen freq_edu_nace = sum(freq), by(edu_3 nace_1)
	gen percent        = (freq / freq_edu_nace) * 100 
	egen max_percent   = max(percent), by(edu_3)
	gen mode           = cond(max_percent == percent, 1, 0)
	keep if mode == 1
	keep occ_4 edu_3 nace_1 freq percent
	merge m:1 edu_3  using ${data}/edu_3_digits,  keep(master match) keepusing(edu_3_label) nogen 
	merge m:1 occ_4  using ${data}/occ_4_digits,  keep(master match) keepusing(occ_4_label licensed) nogen
	merge m:m nace_1 using ${data}/nace_1_digits, keep(master match) keepusing(nace_1_label) nogen // m:m merge is ok here
	order edu_3 edu_3_label nace_1 nace_1_label occ_4 occ_4_label licensed freq percent
	gsort -percent
	save ${data}/mode_occ_within_edu_nace.dta, replace
restore

exit
