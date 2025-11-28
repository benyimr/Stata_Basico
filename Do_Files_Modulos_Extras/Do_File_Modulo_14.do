********************************************************************************
********************************************************************************
**************               SESION 14:TALLER STATA               **************
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
cd "/Users/benjaminmunozrojas/pCloud Drive/3_Docencia/6_Analisis_de_Datos_Con_Stata/Sesion_14"

*Iniciar un documento log (con formato .txt)
log using log_sesion_14, append text  /*Creamos un archivo log para 
										almacenar los outputs de Stata.*/

											   
********************************************************************************
										   
***PASO 1: UTILIZAR BASE DE DATOS Y REVISIÓN DE VARIABLES

*Cargar base de datos
use "ELSOC_Wide_2016_2018_v1.00_Stata14.dta"

*Análisis Descriptivo Univariado
describe m13_w01
describe m13_w02
describe m13_w03

summ m13_w01, detail
summ m13_w02, detail
summ m13_w03, detail


********************************************************************************
										   
***PASO 2: ANÁLISIS DE CORRELACIONES DE PEARSON

*Tabla de Correlaciones
correlate m13_w01 m13_w02 m13_w03

*Recodificación de Variables: Valores Perdidos
recode   m13_w01 (-888=.) (-999=.), gen(m13_w01_rec)
recode   m13_w02 (-888=.) (-999=.), gen(m13_w02_rec)
recode   m13_w03 (-888=.) (-999=.), gen(m13_w03_rec)

*Diferencia entre Listwise y Pairwise Deletion
correlate m13_w01_rec m13_w02_rec m13_w03_rec
pwcorr  m13_w01_rec m13_w02_rec m13_w03_rec

*ACTIVIDAD PRACTICA N º 1: Elabore gráficos descriptivos para analizar
*                          la correlación entre variables.   
* Diagnostique los problemas y proponga una solución.

gen m13_w01_rec1 = m13_w01_rec
replace m13_w01_rec1 = . if m13_w01_rec> 5000000

gen m13_w03_rec1 = m13_w03_rec
replace m13_w03_rec1 = . if m13_w03_rec> 5000000

twoway (scatter m13_w02_rec m13_w01_rec1)
twoway (scatter m13_w03_rec1 m13_w01_rec1)

pwcorr m13_w01 m13_w02 m13_w03 m13_w01_rec m13_w02_rec m13_w03_rec m13_w01_rec1


*ACTIVIDAD PRACTICA Nº 2: Calcule una matriz de correlaciones de Pearson
*                          a un subconjunto de variables de interés.


********************************************************************************
										   
***PASO 3: ANÁLISIS DE CORRELACIONES PARA VARIABLES CATEGÓRICAS

*Tres opciones Kendall Tau, Spearman Rho y Correlaciones Policóricas.

describe c05_01_w01 c05_02_w01 c05_03_w01 c05_04_w01 c05_05_w01 c05_06_w01 c05_07_w01
summ c05_01_w01 c05_02_w01 c05_03_w01 c05_04_w01 c05_05_w01 c05_06_w01 c05_07_w01, detail

*ktau c05_01_w01 c05_02_w01 c05_03_w01 c05_04_w01 c05_05_w01 c05_06_w01 c05_07_w01 
*spearman c05_01_w01 c05_02_w01 c05_03_w01 c05_04_w01 c05_05_w01 c05_06_w01 c05_07_w01 
ssc install polychoric
polychoric c05_01_w01 c05_02_w01 c05_03_w01 c05_04_w01 c05_05_w01 c05_06_w01 c05_07_w01 

*ACTIVIDAD PRÁCTICA Nº 3: Recodifique las variables y calcule el coeficiente de
*                         de correlación para todas las variables de confianza institucional.

recode   c05_01_w01 (-888=.) (-999=.) , gen(c05_01_w01_rec)
recode   c05_02_w01 (-888=.) (-999=.) , gen(c05_02_w01_rec)
recode   c05_03_w01 (-888=.) (-999=.) , gen(c05_03_w01_rec)
recode   c05_04_w01 (-888=.) (-999=.) , gen(c05_04_w01_rec)
recode   c05_05_w01 (-888=.) (-999=.) , gen(c05_05_w01_rec)
recode   c05_06_w01 (-888=.) (-999=.) , gen(c05_06_w01_rec)
recode   c05_07_w01 (-888=.) (-999=.) , gen(c05_07_w01_rec)
recode   c05_08_w01 (-888=.) (-999=.) , gen(c05_08_w01_rec)
polychoric c05_01_w01_rec c05_02_w01_rec c05_03_w01_rec c05_04_w01_rec c05_05_w01_rec c05_06_w01_rec c05_07_w01_rec c05_08_w01_rec 


*Variables Dicotómicas
describe c07_01_w01 c07_02_w01 c07_03_w01 c07_04_w01 c07_05_w01 c07_06_w01 c07_07_w01 c07_08_w01

recode   c07_01_w01 (-888=.) (-999=.) (1=0) (2/3=1), gen(c07_01_w01_rec)
recode   c07_02_w01 (-888=.) (-999=.) (1=0) (2/3=1), gen(c07_02_w01_rec)
recode   c07_03_w01 (-888=.) (-999=.) (1=0) (2/3=1), gen(c07_03_w01_rec)
recode   c07_04_w01 (-888=.) (-999=.) (1=0) (2/3=1), gen(c07_04_w01_rec)
recode   c07_05_w01 (-888=.) (-999=.) (1=0) (2/3=1), gen(c07_05_w01_rec)
recode   c07_06_w01 (-888=.) (-999=.) (1=0) (2/3=1), gen(c07_06_w01_rec)
recode   c07_07_w01 (-888=.) (-999=.) (1=0) (2/3=1), gen(c07_07_w01_rec)
recode   c07_08_w01 (-888=.) (-999=.) (1=0) (2/3=1), gen(c07_08_w01_rec)

tetrachoric c07_01_w01_rec c07_02_w01_rec c07_03_w01_rec c07_04_w01_rec c07_05_w01_rec c07_06_w01_rec c07_07_w01_rec c07_08_w01_rec

********************************************************************************
										   
***PASO 4: CONSTRUCCIÓN DE ÍNDICES

*Índice de Confianza Institucional
gen indice_01 = c05_01_w01_rec + c05_02_w01_rec + c05_03_w01_rec + c05_04_w01_rec + c05_05_w01_rec + c05_06_w01_rec + c05_07_w01_rec + c05_08_w01_rec
summ indice_01

alpha c05_01_w01_rec c05_02_w01_rec c05_03_w01_rec c05_04_w01_rec c05_05_w01_rec c05_06_w01_rec c05_07_w01_rec c05_08_w01_rec, item generate(trust)

*ACTIVIDAD PRÁCTICA Nº 4: Construya índices de comportamiento pro-social.


          
