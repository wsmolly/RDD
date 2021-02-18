
use https://github.com/scunning1975/causal-inference-class/raw/master/hansen_dwi, clear

*Q3.Create dummy for bac>0/08
gen DUI=1 if bac1>=0.08
replace DUI=0 if DUI==.

*Q4.Figure1:BAC hitogram
cd "C:\Users\user\Desktop\Austin course\Causal Inference\Replicate1\Figures"
histogram bac1, bin(150) xline(0.08)
graph export "C:\Users\user\Desktop\Austin course\Causal Inference\Replicate1\Figures\Figure1.png", as(png) replace
cd "C:\Users\user\Desktop\Austin course\Causal Inference\Replicate1\Do"

*Q5.Table2:Corvariate balance
ssc install outreg2
gen DUI_bac1 = bac1*DUI
reg male bac1 DUI DUI_bac1 if bac1>0.08-0.05& bac1<0.08+0.05,cluster(bac1)
outreg2 using ../Tables/Table2.doc, replace ctitle(Male) label

reg white bac1 DUI DUI_bac1 if bac1>0.08-0.05& bac1<0.08+0.05,cluster(bac1)
outreg2 using ../Tables/Table2.doc, append ctitle(white) label

reg aged bac1 DUI DUI_bac1 if bac1>0.08-0.05& bac1<0.08+0.05,cluster(bac1)
outreg2 using ../Tables/Table2.doc, append ctitle(aged) label

reg acc bac1 DUI DUI_bac1 if bac1>0.08-0.05& bac1<0.08+0.05,cluster(bac1)
outreg2 using ../Tables/Table2.doc, append ctitle(acc) label

*Q6.Figure2

*lineat(#) draws a vertical line at the specified point along the x axis.
*cutpoint(#) splits the graph at the specified point along the x axis. No bin spanning the cutoff.
*histopts(options) controls the definition of bins with histogram options.When graphs are split by cutpoint, these options govern bindefinitions for each side of the graph
ssc install cmogram
cmogram acc bac1 if bac1 < 0.2, lineat(0.08 0.15) cutpoint(0.08)scatter lfitci title(Panel A. Accident at scene) histopts(bin(30)) graphopts(xtitle("BAC") ytitle(""))
graph save ../figures/Fig2.ACC.gph

cmogram male bac1 if bac1 < 0.2, lineat(0.08 0.15) cutpoint(0.08)scatter lfitci title(Panel B. Male) histopts(bin(30)) graphopts(xtitle("BAC") ytitle(""))
graph save ../figures/Fig2.male.gph

cmogram aged bac1 if bac1 < 0.2, lineat(0.08 0.15) cutpoint(0.08)scatter lfitci title(Panel C. Age) histopts(bin(30)) graphopts(xtitle("BAC") ytitle(""))
graph save ../figures/Fig2.age.gph

cmogram white bac1 if bac1 < 0.2, lineat(0.08 0.15) cutpoint(0.08)scatter lfitci title(Panel D. White) histopts(bin(30)) graphopts(xtitle("BAC") ytitle(""))
graph save ../figures/Fig2.white.gph

graph combine ../figures/Fig2.ACC.gph ../figures/Fig2.male.gph ../figures/Fig2.age.gph ../figures/Fig2.white.gph, title(Linear Fit) saving(../figures/Fig2.Linear.gph)
graph export "C:\Users\user\Desktop\Austin course\Causal Inference\Replicate1\Figures\Figure2_linear.png", as(png) replace

*quadratic
cmogram acc bac1 if bac1 < 0.2, lineat(0.08 0.15) cutpoint(0.08)scatter qfitci title(Panel A. Accident at scene) histopts(bin(30)) graphopts(xtitle("BAC") ytitle(""))
graph save ../figures/Fig2.ACC_q.gph

cmogram male bac1 if bac1 < 0.2, lineat(0.08 0.15) cutpoint(0.08)scatter qfitci title(Panel B. Male) histopts(bin(30)) graphopts(xtitle("BAC") ytitle(""))
graph save ../figures/Fig2.male_q.gph

cmogram aged bac1 if bac1 < 0.2, lineat(0.08 0.15) cutpoint(0.08)scatter qfitci title(Panel C. Age) histopts(bin(30)) graphopts(xtitle("BAC") ytitle(""))
graph save ../figures/Fig2.age_q.gph

cmogram white bac1 if bac1 < 0.2, lineat(0.08 0.15) cutpoint(0.08)scatter qfitci title(Panel D. White) histopts(bin(30)) graphopts(xtitle("BAC") ytitle(""))
graph save ../figures/Fig2.white_q.gph

graph combine ../figures/Fig2.ACC_q.gph ../figures/Fig2.male_q.gph ../figures/Fig2.age_q.gph ../figures/Fig2.white_q.gph, title(Quadratic Fit) saving(../figures/Fig2.Quadratic.gph)
graph use "C:\Users\user\Desktop\Austin course\Causal Inference\Replicate1\Figures\Fig2.Quadratic.gph" 

*Q7.Table3 Panel A:recidivism outcome (0.03 < bac1 < 0.13)

reg recid bac1 DUI  white male age acc year if bac1>0.03& bac1<0.13,robust 
outreg2 using ../Tables/Table3A.doc, replace title("Table 3 Panel A: Regression Discontinuity Estimates for the Effect of Exceeding the 0.08 BAC Threshold on Recidivism") ctitle(1) label

reg recid bac1 DUI DUI_bac1 white male age acc  year if bac1>0.03& bac1<0.13,robust 
outreg2 using ../Tables/Table3A.doc, append title("Table 3 Panel A: Regression Discontinuity Estimates for the Effect of Exceeding the 0.08 BAC Threshold on Recidivism") ctitle(2) label

gen bac1sq_DUI= bac1*bac1*DUI
reg recid  bac1 DUI DUI_bac1 bac1sq bac1sq_DUI white male age acc year if bac1>0.03& bac1<0.13,robust 
outreg2 using ../Tables/Table3A.doc, append title("Table 3 Panel A: Regression Discontinuity Estimates for the Effect of Exceeding the 0.08 BAC Threshold on Recidivism") ctitle(3) label


*Q7.Table3 Panel B:recidivism outcome (0.055 < bac1 < 0.105)

reg recid bac1 DUI white male age acc year if bac1>0.055& bac1<0.105,robust 
outreg2 using ../Tables/Table3B.doc, replace title("Table 3 Panel B: Regression Discontinuity Estimates for the Effect of Exceeding the 0.08 BAC Threshold on Recidivism") ctitle(1) label

reg recid bac1 DUI DUI_bac1 white male age acc year if bac1>0.055& bac1<0.105,robust 
outreg2 using ../Tables/Table3B.doc, append title("Table 3 Panel B: Regression Discontinuity Estimates for the Effect of Exceeding the 0.08 BAC Threshold on Recidivism") ctitle(2) label

gen bac1sq=bac1*bac1
reg recid bac1 bac1sq DUI DUI_bac1 bac1sq bac1sq_DUI white male age acc year if bac1>0.055& bac1<0.105,robust 
outreg2 using ../Tables/Table3B.doc, append title("Table 3 Panel B: Regression Discontinuity Estimates for the Effect of Exceeding the 0.08 BAC Threshold on Recidivism") ctitle(3) label


*Q8.Figure3: BAC and Recidivism
cmogram recid bac1 if bac1 < 0.15, lineat(0.08) cutpoint(.08)scatter lfit title(Panel A. BAC and Recidivism-Linear ) histopts(bin(30)) graphopts(xtitle("BAC") ytitle(""))
graph save ../figures/Fig3.Linear.gph

cmogram recid bac1 if bac1 < 0.15, lineat(0.08) cutpoint(.08)scatter qfit title(Panel B. BAC and Recidivism-Quadratic ) histopts(bin(30)) graphopts(xtitle("BAC") ytitle(""))
graph save ../figures/Fig3.Quadratic.gph

graph combine ../figures/Fig3.Linear.gph ../figures/Fig3.Quadratic.gph, rows(2) cols(1) saving(../figures/Fig3.gph)

















