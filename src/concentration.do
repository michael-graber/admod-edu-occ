/*==============================================================================
	                    CONCENTRATION
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

// concentration of education within occupations: Herfindahl index
preserve
	contract date edu_3 occ_4, freq(freq)
	egen freq_occ = sum(freq), by(date occ_4)
	gen s2 = (100 * (freq / freq_occ))^2
	collapse (sum) s2 (last) freq_occ, by(date occ_4)
	rename s2 hhi 
	merge m:1 occ_4  using ${data}/occ_4_digits, keep(master match) keepusing(occ_4_label licensed) nogen
	gen concentrated = cond(hhi >= 2500, 1, 0)
	order date occ_4 occ_4_label licensed hhi concentrated freq_occ
	save ${data}/hhi_occ_m1_2015_m2_2022.dta, replace
restore 

// concentration of occupation within education: Herfindahl index
preserve
	contract date edu_3 occ_4, freq(freq)
	egen freq_edu = sum(freq), by(date edu_3)
	gen s2 = (100 * (freq / freq_edu))^2
	collapse (sum) s2 (last) freq_edu, by(date edu_3)
	rename s2 hhi 
	merge m:1 edu_3 using ${data}/edu_3_digits, keep(master match) keepusing(edu_3_label) nogen 
	gen concentrated = cond(hhi >= 2500, 1, 0)
	order date edu_3 edu_3_label hhi concentrated freq_edu
	save ${data}/hhi_edu_m1_2015_m2_2022.dta, replace
restore 

// percentage of workers in education-concentrated occupations over time
preserve  
	use ${data}/hhi_occ_m1_2015_m2_2022.dta, clear
	collapse (mean) concentrated [fw=freq_occ], by(date)
	gen percent = 100 * concentrated
	sort date
	twoway line percent date, ///
	graphregion(color(white)) ///
	xlabel(660(12)745, format(%tmCY) grid) ///
	ylabel(0(10)50, format(%9.1f) grid) ///
	xtitle("Year") ///
	ytitle("Percent") ///
	title("{fontface Roboto Condensed Bold: Concentrated Occupations}")
	gr export ${figures}/concentrated_occ.pdf, replace 
restore

// percentage of workers in occupation-concentrated educations over time
preserve  
	use ${data}/hhi_edu_m1_2015_m2_2022.dta, clear
	collapse (mean) concentrated [fw=freq_edu], by(date)
	gen percent = 100 * concentrated
	sort date
	twoway line percent date, ///
	graphregion(color(white)) ///
	xlabel(660(12)745, format(%tmCY) grid) ///
	ylabel(0(10)50, format(%9.1f) grid) ///
	xtitle("Year") ///
	ytitle("Percent") ///
	title("{fontface Roboto Condensed Bold: Concentrated Educations}")
	gr export ${figures}/concentrated_edu.pdf, replace 
restore
exit
 
