# REVS-Chagas
*REVS (REDCap ELISA Validation System) - per a la malaltia de Chagas*

[![es](https://img.shields.io/badge/lang-es-green.svg)](https://github.com/UBIOESGD/REVS-Chagas/blob/main/README.md)
[![en](https://img.shields.io/badge/lang-en-blue.svg)](https://github.com/UBIOESGD/REVS-Chagas/blob/main/README-en.md)
[![ct](https://img.shields.io/badge/lang-ct-yellow.svg)](https://github.com/UBIOESGD/REVS-Chagas/blob/main/README-ct.md)

REVS (Sistema de validació REDCap ELISA) és un conjunt complet d’eines per a la validació i integració de resultats de laboratori ELISA i informació de subjectes o pacients, mitjançant REDCap.  
Aquest projecte conté el codi R que forma part de REVS, per a la validació i transferència de plaques ELISA de diagnòstic de la malaltia de Chagas.  
El codi és fàcilment extensible per utilitzar tant altres plaques ELISA de Chagas com d'altres tipus.

## Conjunt d’eines
REVS-Chagas es compon de:

- Projecte REDCap *REVS-Chagas - Subjecte*, que gestiona dades de subjectes (pacients), incloent-hi resultats de laboratori ELISA  
- Projecte REDCap *REVS-Chagas - Placa ELISA*, que gestiona els resultats obtinguts al laboratori després de la realització dels assaigs de placa ELISA (diverses mostres de diferents subjectes)  
- **validacion_ELISA.Rmd**: Informe de validació dels assaigs de laboratori ELISA recollits a *REVS-Chagas - Placa ELISA* i la seva relació i transferència a *REVS-Chagas - Subjecte*  
- **ELISA_transfer.R**: Script de transferència de dades, dels resultats recollits al projecte *REVS-Chagas - Placa ELISA* de cada placa ELISA al projecte *REVS-Chagas - Subjecte*  
- **config.R**: Fitxer de configuració  

Tipus d’ELISA considerats actualment a REVS-Chagas:

1. Wiener - Chagatest ELISA Recombinant 3.0  
2. Wiener - Chagatest ELISA Recombinant 4.0  
3. Wiener - Chagatest ELISA Lisiat  
4. Lemos - Biozima Chagas Recombinant  
5. Lemos - Biozima Chagas Lisiat  
6. IICS - Chagas V1  
7. IICS - Chagas V2  

### validacion_ELISA.Rmd
Informe Markdown (sortida en HTML) de control i validació de les dades recollides a les plaques ELISA: resultats i transferències de dades realitzades.  
Validació de les plaques i els resultats al projecte *REVS-Chagas - Placa ELISA* amb els resultats de placa ELISA (mostres de pacients).

Apartats inclosos a l’informe:

1. **Plaques ELISA**. Llista de plaques ELISA al projecte *REVS-Chagas - Placa ELISA*  
2. **Validació de les plaques ELISA**. Taula amb els paràmetres de control d’una placa ELISA i els càlculs de validació, segons el tipus de placa.  
3. **Resultats (mostres) realitzades a les plaques ELISA**. Nombre de mostres per cada resultat (Positiu/Negatiu/Indeterminat) en cada placa.  
4. **Validació de les mostres**
   1. *Mostres no identificables (opcional)*. Si les mostres es poden identificar segons un patró donat, llista de mostres que no compleixen el patró.  
   2. *Resultats individuals no vàlids de les mostres*. Taula amb els resultats individuals que no passen la validació del fabricant de la placa.  
5. **Resultats al projecte *REVS-Chagas - Subjecte***. Llistats de control dels resultats validats i transferits a cada subjecte/pacient  
   1. Resultats transferits al projecte  
   2. Resultats per placa transferits al projecte  
   3. Resultats no transferits al projecte  
   4. Resultats per placa no transferits al projecte  

### ELISA_transfer.R
Script de transferència de resultats del projecte *REVS-Chagas - Placa ELISA* al projecte *REVS-Chagas - Subjecte*. El procés consta de diverses fases on es realitzen validacions tant de la placa ELISA com dels seus resultats. Aquestes validacions es descriuen a continuació:

1. Comprovar errors de la pròpia placa, com ara errors en el càlcul del *cut-off*, valors absents o paràmetres de control específics de cada tipus d’ELISA  
2. Comprovar codis de subjecte duplicats dins d’una mateixa placa  
3. Comprovar codis de subjecte inexistents al projecte *REVS-Chagas - Subjecte*  
4. Comprovar si hi ha discrepàncies entre les densitats òptiques i el resultat de positivitat  

Les comprovacions descrites generen quadres de diàleg on l’usuari pot decidir si es tracta d’errors menors que no afecten la correcta importació dels resultats, o bé d’errors crítics que cal solucionar abans de fer la transferència.

### config.R
Fitxer de configuració: conté les variables que el procés *ELISA_transfer.R* utilitzarà per importar i exportar dades. Les variables que cal indicar són les següents:

- Variable *language*: idioma en què apareixeran els missatges/avisos. Ex: 'es' (espanyol) / 'en' (anglès)  
- Variable *api_url*: URL del servidor REDCap  
- Variable *REDCap_token_lab*: token del projecte *REVS-Chagas - Placa ELISA* (dades a exportar)  
- Variable *REDCap_token_reg*: token del projecte *REVS-Chagas - Subjecte* (dades a importar)  
- Variable *lock_forms*: TRUE/FALSE indica si cal bloquejar una placa ELISA quan es transfereixen els resultats. Requereix el mòdul extern de REDCap "Locking API"  

Els tokens es troben a la secció 'API' del menú esquerre de cada projecte REDCap. L’usuari ha de tenir permisos d’API, que es poden activar des de la secció "Drets d’usuari" o "User Rights".

(*): el diccionari ve definit en els arxius presents a la carpeta/subdirectori *languages*. Si es vol crear un altre idioma, cal copiar un diccionari existent, traduir manualment els missatges, i indicar al fitxer config.R el nou idioma desitjat.

## Posada en marxa

Per utilitzar l’eina REVS-Chagas, és essencial accedir a un servidor REDCap. REDCap, encara que està disponible gratuïtament per a organitzacions sense ànim de lucre, no és un programari de codi obert.  
Perquè una organització pugui instal·lar i utilitzar REDCap, cal unir-se al consorci. Les instruccions per fer-ho es troben al lloc web oficial de REDCap. El procés sol implicar l’enviament d’una sol·licitud, proporcionar informació sobre l’ús previst de la plataforma i acceptar els termes de la llicència estàndard.  
Si la vostra organització ja utilitza REDCap, només cal contactar amb l’administrador REDCap de la institució per sol·licitar un nou compte d’usuari per iniciar sessió al sistema.

Cal crear dos nous projectes REDCap, seleccionant l’opció *Upload a REDCap project XML file (CDISC ODM format)*.  
Els arxius XML per crear ambdós projectes (*REVS-Chagas - Subjecte* i *REVS-Chagas - Placa ELISA*) es troben a la carpeta XML_files.

Configura el fitxer config.R amb la informació necessària per connectar-te amb el teu servidor mitjançant l’API.
