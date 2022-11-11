/*==============================================================================
	                         FIGURES					   					   
==============================================================================*/

// threshold
local min_nobs = 100  // at least min_nobs workers in a given cell

// percentage of workers in education-concentrated occupations over time
use ${data}/hhi_edu_3_within_occ_4.dta if freq_occ > `min_nobs', clear  
collapse (mean) concentrated [fw=freq_occ], by(date)
gen percent = 100 * concentrated
sort date
twoway line percent date, ///
	graphregion(color(white)) ///
	xlabel(660(12)745, format(%tmCY) grid) ///
	ylabel(0(10)50, format(%9.1f) grid) ///
	xtitle("") ///
	ytitle("Prosent") 
gr export ${figures}/share_concentrated_edu_3_within_occ_4.png, replace 

// percentage of workers in education-concentrated occupations over time, alternative education groups
use ${data}/hhi_edu_3alt_within_occ_4.dta if freq_occ > `min_nobs', clear  
collapse (mean) concentrated [fw=freq_occ], by(date)
gen percent = 100 * concentrated
sort date
twoway line percent date, ///
	graphregion(color(white)) ///
	xlabel(660(12)745, format(%tmCY) grid) ///
	ylabel(0(10)50, format(%9.1f) grid) ///
	xtitle("") ///
	ytitle("Prosent") 
gr export ${figures}/share_concentrated_edu_3alt_within_occ_4.png, replace 

// percentage of workers in occupation-concentrated educations over time
use ${data}/hhi_occ_4_within_edu_3.dta if freq_edu > `min_nobs', clear
collapse (mean) concentrated [fw=freq_edu], by(date)
gen percent = 100 * concentrated
sort date
twoway line percent date, ///
	graphregion(color(white)) ///
	xlabel(660(12)745, format(%tmCY) grid) ///
	ylabel(0(10)50, format(%9.1f) grid) ///
	xtitle("") ///
	ytitle("Prosent") 
gr export ${figures}/share_concentrated_occ_4_within_edu_3.png, replace 

// percentage of workers in occupation-concentrated educations over time, alternative education groups
use ${data}/hhi_occ_4_within_edu_3alt.dta if freq_edu > `min_nobs', clear
collapse (mean) concentrated [fw=freq_edu], by(date)
gen percent = 100 * concentrated
sort date
twoway line percent date, ///
	graphregion(color(white)) ///
	xlabel(660(12)745, format(%tmCY) grid) ///
	ylabel(0(10)50, format(%9.1f) grid) ///
	xtitle("") ///
	ytitle("Prosent") 
gr export ${figures}/share_concentrated_occ_4_within_edu_3alt.png, replace 

**#
// concentration of education within occupation --------------------------------
// note: we consider the distribution of neq = 10000 / HHI, 
// where neq is the number of (equally sized) education groups.

// pooled across all time periods, unweighted, cdf of equivalized education groups
use ${data}/hhi_edu_3_within_occ_4.dta if freq_occ > `min_nobs', clear
gen neq = 10000 / hhi
cumul neq, gen(ecdf)
replace ecdf = ecdf * 100
sort ecdf
line ecdf neq, ///
graphregion(color(white)) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("Tilsvarende antall utdanningsgrupper") ///
ytitle("Prosent av yrker") 
gr export ${figures}/cdf_neq_edu_3_within_occ_4.png, replace

// pooled across all time periods, weighted by employment, cdf of equivalized education groups
use ${data}/hhi_edu_3_within_occ_4.dta if freq_occ > `min_nobs', clear
gen neq = 10000 / hhi
cumul neq [fw=freq_occ], gen(ecdf)
replace ecdf = ecdf * 100
sort ecdf
line ecdf neq, ///
graphregion(color(white)) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("Tilsvarende antall utdanningsgrupper") ///
ytitle("Prosent av yrker") 
gr export ${figures}/cdf_fw_neq_edu_3_within_occ_4.png, replace

// pooled across all time periods, weighted by employment, cdf of equivalized education groups, alternative education groups
use ${data}/hhi_edu_3alt_within_occ_4.dta if freq_occ > `min_nobs', clear
gen neq = 10000 / hhi
cumul neq [fw=freq_occ], gen(ecdf)
replace ecdf = ecdf * 100
sort ecdf
line ecdf neq, ///
graphregion(color(white)) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("Tilsvarende antall utdanningsgrupper") ///
ytitle("Prosent av yrker") 
gr export ${figures}/cdf_fw_neq_edu_3alt_within_occ_4.png, replace

// 2015(q2-q4) vs 2019(q1-q4), weighted by employment, cdf of equivalized education groups
use ${data}/hhi_edu_3_within_occ_4.dta if freq_occ > `min_nobs', clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
gen year = year(dofm(date))
gen neq = 10000 / hhi
bys year: cumul neq [fw=freq_occ], gen(ecdf)
replace ecdf = ecdf * 100
sort year ecdf 
twoway (line ecdf neq if year == 2015, lpattern(solid)) (line ecdf neq if year == 2019,  lpattern(dash)), ///
	graphregion(color(white)) ///
	xlabel(, format(%9.1f) grid) ///
	ylabel(, format(%9.0f) grid) ///
	xtitle("Tilsvarende antall utdanningsgrupper") ///
	ytitle("Prosent av yrker") ///
	legend(order(1 "2015" 2 "2019"))
gr export ${figures}/cdf_fw_neq_2015_vs_2019_edu_3_within_occ_4.png, replace

// 2015(q2-q4) vs 2019(q1-q4), weighted by employment, cdf of equivalized education groups, alternative education groups
use ${data}/hhi_edu_3alt_within_occ_4.dta if freq_occ > `min_nobs', clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
gen year = year(dofm(date))
gen neq = 10000 / hhi
bys year: cumul neq [fw=freq_occ], gen(ecdf)
replace ecdf = ecdf * 100
sort year ecdf 
twoway (line ecdf neq if year == 2015, lpattern(solid)) (line ecdf neq if year == 2019,  lpattern(dash)), ///
	graphregion(color(white)) ///
	xlabel(, format(%9.1f) grid) ///
	ylabel(, format(%9.0f) grid) ///
	xtitle("Tilsvarende antall utdanningsgrupper") ///
	ytitle("Prosent av yrker") ///
	legend(order(1 "2015" 2 "2019"))
gr export ${figures}/cdf_fw_neq_2015_vs_2019_edu_3alt_within_occ_4.png, replace

// 2015(q2-q4) vs 2019(q1-q4), weighted by employment, cdf of equivalized education groups, by industry
use ${data}/hhi_edu_3_within_occ_4_nace_1.dta if freq_occ_nace > `min_nobs', clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
gen year = year(dofm(date))
gen neq = 10000 / hhi
bys year nace_1: cumul neq [fw=freq_occ_nace], gen(ecdf)
replace ecdf = ecdf * 100
sort year ecdf 
twoway (line ecdf neq if year == 2015, lpattern(solid)) (line ecdf neq if year == 2019,  lpattern(dash)), ///
	by(nace_1_label, iscale(*0.8) note("")) ///
	graphregion(color(white)) ///
	xlabel(, format(%9.1f) grid) ///
	ylabel(, format(%9.0f) grid) ///
	xtitle("Tilsvarende antall utdanningsgrupper") ///
	ytitle("Prosent av yrker") ///
	legend(order(1 "2015" 2 "2019")) 
gr export ${figures}/cdf_fw_neq_2015_vs_2019_edu_3_within_occ_4_nace_1.png, replace

**#
// concentration of occupation within education --------------------------------
// note: we consider the distribution of neq = 10000 / HHI, 
// where neq is the number of (equally sized) education groups.

// pooled across all time periods, unweighted, cdf of equivalized occupation groups
use ${data}/hhi_occ_4_within_edu_3.dta if freq_edu > `min_nobs', clear
gen neq = 10000 / hhi
cumul neq, gen(ecdf)
replace ecdf = ecdf * 100
sort ecdf
line ecdf neq, ///
graphregion(color(white)) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("Tilsvarende antall yrker") ///
ytitle("Prosent av utdanningsgrupper") 
gr export ${figures}/cdf_neq_occ_4_within_edu_3.png, replace

// pooled across all time periods, weighted by employment, cdf of equivalized occupation groups
use ${data}/hhi_occ_4_within_edu_3.dta if freq_edu > `min_nobs', clear
gen neq = 10000 / hhi
cumul neq [fw=freq_edu], gen(ecdf)
replace ecdf = ecdf * 100
sort ecdf
line ecdf neq, ///
graphregion(color(white)) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("Tilsvarende antall yrker") ///
ytitle("Prosent av utdanningsgrupper") 
gr export ${figures}/cdf_fw_neq_occ_4_within_edu_3.png, replace

// pooled across all time periods, weighted by employment, cdf of equivalized occupation groups, alternative education groups
use ${data}/hhi_occ_4_within_edu_3alt.dta if freq_edu > `min_nobs', clear
gen neq = 10000 / hhi
cumul neq [fw=freq_edu], gen(ecdf)
replace ecdf = ecdf * 100
sort ecdf
line ecdf neq, ///
graphregion(color(white)) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("Tilsvarende antall yrker") ///
ytitle("Prosent av utdanningsgrupper") 
gr export ${figures}/cdf_fw_neq_occ_4_within_edu_3alt.png, replace

// 2015(q2-q4) vs 2019(q1-q4), weighted by employment, cdf of equivalized occupation groups
use ${data}/hhi_occ_4_within_edu_3.dta if freq_edu > `min_nobs', clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
gen year = year(dofm(date))
gen neq = 10000 / hhi
bys year: cumul neq [fw=freq_edu], gen(ecdf)
replace ecdf = ecdf * 100
sort year ecdf 
twoway (line ecdf neq if year == 2015, lpattern(solid)) (line ecdf neq if year == 2019,  lpattern(dash)), ///
graphregion(color(white))  ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("Tilsvarende antall yrker") ///
ytitle("Prosent av utdanningsgrupper") ///
legend(order(1 "2015" 2 "2019"))
gr export ${figures}/cdf_fw_neq_2015_vs_2019_occ_4_within_edu_3.png, replace

// 2015(q2-q4) vs 2019(q1-q4), weighted by employment, cdf of equivalized occupation groups, alternative education groups
use ${data}/hhi_occ_4_within_edu_3alt.dta if freq_edu > `min_nobs', clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
gen year = year(dofm(date))
gen neq = 10000 / hhi
bys year: cumul neq [fw=freq_edu], gen(ecdf)
replace ecdf = ecdf * 100
sort year ecdf 
twoway (line ecdf neq if year == 2015, lpattern(solid)) (line ecdf neq if year == 2019,  lpattern(dash)), ///
graphregion(color(white))  ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("Tilsvarende antall yrker") ///
ytitle("Prosent av utdanningsgrupper") ///
legend(order(1 "2015" 2 "2019"))
gr export ${figures}/cdf_fw_neq_2015_vs_2019_occ_4_within_edu_3alt.png, replace

// 2015(q2-q4) vs 2019(q1-q4), weighted by employment, ecdf of equivalized occupations, by industry
use ${data}/hhi_occ_4_within_edu_3_nace_1.dta if freq_edu_nace > `min_nobs', clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
gen year = year(dofm(date))
gen neq = 10000 / hhi
bys year nace_1: cumul neq [fw=freq_edu_nace], gen(ecdf)
replace ecdf = ecdf * 100
sort year ecdf 
twoway (line ecdf neq if year == 2015, lpattern(solid)) (line ecdf neq if year == 2019,  lpattern(dash)), ///
	by(nace_1_label, iscale(*0.8) note("")) ///
	graphregion(color(white)) ///
	xlabel(, format(%9.1f) grid) ///
	ylabel(, format(%9.0f) grid) ///
	xtitle("Tilsvarende antall yrker") ///
	ytitle("Prosent av utdanningsgrupper") ///
	legend(order(1 "2015" 2 "2019")) 
gr export ${figures}/cdf_fw_neq_2015_vs_2019_occ_4_within_edu_3_nace_1.png, replace

exit
