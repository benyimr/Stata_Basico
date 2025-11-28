********************************************************************************
********************************************************************************
**************               SESION 4: TALLER STATA               **************
**************                                                    **************
********************************************************************************
********************************************************************************

***PASO 0: CONFIGURACIÓN DEL ESPACIO DE TRABAJO


*Limpieza del Espacio de trabajo
clear all                   /*Usamos clear all para remover de la memoria
							 todas las bases de datos, etiquetas, matrices,
							 valores, restricciones, valores almacenados,
							 funciones y otros de la memoria. A su vez,
							 cierra los archivos abiertos (y ventanas 
							 adicionales) y resetea los timers a cero. 
							 GARANTIZA que se elimine todo de la memoria 
							 de Stata y se comience la sesión "limpia".*/
								   
capture log close           /*Sin embargo, clear all NO cierra los archivos 
						     log. En dicho caso, esto se hace con esta 
							 línea de comandos.*/


*Identificar versión utilizada (evitar problemas surgidos desde versiones).
version 14


**********************************************************************
*Manipular DISTRIBUCIÓN DE VENTANAS DE STATA

*View/Layout/Combined View: visor más comprimido. Facilita ver el 
*Do File Editor

*View/Layout/Swap Results and Command: intercambia posición (sube/baja) 
*ventana de comandos y de resultados

*View/Layout/Swap Review and Variables: intercambia posición (sube/baja)
*ventana de variables y de revisión de comandos (útil en combined view).

*View/Zoom in(out): cambiar tamaño de letra.

*View/Customize Toolbar: elegir elementos presentes en barra de herramientas.
**********************************************************************

*Modificar ancho de línea de resultados
set linesize 90               /*Antes modificamos las ventanas de Stata.
								Con este comando fijamos el largo de las
								líneas de output. Permite una mejor 
								visualización.*/

								

*¿En qué directorio estamos trabajando?
pwd                                     /*Imprime el directorio de trabajo*/


*Generar un Directorio (Carpeta) y por medio de cd definirlo como directorio de trabajo.
cd "/Users/benjaminmunozrojas/pCloud Drive/3_Docencia/6_Analisis_de_Datos_Con_Stata/Sesion_04"




*Iniciar un documento log (con formato .txt)
log using log_sesion_04, append text  /*Creamos un archivo log para 
										almacenar los outputs de Stata.
										Usamos dos argumentos: append 
				para indicar que los outputs se agregan al archivo (Si no 
				existe el log file, lo crea, pero nunca lo sobreescribe). 
				La opción text indica que se almacene en formato .txt*/

											   
********************************************************************************
											   
***PASO 1: UTILIZAR BASE DE DATOS

import excel "IDEA_Turnout.xls", firstrow


*****EXPLORAR BASE DE DATOS: comandos útiles
***
*** list
*** codebook
*** describe
*** lookfor
*** summarize
*** fre      /*Primero debemos instalarlos con ssc install*/

describe
summ

*El problema de la base de datos es que las variables son 
*tratadas como string.

*Solución Nº 1: manipular los datos en Excel.
*Solución Nº 2: transformar las variables en Stata.

********************************************************************************

***PASO 2: TRANSFORMAR VARIABLES

*Crear la variable de Tipo de Elección
generate presidential = .
replace presidential = 1 if Electiontype == "Presidential"
replace presidential = 0 if Electiontype == "Parliamentary"

*Elaborar Etiquetas para Variable y de Valores
label variable presidential "Tipo de Eleccion"

label define preslabel 0 "Parlamentario" 1 "Presidencial"
label values presidential preslabel

*Chequeo del Proceso 
summ presidential
misstable summarize presidential
tab presidential
tab Electiontype presidential


*Variable de Total de Votos Válidos
generate vote1 = Totalvote
replace vote1 = subinstr(Totalvote, ",", "",.) /*El comando reemplaza los 
												 símbolos: la coma (,) por
												 un espacio nulo ().*/
generate vote2 = real(vote1)                   /*La variable sigue siendo
												 un string. La transformo
												 (y mantengo su valor) con
												 el comando real (la 
												 interpreta como número).*/

rename vote2 vote_tot         /*Cambio el nombre de la variable*/
label variable vote_tot  "Total de Votos Validos"


*Variable de Total de Votantes Registrados
generate registered1 = subinstr(Registration, ",", "",.)
destring registered1, gen(regist_tot)      /*Otro modo de pasar de string
											  a numérico, manteniendo los
											  valores*/
label variable regist_tot "Total de Votantes Registrados"


*Variable de Participación Electoral
generate turnout = (vote_tot/regist_tot)*100

label variable turnout "Participacion Electoral"


*OTRO MODO: Más avanzado, pero usando el Menú de Stata.
*Lo usaremos para chequear nuestro trabajo
destring VoterTurnout, generate(turnout_check) ignore(`"%"')
generate turnout_control = turnout - turnout_check

summ turnout_control /*Debería ser 0 (o casi cero) en todos los casos.*/
twoway (scatter turnout turnout_check)

*Inspeccionemos los problemas. Un modo simple
*es filtrar las observaciones que nos interesan revisar.
preserve
keep if abs(turnout_control)>0.1
keep Country Electiontype Year VoterTurnout turnout_check Totalvote Registration vote_tot regist_tot turnout turnout_control
keep if turnout_control!=.
browse
restore



*Variable de Voto Obligatorio
encode Compulsoryvoting, gen(compulsory1)

*¿Funcionó el comando?
tab compulsory1
tab compulsory1, nolabel
fre compulsory1


*Deseo cambiar los valores a 1/0
generate compulsory2 = compulsory1
replace compulsory2 = 1 if compulsory2 == 2
replace compulsory2 = 0 if compulsory2 == 1
tab compulsory2 						/*¿Cuál es el origen del ERROR?*/
drop compulsory2


*Una alternativa es utilizar recode
recode compulsory1 (2=1) (1=0), generate(compulsory3)

*Correcciones menores (nombre y etiquetas)
rename compulsory3 comp_vote
label variable comp_vote "Voto Obligatorio"
label define comp_votelabel 0 "Voluntario" 1 "Obligatorio"
label values comp_vote comp_votelabel

*Chequeo de transformación
tab compulsory1 comp_vote


********************************************************************************


***PASO 3: TRANSFORMAR VARIABLES COMANDOS AVANZADOS CON GEN y EGEN

*** Ayuda: http://wlm.userweb.mwn.de/Stata/


*A) Crear Participacion Electoral con Poblacion en Edad de Votar
destring VAPTurnout, generate(turnout_vap) ignore(`"%"')

*Quiero combinar ambas variables: si está disponible VAP Turnout uso
*dicha información, pero si está perdida, le imputaré Turnout con
*votantes registrados.

*Esto corresponde al uso de instrucciones condicionales: IF ELSE.
generate turnout_full = cond(!missing(turnout_vap),turnout_vap,turnout)


*B) ¿Cómo podemos calcular la variación inter-elecciones de turnout?
sort Country Electiontype Year
gen turnout_dif = turnout[_n] - turnout[_n-1]
*Estamos cometiendo un error aquí.

bysort Country Electiontype: gen turnout_dif2 = turnout[_n] - turnout[_n-1]

preserve
keep Country Electiontype Year turnout turnout_dif2
restore


*C) ¿Cómo podemos recodificar una variable continua en una categórica?
egen float turnout_group = cut(turnout), at(0, 25, 50, 75, 100) icodes label


********************************************************************************


***PASO 4: ANALISIS EXPLORATORIO Y GUARDAR BASE DE DATOS

*Inspección de Tendencias
twoway (scatter turnout_vap turnout)
graph box turnout
graph box turnout, by(comp_vote)
ttest turnout, by(comp_vote) unequal welch
tabulate comp_vote turnout_group, chi2 V

*Guardar Base de Datos
save "IDEA_Turnout_Procesado.dta", replace

*Cerrar Archivo Log
log close

*Cerrar Stata
exit

