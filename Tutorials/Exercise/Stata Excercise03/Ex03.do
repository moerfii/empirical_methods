cd "C:\Users\ramon\Desktop\UZH\Empirical Methods\Tutorials\Exercise\Stata Excercise03"

capture log close

log using "log_gmuer_ramon_PS2", replace

insheet using "C:\Users\ramon\Desktop\UZH\Empirical Methods\Tutorials\Exercise\Stata Excercise03\indicators.csv"

*b)

**i)
reg mortalityun corruptionun
outreg2 using "ex3tables.doc", replace ctitle(b.i)

***big change (0.62 SD)

**iii)
twoway (scatter mortalityun corruptionun) (lfitci mortalityun corruptionun)

*c)

**ii)
reg hospital_deaths corruption
outreg2 using "ex3tables.doc", append ctitle(c.ii)

**iii)
twoway (lfitci mortalityun corruptionun) (lfitci hospital_deaths corruptionun) (scatter mortalityun corruptionun) (scatter hospital_deaths corruptionun)
***no ci due to overlapping

*d)

**i)
reg mortalityun ruleoflaw
outreg2 using "ex3tables.doc", append ctitle(d.i)

***plot same as in c.iii)

*e)

**iii)
reg govmort corruptionun
outreg2 using "ex3tables.doc", append ctitle(e.iii)

