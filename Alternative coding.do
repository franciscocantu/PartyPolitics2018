

use "~/CrossNational.dta", clear

replace health=0 if health==.
replace farming=0 if farming==.
replace education=0 if education==.
replace constitutional=0 if constitutional==.
replace labor=0 if labor==.
replace finance=0 if finance==.
replace foreign=0 if foreign==.
replace publicw=0 if publicw==.
replace defense=0 if defense==.
replace seniority=0 if seniority==.
replace government=0 if government==.


gen constituencyA=0
gen policyA=0
gen prestigeA=0


recode policyA 0=1 if health==1
recode constituencyA 0=1 if farming==1
recode policyA 0=1 if education==1
recode prestigeA 0=1 if constitutional==1
recode policyA 0=1 if labor==1
recode policyA 0=1 if finance==1
recode policyA 0=1 if foreign==1
recode constituencyA 0=1 if publicw==1
recode constituencyA 0=1 if defense==1
recode constituencyA 0=1 if seniority==1
recode policyA 0=1 if government==1

gen distributiveB=0
recode distributiveB 0=1 if farming==1
recode distributiveB 0=1 if labor==1
recode distributiveB 0=1 if defense==1
recode distributiveB 0=1 if publicw==1
recode distributiveB 0=1 if education==1




xtmixed constituencyA i.termid logmag relrank closed closed_relrank  || _all: R.partyid || districtid:, variance
xtmixed prestigeA i.termid logmag relrank closed closed_relrank   || _all: R.partyid || districtid:, variance

xtmixed constituencyA i.termid logmag relrank closed closed_relrank seniority government  || _all: R.partyid || districtid:, variance
xtmixed prestigeA i.termid logmag relrank closed closed_relrank seniority government || _all: R.partyid || districtid:, variance


xtmixed constituencyA i.termid logmag relrank closed closed_logmag || _all: R.partyid || districtid:, variance
xtmixed prestigeA i.termid logmag relrank closed closed_logmag || _all: R.partyid || districtid:, variance

xtmixed prestigeA i.termid position || _all: R.partyid || districtid:, variance
xtmixed prestigeA i.termid position logmag importance2 || _all: R.partyid || districtid:, variance

******


eststo clear
xtmixed constituencyA i.termid logmag relrank closed closed_relrank  || _all: R.partyid || districtid:, variance
outreg2 using Appendix3.doc,   ctitle(Constituency Posts) alpha(.01, .05, .10) symbol(***, **, *) replace
xtmixed constituencyA i.termid logmag relrank closed closed_relrank seniority government || _all: R.partyid || districtid:, variance
outreg2 using Appendix3.doc,   ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed constituencyA i.termid logmag Constituency closed closed_logmag || _all: R.partyid || districtid:, variance
outreg2 using Appendix3.doc,   ctitle(Constituency Posts) alpha(.01, .05, .10) symbol(***, **, *) append

eststo clear
xtmixed prestigeA i.termid position logmag importance2  || _all: R.partyid || districtid:, variance
outreg2 using Appendix4.doc,   ctitle(Prestige Posts) alpha(.01, .05, .10) symbol(***, **, *) replace
xtmixed prestigeA i.termid position logmag importance2 seniority government || _all: R.partyid || districtid:, variance
outreg2 using Appendix4.doc,   ctitle(Prestige Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed prestigeA i.termid position logmag importance2 || _all: R.partyid || districtid:, variance
outreg2 using Appendix4.doc,   ctitle(Prestige Posts) alpha(.01, .05, .10) symbol(***, **, *) append
bysort closed: xtmixed prestigeA i.termid position logmag importance2 || _all: R.partyid || districtid:, variance
outreg2 using Appendix4.doc,   ctitle(Prestige Posts) alpha(.01, .05, .10) symbol(***, **, *) append

****************
gen intra_vul=intraseats*relrank

eststo clear
xtmixed distributive i.termid logmag relrank closed closed_relrank intraseats  || _all: R.partyid || districtid:, variance
outreg2 using AppendixDistributive.doc,   ctitle(Prestige Posts) alpha(.01, .05, .10) symbol(***, **, *) replace
xtmixed distributive i.termid logmag relrank closed closed_relrank intraseats intra_vul || _all: R.partyid || districtid:, variance
outreg2 using AppendixDistributive.doc,   ctitle(Prestige Posts) alpha(.01, .05, .10) symbol(***, **, *) append



xtmixed highpolicy i.termid logmag relrank closed closed_relrank  intraseats || _all: R.partyid || districtid:, variance
outreg2 using AppendixHighP.doc,   ctitle(Prestige Posts) alpha(.01, .05, .10) symbol(***, **, *) replace
xtmixed highpolicy i.termid logmag relrank closed closed_relrank  intraseats intra_vul || _all: R.partyid || districtid:, variance
outreg2 using AppendixHighP.doc,   ctitle(Prestige Posts) alpha(.01, .05, .10) symbol(***, **, *) append

***************
* with defense and education in distributive
eststo clear
xtmixed distributiveB i.termid logmag relrank closed closed_relrank  || _all: R.partyid || districtid:, variance
outreg2 using Appendix5.doc,   ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) replace
xtmixed distributiveB i.termid logmag relrank closed closed_relrank seniority government minister || _all: R.partyid || districtid:, variance
outreg2 using Appendix5.doc,   ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed distributiveB i.termid logmag  relrank closed closed_logmag || _all: R.partyid || districtid:, variance
outreg2 using Appendix5.doc,   ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) append

* with agedem and without fixed effects per term
eststo clear
xtmixed distributive  logmag relrank closed closed_relrank agedem || _all: R.partyid || districtid:, variance
outreg2 using Appendix6.doc,   ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) replace
xtmixed distributive  logmag relrank closed closed_relrank seniority government minister agedem  || _all: R.partyid || districtid:, variance
outreg2 using Appendix6.doc,   ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed distributive  logmag  relrank closed closed_logmag agedem || _all: R.partyid || districtid:, variance
outreg2 using Appendix6.doc,   ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed highpolicy  logmag relrank closed closed_relrank agedem || _all: R.partyid || districtid:, variance
outreg2 using Appendix6.doc,   ctitle(High Policy Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed highpolicy  logmag relrank closed closed_relrank seniority government minister agedem  || _all: R.partyid || districtid:, variance
outreg2 using Appendix6.doc,   ctitle(High Policy Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed highpolicy  logmag  relrank closed closed_logmag agedem || _all: R.partyid || districtid:, variance
outreg2 using Appendix6.doc,   ctitle(High Policy Posts) alpha(.01, .05, .10) symbol(***, **, *) append

eststo clear
xtmixed highpolicy  position logmag importance2 agedem  || _all: R.partyid || districtid:, variance
outreg2 using Appendix7.doc,   ctitle(High Policy Posts) alpha(.01, .05, .10) symbol(***, **, *) replace
xtmixed highpolicy  position logmag importance2 seniority government minister agedem|| _all: R.partyid || districtid:, variance
outreg2 using Appendix7.doc,   ctitle(High Policy Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed highpolicy position logmag importance2 agedem || _all: R.partyid || districtid:, variance
outreg2 using Appendix7.doc,   ctitle(High Policy Posts) alpha(.01, .05, .10) symbol(***, **, *) append
bysort closed: xtmixed highpolicy  position logmag importance2 agedem || _all: R.partyid || districtid:, variance
outreg2 using Appendix7.doc,   ctitle(High Policy Posts) alpha(.01, .05, .10) symbol(***, **, *) append

**by decades
eststo clear
xtmixed distributive  logmag relrank closed closed_relrank eighties nineties twothousands || _all: R.partyid || districtid:, variance
outreg2 using Appendix8.doc,   ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) replace
xtmixed distributive  logmag relrank closed closed_relrank seniority government minister eighties nineties twothousands  || _all: R.partyid || districtid:, variance
outreg2 using Appendix8.doc,   ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed distributive  logmag  relrank closed closed_logmag eighties nineties twothousands || _all: R.partyid || districtid:, variance
outreg2 using Appendix8.doc,   ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed highpolicy  logmag relrank closed closed_relrank eighties nineties twothousands || _all: R.partyid || districtid:, variance
outreg2 using Appendix8.doc,   ctitle(High Policy Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed highpolicy  logmag relrank closed closed_relrank seniority government minister eighties nineties twothousands  || _all: R.partyid || districtid:, variance
outreg2 using Appendix8.doc,   ctitle(High Policy Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed highpolicy  logmag  relrank closed closed_logmag eighties nineties twothousands || _all: R.partyid || districtid:, variance
outreg2 using Appendix8.doc,   ctitle(High Policy Posts) alpha(.01, .05, .10) symbol(***, **, *) append

eststo clear
xtmixed highpolicy  position logmag importance2 eighties nineties twothousands  || _all: R.partyid || districtid:, variance
outreg2 using Appendix9.doc,   ctitle(High Policy Posts) alpha(.01, .05, .10) symbol(***, **, *) replace
xtmixed highpolicy  position logmag importance2 seniority government minister eighties nineties twothousands|| _all: R.partyid || districtid:, variance
outreg2 using Appendix9.doc,   ctitle(High Policy Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed highpolicy position logmag importance2 eighties nineties twothousands || _all: R.partyid || districtid:, variance
outreg2 using Appendix9.doc,   ctitle(High Policy Posts) alpha(.01, .05, .10) symbol(***, **, *) append

*************majority

gen plur_vul=plurality*relrank

set more off

eststo clear
xtmixed distributive i.termid logmag relrank closed closed_relrank plurality plur_vul || _all: R.partyid || districtid:, variance
outreg2 using Appendix10.doc,   ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) replace
xtmixed distributive i.termid logmag relrank closed closed_relrank seniority government minister plurality plur_vul || _all: R.partyid || districtid:, variance
outreg2 using Appendix10.doc,   ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed distributive i.termid logmag closed closed_logmag plurality plur_vul || _all: R.partyid || districtid:, variance
outreg2 using Appendix10.doc,   ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed highpolicy  i.termid logmag relrank closed closed_relrank plurality plur_vul || _all: R.partyid || districtid:, variance
outreg2 using Appendix10.doc,   ctitle(High Policy Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed highpolicy  i.termid logmag relrank closed closed_relrank seniority government minister  plurality plur_vul || _all: R.partyid || districtid:, variance
outreg2 using Appendix10.doc,   ctitle(High Policy Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed highpolicy  i.termid logmag  closed closed_logmag plurality plur_vul || _all: R.partyid || districtid:, variance
outreg2 using Appendix10.doc,   ctitle(High Policy Posts) alpha(.01, .05, .10) symbol(***, **, *) append
