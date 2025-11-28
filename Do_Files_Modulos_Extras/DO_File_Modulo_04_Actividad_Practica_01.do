**************************************************************************
***** DO FILE: ACTIVIDAD PRACTICA SESION 04
*****
***** INVESTIGADORA: _____________
***** FECHA: 14/01/2019


***************************************************************************

***PASO 0: CONFIGURACIÓN DEL ESPACIO DE TRABAJO


*Limpieza del Espacio de trabajo
clear all    
capture log close 

*Identificar version de Stata 
version 14

*Fijar directorio de trabajo
pwd 
cd "______________"


*Iniciar un documento log (con formato .txt)
log using ___________, append text  

********************************************************************************
											   
***PASO 1: UTILIZAR BASE DE DATOS

*Abrir base de datos
use ______________
import ___________
insheet __________


*Inspeccion General de Datos
describe
codebook

********************************************************************************

***PASO 2: TRANSFORMAR VARIABLES Y CREAR ETIQUETAS

***AYUDA: http://wlm.userweb.mwn.de/Stata/wstatgen.htm
***
***gen new_variable=something

*a) Identificar una necesidad
*b) Planificar (en papel) el procedimiento a implementar
*c) Escribir código con generate

*Comandos de apoyo: replace, recode
*Comandos más avanzados: destring, encode, decode, 
*Extensiones: egen 

gen nombre_variable = ________________________


*d) Crear etiqueta de variable
label variable nombre_variable "________________"

label define nombre_label _ "___"  _ "___" ....
label values nombre_variable nombre_label





