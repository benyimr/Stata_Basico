

preserve
keep country v1-v10 SEX AGE DEGREE WORK WEIGHT
tab v1 [aw=WEIGHT]

fre country
drop if country == 158 | country == 268 | country == 356 | country == 376 | country == 392 | country == 410 | country == 608 | country == 643 | country == 764 | country == 792 
tab v1 [aw=WEIGHT]

tab AGE
keep if AGE >= 18 & AGE <=65

tab AGE
fre DEGREE
