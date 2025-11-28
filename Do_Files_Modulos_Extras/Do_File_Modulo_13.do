********************************************************************************
********************************************************************************
**************               SESION 13:TALLER STATA               **************
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
cd "/Users/benjaminmunozrojas/pCloud Drive/3_Docencia/6_Analisis_de_Datos_Con_Stata/Sesion_13"

*Iniciar un documento log (con formato .txt)
log using log_sesion_13, append text  /*Creamos un archivo log para 
										almacenar los outputs de Stata.*/

											   
********************************************************************************
										   
***PASO 1: UTILIZAR BASE DE DATOS Y REVISIÓN DE VARIABLES

*Cargar base de datos
use "ISSP_Citizenship.dta"


********************************************************************************
										   
***PASO 2: GRÁFICOS LIKERT

*Batería de Participación
describe V17-V24
fre V17-V24

*Recodificación de Preguntas
recode   V17 (1/2=1) (3/4=0) (8/9=.), gen(V17_rec)
*Los valores del 1 al 2 les asigno un 1, los valores originales del 3 al 4 un 0
* y a los 8 y 9 son missing
tab V17 V17_rec
recode   V18 (1/2=1) (3/4=0) (8/9=.), gen(V18_rec)
tab V18 V18_rec
recode   V19 (1/2=1) (3/4=0) (8/9=.), gen(V19_rec)
tab V19 V19_rec
recode   V20 (1/2=1) (3/4=0) (8/9=.), gen(V20_rec)
tab V20 V20_rec
recode   V21 (1/2=1) (3/4=0) (8/9=.), gen(V21_rec)
tab V21 V21_rec
recode   V22 (1/2=1) (3/4=0) (8/9=.), gen(V22_rec)
tab V22 V22_rec
recode   V23 (1/2=1) (3/4=0) (8/9=.), gen(V23_rec)
tab V23 V23_rec
recode   V24 (1/2=1) (3/4=0) (8/9=.), gen(V24_rec)
tab V24 V24_rec

label variable V17_rec "Acciones Políticas: Firmar una Petición"
label variable V18_rec "Acciones Políticas: Boicotear ciertos Productos"
label variable V19_rec "Acciones Políticas: Participar en Protestas"
label variable V20_rec "Acciones Políticas: Asistir a Evento Político"
label variable V21_rec "Acciones Políticas: Contactar a un Político"
label variable V22_rec "Acciones Políticas: Donar Dinero o Recolectar Fondos"
label variable V23_rec "Acciones Políticas: Contactar a los Medios"
label variable V24_rec "Acciones Políticas: Expresar Opiniones en Internet"
label define v17label 0 "No lo ha hecho" 1 "Lo ha hecho"
label values V17_rec v17label
label values V18_rec v17label
label values V19_rec v17label
label values V20_rec v17label
label values V21_rec v17label
label values V22_rec v17label
label values V23_rec v17label
label values V24_rec v17label

*Recodificación de Variable Sexo
fre SEX
recode SEX (9=.), gen(sex_rec)
label variable sex_rec "Sexo del Entrevistado"
label define sexlab 1 "Hombre" 2 "Mujer"
label values sex_rec sexlab

*Análisis Descriptivo
fre V17_rec-V24_rec
histogram V17_rec, discrete percent
*Hay mucho por hacer para mejorar este histograma!!
*Optaremos por un gráfico de barras horizontal, para
*esto usaremos slideplot



*Instalación de SLIDEPLOT
ssc install slideplot

slideplot hbar V17_rec, negative(0) positive(1) percent
slideplot hbar V18_rec, negative(0) positive(1) percent


slideplot hbar V17_rec [aw = WEIGHT], negative(0) positive(1) ytitle("") ylabel(-100 (25) 100) blabel(total, position(outside) format(%4.2f)) bar(1, bcolor(blue*0.4)) bar(2, bcolor(red*0.4)) legend(off) title("Ha firmado una petición", size(msmall)) percent scheme(s1color) fysize(19)
graph save item_01.gph, replace
slideplot hbar V18_rec [aw = WEIGHT], negative(0) positive(1) ytitle("") ylabel(-100 (25) 100) blabel(total, position(outside) format(%4.2f)) bar(1, bcolor(blue*0.4)) bar(2, bcolor(red*0.4)) legend(off) title("Ha boicoteado productos", size(msmall)) percent scheme(s1color) fysize(19)
graph save item_02.gph, replace
slideplot hbar V19_rec [aw = WEIGHT], negative(0) positive(1) ytitle("") ylabel(-100 (25) 100) blabel(total, position(outside) format(%4.2f)) bar(1, bcolor(blue*0.4)) bar(2, bcolor(red*0.4)) legend(off) title("Ha participado en protestas", size(msmall)) percent scheme(s1color) fysize(19)
graph save item_03.gph, replace
slideplot hbar V20_rec [aw = WEIGHT], negative(0) positive(1) ytitle("") ylabel(-100 (25) 100) blabel(total, position(outside) format(%4.2f)) bar(1, bcolor(blue*0.4)) bar(2, bcolor(red*0.4)) legend(row(1) size(vsmall) lab(1 "No lo ha Hecho") lab(2 "Lo ha hecho")) title("Ha asistido a actos políticos", size(msmall)) percent scheme(s1color) fysize(26)
graph save item_04.gph, replace
slideplot hbar V21_rec [aw = WEIGHT], negative(0) positive(1) ytitle("") ylabel(-100 (25) 100) blabel(total, position(outside) format(%4.2f)) bar(1, bcolor(blue*0.4)) bar(2, bcolor(red*0.4)) legend(off) title("Ha contactado a un político", size(msmall)) percent scheme(s1color) fysize(19)
graph save item_05.gph, replace
slideplot hbar V22_rec [aw = WEIGHT], negative(0) positive(1) ytitle("") ylabel(-100 (25) 100) blabel(total, position(outside) format(%4.2f)) bar(1, bcolor(blue*0.4)) bar(2, bcolor(red*0.4)) legend(off) title("Ha donado dinero o recaudado fondos", size(msmall)) percent scheme(s1color) fysize(19)
graph save item_06.gph, replace
slideplot hbar V23_rec [aw = WEIGHT], negative(0) positive(1) ytitle("") ylabel(-100 (25) 100) blabel(total, position(outside) format(%4.2f)) bar(1, bcolor(blue*0.4)) bar(2, bcolor(red*0.4)) legend(off) title("Ha contactado a los medios", size(msmall)) percent scheme(s1color) fysize(19)
graph save item_07.gph, replace
slideplot hbar V24_rec [aw = WEIGHT], negative(0) positive(1) ytitle("") ylabel(-100 (25) 100) blabel(total, position(outside) format(%4.2f)) bar(1, bcolor(blue*0.4)) bar(2, bcolor(red*0.4)) legend(row(1) size(vsmall) lab(1 "No lo ha Hecho") lab(2 "Lo ha hecho")) title("Ha dado su opinión por Internet", size(msmall)) percent scheme(s1color) fysize(26)
graph save item_08.gph, replace

graph combine item_01.gph item_02.gph item_03.gph item_04.gph, row(4) imargin(0 0 0 0) title("Figura Nº 1.A: Realización de Acciones Políticas")
graph combine item_05.gph item_06.gph item_07.gph item_08.gph, row(4) imargin(0 0 0 0) title("Figura Nº 1.A: Realización de Acciones Políticas")


slideplot hbar V17_rec [aw = WEIGHT], by(sex_rec) negative(0) positive(1) ytitle("") ylabel(-100 (25) 100) blabel(total, position(outside) format(%4.2f)) bar(1, bcolor(blue*0.4)) bar(2, bcolor(red*0.4)) legend(off) title("Ha firmado una petición", size(msmall)) percent scheme(s1color) fysize(19)
graph save item_01.gph, replace
slideplot hbar V18_rec [aw = WEIGHT], by(sex_rec) negative(0) positive(1) ytitle("") ylabel(-100 (25) 100) blabel(total, position(outside) format(%4.2f)) bar(1, bcolor(blue*0.4)) bar(2, bcolor(red*0.4)) legend(off) title("Ha boicoteado productos", size(msmall)) percent scheme(s1color) fysize(19)
graph save item_02.gph, replace
slideplot hbar V19_rec [aw = WEIGHT], by(sex_rec) negative(0) positive(1) ytitle("") ylabel(-100 (25) 100) blabel(total, position(outside) format(%4.2f)) bar(1, bcolor(blue*0.4)) bar(2, bcolor(red*0.4)) legend(off) title("Ha participado en protestas", size(msmall)) percent scheme(s1color) fysize(19)
graph save item_03.gph, replace
slideplot hbar V20_rec [aw = WEIGHT], by(sex_rec) negative(0) positive(1) ytitle("") ylabel(-100 (25) 100) blabel(total, position(outside) format(%4.2f)) bar(1, bcolor(blue*0.4)) bar(2, bcolor(red*0.4)) legend(row(1) size(vsmall) lab(1 "No lo ha Hecho") lab(2 "Lo ha hecho")) title("Ha asistido a actos políticos", size(msmall)) percent scheme(s1color) fysize(26)
graph save item_04.gph, replace
graph combine item_01.gph item_02.gph item_03.gph item_04.gph, row(4) imargin(0 0 0 0) title("Figura Nº 1.A: Realización de Acciones Políticas según Sexo")


********************************************************************************
										   
***PASO 3: COMBINAR INFORMACIÓN EN ÍNDICES

*Batería de Buen Ciudadano
describe V5-V13
fre V5-V13

*Recodificación de Preguntas
recode   V5 (8/9=.), gen(V5_rec)
recode   V6 (8/9=.), gen(V6_rec)
recode   V7 (8/9=.), gen(V7_rec)
recode   V8 (8/9=.), gen(V8_rec)
recode   V9 (8/9=.), gen(V9_rec)
recode   V10 (8/9=.), gen(V10_rec)
recode   V11 (8/9=.), gen(V11_rec)
recode   V12 (8/9=.), gen(V12_rec)
recode   V13 (8/9=.), gen(V13_rec)

label variable V5_rec "Buen Ciudadano: Siempre vota en elecciones"
label variable V6_rec "Buen Ciudadano: Nunca trata de evadir impuestos"
label variable V7_rec "Buen Ciudadano: Siempre obedece las leyes"
label variable V8_rec "Buen Ciudadano: Vigila las acciones del Gobierno"
label variable V9_rec "Buen Ciudadano: Es activo en asociaciones políticas y sociales"
label variable V10_rec "Buen Ciudadano: Entiende opiniones de otros"
label variable V11_rec "Buen Ciudadano: Elige productos por razones políticas o ambientales"
label variable V12_rec "Buen Ciudadano: Ayuda a personas menos privilegiadas de su país"
label variable V13_rec "Buen Ciudadano: Ayuda a personas menos privilegiadas del resto del mundo"

label define v5lab 1 "Nada importante" 7 "Muy importante"
label values V5_rec v5label
label values V6_rec v6label
label values V7_rec v7label
label values V8_rec v8label
label values V9_rec v9label
label values V10_rec v10label
label values V11_rec v11label
label values V12_rec v12label
label values V13_rec v13label

*ACTIVIDAD PRÁCTICA Nº 1:  
*a) Realizar histograma de una variable de la batería de buen ciudadano. Incluir todos los elementos necesarios.
*b) Probar el comando catplot para generar gráfico
*c) Combinar gráficos de Histogramas

histogram V12_rec, discrete percent fcolor(blue) lcolor(black) ytitle("Porcentaje") ylabel(0 (10) 50) xtitle("Grado de Importancia") title("Un Buen Ciudadano ayuda a menos Privilegiados del País", size(small)) scheme(s1color)
graph save plot_01.gph, replace
histogram V13_rec, discrete percent fcolor(blue) lcolor(black) ytitle("Porcentaje") ylabel(0 (10) 50) xtitle("Grado de Importancia") title("Un Buen Ciudadano ayuda a menos Privilegiados del Mundo", size(small)) scheme(s1color)
graph save plot_02.gph, replace
graph combine plot_01.gph plot_02.gph, col(2) imargin(0 0 0 0) title("Figura Nº 1: Roles de Ciudadanía y Ayuda") caption("Fuente: ISSP 2016", size(small))


*Índice de Participación
gen participa = V17_rec + V18_rec + V19_rec + V20_rec + V21_rec + V22_rec + V23_rec + V24_rec
summ participa

*Índice de Buen Ciudadano
gen ciudadano_01 = (V5_rec + V6_rec + V7_rec + V8_rec + V9_rec + V10_rec + V11_rec + V12_rec + V13_rec)/9


*ACTIVIDAD PRÁCTICA Nº 2:  
*a) Crear histograma y boxplot de ambas variables.
*b) Crear gráficos que caractericen según sexo y tramos de edad.
*c) Crear gráfico agregado a nivel de país de esta relación


