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

use ________________

**CREAR VARIABLES DE SER NECESARIO


********************************************************************************
											   
***PASO 2: ANÁLISIS EXPLORATORIO DE DATOS

*Codebook
codebook ________________

*Tablas de Frecuencias
tab _____


*Gráfico de barras (como tablas) para V. Categórica
graph bar (count), over(________)

ssc install catplot
catplot __________

*Gráfico para V. Continua
histogram ______, frequency
histogram ______, frequency normal
graph box ______ 



*Estadística Descriptiva
summarize _____
summarize _____, detail


*Valores Perdidos
misstable summarize _____

misstable patterns
misstable nested


*Correlaciones entre Variables Continuas
correlate

*Correlaciones entre Variables Categóricas
tetrachoric ______ _________, stats(rho se obs p)


*Tablas Cruzadas
tabulate _____ _________
tabulate _____ _________, cell
tabulate _____ _________, col
tabulate _____ _________, row

tabulate _____ _________, row chi2 V 
tabulate _____ _________, row chi2 V cchi2










