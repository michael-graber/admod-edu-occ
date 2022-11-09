/*==============================================================================
	                         FIGURES					   					   
==============================================================================*/

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


// Concentration of education within occupation --------------------------------
// Distribution of log(HHI) = 2 * log(100) - log(n), where n is the number of 
// (equally sized) education groups.

// pooled across all time periods, unweighted, pdf
use ${data}/hhi_occ_m1_2015_m2_2022.dta, clear
gen log_hhi = log(hhi)
hist log_hhi, bin(20) ///
graphregion(color(white)) scheme(s2mono) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.1f) grid) ///
xtitle("log(HHI)") 
gr export ${figures}/hist_hhi_occ_m1_2015_m2_2022.png, replace

// pooled across all time periods, unweighted, ecdf
use ${data}/hhi_occ_m1_2015_m2_2022.dta, clear
gen log_hhi = log(hhi)
cumul log_hhi, gen(ecdf)
replace ecdf = ecdf * 100
sort ecdf
line ecdf log_hhi, ///
graphregion(color(white)) scheme(s2mono) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("log(HHI)") ///
ytitle("% of occupations") 
gr export ${figures}/ecdf_hhi_occ_m1_2015_m2_2022.png, replace

// pooled across all time periods, weighted by employment, pdf
use ${data}/hhi_occ_m1_2015_m2_2022.dta, clear
gen log_hhi = log(hhi)
hist log_hhi [fw=freq_occ], bin(20) ///
graphregion(color(white)) scheme(s2mono) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.1f) grid) ///
xtitle("log(HHI)") 
gr export ${figures}/hist_fwhhi_occ_m1_2015_m2_2022.png, replace

// pooled across all time periods, weighted by employment, ecdf
use ${data}/hhi_occ_m1_2015_m2_2022.dta, clear
gen log_hhi = log(hhi)
cumul log_hhi [fw=freq_occ], gen(ecdf)
replace ecdf = ecdf * 100
sort ecdf
line ecdf log_hhi, ///
graphregion(color(white)) scheme(s2mono) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("log(HHI)") ///
ytitle("% of occupations") 
gr export ${figures}/ecdf_fwhhi_occ_m1_2015_m2_2022.png, replace

// Period 2015/q2 - 2015/q4 vs 2019/q1 - 2019/q4, unweighted, pdf
use ${data}/hhi_occ_m1_2015_m2_2022.dta, clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
gen year = year(dofm(date))
gen log_hhi = log(hhi)
twoway (hist log_hhi if year == 2015,  bcolor(red%30) bin(20)) (hist log_hhi if year == 2019,  bcolor(blue%30) bin(20)), ///
graphregion(color(white)) scheme(s2mono) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.1f) grid) ///
xtitle("log(HHI)") ///
legend(order(1 "2015" 2 "2019"))
gr export ${figures}/hist_hhi_occ_2015_vs_2019.png, replace

// Period 2015/q2 - 2015/q4 vs 2019/q1 - 2019/q4, unweighted, ecdf
use ${data}/hhi_occ_m1_2015_m2_2022.dta, clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
gen year = year(dofm(date))
gen log_hhi = log(hhi)
bys year: cumul log_hhi, gen(ecdf)
replace ecdf = ecdf * 100
sort year ecdf 
twoway (line ecdf log_hhi if year == 2015, bcolor(red%30)) (line ecdf log_hhi if year == 2019,  bcolor(blue%30)), ///
graphregion(color(white)) scheme(s2mono) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("log(HHI)") ///
ytitle("% of occupations") ///
legend(order(1 "2015" 2 "2019"))
gr export ${figures}/ecdf_hhi_occ_2015_vs_2019.png, replace

// Period 2015/q2 - 2015/q4 vs 2019/q1 - 2019/q4, weighted by employment, pdf
use ${data}/hhi_occ_m1_2015_m2_2022.dta, clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
gen year = year(dofm(date))
gen log_hhi = log(hhi)
twoway (hist log_hhi [fw=freq_occ] if year == 2015,  bcolor(red%30) bin(20)) (hist log_hhi [fw=freq_occ] if year == 2019,  bcolor(blue%30) bin(20)), ///
graphregion(color(white)) scheme(s2mono) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.1f) grid) ///
xtitle("log(HHI)") ///
legend(order(1 "2015" 2 "2019"))
gr export ${figures}/hist_fwhhi_occ_2015_vs_2019.png, replace

// Period 2015/q2 - 2015/q4 vs 2019/q1 - 2019/q4, weighted by employment, ecdf
use ${data}/hhi_occ_m1_2015_m2_2022.dta, clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
gen year = year(dofm(date))
gen log_hhi = log(hhi)
bys year: cumul log_hhi [fw=freq_occ], gen(ecdf)
replace ecdf = ecdf * 100
sort year ecdf 
twoway (line ecdf log_hhi if year == 2015, bcolor(red%30)) (line ecdf log_hhi if year == 2019,  bcolor(blue%30)), ///
graphregion(color(white)) scheme(s2mono) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("log(HHI)") ///
ytitle("% of occupations") ///
legend(order(1 "2015" 2 "2019"))
gr export ${figures}/ecdf_fwhhi_occ_2015_vs_2019.png, replace

// Period 2015/q2 - 2015/q4 vs 2019/q1 - 2019/q4: relative changes in equivalized education groups
// Recall that log(HHI) = 2 * log(100) - log(n), where n is the number of 
// (equally sized) education groups. Therefore, 
// log(HHI_2019) - log(HHI_2015) = - (log(n_2019) - log(n_2015)),
// which corresponds to the relative change in the equivalized education groups with the sign reversed.
use ${data}/hhi_occ_m1_2015_m2_2022.dta, clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
replace occ_4_label = occ_4_label + " (" + occ_4 + ")"
gen year = year(dofm(date))
collapse (mean) hhi (mean) freq_occ (last) occ_4_label, by(occ_4 year)
keep if freq_occ > 1000
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
bar(1, color(red)) bar(2, color(green)) ///
graphregion(color(white)) ///
ytitle("Change in %") ///
legend(off) 
gr export ${figures}/rel_change_hhi_occ_2015_vs_2019.png, replace

// Concentration of occupation within education --------------------------------
// Distribution of log(HHI) = 2 * log(100) - log(n), where n is the number of 
// (equally sized) occupation groups.

// pooled across all time periods, unweighted, pdf
use ${data}/hhi_edu_m1_2015_m2_2022.dta, clear
gen log_hhi = log(hhi)
hist log_hhi, bin(20) ///
graphregion(color(white)) scheme(s2mono) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.1f) grid) ///
xtitle("log(HHI)") 
gr export ${figures}/hist_hhi_edu_m1_2015_m2_2022.png, replace

// pooled across all time periods, unweighted, ecdf
use ${data}/hhi_edu_m1_2015_m2_2022.dta, clear
gen log_hhi = log(hhi)
cumul log_hhi, gen(ecdf)
replace ecdf = ecdf * 100
sort ecdf
line ecdf log_hhi, ///
graphregion(color(white)) scheme(s2mono) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("log(HHI)") ///
ytitle("% of education") 
gr export ${figures}/ecdf_hhi_edu_m1_2015_m2_2022.png, replace

// pooled across all time periods, weighted by employment, pdf
use ${data}/hhi_edu_m1_2015_m2_2022.dta, clear
gen log_hhi = log(hhi)
hist log_hhi [fw=freq_edu], bin(20) ///
graphregion(color(white)) scheme(s2mono) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.1f) grid) ///
xtitle("log(HHI)") 
gr export ${figures}/hist_fwhhi_edu_m1_2015_m2_2022.png, replace

// pooled across all time periods, weighted by employment, ecdf
use ${data}/hhi_edu_m1_2015_m2_2022.dta, clear
gen log_hhi = log(hhi)
cumul log_hhi [fw=freq_edu], gen(ecdf)
replace ecdf = ecdf * 100
sort ecdf
line ecdf log_hhi, ///
graphregion(color(white)) scheme(s2mono) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("log(HHI)") ///
ytitle("% of education") 
gr export ${figures}/ecdf_fwhhi_edu_m1_2015_m2_2022.png, replace

// Period 2015/q2 - 2015/q4 vs 2019/q1 - 2019/q4, unweighted, pdf
use ${data}/hhi_edu_m1_2015_m2_2022.dta, clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
gen year = year(dofm(date))
gen log_hhi = log(hhi)
twoway (hist log_hhi if year == 2015,  bcolor(red%30) bin(20)) (hist log_hhi if year == 2019,  bcolor(blue%30) bin(20)), ///
graphregion(color(white)) scheme(s2mono) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.1f) grid) ///
xtitle("log(HHI)") ///
legend(order(1 "2015" 2 "2019"))
gr export ${figures}/hist_hhi_edu_2015_vs_2019.png, replace

// Period 2015/q2 - 2015/q4 vs 2019/q1 - 2019/q4, unweighted, ecdf
use ${data}/hhi_edu_m1_2015_m2_2022.dta, clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
gen year = year(dofm(date))
gen log_hhi = log(hhi)
bys year: cumul log_hhi, gen(ecdf)
replace ecdf = ecdf * 100
sort year ecdf 
twoway (line ecdf log_hhi if year == 2015, bcolor(red%30)) (line ecdf log_hhi if year == 2019,  bcolor(blue%30)), ///
graphregion(color(white)) scheme(s2mono) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("log(HHI)") ///
ytitle("% of education") ///
legend(order(1 "2015" 2 "2019"))
gr export ${figures}/ecdf_hhi_edu_2015_vs_2019.png, replace

// Period 2015/q2 - 2015/q4 vs 2019/q1 - 2019/q4, weighted by employment, pdf
use ${data}/hhi_edu_m1_2015_m2_2022.dta, clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
gen year = year(dofm(date))
gen log_hhi = log(hhi)
twoway (hist log_hhi [fw=freq_edu] if year == 2015,  bcolor(red%30) bin(20)) (hist log_hhi [fw=freq_edu] if year == 2019,  bcolor(blue%30) bin(20)), ///
graphregion(color(white)) scheme(s2mono) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.1f) grid) ///
xtitle("log(HHI)") ///
legend(order(1 "2015" 2 "2019"))
gr export ${figures}/hist_fwhhi_edu_2015_vs_2019.png, replace

// Period 2015/q2 - 2015/q4 vs 2019/q1 - 2019/q4, weighted by employment, ecdf
use ${data}/hhi_edu_m1_2015_m2_2022.dta, clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
gen year = year(dofm(date))
gen log_hhi = log(hhi)
bys year: cumul log_hhi [fw=freq_edu], gen(ecdf)
replace ecdf = ecdf * 100
sort year ecdf 
twoway (line ecdf log_hhi if year == 2015, bcolor(red%30)) (line ecdf log_hhi if year == 2019,  bcolor(blue%30)), ///
graphregion(color(white)) scheme(s2mono) ///
xlabel(, format(%9.1f) grid) ///
ylabel(, format(%9.0f) grid) ///
xtitle("log(HHI)") ///
ytitle("% of education") ///
legend(order(1 "2015" 2 "2019"))
gr export ${figures}/ecdf_fwhhi_edu_2015_vs_2019.png, replace

// Period 2015/q2 - 2015/q4 vs 2019/q1 - 2019/q4: relative changes in equivalized occupation groups
use ${data}/hhi_edu_m1_2015_m2_2022.dta, clear
keep if (date >= ym(2015,4) & date <= ym(2015,12)) | (date >= ym(2019,1) & date <= ym(2019,12))
replace edu_3_label = edu_3_label + " (" + edu_3 + ")"
gen year = year(dofm(date))
collapse (mean) hhi (mean) freq_edu (last) edu_3_label, by(edu_3 year)
keep if freq_edu > 1000
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
bar(1, color(red)) bar(2, color(green)) ///
graphregion(color(white)) ///
legend(off) 
gr export ${figures}/rel_change_hhi_edu_2015_vs_2019.png, replace
