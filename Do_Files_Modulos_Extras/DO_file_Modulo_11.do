********************************************************************************
********************************************************************************
**************               SESION 11:TALLER STATA               **************
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
cd "/Users/benjaminmunozrojas/pCloud Drive/3_Docencia/6_Analisis_de_Datos_Con_Stata/Sesion_11"


*Iniciar un documento log (con formato .txt)
log using log_sesion_11, append text  /*Creamos un archivo log para 
										almacenar los outputs de Stata.*/

											   
********************************************************************************
											   
***PASO 1: UTILIZAR BASE DE DATOS Y REVISIÓN DE VARIABLES

*Cargar base de datos
use "V_Dem_v9.dta"

*Variables Clave
tab country_name
tab year

describe v2pepwrgen
describe v2x_polyarchy


*Diagrama de Puntos
twoway (scatter year v2pepwrgen)
twoway (scatter v2pepwrgen year)


*Filtrar casos según país
twoway (scatter v2pepwrgen year) if country_name == "Chile"
twoway (line v2pepwrgen year) if country_name == "Chile"
twoway (connected v2pepwrgen year) if country_name == "Chile"

twoway  (line v2pepwrgen year if country_name == "Chile")  (line v2pepwrgen year if country_name == "Argentina")

tab country_id if country_name == "Chile"
tab country_id if country_name == "Argentina"

twoway  (line v2pepwrgen year if country_id == 72)  (line v2pepwrgen year if country_id == 37)

separate v2pepwrgen, by(country_id)
graph twoway scatter v2pepwrgen37 v2pepwrgen72 year 

**EJERCICIO Nº 1: TENDENCIA TEMPORAL

*ELABORE UN GRÁFICO DE INTERÉS DE EVOLUCIÓN EN EL TIEMPO DE UNA VARIABLE PARA UN PAÍS.
*REELABORE DICHO GRÁFICO PRESENTANDO VARIOS PAÍSES SIMULTÁNEAMENTE.

twoway (line v2pepwrgen year) if e_regionpol_6C==2, by(country_name)



*Agregar información
preserve
collapse corrupcion = v2xnp_regcorr democracy = (v2x_polyarchy), by(country_name)

twoway (scatter democracy corrupcion) (lfitci democracy corrupcion)

**EJERCICIO Nº 2: AGREGAR DATOS




*Diagrama de Puntos
twoway (scatter v2x_polyarchy v2pepwrgen)

*Filtrar casos según años
twoway (scatter v2x_polyarchy v2pepwrgen) if year == 2017


*Gráfico Más Elaborado
twoway (scatter v2x_polyarchy v2pepwrgen) if year == 2017, /*
*/ ytitle(Índice de Democracia Electoral) /*
*/ xtitle(Índice de Empoderamiento de Género) /*
*/ title("Gráfico 1: Relación entre Empoderamiento de Género y Democracia") /*
*/ subtitle("Datos a nivel País, 2017") caption("Fuente: V-DEM (2018)") /*
*/ scheme(plotplain)

*Gráfico con Tendencia
twoway (scatter v2x_polyarchy v2pepwrgen) (lfit v2x_polyarchy v2pepwrgen) /*
*/ if year == 2017, /*
*/ ytitle(Índice de Democracia Electoral) /*
*/ xtitle(Índice de Empoderamiento de Género) /*
*/ title("Gráfico 1: Relación entre Empoderamiento de Género y Democracia") /*
*/ subtitle("Datos a nivel País, 2017") caption("Fuente: V-DEM (2018)") /*
*/ scheme(plotplain)

**Gráfico con Tendencia e Intervalo de Confianza
twoway (scatter v2x_polyarchy v2pepwrgen) (lfitci v2x_polyarchy v2pepwrgen) /*
*/ if year == 2017, /*
*/ ytitle(Índice de Democracia Electoral) /*
*/ xtitle(Índice de Empoderamiento de Género) /*
*/ title("Gráfico 1: Relación entre Empoderamiento de Género y Democracia") /*
*/ subtitle("Datos a nivel País, 2017") caption("Fuente: V-DEM (2018)") /*
*/ scheme(plotplain)

*Variable de Control
tab v2lgqugen

gen quota = .
replace quota =1 if v2lgqugen == 1|v2lgqugen==1|v2lgqugen==3|v2lgqugen==4
replace quota =0 if v2lgqugen == 0

*Gráfico
twoway (scatter v2x_polyarchy v2pepwrgen if quota ==0) (scatter v2x_polyarchy v2pepwrgen if quota ==1) if year == 2017, ytitle(Índice de Democracia Electoral) xtitle(Índice de Empoderamiento de Género) by(, title("Gráfico 1: Relación entre Empoderamiento de Género y Democracia") subtitle("Datos a nivel País, 2017") caption("Fuente: V-DEM (2018)")) scheme(plotplain) 


*Variable de Control
tab e_regionpol_6C if year == 2017

gen clasif = .
replace clasif = 1 if e_regionpol_6C == 2 | e_regionpol_6C==5
replace clasif = 0 if e_regionpol_6C == 1 | e_regionpol_6C==3 | e_regionpol_6C==4 | e_regionpol_6C==6

*Gráfico
twoway (scatter v2x_polyarchy v2pepwrgen) (lfitci v2x_polyarchy v2pepwrgen) /*
*/ if year == 2017, ytitle(Índice de Democracia Electoral) /*
*/ xtitle(Índice de Empoderamiento de Género) /*
*/ by(, title("Gráfico 1: Relación entre Empoderamiento de Género y Democracia")/*
*/ subtitle("Datos a nivel País, 2017") caption("Fuente: V-DEM (2018)")) /*
*/ scheme(plotplain) by(clasif)

**EJERCICIO Nº 3: GRÁFICO ASOCIATIVO

*ELABORE UN GRÁFICO QUE PRESENTE LA RELACIÓN ENTRE DOS VARIABLES





