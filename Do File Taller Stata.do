*Do File Taller de Stata


*Generar un Directorio (Carpeta) y por medio de cd definirlo como directorio de trabajo.
* Almacenar Bases de Datos Provistas

*1)LECTURA DE BASES DE DATOS

*Archivo Separado por Comas
insheet using QoGSepComa.csv

*Archivo Excel
import excel QoGExcel.xls
clear
import excel QoGExcel.xlsx
browse
clear
import excel QoGExcel.xlsx, firstrow

*Archivo Texto
clear
insheet using QoGTexto.txt

***************************************
*Archivo de SPSS (Sólo para Windows)
* ssc describe usespss
* ssc install usespss
* usespss using QoGSPSS.sav
***************************************

*Archivo de Stata
clear
use QoGStata


*2)MANEJO DE BASES DE DATOS

*a) Eliminación o Mantención de Observaciones

use QoGOECD.dta

*Mantener Casos
tab year
preserve
keep if year==2014
tab year
restore

tab year

*Descartar Casos
preserve
drop if year<=2010
tab year
restore
tab year

*b) Homologación de Bases de Datos

*Agregar Variables

use AGL_1.dta
merge 1:1 country using AGL_2.dta

*La sintaxis de merge ha evolucionado.

*Agregar Casos
append using AGL_3


*c)Recodificación y Generación de Variables

gen logcrec=log(growth)
browse

summ logcrec

summ openex
gen openexR=openex
replace openexR=. if openex>1500

summ openexR


*3)ESTADISTICA DESCRIPTIVA

tab country
tab country, nolabel

summarize growth
summarize growth, detail
correlate growth opengdp openex openimp leftc central

histogram growth
graph box growth
twoway (scatter growth leftc)


*Aspecto más complejo: Cambio de unidad de Análisis (agregación)

use ISSP2009COES2.dta

describe brecha_percibida
codebook brecha_percibida

preserve 

collapse (mean) brecha1=brecha_percibidaT2 gini=gini2009 (median)brecha1A=brecha_percibidaT2 (sd) brecha1B=brecha_percibidaT2 (semean) brecha1C=brecha_percibidaT2 [aw=ponderador], by(codigopais pais2) 

pwcorr brecha1 brecha1A brecha1B brecha1C gini, sig

twoway (scatter brecha1B brecha1, msymbol(none) mlabel(codigopais) mlabposition(0)), ytitle(Desviación Estándar Brecha Salarial Percibida) xtitle(Media Nacional de Brecha Salarial Percibida) title("Gráfico 1: Relación entre media y dispersión de" "brecha salarial percibida, según país") 

twoway (scatter gini brecha1, msymbol(none) mlabel(codigopais) mlabposition(0)), ytitle(Coeficiente de Gini 2009) xtitle(Media Nacional de Brecha Salarial Percibida) title("Gráfico 2: Relación entre brecha salarial" "percibida y desigualdad de ingresos, según país") 


*4)ESTADISTICA INFERENCIAL: APLICACIÓN A TSCS DATA

*Usaremos una especie de comando especial para panel.

*a) Fijar las características del panel
xtset  pais year
encode pais, gen(country)
xtset  country year

*b) Gráficos Descriptivos 
graph box growth, by(country)
histogram growth, by(country)

*Una ventaja es la existencia de gráficos especializados

*Heterogeneidad en el tiempo
xtline growth
xtline growth, overlay

bysort year: egen growth_mean1=mean(growth)
twoway scatter growth year, msymbol(circle_hollow) || connected growth_mean1 year, msymbol(diamond)

*Heterogeneidad entre los paises
bysort country: egen growth_mean=mean(growth)
twoway scatter growth country, msymbol(circle_hollow) || connected growth_mean country, msymbol(diamond)

*Análisis de Regresión
reg growth leftc
reg growth leftc central
reg growth leftc central inter
reg growth c.leftc##c.central 
reg growth c.leftc##c.central 

*Post-estimación
margins, dydx(left) at(central=(0(0.1)4)) vsquish
marginsplot
margins, dydx(central) at(left=(0(1)100)) vsquish
marginsplot

*Distinción por Paises: Dummys de Países
xi: reg growth leftc i.country

predict yhat

separate growth, by(country)
separate yhat, by(country)
twoway connected yhat1-yhat16 leftc

*Modelo de Efectos Fijos

xtreg growth leftc , fe
xtreg growth central, fe
xtreg growth leftc central, fe
xtreg growth c.leftc##c.central, fe
