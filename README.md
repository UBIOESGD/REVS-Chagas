# REVS-Chagas
*REVS (REDCap ELISA Validation System) - for Chagas disease*

[![es](https://img.shields.io/badge/lang-es-yellow.svg)](https://github.com/UBIOESGD/REVS-Chagas/blob/main/README.md)
[![en](https://img.shields.io/badge/lang-en-blue.svg)](https://github.com/UBIOESGD/REVS-Chagas/blob/main/README.md)


REVS (Sistema de validación REDCap ELISA) es un completo conjunto de herramientas para la validación e integración de resultados de laboratorio ELISA e información de sujetos o pacientes, mediante REDCap.
El presente proyecto contiene el código R que forma parte de REVS, para la validación y transferencia de placas ELISA de diagnóstico de la enfermedad de Chagas.
El código es fácilmente extensible para utilizar tanto otras placas ELISA de Chagas como de otros tipos.

## Partes de la herramienta
REVS-Chagas se compone de:

   - Proyecto REDCap *REVS-Chagas - Sujeto*, que gestiona datos de sujetos (pacientes) entre los que se incluye resultados de laboratorio de ELISA
   - Proyecto REDCap *REVS-Chagas - Placa ELISA*, que gestiona los resultados obtenidos en laboratorio tras la realización de los ensayos de placa ELISA (varias muestras de diferentes sujetos)
   - **validacion_ELISA.Rmd**: Informe de validación de los ensayos de laboratorio ELISA recogidos en *REVS-Chagas - Placa ELISA* y su relación y transferencia a *REVS-Chagas - Sujeto*
   - **ELISA_transfer.R**: Script de transferencia de datos, de los resultados recogidos en el proyecto *REVS-Chagas - Placa ELISA* de cada placa ELISA al proyecto *REVS-Chagas - Sujeto*
   - **Config.R**: Fichero de inicialización

Tipos de ELISA considerados actualmente en REVS-Chagas:

   1.	Wiener - Chagatest ELISA Recombinante 3.0
   2.	Wiener - Chagatest ELISA Recombinante 4.0
   3.	Wiener - Chagatest ELISA Lisado
   4.	Lemos - Biozima Chagas Recombinante
   5.	Lemos - Biozima Chagas Lisado
   6.	IICS - Chagas V1
   7.	IICS - Chagas V2
   
### validacion_ELISA.Rmd
Informe Markdown (salida en html) de control y validación de los datos recogidos en las placas ELISA: los resultados y los traspasos de datos realizados.
Validacion de las placas y los resultados en el proyecto *REVS-Chagas - Placa ELISA* con los resultados de placa ELISA (muestras de pacientes)

Apartados incluidos en el informe:

   1. **Placas ELISA**. Lista de placas ELISA en el proyecto *REVS-Chagas - Placa ELISA*
   2. **Validación de las placas ELISA**. Tabla con los parámetros de control de una placa ELISA y los cálculos de validación, según el tipo de placa.
   3. **Resultados (muestras) realizadas en las placas ELISA**. Numero de muestras de cada resultado (Positivo/Negativo/Indeterminado) en cada placa.
   4. **Validación de las muestras**
      1. *Muestras no identificables (opcional)*. Si las muestras se identifican según un patrón dado, lista de de las muestras que no cumplen el patrón.
      2. *Resultados individuales no válidos de las muestras*. Tabla con los resultados individuales que no pasan la validación del fabricante de la placa.
   5. **Resultados en el proyecto *REVS-Chagas - Sujeto***. Listados de control de los resultados validados y traspasados a cada sujeto/paciente
      1. Resultados traspasados al proyecto
      2. Resultados por placa traspasados al proyecto
      3. Resultados no traspasados al proyecto
      4. Resultados por placa no traspasados al proyecto

### ELISA_transfer.R
Script de transferencia de resultados del proyecto *REVS-Chagas - Placa ELISA* al proyecto *REVS-Chagas - Sujeto*. El proceso consta de diferentes fases en las que se realizan tanto validaciones de la propia placa ELISA como de los resultados de la misma. Dichas validaciones son descritas a continuación:

   1. Comprobar errores de la propia placa, como pueden ser errores en el cálculo de cut-off, valores faltantes, o parámetros de control propios de cada tipo de ELISA
   2. Comprobar códigos de sujeto duplicados dentro de una misma placa
   3. Comprobar códigos de sujeto inexistentes en el proyecto *REVS-Chagas - Sujeto*
   4. Comprobar si existen discordancias entre las densidades ópticas y el resultados de positividad

Las comprobaciones descritas anteriormente generan unos cuadros de diálogo en los que el usuario podrá decidir si se trata de errores menores que no influyen en la correcta importación de resultados, o bien se trata de errores críticos que deben ser solucionados antes de la transferencia de resultados.

### config.R
Fichero de inicialización: contiene las variables que el proceso *ELISA_transfer.R* utilizará para importar y exportar datos. Las variables que se deben indicar son las siguientes:

-  Variable *language*: idioma de en el que aparecerán los mensajes/avisos. Ej: 'es' (español) / 'en' (inglés) (1)
-  Variable *api_url*: url del servidor REDCap
-  Variable *REDCap_token_lab*: token del proyecto *REVS-Chagas - Placa ELISA* (datos a exportar).
-  Variable *REDCap_token_reg*: token del proyecto *REVS-Chagas - Sujeto*   (datos a importar).
-  Variable *lock_forms*: TRUE/FALSE indica si bloquear una placa ELISA al ser traspasados sus resultados. Necesario módulo externo de REDCap "Locking API".

Los tokens se encuentra en la sección 'API' del menú izquierdo de cada proyecto REDCap. El usuario debe disponer de los permisos API, los cuales se podrán activar des de la sección "Derechos de Usuarios" o "User Rights".

(1): el diccionario viene definido en los archivos presentes en la carpeta/sub-directorio *languages*. Si desea crear otro idioma, deberá copiar un diccionario ya creado, traducir los mensajes manualmente, e indicar en el archivo config.R el nuevo idioma deseado.

