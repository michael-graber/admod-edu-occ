/*==============================================================================
	               MODES (3-digit education, 4-digit occupation)
==============================================================================*/

// Period 2015/1 - 2022/2 ------------------------------------------------------

// Worker-month level observations
use ${data}/workers, clear

// education and occupation
gen edu_3  = substr(pers_bu_nus2000,1,3)
gen occ_4  = substr(arb_yrke_styrk08,1,4)

// aggregate 3-digit education code
// note: aggregate first digit, taking together, for example, digits 6, 7, and 8
// implies that we group together those with and undergraduate, graduate and post-graduate degree.
replace edu_3 = "7" + substr(edu_3, 2, 3) if (substr(edu_3, 1, 1) == "6" | substr(edu_3, 1, 1) == "8") 
replace edu_3 = "4" + substr(edu_3, 2, 3) if (substr(edu_3, 1, 1) == "3" | substr(edu_3, 1, 1) == "5") 	

// frequencies within education / occupation cells
contract edu_3 occ_4, freq(freq)

// modal education within occupation
preserve 
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
	save ${data}/mode_edu_m1_2015_m2_2022.dta, replace
restore

// modal occupation within education
preserve 
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
	save ${data}/mode_occ_m1_2015_m2_2022.dta, replace
restore

// Period 2015/q2 - 2015/q4 ----------------------------------------------------

// Worker-month level observations
use if date >= ym(2015,4) & date <= ym(2015,12) using ${data}/workers, clear

// education and occupation
gen edu_3  = substr(pers_bu_nus2000,1,3)
gen occ_4  = substr(arb_yrke_styrk08,1,4)

// aggregate 3-digit education code
// note: aggregate first digit, taking together, for example, digits 6, 7, and 8
// implies that we group together those with and undergraduate, graduate and post-graduate degree.
replace edu_3 = "7" + substr(edu_3, 2, 3) if (substr(edu_3, 1, 1) == "6" | substr(edu_3, 1, 1) == "8") 
replace edu_3 = "4" + substr(edu_3, 2, 3) if (substr(edu_3, 1, 1) == "3" | substr(edu_3, 1, 1) == "5") 	

// frequencies within education / occupation cells
contract edu_3 occ_4, freq(freq)

// modal education within occupation
preserve 
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
	save ${data}/mode_edu_q2_2015_q4_2015.dta, replace
restore

// modal occupation within education
preserve 
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
	save ${data}/mode_occ_q2_2015_q4_2015.dta, replace
restore

// Period 2019/q1 - 2019/q4 ----------------------------------------------------

// Worker-month level observations
use if date >= ym(2019,1) & date <= ym(2019,12) using ${data}/workers, clear

// education and occupation
gen edu_3  = substr(pers_bu_nus2000,1,3)
gen occ_4  = substr(arb_yrke_styrk08,1,4)

// aggregate 3-digit education code
// note: aggregate first digit, taking together, for example, digits 6, 7, and 8
// implies that we group together those with and undergraduate, graduate and post-graduate degree.
replace edu_3 = "7" + substr(edu_3, 2, 3) if (substr(edu_3, 1, 1) == "6" | substr(edu_3, 1, 1) == "8") 
replace edu_3 = "4" + substr(edu_3, 2, 3) if (substr(edu_3, 1, 1) == "3" | substr(edu_3, 1, 1) == "5") 	

// frequencies within education / occupation cells
contract edu_3 occ_4, freq(freq)

// modal education within occupation
preserve 
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
	save ${data}/mode_edu_q1_2019_q4_2019.dta, replace
restore

// modal occupation within education
preserve 
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
	save ${data}/mode_occ_q1_2019_q4_2019.dta, replace
restore
exit
