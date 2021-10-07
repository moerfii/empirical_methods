cd "C:\Users\ramon\Desktop\UZH\Empirical Methods\Problem Sets\Problem Set 1\Stata"

capture log close

log using "log_gmuer_ramon_PS1", replace

use "C:\Users\ramon\Desktop\UZH\Empirical Methods\Problem Sets\Problem Set 1\Stata\smoke.dta"

*8a) How many obs

display _N

*8b) Summary statistics for cigs, educ, age, income, white, restaurn

asdoc sum cigs educ age income white restaurn

*8c)
**i) Compute Beta 1 and 2 (error in the PS, we use 1 and 2, not 0 and 1)
***B2) 
gen COV = 0
correlate educ cigs, covariance
replace COV = r(cov_12)

egen SD = sd(educ)
gen VAR = SD^2

display COV/VAR

***B1)
gen B2 = COV/VAR

gen mean_cigs = 0
mean(cigs)
matrix b=e(b)
replace mean_cigs=b[1,1]

gen mean_educ = 0
mean(educ)
matrix b=e(b)
replace mean_educ=b[1,1]

gen B1 = mean_cigs - mean_educ*B2

display B1

**ii) Regression

reg cigs educ
outreg2 using "PS1_regression.doc", replace ctitle(Reg)

**iv) Estimates

graph twoway (lfit cigs educ) (scatter cigs educ)

**v)

reg cigs educ, noconstant
outreg2 using "PS1_regression_noconstant.doc", replace ctitle(Reg)
twoway (lfit cigs educ) (lfit cigs educ, estopts(noconstant)) (scatter cigs educ)

*8d)
**i) 

gen age2 = age^2
reg cigs educ age age2 white restaurn
outreg2 using "PS1_regression2.doc", replace ctitle(Reg)

**ii)

reg cigs educ age age2 white restaurn
mfx, varlist(age age2)

**iii)
***A)
reg cigs educ age age2 white restaurn
rvpplot age

***B)
predict age_res, residuals
gen age_res1=age_res[_n-1]
reg age_res age_res1

***C)
hist age_res, frequency normal width(1)


