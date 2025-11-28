********************************************************************************
********************************************************************************
**************               SESION 16:TALLER STATA               **************
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
cd 

*Iniciar un documento log (con formato .txt)
log using log_sesion_15, append text  /*Creamos un archivo log para 
										almacenar los outputs de Stata.*/

											   
********************************************************************************
										   
***PASO 1: UTILIZAR BASE DE DATOS Y REVISIÓN DE VARIABLES

*Construiremos un índice agregado de la aprobación presidencial, usando datos de 
*la encuesta CEP. 

*Cargar base de datos
use "Encuesta_CEP_2019.dta"

*Análisis Descriptivo Univariado: Evaluación Presidencial
describe MB_P7-MB_12_8
summ MB_P7-MB_12_8, detail
fre MB_P7-MB_12_8

********************************************************************************
										   
***PASO 2: RECODIFICACIÓN DE VARIABLES ESCALA DE APROBACIÓN PRESIDENCIAL

*Recodificación de Respuestas No Sabe y No Responde: los eliminamos como 
* respuesta para analizar los datos.
recode   MB_P7   (8=.) (9=.) , gen(MB_P7_rec)
recode   MB_P8   (8=.) (9=.) , gen(MB_P8_rec)
recode   MB_P9   (8=.) (9=.) , gen(MB_P9_rec)
recode   MB_P10  (8=.) (9=.) , gen(MB_P10_rec)
recode   MB_P11  (8=.) (9=.) , gen(MB_P11_rec)
recode   MB_12_1 (8=.) (9=.) , gen(MB_12_1_rec)
recode   MB_12_2 (8=.) (9=.) , gen(MB_12_2_rec)
recode   MB_12_3 (8=.) (9=.) , gen(MB_12_3_rec)
recode   MB_12_4 (8=.) (9=.) , gen(MB_12_4_rec)
recode   MB_12_5 (8=.) (9=.) , gen(MB_12_5_rec)
recode   MB_12_6 (8=.) (9=.) , gen(MB_12_6_rec)
recode   MB_12_7 (8=.) (9=.) , gen(MB_12_7_rec)
recode   MB_12_8 (8=.) (9=.) , gen(MB_12_8_rec)

*Exploramos la correlación entre las variables
correlate MB_P7_rec MB_P8_rec MB_P9_rec MB_P10_rec MB_P11_rec MB_12_1_rec MB_12_2_rec MB_12_3_rec MB_12_4_rec MB_12_5_rec MB_12_6_rec MB_12_7_rec MB_12_8_rec
polychoric MB_P7_rec MB_P8_rec MB_P9_rec MB_P10_rec MB_P11_rec MB_12_1_rec MB_12_2_rec MB_12_3_rec MB_12_4_rec MB_12_5_rec MB_12_6_rec MB_12_7_rec MB_12_8_rec
*Si no funciona, instalar: ssc install polychoric


********************************************************************************
*****************************CONSTRUCCIÓN DE ÍNDICES****************************
********************************************************************************

*Al momento del diseño de cuestionarios nos encontramos con el desafio de medir 
*aspectos de la realidad que son observales y otros aspectos que no son observables.

*Cuando nos encontramos con hechos que son directamente observables en la realidad 
*podemos preguntales directamente a los sujetos del estudio (por ejemplo su edad).

*No obstante, en ciencias sociales nos encontramos recurrentemente con aspectos de 
*la sociedad que no son directamente medibles a partir de una pregunta, como por
*ejemplo el grado de justificación de la violencia o la desafección política.
*Fenómenos complejos -en general- requieren de una medición que requiere más de una 
*pregunta, con el objetivo de dar cuenta de mejor manera, con el objetivo de minimizar 
*el error de medición

*Existen múltiples modos para construir índices. Todos siguen una secuencia de pasos 
*común:

*1. Identificación teórico-conceptual.
*2. Selección de datos y transformación de variables.
*3. Imputación de valores perdidos (en caso de ser necesario).
*4. Análisis de medición.
*5. Estrategia de combinación, ponderación y normalización.
*6. Análisis de sensibilidad y exploración de resultados. 

*Un índice SIEMPRE es la operacionalización de un concepto teórico relevante. La definición
*de los insumos puede ser exclusivamente teórica o se puede apoyar en análisis empírico.

*A) Definir estructura del concepto a medir. Se compone de una o varias dimensiones
* diferenciadas. 
*B) ¿Que variables incluir? (primera selección, muchas variables).
*C) Chequear descriptivamente todas las variables. Se requiere: bajo (o nulo) porcentaje
* de valores perdidos; que todas midan el atributo en el mismo sentido (- a +); niveles
* de varianza aceptables (escalas de medición similares).
* Ítems invertidos: Es una práctica general dentro de la construcción de escalas agregar 
* items de manera inversa para reducir el sesgo de respuesta de los encuestados, de 
* manera que los encuestados tengan que de verdad leer todos los ítems y no contestar 
* en “modo automático”.
* En caso de ser necesario, realizar transformaciones de variables. 


********************************************************************************
										   
***PASO 3: CREACIÓN DE ÍNDICE DE EVALUACIÓN PRESIDENCIAL


*A) Identificación teórico-conceptual: evaluación presidencial

*B) Selección de datos y transformación de variables: las preguntas MB_P7 a MB_12_8
*                                                     preguntan por evaluación del Pdte.

*MB_P7 Independientemente de su posición política, ¿Ud. aprueba o desaprueba la forma 
*      como Sebastián Piñera está conduciendo su gobierno?

*MB_P8 Con relación a las presiones de instituciones, grupos y personas, ¿cree Ud. que 
*      el actual gobierno de Sebastián Piñera, en general, ha actuado con firmeza o con debilidad?

*MB_P9 Con relación a las presiones de instituciones, grupos y personas, ¿cree Ud. que el actual
*      gobierno de Sebastián Piñera, en general, ha actuado con destreza y habilidad o sin destreza ni habilidad?

*MB_P10	Pensando en el Presidente Sebastián Piñera, ¿Ud. diría que él le da confianza o no le da confianza?

*MB_P11 Y, ¿Ud. diría que él le resulta cercano o lejano?

*MB_P12	PASE TARJETA “12” MÓDULO 1. Entre 1 y 7, ¿qué nota le pondría usted al Gobierno por su gestión en…?

*1. Delincuencia
*2. Pensiones
*3. Salud
*4. Educación
*5. Empleo
*6. Crecimiento económico
*7. Transporte público
*8. Inmigración
 
*Las preguntas MB_P12_1 a MB_P12_8 evalúan la gestión presidencial en distintas áreas de políticas. Tienen la misma
*escala de medición y las correlaciones entre éstas son elevadas. Las combinaremos en un índice. 

*C) Imputación de valores perdidos (en caso de ser necesario): no lo haremos.

*Índice de Evaluación Presidencial
gen indice_01 = MB_12_1_rec + MB_12_2_rec + MB_12_3_rec + MB_12_4_rec + MB_12_5_rec + MB_12_6_rec + MB_12_7_rec + MB_12_8_rec

********************************************************************************
										   
***PASO 4A: ANÁLISIS DE CONFIABILIDAD 

*La confiabilidad es la consistencia global de un indicador. En términos simples,
*examinamos si todas las variables incluidas en el índice están midiendo 
*aproximadamente lo mismo (el fenómeno latente: en nuestro caso, la evaluación pdcial).

*Alfa de Cronbach mide confiabilidad de una escala. Requiere que items estén en la 
*misma escala (y se midan en el mismo sentido). El argumento std estandariza las variables,
*proveyendo una escala común. 

*Valores de alfa de cronbach mayores a 0.6 se consideran aceptables/tolerables.
*Lo ideal es encontrar valores sobre el 0.7 o 0.8 como satisfactorios 

alpha MB_12_1_rec MB_12_2_rec MB_12_3_rec MB_12_4_rec MB_12_5_rec MB_12_6_rec MB_12_7_rec MB_12_8_rec, item gen(ev_pres)

*En Test scale se incluye los indicadores para el índice compuesto (correlación inter-item
*promedio y Alfa de Cronbach).
*En OBS se muestra el nº de observaciones válidas y SIGN refleja el signo de la variable
*(si aparece "-" implica que la variable fue invertida al ingresarse).

*Comúnmente, correlación item-test debería ser muy similar entre ítems y no es el mejor
*indicador de items con poco ajuste en índice. Es más útil utilizr correlaciones items-resto
* (correlación entre item y la escala formada por todas las variables restantes).
*La última columna muestra cómo varía el Alfa de Cronbach si se elimina dicho item. Los
*items con poco ajuste aumentarán el Alfa. 

*RESPUESTA:
*NUESTRO ÍNDICE ES MUY BUENO: TIENE UNA CONFIABILIDAD ELEVADA Y LA ELIMINACIÓN DE NINGUNO DE LOS 
*ITEMS MEJORA LA CONFIABILIDAD.

********************************************************************************
										   
***PASO 4B: REDUCCIÓN DE DIMENSIONES (EXPLORATORIO) CON  ANÁLISIS DE COMPONENTES PRINCIPALES

*El análisis de componentes principales es una técnica de reducción de datos. 
*El objetivo es tomar un grupo de variables y "extraer su variabilidad común" -su 
*componente(s) principal(es)- para tener una única variable (que es una combinación 
*lineal de las originales) en vez de muchas, que reuna la mayor parte posible de la
*varianza. Para esto, examina la matriz de correlaciones entre las variables. 
*Podemos usarlo para explorar si las variables incluidas son útiles para el índice. 

pca MB_12_1_rec MB_12_2_rec MB_12_3_rec MB_12_4_rec MB_12_5_rec MB_12_6_rec MB_12_7_rec MB_12_8_rec

*Es fundamental que todas las variables estén en la misma escala. 
*El primer panel muestra los "componentes" (proxy de dimensiones del indicador), los
*cuales resumen las variables. Los componentes no están correlacionados entre sí.
*Están ordenados del más explicativo al menos explicativo.  La columna PROPORTION
*señala cuánta varianza es explicada por cada componente. Lo ideal es captar la mayor
*proporción de varianza en el menor número de componentes (lo ideal es que sea mayor a 80%).
*Autovalores iguales o mayores a 1 indican que el componente logra explicar más varianza que 
*una variable por sí sola.

*Con el argumento vce(normal) se puede revisar con mayor detalle los resultados. 

pca MB_12_1_rec MB_12_2_rec MB_12_3_rec MB_12_4_rec MB_12_5_rec MB_12_6_rec MB_12_7_rec MB_12_8_rec, vce(normal)

*OTRO insumo es el análisis de sedimentación, que visualiza la caída en la proporción
*de varianza explicada. 

greigen

*Otro tema es revisar la segunda parte del panel. Lo primero es ver los signos. Idealmente,
*todos tienen el mismo signo, lo que se puede interpretar como evidencia de "unidimensionalidad".

*RESPUESTA:
*NUESTRO ÍNDICE ES UNIDIMENSIONAL. ES CIERTO, EL PRIMER COMPONENTE CAPTA SÓLO EL 63% DE LA VARIANZA
*(LO IDEAL SERÍA UN 80%), PERO LOS OTROS COMPONENTES ADICIONALES EXPLICAN MUY POCA VARIANZA (8% O MENOS).
*TODAS LAS VARIABLES SE ASOCIAN POSITIVAMENTE CON EL PRIMER COMPONENTE. ES DECIR, ESTE COMPONENTE
*ES LA EVALUACIÓN PRESIDENCIAL EN ÁREAS DE POLÍTICA PÚBLICA.
*SE PRESERVAN TODAS LAS VARIABLES EN EL ÍNDICE.

********************************************************************************
										   
***PASO 5: ANÁLISIS DESCRIPTIVO

*HISTOGRAMA
histogram indice_01

*Mejorar formato
histogram indice_01, bin(15) frequency normal ytitle(Frecuencia) xtitle(Índice de Evaluación Gestión Presidencial) title("Figura Nº1: Evaluación de Gestión Presidencial de Sebastián Piñera") subtitle("Áreas de Política") caption("Fuente: Encuesta CEP 2019") scheme(plottigblind) note("Nota: Valores no ponderados")  

*VARIABLES DE SUBGRUPOS 
rename ZONA urb_rur     
rename DS_P1 sexo 

recode   DS_P2_EXACTA (18/29=1) (30/49=2) (50/64=3) (65/96=4) (98/99=.), gen(edad_tr)
label variable edad_tr "Edad en Tramos"
label define edad_lab 1 "18 a 29 años" 2 "30 a 49 años" 3 "50 a 64 años" 4 "65 años o más"
label values edad_tr edad_lab

recode   MB_P14 (1/2=1) (3=2) (4/5=3) (6/7=4) (8/9=.), gen(pos_pol)
label variable pos_pol "Posición Política"
label define pos_pol_lab 1 "Derecha" 2 "Centro" 3 "Izquierda" 4 "Ninguna"
label values pos_pol pos_pol_lab


*Gráficos por subgrupos: SEXO
graph box indice_01, by(sexo)
graph box indice_01, over(sexo)

graph box indice_01 [aweight = FACTOR], over(sexo) ytitle(Frecuencia) title("Figura Nº2: Evaluación Presidencial según Sexo") subtitle("Gestión de Áreas de Política, Gobierno de Sebastián Piñera") caption("Fuente: Encuesta CEP 2019") note("Nota: Valores Ponderados") scheme(plottigblind)
*NO HAY DIFERENCIAS SEGÚN SEXO.


*Gráficos por subgrupos: URBANO RURAL
graph box indice_01 [aweight = FACTOR], over(urb_rur) ytitle(Frecuencia) title("Figura Nº3: Evaluación Presidencial según Área de Residencia") subtitle("Gestión de Áreas de Política, Gobierno de Sebastián Piñera") caption("Fuente: Encuesta CEP 2019") note("Nota: Valores Ponderados") scheme(plottigblind)
*LAS PERSONAS QUE VIVEN EN ZONAS URBANAS EVALÚAN DE PEOR MANERA.


*Gráficos por subgrupos: EDAD
graph box indice_01 [aweight = FACTOR], over(edad_tr) ytitle(Frecuencia) title("Figura Nº4: Evaluación Presidencial según Edad") subtitle("Gestión de Áreas de Política, Gobierno de Sebastián Piñera") caption("Fuente: Encuesta CEP 2019") note("Nota: Valores Ponderados") scheme(plottigblind)
*LAS PERSONAS JÓVENES EVALÚAN DE MEJOR MANERA.

*ZOOM en EDAD
twoway (scatter indice_01 DS_P2_EXACTA), ytitle(Frecuencia) xtitle(Edad (en Años)) title("Figura Nº 4A: Evaluación Presidencial según Edad") subtitle("Gestión de Áreas de Política, Gobierno de Sebastián Piñera") caption("Fuente: Encuesta CEP 2019") note("Valores No Ponderados") scheme(plottig)
twoway (scatter indice_01 DS_P2_EXACTA) (lfitci indice DS_P2_EXACTA), ytitle(Frecuencia) xtitle(Edad (en Años)) title("Figura Nº 4A: Evaluación Presidencial según Edad") subtitle("Gestión de Áreas de Política, Gobierno de Sebastián Piñera") caption("Fuente: Encuesta CEP 2019") note("Valores No Ponderados") scheme(plottig)
twoway (scatter indice_01 DS_P2_EXACTA) (qfitci indice DS_P2_EXACTA), ytitle(Frecuencia) xtitle(Edad (en Años)) title("Figura Nº 4A: Evaluación Presidencial según Edad") subtitle("Gestión de Áreas de Política, Gobierno de Sebastián Piñera") caption("Fuente: Encuesta CEP 2019") note("Valores No Ponderados") scheme(plottig)


*Gráficos por subgrupos: POSICIÓN POLÍTICA
graph box indice_01 [aweight = FACTOR], over(pos_pol) ytitle(Frecuencia) title("Figura Nº5: Evaluación Presidencial según Posición Política") subtitle("Gestión de Áreas de Política, Gobierno de Sebastián Piñera") caption("Fuente: Encuesta CEP 2019") note("Nota: Valores Ponderados") scheme(plottigblind)
*LAS PERSONAS DE DERECHA EVALÚAN DE MEJOR MANERA.













	
