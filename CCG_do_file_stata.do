*MASTER FILE*
*Stata Settings*

*==============================================================================*

*Project name: CCG*
*Author: Trajana Erlenberg*
*Date: 18.08.2024*

* define Stata setting
*
clear all

*Overall directory path

cd "H:\Stata"

*Dataset

sysuse CCGfinal

*==============================================================================*

*Initial Tests for validation



*1. TEST: Kruskal-Wallis-Test 

*PURPOSE: Determine whether there are significant differences in the suggested 
*decisions made in the baseline group based on the different orders in which the 
*games were played (non-parametric alternative to ANOVA)

kwallis p1_decision if treatment == 0, by(order)
kwallis p2_decision if treatment == 0, by(order)
kwallis p3_decision if treatment == 0, by(order)
kwallis p4_decision if treatment == 0, by(order)
kwallis ba_decision if treatment == 0, by(order)
kwallis bb_decision if treatment == 0, by(order)
kwallis bc_decision if treatment == 0, by(order)
kwallis bd_decision if treatment == 0, by(order)

*FIRST INTERPRETATION: No significant differences. All p-values above 0.05. Only
*for Bargaining Table C a very low value ov 0.0559. 



*2. TEST: Kruskal-Wallis-Test 

*PURPOSE: Determine whether there are significant differences in the suggested 
*decisions made in the treatment group based on the different orders in which 
*the games were played. (non-parametric alternative to ANOVA)

kwallis p1_decision if treatment == 1, by(order)
kwallis p2_decision if treatment == 1, by(order)
kwallis p3_decision if treatment == 1, by(order)
kwallis p4_decision if treatment == 1, by(order)
kwallis ba_decision if treatment == 1, by(order)
kwallis bb_decision if treatment == 1, by(order)
kwallis bc_decision if treatment == 1, by(order)
kwallis bd_decision if treatment == 1, by(order)

*FIRST INTERPRETATION: No significant differences. All p-values above 0.05.

*==============================================================================*

*Descriptive statsistics

*Descriptive statistics for age
summarize age

*Descriptive statistics for gender
tabulate gender

*Descriptive statistics for faculty
tabulate faculty

*==============================================================================*

*Tests for Hypothesis 1: The IOS11 score is expected to be higher in the 
*treatment group, indicating greater social closeness among friends compared to 
*strangers.


*1. TEST: Calculate mean values and create histogramm

*PURPOSE: See if the values differ

mean ios1 if treatment == 1
mean ios1 if treatment == 0
histogram ios1, by(treatment) discrete freq

*FIRST INTERPRETATION: Baseline: 2.95 Treatment:6.03


*2. TEST: Wilcoxon-Mann-Whitney-Test / Ranksum-Test

*PURPOSE: Test whether friends actually feel socially closer than strangers. 
*This is also a manipultion check. (non-parametric alternative to t-test)

ranksum ios1, by(treatment)

*FIRST INTERPRETATION: p-value of 0.0000 is smaller than 0.05, so there is a 
*significant difference. The z-value (-5.059) indicates a higher IOS score in 
*the treatment group, which supports H1. The manipulation has worked.

*3. TEST: Quantile Regression

*PURPOSE: A non-parametric robustness check for the Mann-Whitney-Test. It
*directly handles the continuous nature of your IOS score while allowing for the
*inclusion of covariates such as gender and age. It does not require the strict
*assumptions of linear regression (e.g., normality of errors) and thus aligns 
*more closely with the spirit of non-parametric methods.

qreg ios1 treatment gender age

*FIRST INTERPRETATION: The results show that being in the treatment group has a 
*statistically significant positive effect on the median IOS score, supporting 
*the idea that individuals in the treatment group feel closer (higher IOS score)
*than those in the baseline group. Neither gender nor age significantly affects 
*the median IOS score, suggesting that the treatment effect is robust even when 
*accounting for these factors. This result provides a non-parametric robustness 
*check that aligns with the findings from the Wilcoxon-Mann-Whitney test.


*==============================================================================*

*Tests for Hypothesis 2: Coordination rates in the suggested decisions will be 
*higher in the treatment condition compared to the baseline condition.


*1. TEST: Contingency table 

*PURPOSE: See the frequencies of decisions for all 8 games devides by baseline 
*vs. treatment and also devided by subgroup. The goal is to  get a feeling for 
*the data and see whether there are noticalble differences between the baseline 
*and the treatment group

*Create new variable for bargaining table games (Labels "close" and "far")

gen ba_decision_cf = .

replace ba_decision_cf = 1 if ba_decision == 1 & subgroup == 1
replace ba_decision_cf = 2 if ba_decision == 2 & subgroup == 1
replace ba_decision_cf = 1 if ba_decision == 2 & subgroup == 2
replace ba_decision_cf = 2 if ba_decision == 1 & subgroup == 2

label define decision_labels 1 "c" 2 "f"
label values ba_decision_cf decision_labels

gen bb_decision_cf = .

replace bb_decision_cf = 1 if bb_decision == 1 & subgroup == 1
replace bb_decision_cf = 2 if bb_decision == 2 & subgroup == 1
replace bb_decision_cf = 1 if bb_decision == 2 & subgroup == 2
replace bb_decision_cf = 2 if bb_decision == 1 & subgroup == 2

label values bb_decision_cf decision_labels

gen bc_decision_cf = .

replace bc_decision_cf = 1 if bc_decision == 1 & subgroup == 1
replace bc_decision_cf = 2 if bc_decision == 2 & subgroup == 1
replace bc_decision_cf = 1 if bc_decision == 2 & subgroup == 2
replace bc_decision_cf = 2 if bc_decision == 1 & subgroup == 2

label values bc_decision_cf decision_labels

gen bd_decision_cf = .

replace bd_decision_cf = 1 if bd_decision == 1 & subgroup == 1
replace bd_decision_cf = 2 if bd_decision == 2 & subgroup == 1
replace bd_decision_cf = 1 if bd_decision == 2 & subgroup == 2
replace bd_decision_cf = 2 if bd_decision == 1 & subgroup == 2

label values bd_decision_cf decision_labels

*Contingency table 

table p1_decision subgroup treatment, contents(freq)
table p2_decision subgroup treatment, contents(freq)
table p3_decision subgroup treatment, contents(freq)
table p4_decision subgroup treatment, contents(freq)
table ba_decision_cf subgroup treatment, contents(freq)
table bb_decision_cf subgroup treatment, contents(freq)
table bc_decision_cf subgroup treatment, contents(freq)
table bd_decision_cf subgroup treatment, contents(freq)

*FIRST INTERPRETATION: There are some differences that could be further 
*investigated (e.g. Pie 4 and Bargaining Table D).



*2. TEST: Fisher's Exact Test

*Purpose: See whether there are significant differences in the decisions for all
*eight games between the treatment groups.

tabulate p1_decision treatment, exact
tabulate p2_decision treatment, exact
tabulate p3_decision treatment, exact
tabulate p4_decision treatment, exact
tabulate ba_decision treatment, exact
tabulate bb_decision treatment, exact
tabulate bc_decision treatment, exact
tabulate bd_decision treatment, exact

*FIRST INTERPRETATION: The p-values are all above 0.05, meaning the treatment 
*did not have a significant impact on the players decisions.



*3. TEST: Fisher's Exact Test

*Purpose: See whether there are significant differences in the decisions for 
*all 8 games within the treatment groups and between the subgroups. "Within each 
*subgroup group (# and §), are the decisions different between 
*treatments (baseline/treatment)?

tabulate p1_decision subgroup if treatment == 0, exact
tabulate p1_decision subgroup if treatment == 1, exact


tabulate p1_decision treatment if subgroup == 1, exact
tabulate p1_decision treatment if subgroup == 2, exact

tabulate p2_decision treatment if subgroup == 1, exact
tabulate p2_decision treatment if subgroup == 2, exact

tabulate p3_decision treatment if subgroup == 1, exact
tabulate p3_decision treatment if subgroup == 2, exact

tabulate p4_decision treatment if subgroup == 1, exact
tabulate p4_decision treatment if subgroup == 2, exact

tabulate ba_decision treatment if subgroup == 1, exact
tabulate ba_decision treatment if subgroup == 2, exact

tabulate bb_decision treatment if subgroup == 1, exact
tabulate bb_decision treatment if subgroup == 2, exact

tabulate bc_decision treatment if subgroup == 1, exact
tabulate bc_decision treatment if subgroup == 2, exact

tabulate bd_decision treatment if subgroup == 1, exact
tabulate bd_decision treatment if subgroup == 2, exact

*FIRST INTERPRETATION: There is only one significant result: Pie 4. This p-value 
*is less than 0.05, indicating that there is a statistically significant 
*difference in the decisions for Pie 4 between the baseline (strangers) and 
*treatment (friends) groups within subgroup #. Specifically, participants in the 
*treatment group (friends) were more likely to choose Decision 2 (10,1), while 
*participants in the baseline group (strangers) were more likely to choose 
*Decision 1 (1,10).


*==============================================================================*

*Tests for Hypothesis 3: Team reasoning will be more frequent in the treatment 
*group compared to the baseline group.



*1. TEST: Contingency tableand mean values

*PURPOSE: See the frequencies of levels of reasoning for all 8 games devided by 
*baseline vs. treatment. 

*lower and upper bound for baseline group for all games

tabulate ki_p1 kii_p1 if treatment == 0
tabulate ki_p2 kii_p2 if treatment == 0
tabulate ki_p3 kii_p3 if treatment == 0
tabulate ki_p4 kii_p4 if treatment == 0
tabulate ki_ba kii_ba if treatment == 0
tabulate ki_bb kii_bb if treatment == 0
tabulate ki_bc kii_bc if treatment == 0
tabulate ki_bd kii_bd if treatment == 0

*Mean values for baseline group

egen row_mean_ki = rowmean(ki_p1 ki_p2 ki_p3 ki_p4 ki_ba ki_bb ki_bc ki_bd)
egen row_mean_kii = rowmean(kii_p1 kii_p2 kii_p3 kii_p4 kii_ba kii_bb kii_bc kii_bd)
mean row_mean_ki if treatment == 0
mean row_mean_kii if treatment == 0

*lower and upper bound for treatment group for all games

tabulate ki_p1 kii_p1 if treatment == 1
tabulate ki_p2 kii_p2 if treatment == 1
tabulate ki_p3 kii_p3 if treatment == 1
tabulate ki_p4 kii_p4 if treatment == 1
tabulate ki_ba kii_ba if treatment == 1
tabulate ki_bb kii_bb if treatment == 1
tabulate ki_bc kii_bc if treatment == 1
tabulate ki_bd kii_bd if treatment == 1

*Mean values for tratment group

mean row_mean_ki if treatment == 1
mean row_mean_kii if treatment == 1

*FIRST INTERPRETATION: There are some differences that could be further 
*investigated. Participants in the treatment group seem to apply more levels of 
*reasoning

*1.1 TEST: Wilcoxon Mann-Whitney Test

*PURPOSE: Test for significant differences in mean values

ranksum row_mean_ki, by(treatment)
ranksum row_mean_kii, by(treatment)

*FIRST INTERPRETATION: Upper bound in treatment group significantly higher


*2. TEST: Fisher’s Exact Test

*PURPOSE: Test whether there is a significant difference in the levels of 
*reasoning between the Baseline group and the Treatment group

* Fisher's Exact Test for all games (lower bound)
tabulate ki_p1 treatment, exact
tabulate ki_p2 treatment, exact
tabulate ki_p3 treatment, exact
tabulate ki_p4 treatment, exact
tabulate ki_ba treatment, exact
tabulate ki_bb treatment, exact
tabulate ki_bc treatment, exact
tabulate ki_bd treatment, exact

* Fisher's Exact Test for all games (upper bound)
tabulate kii_p1 treatment, exact
tabulate kii_p2 treatment, exact
tabulate kii_p3 treatment, exact
tabulate kii_p4 treatment, exact
tabulate kii_ba treatment, exact
tabulate kii_bb treatment, exact
tabulate kii_bc treatment, exact
tabulate kii_bd treatment, exact

*FIRST INTERPRETATION: Only the lower bound for the Pie 1 shows a significant 
*difference. Specifically, there are more participants in the Treatment group 
*who reached Level 2 reasoning compared to the Baseline group, where no one 
*reached Level 2 reasoning.




*3. TEST: Contingency table 

*PURPOSE: See the frequencies of label salience for all 8 games devided by 
*baseline vs. treatment. 

*Create new variable for label salience in bargaining table games ("close" and 
*"far")

gen σi_ba_cf = .

replace σi_ba_cf = 1 if σi_ba == 1 & subgroup == 1
replace σi_ba_cf = 2 if σi_ba == 2 & subgroup == 1
replace σi_ba_cf = 1 if σi_ba == 2 & subgroup == 2
replace σi_ba_cf = 2 if σi_ba == 1 & subgroup == 2
replace σi_ba_cf = 0 if σi_ba == 0 & subgroup == 1
replace σi_ba_cf = 0 if σi_ba == 0 & subgroup == 2

label define σi_labels 1 "c" 2 "f" 3 "n/a"
label values σi_ba_cf σi_labels

gen σi_bb_cf = .

replace σi_bb_cf = 1 if σi_bb == 1 & subgroup == 1
replace σi_bb_cf = 2 if σi_bb == 2 & subgroup == 1
replace σi_bb_cf = 1 if σi_bb == 2 & subgroup == 2
replace σi_bb_cf = 2 if σi_bb == 1 & subgroup == 2
replace σi_bb_cf = 0 if σi_bb == 0 & subgroup == 1
replace σi_bb_cf = 0 if σi_bb == 0 & subgroup == 2

label values σi_bb_cf σi_labels

gen σi_bc_cf = .

replace σi_bc_cf = 1 if σi_bc == 1 & subgroup == 1
replace σi_bc_cf = 2 if σi_bc == 2 & subgroup == 1
replace σi_bc_cf = 1 if σi_bc == 2 & subgroup == 2
replace σi_bc_cf = 2 if σi_bc == 1 & subgroup == 2
replace σi_bc_cf = 0 if σi_bc == 0 & subgroup == 1
replace σi_bc_cf = 0 if σi_bc == 0 & subgroup == 2

label values σi_bc_cf σi_labels

gen σi_bd_cf = .

replace σi_bd_cf = 1 if σi_bd == 1 & subgroup == 1
replace σi_bd_cf = 2 if σi_bd == 2 & subgroup == 1
replace σi_bd_cf = 1 if σi_bd == 2 & subgroup == 2
replace σi_bd_cf = 2 if σi_bd == 1 & subgroup == 2
replace σi_bd_cf = 0 if σi_bd == 0 & subgroup == 1
replace σi_bd_cf = 0 if σi_bd == 0 & subgroup == 2

label values σi_bd_cf σi_labels

*label salience for baseline group for all games

tabulate σi_p1 if treatment == 0
tabulate σi_p2 if treatment == 0
tabulate σi_p3 if treatment == 0
tabulate σi_p4 if treatment == 0
tabulate σi_ba_cf if treatment == 0
tabulate σi_bb_cf if treatment == 0
tabulate σi_bc_cf if treatment == 0
tabulate σi_bd_cf if treatment == 0

*label salience for treatment group for all games

tabulate σi_p1 if treatment == 1
tabulate σi_p2 if treatment == 1
tabulate σi_p3 if treatment == 1
tabulate σi_p4 if treatment == 1
tabulate σi_ba_cf if treatment == 1
tabulate σi_bb_cf if treatment == 1
tabulate σi_bc_cf if treatment == 1
tabulate σi_bd_cf if treatment == 1

*FIRST INTERPRETATION: No apparant differences.



*4. TEST: Fisher’s Exact Test

*PURPOSE: Test whether there is a significant difference in the label salience 
*between the baseline group and the treatment group

tabulate σi_p1 treatment, exact
tabulate σi_p2 treatment, exact
tabulate σi_p3 treatment, exact
tabulate σi_p4 treatment, exact
tabulate σi_ba_cf treatment, exact
tabulate σi_bb_cf treatment, exact
tabulate σi_bc_cf treatment, exact
tabulate σi_bd_cf treatment, exact

*FIRST INTERPRETATION: No apparant differences.



*5. TEST: Contingency table 

*PURPOSE: See the frequencies of payoff salience for all 8 games devided by 
*baseline vs. treatment. 

*payoff salience for baseline group for all games

tabulate ρi_p1 if treatment == 0
tabulate ρi_p2 if treatment == 0
tabulate ρi_p3 if treatment == 0
tabulate ρi_p4 if treatment == 0
tabulate ρi_ba if treatment == 0
tabulate ρi_bb if treatment == 0
tabulate ρi_bc if treatment == 0
tabulate ρi_bd if treatment == 0

*payoff salience for treatment group for all games

tabulate ρi_p1 if treatment == 1
tabulate ρi_p2 if treatment == 1
tabulate ρi_p3 if treatment == 1
tabulate ρi_p4 if treatment == 1
tabulate ρi_ba if treatment == 1
tabulate ρi_bb if treatment == 1
tabulate ρi_bc if treatment == 1
tabulate ρi_bd if treatment == 1

*FIRST INTERPRETATION: No apparant differences.



*6. TEST: Fisher’s Exact Test

*PURPOSE: Test whether there is a significant difference in the payoff salience 
*between the baseline group and the treatment group

tabulate ρi_p1 treatment, exact
tabulate ρi_p2 treatment, exact
tabulate ρi_p3 treatment, exact
tabulate ρi_p4 treatment, exact
tabulate ρi_ba treatment, exact
tabulate ρi_bb treatment, exact
tabulate ρi_bc treatment, exact
tabulate ρi_bd treatment, exact

*FIRST INTERPRETATION: No significant results.



*7. TEST: Contingency table 

*PURPOSE: See the frequencies of team reasoning for all 8 games devided by 
*baseline vs. treatment. 

*team reasoning for baseline group for all games

tabulate TR_p1 if treatment == 0
tabulate TR_p2 if treatment == 0
tabulate TR_p3 if treatment == 0
tabulate TR_p4 if treatment == 0
tabulate TR_ba if treatment == 0
tabulate TR_bb if treatment == 0
tabulate TR_bc if treatment == 0
tabulate TR_bd if treatment == 0

*team reasoning for treatment group for all games

tabulate TR_p1 if treatment == 1
tabulate TR_p2 if treatment == 1
tabulate TR_p3 if treatment == 1
tabulate TR_p4 if treatment == 1
tabulate TR_ba if treatment == 1
tabulate TR_bb if treatment == 1
tabulate TR_bc if treatment == 1
tabulate TR_bd if treatment == 1

*FIRST INTERPRETATION: No apparant differences.



*8. TEST: Fisher’s Exact Test

*PURPOSE: Test whether there is a significant difference in the team reasoning 
*between the baseline group and the treatment group

tabulate TR_p1 treatment, exact
tabulate TR_p2 treatment, exact
tabulate TR_p3 treatment, exact
tabulate TR_p4 treatment, exact
tabulate TR_ba treatment, exact
tabulate TR_bb treatment, exact
tabulate TR_bc treatment, exact
tabulate TR_bd treatment, exact

*FIRST INTERPRETATION: No statistically significant results.



*9. TEST: Fisher’s Exact Test

*PURPOSE: Test whether there is a significant difference in the team reasoning 
*between the baseline group and the treatment group. This time no distinction 
*between team reasoning types. Just team reasoning or no team reasoning

tabulate TR_p1_grouped treatment, exact
tabulate TR_p2_grouped treatment, exact
tabulate TR_p3_grouped treatment, exact
tabulate TR_p4_grouped treatment, exact
tabulate TR_ba_grouped treatment, exact
tabulate TR_bb_grouped treatment, exact
tabulate TR_bc_grouped treatment, exact
tabulate TR_bd_grouped treatment, exact

*FIRST INTERPRETATION: No statistically significant results.






































*REGRESSION

*1. TEST: Regression

*PURPOSE: to be continued


*Tests with panel structure:

sort session_no participant_id_in_session
gen id = _n

rename TR_p1_grouped TR_grouped1 //games 1-4 are pie games
rename TR_p2_grouped TR_grouped2
rename TR_p3_grouped TR_grouped3
rename TR_p4_grouped TR_grouped4

rename TR_ba_grouped TR_grouped5 //games 5-8 are bargaining games
rename TR_bb_grouped TR_grouped6
rename TR_bc_grouped TR_grouped7
rename TR_bd_grouped TR_grouped8

reshape long TR_grouped, i(id) j(Game_ID)

probit TR_grouped ios1 if treatment==0 , vce(cluster id) //p=0.864 und falsches 
//Vorzeichen
probit TR_grouped ios1 if treatment==1 , vce(cluster id) //p=0.016

// add control variables here.
// add sequence

gen position =.
replace position = Game_ID if order == 1
replace position = 1 if Game_ID == 5 & order == 2
replace position = 2 if Game_ID == 6 & order == 2
replace position = 3 if Game_ID == 7 & order == 2
replace position = 4 if Game_ID == 8 & order == 2
replace position = 5 if Game_ID == 1 & order == 2
replace position = 6 if Game_ID == 2 & order == 2
replace position = 7 if Game_ID == 3 & order == 2
replace position = 8 if Game_ID == 4 & order == 2

probit TR_grouped ios1 position order age gender if treatment==1 , vce(cluster id) //p=0.016
probit TR_grouped ios1 position order age gender if treatment==0 , vce(cluster id) //p=0.016


*==============================================================================*

*Tests for Hypothesis 4: Team reasoning will lead to a higher choice of focal 
*strategies.


*New variable to show if subjects chose the focal strategy or not for later tests

gen p1_focal = .  
replace p1_focal = 1 if p1_decision == 2  // 1 = focal strategy
replace p1_focal = 0 if inlist(p1_decision, 1, 3)  // 2 = non focal strategy

gen p2_focal = .
replace p2_focal = 1 if p2_decision == 2
replace p2_focal = 0 if inlist(p2_decision, 1, 3)

gen p3_focal = .
replace p3_focal = 1 if p3_decision == 2
replace p3_focal = 0 if inlist(p3_decision, 1, 3)

gen p4_focal = .
replace p4_focal = 1 if p4_decision == 2
replace p4_focal = 0 if inlist(p4_decision, 1, 3)


gen ba_focal = .
replace ba_focal = 1 if ba_decision_cf == 1  // 1 = focal strategy
replace ba_focal = 0 if ba_decision_cf == 2  // 2 = non focal strategy

gen bb_focal = .
replace bb_focal = 1 if bb_decision_cf == 1
replace bb_focal = 0 if bb_decision_cf == 2

gen bc_focal = .
replace bc_focal = 1 if bc_decision_cf == 1
replace bc_focal = 0 if bc_decision_cf == 2

gen bd_focal = .
replace bd_focal = 1 if bd_decision_cf == 1
replace bd_focal = 0 if bd_decision_cf == 2


label define focal_label 1 "focal strategy" 0 "non-focal strategy"

label values p1_focal focal_label
label values p2_focal focal_label
label values p3_focal focal_label
label values p4_focal focal_label
label values ba_focal focal_label
label values bb_focal focal_label
label values bc_focal focal_label
label values bd_focal focal_label


gen focal_strategy = .
replace focal_strategy = p1_focal if Game_ID == 1
replace focal_strategy = p2_focal if Game_ID == 2
replace focal_strategy = p3_focal if Game_ID == 3
replace focal_strategy = p4_focal if Game_ID == 4
replace focal_strategy = ba_focal if Game_ID == 5
replace focal_strategy = bb_focal if Game_ID == 6
replace focal_strategy = bc_focal if Game_ID == 7
replace focal_strategy = bd_focal if Game_ID == 8

*Probit regression

probit focal_strategy TR_grouped position order age gender if treatment == 1, vce(cluster id)
probit focal_strategy TR_grouped position order age gender if treatment == 0, vce(cluster id)

xtset id
xtprobit focal_strategy TR_grouped ios1 position order age gender, vce(robust)

*FIRST INTERPRETATION: The probit regression results in Table 4 show that team 
*reasoning significantly increases the likelihood of choosing focal strategies 
*in both the treatment (coefficient = 1.157, p < 0.01) and baseline group (
*coefficient = 1.119, p < 0.01). None of the control variables (position, order, 
*age) are significant in either group. However, gender is a significant 
*pre-dictor in the treatment group (coefficient = 0.557, p < 0.05) but not in 
*the baseline group. 

*==============================================================================*

*Additional Analysis

*Calculate the mean of final_payoff_euro for the baseline group (treatment == 0)
mean final_payoff_euro if treatment == 0

*Calculate the mean of final_payoff_euro for the treatment group (treatment == 1)
mean final_payoff_euro if treatment == 1

*Perform a ranksum test to check if there are significant differences between 
*the two groups
ranksum final_payoff_euro, by(treatment)

*==============================================================================*






