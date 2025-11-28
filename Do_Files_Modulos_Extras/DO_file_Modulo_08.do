********************************************************************************
********************************************************************************
**************               SESION 8: TALLER STATA               **************
**************                                                    **************
********************************************************************************
********************************************************************************

***PASO 0: CONFIGURACIÓN DEL ESPACIO DE TRABAJO


*Limpieza del Espacio de trabajo
clear all                   /*Remueve de la memoria todos los elementos 
							  que se encuentren activos. A su vez,
							 cierra los archivos abiertos (y ventanas 
							 adicionales) y resetea los timers a cero. */
								   
capture log close           /*clear all NO cierra los archivos log.*/


*Identificar versión utilizada
version 14

*Modificar ancho de línea de resultados
set more off
set linesize 90               /*Con este comando fijamos el largo de las
								líneas de output.*/

								
*¿En qué directorio estamos trabajando?
pwd                                     /*Imprime el directorio de trabajo*/


*Generar un Directorio (Carpeta) y por medio de cd definirlo como directorio de trabajo.
cd "/Users/benjaminmunozrojas/pCloud Drive/3_Docencia/6_Analisis_de_Datos_Con_Stata/Sesion_08"




*Iniciar un documento log (con formato .txt)
log using log_sesion_08, append text  /*Creamos un archivo log para 
										almacenar los outputs de Stata.*/

											   
********************************************************************************
											   
***PASO 1: UTILIZAR BASE DE DATOS Y CREACIÓN DE VARIABLES

use "ZA6900_v2-0-0.dta"


*SEXO
fre SEX
recode SEX (1=0) (2=1)(9=.), gen(mujer)
label variable mujer "Sexo del Entrevistado"
label define mujerlab 0 "Hombre" 1 "Mujer"
label values mujer mujerlab

tab SEX mujer


*EDAD
fre AGE
recode AGE (0=.) (15/17=.) (999=.), gen(edad)
label variable edad "Edad del Entrevistado"

gen edad_control = AGE - edad
summ edad_control


*EDAD EN TRAMOS
egen edad_tramos = cut(edad), at(15,30,45,65,100)
recode edad_tramos (15=1) (30=2) (45=3) (65=4)
label variable edad_tramos "Edad del Entrevistado (en tramos)"
label define edad_tramoslab 1 "18 a 29" 2 "30 a 44" 3 "45 a 64" 4 "65 a 99"
label values edad_tramos edad_tramoslab

tab edad_tramos
tab edad edad_tramos


*EDUCACION
fre DEGREE
recode DEGREE (0/1=1) (2/3=2) (4/6=3) (9=.), gen(educ)
label variable educ "Nivel educativo"
label define educlabel 1 "Menos que secundaria" 2 "Secundaria" 3 "Mas que secundaria"
label values educ educlabel

tab DEGREE educ


*CORRUPCION
fre v59
generate corrupcion = v59
replace corrupcion =. if v59 ==8
replace corrupcion =. if v59 ==9
label variable corrupcion "Percepcion Numero Oficiales Publicos Corruptos"
label define corruplab 1 "Casi ninguno" 2 "Unos pocos" 3 "Algunos" 4 "Muchos" 5 "Casi todos"
label values corrupcion corruplab

fre corrupcion
tab v59 corrupcion

recode corrupcion (1/3=0) (4/5=1), gen(corrup_bin)
label variable corrup_bin "Percepcion Corrupcion (Dicotomizada)"
label define corruplabel1 0 "Baja-Media" 1 "Alta"
label values corrup_bin corruplabel1

fre corrup_bin
tab corrupcion corrup_bin


*Base de datos temporal
preserve
keep country mujer edad edad_tramos educ corrupcion corrup_bin WEIGHT

********************************************************************************
											   
***PASO 2: ANÁLISIS EXPLORATORIO DE DATOS

*Codebook
codebook mujer edad edad_tramos educ corrupcion corrup_bin

*Tablas de Frecuencias
tab mujer
tab mujer [aw = WEIGHT]

tab edad 
tab edad [aw = WEIGHT]

tab corrupcion
tab corrupcion [aw = WEIGHT]


*Gráfico de barras (como tablas)
graph bar (count), over(corrupcion)
graph bar (count) [aweight = WEIGHT] , over(corrupcion)

ssc install catplot
catplot corrupcion


histogram edad, frequency
histogram edad, frequency normal
graph box edad [aweight = WEIGHT]



*Estadística Descriptiva
summarize mujer
summarize mujer, detail
summarize mujer [aweight = WEIGHT], detail

summarize edad, detail
summarize edad [aweight = WEIGHT], detail

summarize corrupcion, detail
summarize corrupcion [aweight = WEIGHT], detail


*Valores Perdidos
misstable summarize mujer
misstable summarize edad
misstable summarize educ
misstable summarize corrupcion

misstable patterns
misstable nested


*Correlaciones entre Variables
correlate
tetrachoric mujer corrup_bin, stats(rho se obs p)


tabulate mujer corrupcion [aweight = WEIGHT]
tabulate mujer corrupcion [aweight = WEIGHT], cell 
tabulate mujer corrupcion [aweight = WEIGHT], col 
tabulate mujer corrupcion [aweight = WEIGHT], row 

tabulate mujer corrupcion [aweight = WEIGHT], row expected
tabulate mujer corrupcion [aweight = WEIGHT], nofreq row

tabulate mujer corrupcion [aweight = WEIGHT], cchi2 chi2 nofreq row V
tabulate mujer corrupcion, cchi2 chi2 nofreq row V







