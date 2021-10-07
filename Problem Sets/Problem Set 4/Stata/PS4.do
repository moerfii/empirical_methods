cd "C:\Users\ramon\Desktop\UZH\Empirical Methods\Problem Sets\Problem Set 4\Stata"

capture log close

log using "log_gmuer_ramon_PS4", replace

insheet using "C:\Users\ramon\Desktop\UZH\Empirical Methods\Problem Sets\Problem Set 4\Stata\mortality_temp.csv"

*a)
gen int date = ym(year, month)
format date %tm
xtset stfips date

reg lndrate bin_1 bin_2 bin_3 bin_4 bin_5 bin_6 bin_8 bin_9 bin_10
outreg2 using "ps4rega.doc", replace ctitle (pooled) keep(bin_1 bin_2 bin_3 bin_4 bin_5 bin_6 bin_8 bin_9 bin_10)

*c)

xtreg lndrate bin_1 bin_2 bin_3 bin_4 bin_5 bin_6 bin_8 bin_9 bin_10 i.month, fe
outreg2 using "ps4regc.doc", replace ctitle (s&m-FE) keep(bin_1 bin_2 bin_3 bin_4 bin_5 bin_6 bin_8 bin_9 bin_10) addtext(State FE, YES, Month FE, YES)

*d)
set matsize 1000

quietly xtreg lndrate bin_1 bin_2 bin_3 bin_4 bin_5 bin_6 bin_8 bin_9 bin_10 i.month#i.stfips
outreg2 using "ps4regd.doc", replace ctitle (s per m-FE) keep(bin_1 bin_2 bin_3 bin_4 bin_5 bin_6 bin_8 bin_9 bin_10) addtext(State/Month FE, YES)

*f)

**i)
preserve
collapse (sum) bin_10, by(year)
twoway (line bin_10 year)
graph export hotovertime.png
restore

**ii)
preserve
collapse (mean) lndrate, by(year)
twoway (line lndrate year)
graph export deathovertime.png
restore

*g)
gen year2=year^2
quietly xtreg lndrate bin_1 bin_2 bin_3 bin_4 bin_5 bin_6 bin_8 bin_9 bin_10 devp25 devp75 year year2 i.month#i.stfips
outreg2 using "ps4regg.doc", replace ctitle (s per m-FE) keep(bin_1 bin_2 bin_3 bin_4 bin_5 bin_6 bin_8 bin_9 bin_10 devp25 devp75 year year2) addtext(State/Month FE, YES)

*h)
quietly xtreg lndrate_mva bin_1 bin_2 bin_3 bin_4 bin_5 bin_6 bin_8 bin_9 bin_10 i.month#i.stfips
outreg2 using "ps4regh.doc", replace ctitle (MVA) keep(bin_1 bin_2 bin_3 bin_4 bin_5 bin_6 bin_8 bin_9 bin_10) addtext(State/Month FE, YES)

quietly xtreg lndrate_cvd bin_1 bin_2 bin_3 bin_4 bin_5 bin_6 bin_8 bin_9 bin_10 i.month#i.stfips
outreg2 using "ps4regh.doc", append ctitle (CVD) keep(bin_1 bin_2 bin_3 bin_4 bin_5 bin_6 bin_8 bin_9 bin_10) addtext(State/Month FE, YES)


