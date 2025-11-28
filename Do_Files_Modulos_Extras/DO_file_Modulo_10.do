********************************************************************************
********************************************************************************
**************               SESION 0: TALLER STATA               **************
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
cd "/Users/benjaminmunozrojas/pCloud Drive/3_Docencia/6_Analisis_de_Datos_Con_Stata/Sesion_10"




*Iniciar un documento log (con formato .txt)
log using log_sesion_01, append text  /*Creamos un archivo log para 
										almacenar los outputs de Stata.*/

											   
********************************************************************************
											   
***PASO 1: UTILIZAR BASE DE DATOS Y REVISIÓN DE VARIABLES

*Cargar base de datos
use "World_Values_Survey_W6.dta"

*Revisión Global de datos
codebook
describe

*Indice de Valores Seculares: disociacion de personas respecto a autoridades externas
tab SACSECVAL
fre SACSECVAL

*Indice de Valores Emancipatorios: personas reclaman autoridad sobre sus vidas
tab RESEMAVAL
fre RESEMAVAL

*Felicidad
tab V10
fre V10

*Sexo 
tab V240
fre V240

recode V240 (1=0) (2=1)(-5=.) (-2=.), gen(mujer)
label variable mujer "Sexo del Entrevistado"
label define mujerlab 0 "Hombre" 1 "Mujer"
label values mujer mujerlab

tab V240 mujer


********************************************************************************
											   
***PASO 2: GENERACIÓN DE GRÁFICOS DESCRIPTIVOS

****A VISUAL GUIDE TO STATA GRAPHICS

*El comando histogram permite construir gráficos univariados
histogram SACSECVAL

*Tiene múltiples opciones de que se desea graficar
histogram SACSECVAL, frequency
histogram SACSECVAL, percent

*Se puede manipular el número de bins o su ancho
histogram SACSECVAL, bin(10) frequency
histogram SACSECVAL, bin(100) frequency
histogram SACSECVAL, width(0.1) frequency

*Se puede agregar una línea de tendencia de distribución
histogram SACSECVAL, bin(10) frequency normal

*Los gráficos pueden ser completamente editados para mejorar la presentación
histogram SACSECVAL, bin(10) frequency normal ytitle(Frecuencia)
histogram SACSECVAL, bin(10) frequency normal ytitle(Frecuencia) ylabel(0(10000)20000)
histogram SACSECVAL, bin(10) frequency normal ytitle(Frecuencia) ylabel(0(10000)20000, labels labsize(small) labcolor(black))
histogram SACSECVAL, bin(10) frequency normal ytitle(Frecuencia) ylabel(0 5000 "5000" 10000 "10000" 15000 "15000" 20000 "20000", labels labsize(small) labcolor(black))

histogram SACSECVAL, bin(10) frequency normal ytitle(Frecuencia) /*
*/ ylabel(0 5000 "5000" 10000 "10000" 15000 "15000" 20000 "20000", labels labsize(small) labcolor(black)) /*
*/ xtitle(Puntaje de Valores Seculares) xlabel(0 0.25 "0.25" 0.50 "0.50" 0.75 "0.75" 1.00 "1.00", labels labsize(small) labcolor(black)) /*
*/ title("Figura 1: Distribución de Valores Seculares") caption("Fuente: Encuesta Mundial de Valores Ola 6 (2019)") note("Nota: Valores no ponderados")  


*Los schemes permiten manipular la estructura global del gráfico
ssc install blindschemes
set scheme plotplain

histogram SACSECVAL, bin(10) frequency normal ytitle(Frecuencia) /*
*/ ylabel(0 5000 "5000" 10000 "10000" 15000 "15000" 20000 "20000", labels labsize(small) labcolor(black)) /*
*/ xtitle(Puntaje de Valores Seculares) xlabel(0 0.25 "0.25" 0.50 "0.50" 0.75 "0.75" 1.00 "1.00", labels labsize(small) labcolor(black)) /*
*/ title("Figura 1: Distribución de Valores Seculares") caption("Fuente: Encuesta Mundial de Valores Ola 6 (2019)") note("Nota: Valores no ponderados")  



*set scheme economist 
*set scheme s1rcolor 


*set scheme plottig 
*set scheme uncluttered 
*set scheme lean2 

*Más adelante revisaremos funciones más avanzadas: 
*https://www.stata.com/meeting/germany18/slides/germany18_Jann.pdf


**Histogram también puede utilizarse para graficos de variables discretas

tab V10
histogram V10, discrete frequency 


**El comando graph es otra alternativa: su ventaja es que permite graficar estadísticos descriptivos
**Sin embargo, la tarea más simple (frecuencias) requiere especificaciones
graph bar (mean) V10
graph bar (sum) V10

*Existen dos opciones over() y by()
graph bar (count), over(V10)
graph bar (count), by(V10)

*Se pueden agregar ponderadores
graph bar (count) [aweight = V258], over(V10)


***GRAFICOS BIVARIADOS

*Boxplots
graph box RESEMAVAL
graph box RESEMAVAL, over(V240)
graph box RESEMAVAL, over(mujer)


*Mejoremos este gráfico
twoway (scatter SACSECVAL RESEMAVAL)
twoway (line SACSECVAL RESEMAVAL)
twoway (lfit SACSECVAL RESEMAVAL)


graph bar (count) [aweight = V258], over(V10) over(V240)
*¿Cómo podemos mejorar la Figura?
graph bar (count) [aweight = V258], over(V10) by(V240)


















