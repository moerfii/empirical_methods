cd "C:\Users\ramon\Desktop\UZH\Empirical Methods\Problem Sets\Problem Set 3\Stata"

capture log close

log using "log_gmuer_ramon_PS2", replace

insheet using "C:\Users\ramon\Desktop\UZH\Empirical Methods\Problem Sets\Problem Set 3\Stata\BCHHS_data.csv"

*1)

gen lnearn = log(earning)
gen agesq = age^2


**a)

reg lnearn highqua age agesq
outreg2 using "regressiona.doc", replace ctitle(OLS)
ivreg lnearn age agesq (highqua = twihigh)
outreg2 using "regressiona.doc", append ctitle(IV)

**b)

***v)
reg highqua twihigh age agesq
outreg2 using "regressionb.doc", replace ctitle(1S)
test _b[twihigh]=0

**c)

drop schyear lnandse part full self married own_exp bweight exp_par parted sm16 sm18
reshape wide lnearn highqua twihigh earning, i(family) j(twinno)

gen dlnearn = lnearn1 - lnearn2
gen dhigh = highqua1 - highqua2
gen dtwihigh = twihigh1 - twihigh2

gen dearn = earning1 - earning2
*This one is for d)

reg dlnearn dhigh, nocons
outreg2 using "regressionc.doc", replace ctitle(OLS)
ivreg dlnearn (dhigh = dtwihigh), nocons
outreg2 using "regressionc.doc", append ctitle(IV)

***ii)

reg dlnearn dhigh
outreg2 using "regressionc2.doc", replace ctitle(OLS)
ivreg dlnearn (dhigh = dtwihigh)
outreg2 using "regressionc2.doc", append ctitle(IV)

**d)

gen absearn = abs(dearn)
preserve
drop if absearn > 60

reg dlnearn dhigh, nocons
outreg2 using "regressiond.doc", replace ctitle(OLS)
ivreg dlnearn (dhigh = dtwihigh), nocons
outreg2 using "regressiond.doc", append ctitle(IV)

restore
