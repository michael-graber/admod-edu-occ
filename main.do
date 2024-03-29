log using "./main.log", replace
di "$S_TIME $S_DATE"
/*==============================================================================
	                    MAIN FILE

The main file that runs all the child scripts in the correct order
==============================================================================*/

// settings
version 17
set more off
set varabbrev off
set max_preservemem 30g

// directories
adopath ++     "./src"                           // additional ado files
global raw     "/ssb/stamme01/admod/wk48/"       // raw admin files
global src     "./src"                           // do-files
global data    "./data"                          // created datasets
global tables  "./out/tables"                    // tables 
global figures "./out/figures"                   // figures 

// SSB color scheme
// net install ssbscheme, from("https://raw.githubusercontent.com/martin-andresen/ssbscheme/master") 
set scheme ssbscheme
translator set Graph2pdf fontfacesans "Open Sans"
foreach type in ps eps svg window {
	graph set `type' fontfacesans "Open Sans"
	graph set `type' fontface "Open Sans"
}

// set up dataset
do ${src}/data.do

// descriptive analysis
do ${src}/summary.do
do ${src}/counts.do
do ${src}/modes.do
do ${src}/concentration.do

// create tables and figures
do ${src}/tables.do
do ${src}/figures.do

di "$S_TIME $S_DATE"
log close
