********************************************************************************
********************************************************************************
**************               SESION 15:TALLER STATA               **************
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
cd "/Users/benjaminmunozrojas/pCloud Drive/3_Docencia/6_Analisis_de_Datos_con_Stata/3_Sesiones_Practicas/Sesion_15"

*Iniciar un documento log (con formato .txt)
log using log_sesion_15, append text  /*Creamos un archivo log para 
										almacenar los outputs de Stata.*/

											   
********************************************************************************
										   
***PASO 1: UTILIZAR BASE DE DATOS Y REVISIÓN DE VARIABLES

*Cargar base de datos
use "ELSOC_Wide_2016_2018_v1.00_Stata14.dta"

*Análisis Descriptivo Univariado: Confianza Institucional
describe c05_01_w01 c05_02_w01 c05_03_w01 c05_04_w01 c05_05_w01 c05_06_w01 c05_07_w01 c05_08_w01
summ c05_01_w01 c05_02_w01 c05_03_w01 c05_04_w01 c05_05_w01 c05_06_w01 c05_07_w01 c05_08_w01, detail
*ssc install polychoric
polychoric c05_01_w01 c05_02_w01 c05_03_w01 c05_04_w01 c05_05_w01 c05_06_w01 c05_07_w01 c05_08_w01
recode   c05_01_w01 (-888=.) (-999=.) , gen(c05_01_w01_rec)
recode   c05_02_w01 (-888=.) (-999=.) , gen(c05_02_w01_rec)
recode   c05_03_w01 (-888=.) (-999=.) , gen(c05_03_w01_rec)
recode   c05_04_w01 (-888=.) (-999=.) , gen(c05_04_w01_rec)
recode   c05_05_w01 (-888=.) (-999=.) , gen(c05_05_w01_rec)
recode   c05_06_w01 (-888=.) (-999=.) , gen(c05_06_w01_rec)
recode   c05_07_w01 (-888=.) (-999=.) , gen(c05_07_w01_rec)
recode   c05_08_w01 (-888=.) (-999=.) , gen(c05_08_w01_rec)
polychoric c05_01_w01_rec c05_02_w01_rec c05_03_w01_rec c05_04_w01_rec c05_05_w01_rec c05_06_w01_rec c05_07_w01_rec c05_08_w01_rec 

*Análisis Descriptivo Univariado: Comportamiento Prosocial (Variables Dicotómicas)
describe c07_01_w01 c07_02_w01 c07_03_w01 c07_04_w01 c07_05_w01 c07_06_w01 c07_07_w01 c07_08_w01
summ c07_01_w01 c07_02_w01 c07_03_w01 c07_04_w01 c07_05_w01 c07_06_w01 c07_07_w01 c07_08_w01, detail

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
										   
***PASO 1: CONSTRUCCIÓN DE ÍNDICES

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


*Índice de Confianza Institucional
gen indice_01 = c05_01_w01_rec + c05_02_w01_rec + c05_03_w01_rec + c05_04_w01_rec + c05_05_w01_rec + c05_06_w01_rec + c05_07_w01_rec + c05_08_w01_rec
summ indice_01
histogram indice_01, percent normal ytitle(Frecuencia) xtitle(Grado de Confianza) title("Figura Nº 1: Índice de Confianza Institucional") caption("Fuente: ELSOC 2016")

********************************************************************************
										   
***PASO 2: ANÁLISIS DE CONFIABILIDAD BÁSICO: ALFA DE CRONBACH

*La confiabilidad es la consistencia global de un indicador. En términos simples,
*examinamos si estan midiendo aproximadamente lo mismo. 

*Análisis de Medición Básico: 
alpha c05_01_w01_rec c05_02_w01_rec c05_03_w01_rec c05_04_w01_rec c05_05_w01_rec c05_06_w01_rec c05_07_w01_rec c05_08_w01_rec

*Alfa de Cronbach mide confiabilidad de una escala. Requiere que items estén en la 
*misma escala (y se midan en el mismo sentido). El argumento std estandariza las variables,
*proveyendo una escala común. 

*α=N2Cov¯∑S2item+∑Covitem

*Para cada ítem en una escala calculamos la varianza entre los ítems S2item y la 
*covarianza entre un ítem en particular con el resto de los items Covitem. En el 
*númerador se encuentra el número de ítems de la escala, al cuadrado multiplicado 
*por el promedio de la covarianza entre los ítems (el promedio de los coeficientes 
*fuera de la diagonal de la matriz de varianza-covarianza). La versión estándarizada 
*de este estadístico utiliza la matriz de correlaciones.

*Valores de alfa de cronbach mayores a 0.6 se consideran aceptables/tolerables.
*Lo ideal es encontrar valores sobre el 0.7 o 0.8 como satisfactorios 

*Como se puede ver en la ecuación, el estadístico depende directamente de la cantidad de 
*ítems, si la cantidad de ítems aumenta es más probable encontrar valores superiores a 
*0.7, por lo que este debe ser un punto que deben tener en cuenta los investigadores.

*Comúnmente se interpreta que este estadístico mide la “unidimensionalidad” de una 
*escala, o en otras palabras que la escala mide un factor o constructo latente 
*subyacente a los ítems. No obstante, pueden encontrar una escala que obtiene valores 
*de alfa de Cronbach superiores a 0.7, no obstante pueden existira dos o más factores 
*subyacentes a está escala que globalmente pueden estar correlacionados. En este aspecto
*sería necesario revisar otros procedimientos estadísticos como el Análisis Factorial.

alpha c05_01_w01_rec c05_02_w01_rec c05_03_w01_rec c05_04_w01_rec c05_05_w01_rec c05_06_w01_rec c05_07_w01_rec c05_08_w01_rec, item generate(trust)

*En Test scale se incluye los indicadores para el índice compuesto (correlación inter-item
*promedio y Alfa de Cronbach).
*En OBS se muestra el nº de observaciones válidas y SIGN refleja el signo de la variable
*(si aparece "-" implica que la variable fue invertida al ingresarse).

*Comúnmente, correlación item-test debería ser muy similar entre ítems y no es el mejor
*indicador de items con poco ajuste en índice. Es más útil utilizr correlaciones items-resto
* (correlación entre item y la escala formada por todas las variables restantes).
*La última columna muestra cómo varía el Alfa de Cronbach si se elimina dicho item. Los
*items con poco ajuste aumentarán el Alfa. 

*Si en la columna de Alfa, el valor asociado a alguno de los items aumenta (en comparación
*al Alfa de la escala completa, aparece en Test scale), dicho item puede ser eliminado
*del índice. Si el alfa disminuye, es mejor mantener ese item en la escala. 

********************************************************************************
										   
***PASO 3: REDUCCIÓN DE DIMENSIONES (EXPLORATORIO) CON  ANÁLISIS DE COMPONENTES PRINCIPALES

*El análisis de componentes principales es una técnica de reducción de datos. 
*El objetivo es tomar un grupo de variables y "extraer su variabilidad común" -su 
*componente(s) principal(es)- para tener una única variable (que es una combinación 
*lineal de las originales) en vez de muchas, que reuna la mayor parte posible de la
*varianza. Para esto, examina la matriz de correlaciones entre las variables. 
*Podemos usarlo para explorar si las variables incluidas son útiles para el índice. 

pca c05_01_w01_rec c05_02_w01_rec c05_03_w01_rec c05_04_w01_rec c05_05_w01_rec c05_06_w01_rec c05_07_w01_rec c05_08_w01_rec

*Es fundamental que todas las variables estén en la misma escala. 
*El primer panel muestra los "componentes" (proxy de dimensiones del indicador), los
*cuales resumen las variables. Los componentes no están correlacionados entre sí.
*Están ordenados del más explicativo al menos explicativo.  La columna PROPORTION
*señala cuánta varianza es explicada por cada componente. Lo ideal es captar la mayor
*proporción de varianza en el menor número de componentes (lo ideal es que sea mayor a 80%).
*Autovalores iguales o mayores a 1 indican que el componente logra explicar más varianza que 
*una variable por sí sola.
*Conn el argumento vce(normal) se puede revisar con mayor detalle los resultados. 
*OTRO insumo es el análisis de sedimentación, que visualiza la caída en la proporción
*de varianza explicada. 

greigen

*Otro tema es revisar la segunda parte del panel. Lo primero es ver los signos. Idealmente,
*todos tienen el mismo signo, lo que se puede interpretar como evidencia de "unidimensionalidad".

pca c05_01_w01_rec c05_02_w01_rec c05_03_w01_rec c05_04_w01_rec c05_05_w01_rec c05_06_w01_rec c05_07_w01_rec c05_08_w01_rec, components(2)

*Luego, se requiere que éstos tomen valores altos y comunes (típico umbral es sobre 0.6),
*pero basta con que sea mayor a 0.3. Al explorar estos resultados podemos identificar
*variables que pueden excluirse: c05_03_w01 , c05_04_w01 y c05_06_w01.

gen indice_02 = c05_01_w01_rec + c05_02_w01_rec + c05_05_w01_rec + c05_07_w01_rec + c05_08_w01_rec
summ indice_02
histogram indice_02, percent normal ytitle(Frecuencia) xtitle(Grado de Confianza) title("Figura Nº 1: Índice de Confianza Institucional") caption("Fuente: ELSOC 2016")



********************************************************************************

*ACTIVIDAD PRACTICA: CREAR UN INDICE ADITIVO.
*Elegir un concepto y definir dimensiones.
*Seleccionar variables y evaluar 
