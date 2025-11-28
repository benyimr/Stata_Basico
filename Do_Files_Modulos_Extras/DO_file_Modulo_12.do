********************************************************************************
********************************************************************************
**************               SESION 12:TALLER STATA               **************
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
cd "/Users/benjaminmunozrojas/pCloud Drive/3_Docencia/6_Analisis_de_Datos_Con_Stata/Sesion_12"


*Iniciar un documento log (con formato .txt)
log using log_sesion_12, append text  /*Creamos un archivo log para 
										almacenar los outputs de Stata.*/

											   
********************************************************************************
										   
***PASO 1: UTILIZAR BASE DE DATOS Y REVISIÓN DE VARIABLES

*Cargar base de datos
use "World_Values_Survey_W6.dta"

*Valores Emancipatorios
describe RESEMAVAL
summ RESEMAVAL

*Crear Nueva Variable
gen val_emanc = RESEMAVAL*100

********************************************************************************
										   
***PASO 2: GRÁFICOS

*Boxplot Univariado
graph box val_emanc

*Boxplot Bivariado
graph box val_emanc, by(V240)

*Corregir variable
fre V240
gen mujer = .
replace mujer =1 if V240 == 2
replace mujer =0 if V240 == 1
label define mujerlab 0 "Hombre" 1 "Mujer"
label values mujer mujerlab

fre V242
recode V242 (-5 -3 -2 -1 = .), gen(edad)

*Gráficos por subgrupos
graph box val_emanc, by(mujer)
graph box val_emanc, over(mujer)

graph box val_emanc if edad >15 & edad < 30, over(mujer)
graph box val_emanc if edad > 59, over(mujer)

graph box val_emanc [aweight = WEIGHTB], over(mujer) by(V2A)
findit burd5
graph box val_emanc [aweight = WEIGHTB], over(mujer) scheme(burd5)
