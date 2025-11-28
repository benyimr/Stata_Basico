********************************************************************************
********************************************************************************
**************               SESION 2: TALLER STATA               **************
**************                                                    **************
********************************************************************************
********************************************************************************

*ACTIVIDAD Nº 1: Elaboración de un Flujo de Trabajo Mínimo

**Examinemos la relación entre interacción con migrantes y confianza en ellos


*Limpieza del Espacio de trabajo
CLEAR
clear all
capture log close


*Identificar versión utilizada
version 14


*Generar un Directorio (Carpeta) y por medio de cd definirlo como directorio de trabajo.
**cd "/Users/benjaminmunozrojas/pCloud Drive/3_Docencia/6_Analisis_de_Datos_Con_Stata/Sesion_02"


*Modificar ancho de línea de resultados
set linesize 150


*Iniciar un documento log (con formato .txt)
log using log_sesion_02, replace text

**Exploremos un poco los argumentos del comando log
help log


*Abrir Base de Datos
use "ELSOC_W01_v3.00_Stata14.dta"


*Explorar variables de interés
codebook r03_04 r06 r07 r08 c06_06

summarize r03_04 
summarize r06
summarize r07

summarize r08, detail
summarize c06_06, detail


*Elaboremos Tablas univariadas
tabulate r03_04
tabulate r06
tabulate r07

tabulate r08
tabulate c06_06, plot
tabulate c06_06 [aweight = ponderador01], plot

histogram c06_06, discrete frequency


*Elaboremos Tablas bivariadas
tab r03_04 c06_06
tab r06    c06_06
tab r07    c06_06
tab r08    c06_06


*Procesemos los datos para explorar la relación
generate c06_06rec = c06_06
replace c06_06rec=. if c06_06==-999
replace c06_06rec=. if c06_06==-888

histogram c06_06rec, discrete frequency

generate r08rec = r08
replace r08rec=. if r08==-999
replace r08rec=. if r08==-888
replace r08rec=2 if r08==3 | r08==4 | r08 == 5

histogram r08rec, discrete frequency


tab r08rec c06_06rec, chi2


log close

********************************************************************************

*ACTIVIDAD Nº 2: Almacenar Bases de Datos Provistas

clear

*A) Importancia del Formato
*¿Cómo son los datos en términos de formato?

type QoGStata.dta


*B) Ingreso Manual de Datos
*Abrir el editor de datos
edit

**   id	sexo	edad	trabajo	   ocupacion
**    1	   1	  19	      1	    "obrero"
**    2	   0	  18	      0	   "gerente"
**    3	   1	  35	      1	    "obrero"
**    4	   0	  34	      0	   "gerente"


*Usar la función Input


*C) Comando input
input id sexo edad
1 1 19
2 0 18
3 0 35
4 0 34
end

*Archivo Separado por Comas
insheet using QoGSepComa.csv, clear

*Archivo Excel
import excel QoGExcel.xls, clear
browse

**Discutamos un momento sobre tipos de variables
describe
import excel QoGExcel.xlsx, firstrow clear
describe


*Archivo Texto
insheet using QoGTexto.txt, clear

***************************************
*Archivo de SPSS 
* ssc describe usespss
* ssc install usespss
* usespss using QoGSPSS.sav
***************************************

*Archivo de Stata
*use QoGStata

***TAREA: GENERAR BASE DE DATOS DEL PROYECTO

