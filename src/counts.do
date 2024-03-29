/*==============================================================================
	                        COUNTS
==============================================================================*/

// Worker-month level observations
use ${data}/workers, clear

// education, occupation, and industry
gen edu_3  = substr(pers_bu_nus2000,1,3)
gen occ_4  = substr(arb_yrke_styrk08,1,4)
gen nace_2 = substr(virk_nace1_sn07,1,2)  
merge m:1 nace_2 using ${data}/nace_1_digits.dta, nogen keepusing(nace_1) keep(master match) // aggregate industries
drop nace_2

// average number of workers within an education / occupation cell, monthly 
preserve
	contract date edu_3 occ_4, freq(freq)
	fillin date edu_3 occ_4 // rectangularize dataset, and add zeros
	replace freq = 0 if _fillin == 1 
	collapse (mean) nobs = freq, by(occ_4 edu_3)
	drop if nobs == 0 // dropping cells with 0 obs across all periods
	save ${data}/nobs_occ_4_edu_3.dta, replace
restore

// average number of workers within an education / occupation cell, monthly, alternative education grouping 
preserve
	replace edu_3 = "7" + substr(edu_3, 2, 3) if (substr(edu_3, 1, 1) == "6" | substr(edu_3, 1, 1) == "8") 
	replace edu_3 = "4" + substr(edu_3, 2, 3) if (substr(edu_3, 1, 1) == "3" | substr(edu_3, 1, 1) == "5")
	contract date edu_3 occ_4, freq(freq)
	fillin date edu_3 occ_4 // rectangularize dataset, and add zeros
	replace freq = 0 if _fillin == 1 
	collapse (mean) nobs = freq, by(occ_4 edu_3)
	drop if nobs == 0 // dropping cells with 0 obs across all periods
	save ${data}/nobs_occ_4_edu_3alt.dta, replace
restore

// average number of workers within an education / occupation / industry cell, monthly 
preserve
	contract date edu_3 occ_4 nace_1, freq(freq)
	fillin date edu_3 occ_4 nace_1 // rectangularize dataset, and add zeros
	replace freq = 0 if _fillin == 1 
	collapse (mean) nobs = freq, by(occ_4 edu_3 nace_1)
	drop if nobs == 0 // dropping cells with 0 obs across all periods
	save ${data}/nobs_occ_4_edu_3_nace_1.dta, replace
restore

exit

 
