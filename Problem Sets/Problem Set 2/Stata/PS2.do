cd "C:\Users\ramon\Desktop\UZH\Empirical Methods\Problem Sets\Problem Set 2\Stata"

capture log close

log using "log_gmuer_ramon_PS2", replace

use "C:\Users\ramon\Desktop\UZH\Empirical Methods\Problem Sets\Problem Set 2\Stata\class_size_pset.dta"

*Empirical Question

**a)

gen big_school = 0
replace big_school = 1 if n_classes > 2

***a-i)

reg mrkgrm classize

outreg2 using "PS2_regressiona.doc", replace ctitle(a-i)

***a-ii)

reg mrkgrm classize big_school

outreg2 using "PS2_regressiona.doc", append ctitle(a-ii)

**b)

drop big_school

***b-i)

gen ln_mrkgrm = log(mrkgrm)
reg mrkgrm classize pct_dis
outreg2 using "PS2_regressionbi.doc", replace ctitle(normal)
reg ln_mrkgrm classize pct_dis
outreg2 using "PS2_regressionbi.doc", append ctitle(log)

***b-ii)

**c)

gen small_size = 0
replace small_size = 1 if classize <= 10

reg mrkgrm small_size pct_dis
outreg2 using "PS2_regressionc.doc", replace ctitle(c)
test _b[small_size]=0
local sign_ss = sign(_b[small_size])
display "Ho: coef <= 0  p-value = " ttail(r(df_r),`sign_ss'*sqrt(r(F)))

***c-i)

****Hand- and Stata-Testing!!!

***c-ii)

reg mrkgrm pct_dis
outreg2 using "PS2_regressioncii.doc", replace ctitle(1)
predict residuals1, residuals

reg small_size pct_dis
outreg2 using "PS2_regressioncii.doc", append ctitle(2)
predict residuals2, residuals

reg residuals1 residuals2 
outreg2 using "PS2_regressioncii.doc", append ctitle(3)

***c-iii)

egen mean_mrkgrm = mean(mrkgrm)
egen mean_small_size = mean(small_size)
egen mean_pct_dis = mean(pct_dis)

display mean_mrkgrm - mean_small_size*2.559768 - mean_pct_dis*-.3267693

***c-iv)

reg ln_mrkgrm small_size pct_dis
outreg2 using "PS2_regressionciv.doc", replace ctitle(c-iv)


**d)

gen many_dis = 0
replace many_dis = 1 if pct_dis > 10
gen many_disXclassize = many_dis*classize
reg mrkgrm classize many_dis many_disXclassize
outreg2 using "PS2_regressiond.doc", replace ctitle(d)

***d-i)

test _b[many_dis]=0
test _b[many_disXclassize]=0, accumulate

	
****Ru^2=0.3005
reg mrkgrm classize
****Rr^2=0.0142
****q=2, N-K=df=1,963
display ((0.3005-0.0142)/2)/((1-0.3005)/1963)


***d-ii)

**e)

reg mrkgrm classize if many_dis == 1
outreg2 using "PS2_regressione.doc", replace ctitle(high dis)
reg mrkgrm classize if many_dis == 0
outreg2 using "PS2_regressione.doc", append ctitle(low dis)
reg mrkgrm classize many_dis many_disXclassize
outreg2 using "PS2_regressione.doc", append ctitle(d)

**f)

foreach regioncode in Reg1 Reg2 Reg3 Reg4 Reg5 Reg6{
	gen `regioncode' = 0
	replace `regioncode' = 1 if regioncode == "`regioncode'"
}

**g)

reg mrkgrm classize pct_dis if regioncode == "Reg1"
outreg2 using "PS2_regressiong.doc", replace ctitle(Reg1)
foreach regioncode in Reg2 Reg3 Reg4 Reg5 Reg6{
	reg mrkgrm classize pct_dis if regioncode =="`regioncode'"
	outreg2 using "PS2_regressiong.doc", append ctitle(`regioncode')
}

****Model alternative: Dummy with ommitting Reg5:
reg mrkgrm classize pct_dis Reg1 Reg2 Reg3 Reg4 Reg6
outreg2 using "PS2_regressiongalt.doc", replace ctitle(alt)

**h)

***h-i)

reg mrkgrm classize sc_boys if n_classes == 1
outreg2 using "PS2_regressionhi.doc", replace ctitle(1)

***h-ii)

reg mrkgrm sc_girls sc_boys if n_classes == 1
outreg2 using "PS2_regressionhii.doc", replace ctitle(1)

correlate sc_boys sc_girls
reg mrkgrm classize if n_classes == 1

