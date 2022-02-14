

use "~/CrossNational.dta",clear


gen closed=0
recode closed 0=1 if country=="Spain"
recode closed 0=1 if country=="Portugal"
recode closed 0=1 if country=="Norway"

egen idterm=group(country termid)
egen idcountry=group(country )


destring idterm, replace

gen closed_relrank=closed*relrank
gen closed_logmag=closed*logmag

egen countryid=group(country)

xtmelogit highpolicy relrank logmag closed closed_relrank closed_logmag i.idterm i.countryid || _all: R.party || district: , variance
xtmelogit publicgoods relrank logmag closed closed_relrank closed_logmag i.idterm || _all: R.party || district: , variance
xtmelogit distributive relrank logmag closed closed_relrank closed_logmag i.idterm  || _all: R.party || district: , variance
xtmelogit base relrank logmag closed closed_relrank closed_logmag i.idterm  || _all: R.party || district: , variance

xtmelogit highpolicy relrank logmag closed closed_relrank closed_logmag i.idterm || country: || _all: R.party || district: , variance
xtmelogit publicgoods relrank logmag closed closed_relrank closed_logmag  i.idterm || _all: R.party || district: , variance
xtmelogit distributive relrank logmag closed_relrank  closed closed_logmag i.idterm || country: || _all: R.party || district: , variance
xtmelogit base relrank logmag closed closed_relrank closed_logmag   i.idterm  || _all: R.party || district: , variance

xtmelogit highpolicy relrank logmag closed closed_logmag i.idterm || country: || _all: R.party || district: , variance


xtmelogit highpolicy relrank logmag age i.idterm || _all: R.party || district: , variance
xtmelogit publicgoods relrank logmag age i.idterm || _all: R.party || district: , variance
xtmelogit distributive relrank logmag age i.idterm  || _all: R.party || district: , variance
xtmelogit base relrank logmag age i.idterm || _all: R.party || district: , variance
