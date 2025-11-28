********************************************************************************
********************************************************************************
**************               SESION 6: TALLER STATA               **************
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
set linesize 90               /*Con este comando fijamos el largo de las
								líneas de output.*/

								
*¿En qué directorio estamos trabajando?
pwd                                     /*Imprime el directorio de trabajo*/


*Generar un Directorio (Carpeta) y por medio de cd definirlo como directorio de trabajo.
cd "/Users/benjaminmunozrojas/pCloud Drive/3_Docencia/6_Analisis_de_Datos_Con_Stata/Sesion_06"




*Iniciar un documento log (con formato .txt)
log using log_sesion_06, append text  /*Creamos un archivo log para 
										almacenar los outputs de Stata.*/

											   
********************************************************************************
											   
***PASO 1: UTILIZAR BASE DE DATOS

use "Chile_ISSP_2016.dta"


*¿Cómo podemos explorar la base de datos?: describe  y/o codebook.


*Cada uno explorará una variable distinta en el trabajo práctico:


/*Benjamín*/
fre v27  

/*Olga*/
fre v6   
/*Paulina*/
fre v31  
/*María Cristina*/
fre v41  

********************************************************************************

***PASO 2: 	MANIPULACIÓN DE VARIABLES Y EXPLORACIÓN

*Recodificaremos una variable, eliminando los valores perdidos.
*Adicionalmente cambiaremos su nombre a uno más lógico.
*¿Cómo podemos hacerlo?

********************************************************************
*****       Recodificar rápidamente los valores perdidos       *****
*****                                                          *****
*****  mvdecode nombre_variable, mv(codigos_valores_perdidos)  *****
*****                                                          *****
********************************************************************

mvdecode v27, mv(8 9)


*************************************************
*****    Invertir la escala de  variable    *****
*****                                       ***** 
*****  ssc install revrs                    ***** 
*****  rename nombre_original nombre_nuevo  *****
*****                                       ***** 
*************************************************

findit revrs
ssc describe revrs
ssc install revrs

revrs v27

fre v27
fre revv27
tab v27 revv27, nolabel


*************************************************
*****   Cambiar el nombre de una variable   *****
*****                                       ***** 
*****  rename nombre_original nombre_nuevo  *****
*****                                       ***** 
*************************************************

rename revv27 desigualdad

label variable desigualdad "Gobierno debe reducir desigualdad"
label define deslabel 1 "Definitivamente no" 2 "Probablemente no" 3 "Probablemente si" 4 "Definitivamente si"
label values desigualdad deslabel


*Gráfico de barras
graph bar (count), over(desigualdad)
graph bar (count) [aweight = WEIGHT] , over(desigualdad)

tab desigualdad


ssc install catplot
catplot desigualdad

********************************************************************************

***PASO 2: MANIPULACIÓN DE BASE DE DATOS

*¿Varían las respuestas según sexo y educacion?
*Primero, corregimos educación

recode DEGREE (0/1=1) (2/3=2) (4/6=3) (9=.), gen(educ)
tab DEGREE educ

label variable educ "Nivel educativo"
label define educlabel 1 "Menos que secundaria" 2 "Secundaria" 3 "Mas que secundaria"
label values educ educlabel

rename SEX sexo

label variable sexo "Sexo"
label define sexlabel 1 "Hombre" 2 "Mujer"
label values sexo sexlabel

*Por medio de una tabla cruzada
tab sexo desigualdad
tab educ desigualdad 
tab sexo educ desigualdad
table sexo educ desigualdad, contents(freq)

*Es díficil trabajar con tablas de 3 variables. Una alternativa es restringir
*la muestra (extraer un subconjunto).

*Preserve y restore son comandos que permiten generar "copias temporales"
*de los datos de Stata. NO deben ejecutarse desde el DO File, si no directamente
*en la ventana de comandos.

*************************************************
*****          Preservar/Recuperar          *****
*****                                       ***** 
*****  preserve                             *****
*****  comandos que modifiquen dataset      ***** 
*****  restore                              *****  
*****                                       ***** 
*************************************************


*Otra cláusula importante es keep/drop, los cuales se usan para indicar
*cuáles observaciones y/o variables se preservan o eliminan

*************************************************
*****          Mantener/Descartar           *****
*****                                       *****
*****  Con Variables                        *****
*****                                       *****
*****  drop var1 var2 var3                  *****
*****  drop var1:var3                       *****
*****                                       *****
*****  Con Casos                            *****
*****                                       *****
***** drop if var1 == N                     *****
*****                                       ***** 
*************************************************
*****      Reglas Lógicas                   *****
*****                                       *****
*****   a  < b      a menor que b           *****
*****   a <= b      a menor o igual que b   *****
*****   a == b      a igual que b           *****
*****   a != b      a distino que b         *****
*****   a  > b      a mayor que b           *****
*****   a >= b      a mayor o igual que b   *****
*****                                       *****
*****  a  &  b       a Y b                  *****
*****  a  |  b       a O b                  *****
*****                                       *****
*****  Ante la duda, siempre usar           *****
*****  paréntesis ()                        *****
*************************************************


*Mantener y eliminar variables
preserve
keep country sexo educ desigualdad
drop country
restore 

*Mantener/Eliminar listado de variables
preserve
drop AU_DEGR-ZA_DEGR
keep v1-v63
restore

*Mantener/Eliminar casos
preserve
keep if sexo ==1
tab educ desigualdad
restore
preserve
keep if sexo ==2
tab educ desigualdad
restore

*Filtrar según valores perdidos
mvdecode CL_INC, mv(9999998 9999999)

preserve
drop if CL_INC ==.
keep if CL_INC>= 750000
tab desigualdad
restore
preserve
drop if CL_INC ==.
keep if CL_INC< 750000
tab desigualdad

********************************************************************************

***PASO 3: COMBINACIÓN DE BASE DE DATOS

*Hay dos tipos de bases de datos: la "master" (activa, la que estamos usando)
*y la "using" (la que queremos agregar).

***************************************************************************
*****         Agregar casos  (filas)                                  *****
*****                                                                 ***** 
*****  append using dataset_a_sumar                                   ***** 
*****                                                                 ***** 
***************************************************************************
*****     Agregar atributos  (columnas)                               *****
*****                                                                 ***** 
*****  merge tipo keyvars using dataset                               ***** 
*****                                                                 ***** 
*****  Tipos                                                          ***** 
*****                                                                 ***** 
*****  1:1   A cada caso se le suma información de un único caso      ***** 
*****  m:1   A muchos casos se le suman información de un único caso  ***** 
*****  1:m   A cada caso se le suma información de muchos casos       ***** 
*****  m:m   A muchos casos se le suman información de muchos casos   ***** 
*****                                                                 ***** 
*****  keyvar es la variable llave: permite combinar bases de datos.  ***** 
*****         tiene el mismo nombre en ambas bases de datos y sus     ***** 
*****         valores permiten combinar la información.               ***** 
***************************************************************************

**AYUDA: https://www.ssc.wisc.edu/sscc/pubs/sfr-combine.htm
**AYUDA: http://wlm.userweb.mwn.de/Stata/wstataddm.htm

*Base de Datos Definitiva
keep country c_sample c_alphan desigualdad sexo educ
save "Chile_Temporal.dta"

*SI SE DESEAN AGREGAR CASOS SE UTILIZA append

append using "Mundo_ISSP_2016_Version_A.dta"
describe
browse
*Hay un problema con las variables. 


clear
use "Chile_Temporal.dta"
append using "Mundo_ISSP_2016_Version_B.dta"
tab country

clear
use "Chile_Temporal.dta"
append using "Mundo_ISSP_2016_Version_C.dta"

*Recodificar desigualdad como variable binaria
recode desigualdad (1/3=0) (4=1), gen(desig_prop)
tab desigualdad desig_prop

*Cambiar la unidad de análisis de la base de datos
collapse (mean) desig_prop, by(country)
browse

*Agregar atributos (variables) con una regla 1 a 1
sort country
merge 1:1 country using "Indicadores_Globales.dta"

tab _merge


*Probemos otro caso de combinación.
clear
use "Chile_Temporal.dta"
append using "Mundo_ISSP_2016_Version_C.dta"

*Agregar atributos (variables) con una regla 1 a 1
sort country
merge m:1 country using "Indicadores_Globales.dta"

tab _merge



