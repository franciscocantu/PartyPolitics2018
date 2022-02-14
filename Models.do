

use "~\CrossNational.dta", clear

gen closed=0
recode closed 0=1 if country=="Spain"
recode closed 0=1 if country=="Portugal"
recode closed 0=1 if country=="Norway"

replace logmag=ln(magnitude) if country=="Luxembourg"

gen closed_relrank=closed*relrank
gen closed_logmag=closed*logmag
gen closed_magnitude=closed*magnitude
gen closed_importance=closed*importance
gen closed_security=closed*security
gen closed_security2=closed*security2



*tab districtid 
replace districtid="A" if country=="Luxembourg" & districtid=="1"
replace districtid="B" if country=="Luxembourg" & districtid=="2"
replace districtid="C" if country=="Luxembourg" & districtid=="3"
replace districtid="D" if country=="Luxembourg" & districtid=="4"



gen termid2=termid
replace termid2=termid+100 if country=="Luxembourg"
replace termid2=termid+200 if country=="Spain"
replace termid2=termid+300 if country=="Portugal"
replace termid2=termid+400 if country=="Norway"

*tostring termid2, replace

egen idterm=group(country termid)
destring idterm, replace

tab partyid 
replace partyid="A" if country=="Luxembourg" & partyid=="1"
replace partyid="B" if country=="Luxembourg" & partyid=="2"
replace partyid="C" if country=="Luxembourg" & partyid=="3"
replace partyid="D" if country=="Luxembourg" & partyid=="4"
replace partyid="E" if country=="Luxembourg" & partyid=="5"
replace partyid="F" if country=="Luxembourg" & partyid=="6"

egen idparty=group(country partyid)
destring idparty, replace

egen idcountry=group(country)


**Table 1/H1
*Model 1


xtmixed distributive i.termid2 logmag relrank || _all: R.partyid || districtid:, variance
xtmixed highpolicy i.termid2 logmag relrank || _all: R.partyid || districtid:, variance
xtmixed publicgoods i.termid2 logmag relrank  || _all: R.partyid || districtid:, variance
xtmixed base i.termid2 logmag relrank || _all: R.partyid || districtid:, variance



set more off
eststo clear
qui xi: xtmixed distributive i.termid logmag relrank || _all: R.partyid || districtid:, variance
eststo
qui xi: xtmixed highpolicy i.termid logmag relrank || _all: R.partyid || districtid:, variance
eststo
qui xi: xtmixed publicgoods i.termid logmag relrank  || _all: R.partyid || districtid:, variance
eststo
qui xi: xtmixed base i.termid logmag relrank || _all: R.partyid || districtid:, variance
eststo

#delimit;
esttab using Model1.tex, b(%8.3f) se(%8.3f) star(* 0.05 ** 0.01 *** 0.001) nodepvars label mti() aic(%9.0g)
nonote 
addn("All estimates are based on multilevel mixed-effects ordered logistic regression."
"Variables not shown include state fixed effects in columns (2)--(4)."
"Robust standard errors in parentheses. * p<0.05, ** p<0.01, *** p<0.001.");



*Model 2
xtmixed distributive i.termid logmag relrank closed closed_relrank || _all: R.partyid || districtid:, variance
xtmixed highpolicy i.termid logmag relrank closed closed_relrank || _all: R.partyid || districtid:, variance
xtmixed publicgoods i.termid logmag relrank closed closed_relrank  || _all: R.partyid || districtid:, variance
xtmixed base i.termid logmag relrank  closed closed_relrank || _all: R.partyid || districtid:, variance

set more off
eststo clear
xtmixed distributive i.termid relrank closed closed_relrank || _all: R.partyid || districtid:, variance
eststo
xtmixed highpolicy i.termid relrank closed closed_relrank || _all: R.partyid || districtid:, variance
eststo
xtmixed publicgoods i.termid relrank closed closed_relrank  || _all: R.partyid || districtid:, variance
eststo
xtmixed base i.termid relrank  closed closed_relrank || _all: R.partyid || districtid:, variance
eststo

#delimit;
esttab using Model1a.tex, b(%8.3f) se(%8.3f) star(* 0.05 ** 0.01 *** 0.001) nodepvars label mti() aic(%9.0g)
nonote 
addn("All estimates are based on multilevel mixed-effects ordered logistic regression."
"Variables not shown include state fixed effects in columns (2)--(4)."
"Robust standard errors in parentheses. * p<0.05, ** p<0.01, *** p<0.001.");

*Model 3 (Appendix)
**The covariates do not appear because they are collinear with closed

xtmixed distributive i.termid logmag relrank closed closed_relrank gov min seniority || _all: R.partyid || districtid:, variance
xtmixed highpolicy i.termid logmag relrank closed closed_relrank gov min seniority || _all: R.partyid || districtid:, variance
xtmixed publicgoods i.termid logmag relrank closed closed_relrank gov min seniority || _all: R.partyid || districtid:, variance
xtmixed base i.termid logmag relrank  closed closed_relrank gov min seniority || _all: R.partyid || districtid:, variance

set more off
eststo clear
xtmixed distributive i.termid relrank closed closed_relrank gov min seniority || _all: R.partyid || districtid:, variance
eststo
xtmixed highpolicy i.termid relrank closed closed_relrank gov min seniority || _all: R.partyid || districtid:, variance
eststo
xtmixed publicgoods i.termid relrank closed closed_relrank gov min seniority || _all: R.partyid || districtid:, variance
eststo
xtmixed base i.termid relrank  closed closed_relrank gov min seniority || _all: R.partyid || districtid:, variance
eststo

#delimit;
esttab using Model1c.tex, b(%8.3f) se(%8.3f) star(* 0.05 ** 0.01 *** 0.001) nodepvars label mti() aic(%9.0g)
nonote 
addn("All estimates are based on multilevel mixed-effects ordered logistic regression."
"Variables not shown include state fixed effects in columns (2)--(4)."
"Robust standard errors in parentheses. * p<0.05, ** p<0.01, *** p<0.001.");


set more off
eststo clear
qui xi: xtmixed distributive i.termid logmag relrank || _all: R.partyid || districtid:, variance
eststo
qui xi: xtmixed distributive i.termid logmag relrank closed closed_relrank || _all: R.partyid || districtid:, variance
eststo
qui xi: xtmixed distributive i.termid logmag relrank closed closed_relrank gov min seniority || _all: R.partyid || districtid:, variance
eststo
qui xi: xtmixed distributive i.termid logmag relrank closed closed_logmag || _all: R.partyid || districtid:, variance
eststo
qui xi: xtmixed highpolicy i.termid logmag relrank || _all: R.partyid || districtid:, variance
eststo
qui xi: xtmixed highpolicy i.termid logmag relrank closed closed_relrank || _all: R.partyid || districtid:, variance
eststo
qui xi: xtmixed highpolicy i.termid logmag relrank closed closed_relrank gov min seniority || _all: R.partyid || districtid:, variance
eststo
qui xi: xtmixed highpolicy i.termid logmag relrank closed closed_logmag gov min seniority || _all: R.partyid || districtid:, variance
eststo

#delimit;
esttab using Model1completoA.tex, b(%8.3f) se(%8.3f) star(* 0.05 ** 0.01 *** 0.001) nodepvars label mti() aic(%9.0g)
nonote 
addn("All estimates are based on multilevel mixed-effects ordered logistic regression."
"Variables not shown include state fixed effects in columns (2)--(4)."
"Robust standard errors in parentheses. * p<0.05, ** p<0.01, *** p<0.001.");


xtmixed publicgoods i.termid logmag relrank closed closed_relrank || _all: R.partyid || districtid:, variance
estat ic
outreg2 using App1.doc,  ctitle(Public Goods Posts) alpha(.01, .05, .10) symbol(***, **, *)  replace
xtmixed publicgoods i.termid logmag relrank closed closed_relrank gov min seniority || _all: R.partyid || districtid:, variance
estat ic
outreg2 using App1.doc,  ctitle(Public Goods Posts) alpha(.01, .05, .10) symbol(***, **, *)  append
xtmixed publicgoods i.termid logmag relrank closed closed_logmag || _all: R.partyid || districtid:, variance
estat ic
outreg2 using v1.doc, ctitle(Public Goods Posts) alpha(.01, .05, .10) symbol(***, **, *)  append



xtmixed base i.termid logmag relrank closed closed_relrank || _all: R.partyid || districtid:, variance
estat ic
outreg2 using App2.doc,  ctitle(Base Posts) alpha(.01, .05, .10) symbol(***, **, *)  replace
xtmixed base i.termid logmag relrank closed closed_relrank gov min seniority || _all: R.partyid || districtid:, variance
estat ic
outreg2 using App2.doc,  ctitle(Base Posts) alpha(.01, .05, .10) symbol(***, **, *)  append
xtmixed base i.termid logmag relrank closed closed_logmag || _all: R.partyid || districtid:, variance
estat ic
outreg2 using App2.doc, ctitle(Base Posts) alpha(.01, .05, .10) symbol(***, **, *)  append



**Table 2/H2
*Model 1
xtmixed distributive i.termid logmag || _all: R.partyid || districtid:, variance
xtmixed highpolicy i.termid logmag || _all: R.partyid || districtid:, variance
xtmixed publicgoods i.termid logmag  || _all: R.partyid || districtid:, variance
xtmixed base i.termid logmag || _all: R.partyid || districtid:, variance

set more off
eststo clear
xtmixed distributive i.termid logmag || _all: R.partyid || districtid:, variance
eststo
xtmixed highpolicy i.termid logmag || _all: R.partyid || districtid:, variance
eststo
xtmixed publicgoods i.termid logmag  || _all: R.partyid || districtid:, variance
eststo
xtmixed base i.termid logmag || _all: R.partyid || districtid:, variance
eststo

#delimit;
esttab using Model2.tex, b(%8.3f) se(%8.3f) star(* 0.05 ** 0.01 *** 0.001) nodepvars label mti() aic(%9.0g)
nonote 
addn("All estimates are based on multilevel mixed-effects ordered logistic regression."
"Variables not shown include state fixed effects in columns (2)--(4)."
"Robust standard errors in parentheses. * p<0.05, ** p<0.01, *** p<0.001.");

*Model 2
xtmixed distributive i.termid logmag closed closed_logmag || _all: R.partyid || districtid:, variance
xtmixed highpolicy i.termid logmag closed closed_logmag || _all: R.partyid || districtid:, variance
xtmixed publicgoods i.termid logmag closed closed_logmag  || _all: R.partyid || districtid:, variance
xtmixed base i.termid logmag closed closed_logmag || _all: R.partyid || districtid:, variance


bysort closed: xtmixed distributive i.termid relrank logmag || _all: R.partyid || districtid:, variance
bysort closed: xtmixed highpolicy i.termid relrank logmag || _all: R.partyid || districtid:, variance


set more off
eststo clear
xtmixed distributive i.termid logmag closed closed_logmag || _all: R.partyid || districtid:, variance
eststo
xtmixed highpolicy i.termid logmag closed closed_logmag || _all: R.partyid || districtid:, variance
eststo
xtmixed publicgoods i.termid logmag closed closed_logmag  || _all: R.partyid || districtid:, variance
eststo
xtmixed base i.termid logmag closed closed_logmag || _all: R.partyid || districtid:, variance
eststo

#delimit;
esttab using Model2a.tex, b(%8.3f) se(%8.3f) star(* 0.05 ** 0.01 *** 0.001) nodepvars label mti() aic(%9.0g)
nonote 
addn("All estimates are based on multilevel mixed-effects ordered logistic regression."
"Variables not shown include state fixed effects in columns (2)--(4)."
"Robust standard errors in parentheses. * p<0.05, ** p<0.01, *** p<0.001.");

*Model 3 (Appendix)
xtmixed distributive i.termid logmag closed closed_logmag gov min seniority || _all: R.partyid || districtid:, variance
xtmixed highpolicy i.termid logmag closed closed_logmag gov min seniority || _all: R.partyid || districtid:, variance
xtmixed publicgoods i.termid logmag closed closed_logmag gov min seniority || _all: R.partyid || districtid:, variance
xtmixed base i.termid logmag closed closed_logmag gov min seniority || _all: R.partyid || districtid:, variance

set more off
eststo clear
xtmixed distributive i.termid logmag closed closed_logmag gov min seniority || _all: R.partyid || districtid:, variance
eststo
xtmixed highpolicy i.termid logmag closed closed_logmag gov min seniority || _all: R.partyid || districtid:, variance
eststo
xtmixed publicgoods i.termid logmag closed closed_logmag gov min seniority || _all: R.partyid || districtid:, variance
eststo
xtmixed base i.termid logmag closed closed_logmag gov min seniority || _all: R.partyid || districtid:, variance
eststo

#delimit;
esttab using Model2b.tex, b(%8.3f) se(%8.3f) star(* 0.05 ** 0.01 *** 0.001) nodepvars label mti() aic(%9.0g)
nonote 
addn("All estimates are based on multilevel mixed-effects ordered logistic regression."
"Variables not shown include state fixed effects in columns (2)--(4)."
"Robust standard errors in parentheses. * p<0.05, ** p<0.01, *** p<0.001.");



**Table 3/H3
*A different way to test H3
gen importance2=logmag*position

*Model 1
xtmixed distributive i.termid position || _all: R.partyid || districtid:, variance
xtmixed highpolicy i.termid position || _all: R.partyid || districtid:, variance
xtmixed publicgoods i.termid position  || _all: R.partyid || districtid:, variance
xtmixed base i.termid position || _all: R.partyid || districtid:, variance

set more off
eststo clear
xtmixed distributive i.termid position || _all: R.partyid || districtid:, variance
eststo
xtmixed highpolicy i.termid position || _all: R.partyid || districtid:, variance
eststo
xtmixed publicgoods i.termid position  || _all: R.partyid || districtid:, variance
eststo
xtmixed base i.termid position || _all: R.partyid || districtid:, variance
eststo

#delimit;
esttab using Model3.tex, b(%8.3f) se(%8.3f) star(* 0.05 ** 0.01 *** 0.001) nodepvars label mti() aic(%9.0g)
nonote 
addn("All estimates are based on multilevel mixed-effects ordered logistic regression."
"Variables not shown include state fixed effects in columns (2)--(4)."
"Robust standard errors in parentheses. * p<0.05, ** p<0.01, *** p<0.001.");

*Model 2
xtmixed distributive i.termid position logmag importance2 || _all: R.partyid || districtid:, variance
xtmixed highpolicy i.termid position logmag importance2 || _all: R.partyid || districtid:, variance
xtmixed publicgoods i.termid position logmag importance2 || _all: R.partyid || districtid:, variance
xtmixed base i.termid position logmag cimportance2 || _all: R.partyid || districtid:, variance

set more off
eststo clear
xtmixed distributive i.termid position logmag importance2 || _all: R.partyid || districtid:, variance
eststo
xtmixed highpolicy i.termid position logmag importance2 || _all: R.partyid || districtid:, variance
eststo
xtmixed publicgoods i.termid position logmag importance2 || _all: R.partyid || districtid:, variance
eststo
xtmixed base i.termid position logmag cimportance2 || _all: R.partyid || districtid:, variance
eststo

#delimit;
esttab using Model3a.tex, b(%8.3f) se(%8.3f) star(* 0.05 ** 0.01 *** 0.001) nodepvars label mti() aic(%9.0g)
nonote 
addn("All estimates are based on multilevel mixed-effects ordered logistic regression."
"Variables not shown include state fixed effects in columns (2)--(4)."
"Robust standard errors in parentheses. * p<0.05, ** p<0.01, *** p<0.001.");

*Model 2a
bysort closed: xtmixed distributive i.termid2 logmag position importance2 || _all: R.partyid || districtid:, variance
bysort closed: xtmixed highpolicy i.termid2 logmag position importance2 || _all: R.partyid || districtid:, variance
bysort closed: xtmixed publicgoods i.termid2 logmag position importance2 || _all: R.partyid || districtid:, variance
bysort closed: xtmixed base i.termid2 logmag position importance2 || _all: R.partyid || districtid:, variance

set more off
eststo clear
bysort closed: xtmixed distributive i.termid2 logmag position importance2 || _all: R.partyid || districtid:, variance
eststo
bysort closed: xtmixed highpolicy i.termid2 logmag position importance2 || _all: R.partyid || districtid:, variance
eststo
bysort closed: xtmixed publicgoods i.termid2 logmag position importance2 || _all: R.partyid || districtid:, variance
eststo
bysort closed: xtmixed base i.termid2 logmag position importance2 || _all: R.partyid || districtid:, variance
eststo

#delimit;
esttab using Model3aa.tex, b(%8.3f) se(%8.3f) star(* 0.05 ** 0.01 *** 0.001) nodepvars label mti() aic(%9.0g)
nonote 
addn("All estimates are based on multilevel mixed-effects ordered logistic regression."
"Variables not shown include state fixed effects in columns (2)--(4)."
"Robust standard errors in parentheses. * p<0.05, ** p<0.01, *** p<0.001.");



set more off
eststo clear
qui xi: xtmixed highpolicy i.termid position || _all: R.partyid || districtid:, variance
eststo
qui xi: xtmixed highpolicy i.termid position logmag importance2 || _all: R.partyid || districtid:, variance
eststo
qui xi: xtmixed highpolicy i.termid position logmag importance2 gov min seniority || _all: R.partyid || districtid:, variance
eststo
xtmixed highpolicy i.termid position logmag importance2 gov min seniority || _all: R.partyid || districtid: if (closed==1), variance
eststo
xtmixed highpolicy i.termid position logmag importance2 gov min seniority || _all: R.partyid || districtid: if (closed==0), variance
eststo

#delimit;
esttab using Model2completoA.tex, b(%8.3f) se(%8.3f) star(* 0.05 ** 0.01 *** 0.001) nodepvars label mti() aic(%9.0g)
nonote 
addn("All estimates are based on multilevel mixed-effects ordered logistic regression."
"Variables not shown include state fixed effects in columns (2)--(4)."
"Robust standard errors in parentheses. * p<0.05, ** p<0.01, *** p<0.001.");

xtmixed highpolicy i.termid position || _all: R.partyid || districtid:, variance
outreg2 using Dos.doc,  ctitle(High Policy Posts) alpha(.01, .05, .10) symbol(***, **, *) replace
xtmixed highpolicy i.termid position logmag importance2 || _all: R.partyid || districtid:, variance
outreg2 using Dos.doc,  ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed highpolicy i.termid position logmag importance2 gov min seniority || _all: R.partyid || districtid:, variance
outreg2 using Dos.doc,  ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed highpolicy i.termid position logmag importance2 gov min seniority || _all: R.partyid || districtid: if (closed==1), variance
outreg2 using Dos.doc, ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed highpolicy i.termid position logmag importance2 gov min seniority || _all: R.partyid || districtid: if (closed==0), variance
outreg2 using Dos.doc, ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) append

xtmixed distributive i.termid position || _all: R.partyid || districtid:, variance
estat ic
outreg2 using Ap3.doc,  ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) replace
xtmixed distributive i.termid position logmag importance2 || _all: R.partyid || districtid:, variance
estat ic
outreg2 using Ap3.doc,  ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed distributive i.termid position logmag importance2 gov min seniority || _all: R.partyid || districtid:, variance
estat ic
outreg2 using Ap3.doc,  ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed distributive i.termid position logmag importance2 gov min seniority || _all: R.partyid || districtid: if (closed==1), variance
estat ic
outreg2 using Ap3.doc, ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed distributive i.termid position logmag importance2 gov min seniority || _all: R.partyid || districtid: if (closed==0), variance
estat ic
outreg2 using Ap3.doc, ctitle(Distributive Posts) alpha(.01, .05, .10) symbol(***, **, *) append


xtmixed publicgoods i.termid position || _all: R.partyid || districtid:, variance
estat ic
outreg2 using Ap4.doc,  ctitle(Public Goods Posts) alpha(.01, .05, .10) symbol(***, **, *) replace
xtmixed publicgoods i.termid position logmag importance2 || _all: R.partyid || districtid:, variance
estat ic
outreg2 using Ap4.doc,  ctitle(Public Goods Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed publicgoods i.termid position logmag importance2 gov min seniority || _all: R.partyid || districtid:, variance
estat ic
outreg2 using Ap4.doc,  ctitle(Public Goods Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed publicgoods i.termid position logmag importance2 gov min seniority || _all: R.partyid || districtid: if (closed==1), variance
estat ic
outreg2 using Ap4.doc, ctitle(Public Goods Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed publicgoods i.termid position logmag importance2 gov min seniority || _all: R.partyid || districtid: if (closed==0), variance
estat ic
outreg2 using Ap4.doc, ctitle(Public Goods Posts) alpha(.01, .05, .10) symbol(***, **, *) append

xtmixed base i.termid position || _all: R.partyid || districtid:, variance
estat ic
outreg2 using Ap5.doc,  ctitle(Base Posts) alpha(.01, .05, .10) symbol(***, **, *) replace
xtmixed base i.termid position logmag importance2 || _all: R.partyid || districtid:, variance
estat ic
outreg2 using Ap5.doc,  ctitle(Base Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed base i.termid position logmag importance2 gov min seniority || _all: R.partyid || districtid:, variance
estat ic
outreg2 using Ap5.doc,  ctitle(Base Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed base i.termid position logmag importance2 gov min seniority || _all: R.partyid || districtid: if (closed==1), variance
estat ic
outreg2 using Ap5.doc, ctitle(Base Posts) alpha(.01, .05, .10) symbol(***, **, *) append
xtmixed base i.termid position logmag importance2 gov min seniority || _all: R.partyid || districtid: if (closed==0), variance
estat ic
outreg2 using Ap5.doc, ctitle(Base Posts) alpha(.01, .05, .10) symbol(***, **, *) append

*Model 3 (Appendix)
xtmixed distributive i.termid importance closed closed_importance gov min seniority || _all: R.partyid || districtid:, variance
xtmixed highpolicy i.termid importance closed closed_importance gov min seniority || _all: R.partyid || districtid:, variance
xtmixed publicgoods i.termid importance closed closed_importance gov min seniority || _all: R.partyid || districtid:, variance
xtmixed base i.termid importance closed closed_importance gov min seniority || _all: R.partyid || districtid:, variance

set more off
eststo clear
xtmixed distributive i.termid importance closed closed_importance gov min seniority || _all: R.partyid || districtid:, variance
eststo
xtmixed highpolicy i.termid importance closed closed_importance gov min seniority || _all: R.partyid || districtid:, variance
eststo
xtmixed publicgoods i.termid importance closed closed_importance gov min seniority || _all: R.partyid || districtid:, variance
eststo
xtmixed base i.termid importance closed closed_importance gov min seniority || _all: R.partyid || districtid:, variance
eststo

#delimit;
esttab using Model3b.tex, b(%8.3f) se(%8.3f) star(* 0.05 ** 0.01 *** 0.001) nodepvars label mti() aic(%9.0g)
nonote 
addn("All estimates are based on multilevel mixed-effects ordered logistic regression."
"Variables not shown include state fixed effects in columns (2)--(4)."
"Robust standard errors in parentheses. * p<0.05, ** p<0.01, *** p<0.001.");



*Model 1

xtmixed distributive i.termid2 logmag position  || _all: R.partyid || districtid:, variance
xtmixed highpolicy i.termid2 logmag position  || _all: R.partyid || districtid:, variance
xtmixed publicgoods i.termid2 logmag position  || _all: R.partyid || districtid:, variance
xtmixed base i.termid2 logmag position  || _all: R.partyid || districtid:, variance

set more off
eststo clear
xtmixed distributive i.termid2 logmag position  || _all: R.partyid || districtid:, variance
eststo
xtmixed highpolicy i.termid2 logmag position  || _all: R.partyid || districtid:, variance
eststo
xtmixed publicgoods i.termid2 logmag position  || _all: R.partyid || districtid:, variance
eststo
xtmixed base i.termid2 logmag position  || _all: R.partyid || districtid:, variance
eststo

#delimit;
esttab using Model4a.tex, b(%8.3f) se(%8.3f) star(* 0.05 ** 0.01 *** 0.001) nodepvars label mti() aic(%9.0g)
nonote 
addn("All estimates are based on multilevel mixed-effects ordered logistic regression."
"Variables not shown include state fixed effects in columns (2)--(4)."
"Robust standard errors in parentheses. * p<0.05, ** p<0.01, *** p<0.001.");

xtmixed distributive i.termid2 logmag position importance2 || _all: R.partyid || districtid:, variance
xtmixed highpolicy i.termid2 logmag position importance2 || _all: R.partyid || districtid:, variance
xtmixed publicgoods i.termid2 logmag position importance2 || _all: R.partyid || districtid:, variance
xtmixed base i.termid2 logmag position importance2 || _all: R.partyid || districtid:, variance

set more off
eststo clear
xtmixed distributive i.termid2 logmag position importance2 || _all: R.partyid || districtid:, variance
eststo
xtmixed highpolicy i.termid2 logmag position importance2 || _all: R.partyid || districtid:, variance
eststo
xtmixed publicgoods i.termid2 logmag position importance2 || _all: R.partyid || districtid:, variance
eststo
xtmixed base i.termid2 logmag position importance2 || _all: R.partyid || districtid:, variance
eststo

#delimit;
esttab using Model4b.tex, b(%8.3f) se(%8.3f) star(* 0.05 ** 0.01 *** 0.001) nodepvars label mti() aic(%9.0g)
nonote 
addn("All estimates are based on multilevel mixed-effects ordered logistic regression."
"Variables not shown include state fixed effects in columns (2)--(4)."
"Robust standard errors in parentheses. * p<0.05, ** p<0.01, *** p<0.001.");

*Model 2
bysort closed: xtmixed distributive i.termid2 logmag position importance2 || _all: R.partyid || districtid:, variance
bysort closed: xtmixed highpolicy i.termid2 logmag position importance2 || _all: R.partyid || districtid:, variance
bysort closed: xtmixed publicgoods i.termid2 logmag position importance2 || _all: R.partyid || districtid:, variance
bysort closed: xtmixed base i.termid2 logmag position importance2 || _all: R.partyid || districtid:, variance

*Model 3 (Appendix)
bysort closed: xtmixed distributive i.termid2 logmag position importance2 gov min seniority || _all: R.partyid || districtid:, variance
bysort closed: xtmixed highpolicy i.termid2 logmag position importance2 gov min seniority || _all: R.partyid || districtid:, variance
bysort closed: xtmixed publicgoods i.termid2 logmag position importance2 gov min seniority || _all: R.partyid || districtid:, variance
bysort closed: xtmixed base i.termid2 logmag position importance2 gov min seniority || _all: R.partyid || districtid:, variance



*Models must be repeated in the Appendix with the following DVs
***constitutional defense education farming finance foreign health labor publicw
***highpolicyrobust1 highpolicyrobust2 highpolicyrobust3 highpolicyrobust4 publicgoodsrobust1 publicgoodsrobust2 distributiverobust1 distributiverobust2

***** Figures
xtmixed distributive i.termid logmag i.closed##c.relrank || _all: R.partyid || districtid:, variance
 margins closed, at(relrank=(0(.1)2)) vsquish
 marginsplot, recast(line) recastci(rarea)
 
**********

xtmixed highpolicy i.termid logmag i.position || _all: R.partyid || districtid:, variance
 margins, at(position=(1(1)12)) vsquish
 
 marginsplot
 
 
