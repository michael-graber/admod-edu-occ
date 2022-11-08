/*==============================================================================
                        CONSUMER PRICE INDEX

This script creates a new variable `cpi' that represents the value of the 
consumper price index (2015 = 100)
	      
args: 
month: month
year: year
==============================================================================*/

cap program drop cpi

program define cpi

	version 17.0
	args month year 
	confirm new var cpi

	quietly{
		gen cpi = .
		replace cpi =  98.6 if  `year' == 2015 & `month' == 1
		replace cpi =  98.9 if  `year' == 2015 & `month' == 2
		replace cpi =  99.2 if  `year' == 2015 & `month' == 3
		replace cpi =  99.6 if  `year' == 2015 & `month' == 4
		replace cpi =  99.8 if  `year' == 2015 & `month' == 5
		replace cpi = 100.1 if  `year' == 2015 & `month' == 6
		replace cpi = 100.1 if  `year' == 2015 & `month' == 7
		replace cpi =  99.9 if  `year' == 2015 & `month' == 8
		replace cpi = 100.6 if  `year' == 2015 & `month' == 9
		replace cpi = 101.0 if  `year' == 2015 & `month' == 10
		replace cpi = 101.3 if  `year' == 2015 & `month' == 11
		replace cpi = 100.9 if  `year' == 2015 & `month' == 12
		
		replace cpi = 101.5 if  `year' == 2016 & `month' == 1
		replace cpi = 102.1 if  `year' == 2016 & `month' == 2
		replace cpi = 102.5 if  `year' == 2016 & `month' == 3
		replace cpi = 102.9 if  `year' == 2016 & `month' == 4
		replace cpi = 103.2 if  `year' == 2016 & `month' == 5
		replace cpi = 103.8 if  `year' == 2016 & `month' == 6
		replace cpi = 104.5 if  `year' == 2016 & `month' == 7
		replace cpi = 103.9 if  `year' == 2016 & `month' == 8
		replace cpi = 104.2 if  `year' == 2016 & `month' == 9
		replace cpi = 104.7 if  `year' == 2016 & `month' == 10
		replace cpi = 104.9 if  `year' == 2016 & `month' == 11
		replace cpi = 104.4 if  `year' == 2016 & `month' == 12
		
		replace cpi = 104.3 if  `year' == 2017 & `month' == 1
		replace cpi = 104.7 if  `year' == 2017 & `month' == 2
		replace cpi = 105.0 if  `year' == 2017 & `month' == 3
		replace cpi = 105.2 if  `year' == 2017 & `month' == 4
		replace cpi = 105.4 if  `year' == 2017 & `month' == 5
		replace cpi = 105.8 if  `year' == 2017 & `month' == 6
		replace cpi = 106.1 if  `year' == 2017 & `month' == 7
		replace cpi = 105.3 if  `year' == 2017 & `month' == 8
		replace cpi = 105.9 if  `year' == 2017 & `month' == 9
		replace cpi = 106.0 if  `year' == 2017 & `month' == 10
		replace cpi = 106.1 if  `year' == 2017 & `month' == 11
		replace cpi = 106.1 if  `year' == 2017 & `month' == 12
		
		replace cpi = 106.0 if  `year' == 2018 & `month' == 1
		replace cpi = 107.0 if  `year' == 2018 & `month' == 2
		replace cpi = 107.3 if  `year' == 2018 & `month' == 3
		replace cpi = 107.7 if  `year' == 2018 & `month' == 4
		replace cpi = 107.8 if  `year' == 2018 & `month' == 5
		replace cpi = 108.5 if  `year' == 2018 & `month' == 6
		replace cpi = 109.3 if  `year' == 2018 & `month' == 7
		replace cpi = 108.9 if  `year' == 2018 & `month' == 8
		replace cpi = 109.5 if  `year' == 2018 & `month' == 9
		replace cpi = 109.3 if  `year' == 2018 & `month' == 10
		replace cpi = 109.8 if  `year' == 2018 & `month' == 11
		replace cpi = 109.8 if  `year' == 2018 & `month' == 12
		
		replace cpi = 109.3 if  `year' == 2019 & `month' == 1
		replace cpi = 110.2 if  `year' == 2019 & `month' == 2
		replace cpi = 110.4 if  `year' == 2019 & `month' == 3
		replace cpi = 110.8 if  `year' == 2019 & `month' == 4
		replace cpi = 110.5 if  `year' == 2019 & `month' == 5
		replace cpi = 110.6 if  `year' == 2019 & `month' == 6
		replace cpi = 111.4 if  `year' == 2019 & `month' == 7
		replace cpi = 110.6 if  `year' == 2019 & `month' == 8
		replace cpi = 111.1 if  `year' == 2019 & `month' == 9
		replace cpi = 111.3 if  `year' == 2019 & `month' == 10
		replace cpi = 111.6 if  `year' == 2019 & `month' == 11
		replace cpi = 111.3 if  `year' == 2019 & `month' == 12
		
		replace cpi = 111.3 if  `year' == 2020 & `month' == 1
		replace cpi = 111.2 if  `year' == 2020 & `month' == 2
		replace cpi = 111.2 if  `year' == 2020 & `month' == 3
		replace cpi = 111.7 if  `year' == 2020 & `month' == 4
		replace cpi = 111.9 if  `year' == 2020 & `month' == 5
		replace cpi = 112.1 if  `year' == 2020 & `month' == 6
		replace cpi = 112.9 if  `year' == 2020 & `month' == 7
		replace cpi = 112.5 if  `year' == 2020 & `month' == 8
		replace cpi = 112.9 if  `year' == 2020 & `month' == 9
		replace cpi = 113.2 if  `year' == 2020 & `month' == 10
		replace cpi = 112.4 if  `year' == 2020 & `month' == 11
		replace cpi = 112.9 if  `year' == 2020 & `month' == 12
		
		replace cpi = 114.1 if  `year' == 2021 & `month' == 1
		replace cpi = 114.9 if  `year' == 2021 & `month' == 2
		replace cpi = 114.6 if  `year' == 2021 & `month' == 3
		replace cpi = 115.0 if  `year' == 2021 & `month' == 4
		replace cpi = 114.9 if  `year' == 2021 & `month' == 5
		replace cpi = 115.3 if  `year' == 2021 & `month' == 6
		replace cpi = 116.3 if  `year' == 2021 & `month' == 7
		replace cpi = 116.3 if  `year' == 2021 & `month' == 8
		replace cpi = 117.5 if  `year' == 2021 & `month' == 9
		replace cpi = 117.2 if  `year' == 2021 & `month' == 10
		replace cpi = 118.1 if  `year' == 2021 & `month' == 11
		replace cpi = 118.9 if  `year' == 2021 & `month' == 12
		
		replace cpi = 117.8 if  `year' == 2022 & `month' == 1
		replace cpi = 119.1 if  `year' == 2022 & `month' == 2
		replace cpi = 119.8 if  `year' == 2022 & `month' == 3
		replace cpi = 121.2 if  `year' == 2022 & `month' == 4
		replace cpi = 121.5 if  `year' == 2022 & `month' == 5
		replace cpi = 122.6 if  `year' == 2022 & `month' == 6
		replace cpi = 124.2 if  `year' == 2022 & `month' == 7
		replace cpi = 123.9 if  `year' == 2022 & `month' == 8
		replace cpi = . if  `year' == 2022 & `month' == 9
		replace cpi = . if  `year' == 2022 & `month' == 10
		replace cpi = . if  `year' == 2022 & `month' == 11
		replace cpi = . if  `year' == 2022 & `month' == 12
		
		label var cpi "Consumer Price Index (2015 = 100)"
	}
end



