/*==============================================================================
	                         FIGURES					   					   
==============================================================================*/

// threshold
local min_nobs = 100  // at least min_nobs workers in a given cell

// percentage of workers in education-concentrated occupations over time
use ${data}/hhi_edu_within_occ.dta if freq_occ > `min_nobs', clear // 
collapse (mean) concentrated [fw=freq_occ], by(date)
gen percent = 100 * concentrated
sort date
twoway line percent date, ///
	graphregion(color(white)) ///
	xlabel(660(12)745, format(%tmCY) grid) ///
	ylabel(0(10)50, format(%9.1f) grid) ///
	xtitle("Year") ///
	ytitle("Percent") ///
	title("{fontface Roboto Condensed Bold: Education-concentrated occupations}")
gr export ${figures}/concentration_edu_within_occ.pdf, replace 

// percentage of workers in occupation-concentrated educations over time
use ${data}/hhi_occ_within_edu.dta if freq_edu > `min_nobs', clear
collapse (mean) concentrated [fw=freq_edu], by(date)
gen percent = 100 * concentrated
sort date
twoway line percent date, ///
	graphregion(color(white)) ///
	xlabel(660(12)745, format(%tmCY) grid) ///
	ylabel(0(10)50, format(%9.1f) grid) ///
	xtitle("Year") ///
	ytitle("Percent") ///
	title("{fontface Roboto Condensed Bold: Occupation-concentrated education}")
gr export ${figures}/concentration_occ_within_edu.pdf, replace 

**#
// concentration of education within occupation --------------------------------
// note: we consider the distribution of log(HHI) = 2 * log(100) - log(n), 
// where n is the number of (equally sized) education groups.

// pooled across all time periods, unweighted, ecdf
use ${data}/hhi_edu_within_occ.dta if freq_occ > `min_nobs', clear
gen log_hhi = log(hhi)
cumul log_hhi, gen(ecdf)
replace ecdf = ecdf * 100
sort ecdf
line ecdf log_hhi, ///
graphregion(color(white)) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("log(HHI)") ///
ytitle("% of occupations") 
gr export ${figures}/cdf_edu_within_occ.png, replace

// pooled across all time periods, weighted by employment, ecdf
use ${data}/hhi_edu_within_occ.dta if freq_occ > `min_nobs', clear
gen log_hhi = log(hhi)
cumul log_hhi [fw=freq_occ], gen(ecdf)
replace ecdf = ecdf * 100
sort ecdf
line ecdf log_hhi, ///
graphregion(color(white)) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("log(HHI)") ///
ytitle("% of occupations") 
gr export ${figures}/cdf_fw_edu_within_occ.png, replace

// 2015(q2-q4) vs 2019(q1-q4), unweighted, ecdf
use ${data}/hhi_edu_within_occ.dta if freq_occ > `min_nobs', clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
gen year = year(dofm(date))
gen log_hhi = log(hhi)
bys year: cumul log_hhi, gen(ecdf)
replace ecdf = ecdf * 100
sort year ecdf 
twoway (line ecdf log_hhi if year == 2015, lpattern(solid)) (line ecdf log_hhi if year == 2019,  lpattern(dash)), ///
	graphregion(color(white)) ///
	xlabel(, format(%9.1f) grid) ///
	ylabel(, format(%9.0f) grid) ///
	xtitle("log(HHI)") ///
	ytitle("% of occupations") ///
	legend(order(1 "2015" 2 "2019"))
gr export ${figures}/cdf_2015_vs_2019_edu_within_occ.png, replace

// 2015(q2-q4) vs 2019(q1-q4), weighted by employment, ecdf
use ${data}/hhi_edu_within_occ.dta if freq_occ > `min_nobs', clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
gen year = year(dofm(date))
gen log_hhi = log(hhi)
bys year: cumul log_hhi [fw=freq_occ], gen(ecdf)
replace ecdf = ecdf * 100
sort year ecdf 
twoway (line ecdf log_hhi if year == 2015, lpattern(solid)) (line ecdf log_hhi if year == 2019,  lpattern(dash)), ///
	graphregion(color(white)) ///
	xlabel(, format(%9.1f) grid) ///
	ylabel(, format(%9.0f) grid) ///
	xtitle("log(HHI)") ///
	ytitle("% of occupations") ///
	legend(order(1 "2015" 2 "2019"))
gr export ${figures}/cdf_fw_2015_vs_2019_edu_within_occ.png, replace

// 2015(q2-q4) vs 2019(q1-q4), weighted by employment, ecdf, by industry
use ${data}/hhi_edu_within_occ_nace.dta if freq_occ_nace > `min_nobs', clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
gen year = year(dofm(date))
gen log_hhi = log(hhi)
bys year nace_1: cumul log_hhi [fw=freq_occ_nace], gen(ecdf)
replace ecdf = ecdf * 100
sort year ecdf 
twoway (line ecdf log_hhi if year == 2015, lpattern(solid)) (line ecdf log_hhi if year == 2019,  lpattern(dash)), ///
	by(nace_1_label, iscale(*0.8) note("")) ///
	graphregion(color(white)) ///
	xlabel(, format(%9.1f) grid) ///
	ylabel(, format(%9.0f) grid) ///
	xtitle("log(HHI)") ///
	ytitle("% of occupations") ///
	legend(order(1 "2015" 2 "2019")) 
gr export ${figures}/cdf_fw_2015_vs_2019_edu_within_occ_nace.png, replace

// 2015(q2-q4) vs 2019(q1-q4), relative changes in equivalized education groups
// recall that log(HHI) = 2 * log(100) - log(n), where n is the number of 
// (equally sized) education groups. Therefore, 
// log(HHI_2019) - log(HHI_2015) = - (log(n_2019) - log(n_2015)),
// which corresponds to the relative change in the equivalized education groups with the sign reversed.
use ${data}/hhi_edu_within_occ.dta if freq_occ > `min_nobs', clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
replace occ_4_label = occ_4_label + " (" + occ_4 + ")"
gen year = year(dofm(date))

collapse (mean) hhi (last) occ_4_label [fw=freq_occ], by(occ_4 year)
egen id = group(occ_4)
xtset id year, delta(4)
gen rel_change = (log(hhi) - log(L1.hhi)) * 100
keep if missing(rel_change) == 0
keep occ_4 occ_4_label rel_change 
label var rel_change "Change in HHI in %"
egen ranking = rank(rel_change)
gsort -ranking 
gen cat = ""
replace cat = "top 10" if _n <= 10
gsort +ranking 
replace cat = "bottom 10" if _n <= 10

graph hbar (asis) rel_change if missing(cat) == 0, ///
	over(cat) asyvars over(occ_4_label, sort(rel_change) descending) ///
	graphregion(color(white)) ///
	ytitle("Change in %") ///
	legend(off) 
gr export ${figures}/change_2015_vs_2019_edu_within_occ.png, replace

**#
// concentration of occupation within education --------------------------------
// Distribution of log(HHI) = 2 * log(100) - log(n), where n is the number of 
// (equally sized) occupation groups.

// pooled across all time periods, unweighted, ecdf
use ${data}/hhi_occ_within_edu.dta if freq_edu > `min_nobs', clear
gen log_hhi = log(hhi)
cumul log_hhi, gen(ecdf)
replace ecdf = ecdf * 100
sort ecdf
line ecdf log_hhi, ///
graphregion(color(white)) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("log(HHI)") ///
ytitle("% of education") 
gr export ${figures}/cdf_occ_within_edu.png, replace

// pooled across all time periods, weighted by employment, ecdf
use ${data}/hhi_occ_within_edu.dta if freq_edu > `min_nobs', clear
gen log_hhi = log(hhi)
cumul log_hhi [fw=freq_edu], gen(ecdf)
replace ecdf = ecdf * 100
sort ecdf
line ecdf log_hhi, ///
graphregion(color(white)) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("log(HHI)") ///
ytitle("% of education") 
gr export ${figures}/cdf_fw_occ_within_edu.png, replace

// 2015(q2-q4) vs 2019(q1-q4), unweighted, ecdf
use ${data}/hhi_occ_within_edu.dta if freq_edu > `min_nobs', clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
gen year = year(dofm(date))
gen log_hhi = log(hhi)
bys year: cumul log_hhi, gen(ecdf)
replace ecdf = ecdf * 100
sort year ecdf 
twoway (line ecdf log_hhi if year == 2015, lpattern(solid)) (line ecdf log_hhi if year == 2019,  lpattern(dash)), ///
graphregion(color(white)) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("log(HHI)") ///
ytitle("% of education") ///
legend(order(1 "2015" 2 "2019"))
gr export ${figures}/cdf_2015_vs_2019_occ_within_edu.png, replace

// 2015(q2-q4) vs 2019(q1-q4), weighted by employment, ecdf
use ${data}/hhi_occ_within_edu.dta if freq_edu > `min_nobs', clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
gen year = year(dofm(date))
gen log_hhi = log(hhi)
bys year: cumul log_hhi [fw=freq_edu], gen(ecdf)
replace ecdf = ecdf * 100
sort year ecdf 
twoway (line ecdf log_hhi if year == 2015, lpattern(solid)) (line ecdf log_hhi if year == 2019,  lpattern(dash)), ///
graphregion(color(white))  ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("log(HHI)") ///
ytitle("% of education") ///
legend(order(1 "2015" 2 "2019"))
gr export ${figures}/cdf_fw_2015_vs_2019_occ_within_edu.png, replace

// 2015(q2-q4) vs 2019(q1-q4), weighted by employment, ecdf, by industry
use ${data}/hhi_occ_within_edu_nace.dta if freq_edu_nace > `min_nobs', clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
gen year = year(dofm(date))
gen log_hhi = log(hhi)
bys year nace_1: cumul log_hhi [fw=freq_edu_nace], gen(ecdf)
replace ecdf = ecdf * 100
sort year ecdf 
twoway (line ecdf log_hhi if year == 2015, lpattern(solid)) (line ecdf log_hhi if year == 2019,  lpattern(dash)), ///
	by(nace_1_label, iscale(*0.8) note("")) ///
	graphregion(color(white)) ///
	xlabel(, format(%9.1f) grid) ///
	ylabel(, format(%9.0f) grid) ///
	xtitle("log(HHI)") ///
	ytitle("% of education") ///
	legend(order(1 "2015" 2 "2019")) 
gr export ${figures}/cdf_fw_2015_vs_2019_occ_within_edu_nace.png, replace

// 2015(q2-q4) vs 2019(q1-q4): relative changes in equivalized occupation groups
use ${data}/hhi_occ_within_edu.dta if freq_edu > `min_nobs', clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
replace edu_3_label = edu_3_label + " (" + edu_3 + ")"
gen year = year(dofm(date))
collapse (mean) hhi (mean) freq_edu (last) edu_3_label, by(edu_3 year)
egen id = group(edu_3)
xtset id year, delta(4)
gen rel_change = (log(hhi) - log(L1.hhi)) * 100
keep if missing(rel_change) == 0
keep edu_3 edu_3_label rel_change 
label var rel_change "Change in HHI in %"
egen ranking = rank(rel_change)
gsort -ranking 
gen cat = ""
replace cat = "top 10" if _n <= 10
gsort +ranking 
replace cat = "bottom 10" if _n <= 10

graph hbar (asis) rel_change if missing(cat) == 0, ///
	over(cat) asyvars over(edu_3_label, sort(rel_change) descending) ///
	graphregion(color(white)) ///
	ytitle("Change in %") ///
	legend(off) 
gr export ${figures}/change_2015_vs_2019_occ_within_edu.png, replace
