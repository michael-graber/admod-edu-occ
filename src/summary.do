/*==============================================================================
	                   SUMMARY STATISTICS					   					   
==============================================================================*/

// Worker-month level observations
use ${data}/workers, clear

// education, occupation and industry (1-digit)
gen edu_1  = substr(pers_bu_nus2000,1,1)
gen occ_1  = substr(arb_yrke_styrk08,1,1)
gen nace_2 = substr(virk_nace1_sn07,1,2)
merge m:1 nace_2 using ${data}/nace_1_digits, keep(master match) keepusing(nace_1) nogen
drop nace_2

// descriptive statistics
tabstat pers_alder lonn, s(mean semean median sd min max p1 p99 n) columns(s) save
return list 
putexcel set ${tables}/summary.xls, sheet("age, lonn", replace) modify
putexcel A1 = matrix(r(StatTotal)), names 
preserve
	contract pers_kjoenn, freq(freq) percent(perc)
	export excel using ${tables}/summary.xls, sheet("kjonn", replace)
restore 
preserve
	contract pers_invkat, freq(freq) percent(perc)
	export excel using ${tables}/summary.xls, sheet("immigrants", replace)
restore 
preserve
	contract edu_1, freq(freq) percent(perc)
	merge 1:1 edu_1 using ${data}/edu_1_digits, keep(master match) keepusing(edu_1_label) nogen noreport
	order edu_1 edu_1_label
	export excel using ${tables}/summary.xls, sheet("education", replace)
restore 
preserve
	contract occ_1, freq(freq) percent(perc)
	merge 1:1 occ_1  using ${data}/occ_1_digits,  keep(master match) keepusing(occ_1_label) nogen noreport
	order occ_1 occ_1_label
	export excel using ${tables}/summary.xls, sheet("occupation", replace)
restore 
preserve
	contract nace_1, freq(freq) percent(perc)
	export excel using ${tables}/summary.xls, sheet("industry", replace)
restore 
exit
