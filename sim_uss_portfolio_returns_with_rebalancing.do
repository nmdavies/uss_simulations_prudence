//Neil Davies 30/10/20
//Reconciliation of the USS FBB model with estimated SDs

//Estimating annual mean and SD to get 4.39% real over 30 years

clear
set obs 10000
forvalues i=1(1)30{
	gen equity_`i'=rnormal(0.078,0.1821)
	gen bonds_`i'=rnormal(0.01,0.03)
	}
	
gen total_equity_90=1
gen total_equity_10=1
gen total_equity_64=1

forvalues i=1(1)30{
	replace total_equity_90=0.9*(1+equity_`i')*total_equity_90+0.1*(1+bonds_`i')*total_equity_90
	replace total_equity_10=0.1*(1+equity_`i')*total_equity_10+0.9*(1+bonds_`i')*total_equity_10
	replace total_equity_64=0.64*(1+equity_`i')*total_equity_64+0.36*(1+bonds_`i')*total_equity_64
	//Output 15 year returns
	if `i'==15{
		gen total_equity_90_15=total_equity_90
		gen total_equity_10_15=total_equity_10
		gen total_equity_64_15=total_equity_64
	}
	}
	
//Pre-retirement portfolio 90% equities	
gen average_returns_90=(exp(ln(total_equity_90)/30)-1)*100

//Post-retirement portfolio 90% bonds
gen average_returns_10=(exp(ln(total_equity_10)/30)-1)*100

//Generate reference portfolio
gen average_returns_64=(exp(ln(total_equity_64)/30)-1)*100
gen average_returns_64_15=(exp(ln(total_equity_64_15)/15)-1)*100

tabstat average_returns_*, stats(mean p50 sd)

twoway kdensity average_returns_64 ||kdensity average_returns_64_15 

//Figure 1 Plot 30 year returns
kdensity average_returns_64, lcolor(black) graphregion(color(white))  ylab(,nogrid) xtitle("Annualised returns (%) CPI+")  xline(0) title("")

//Figure 2 plot 15 versus 30 year returns
twoway kdensity average_returns_64,lcolor(black)|| kdensity average_returns_64_15, lcolor(red) graphregion(color(white))  ylab(,nogrid) xtitle("Annualised returns (%) CPI+")  xline(0) title("") ///
	legend(order(1 "30 year annualised returns" 2 "15 year annualised returns")) 
