# REVS-Chagas
*REVS (REDCap ELISA Validation System) - for Chagas disease*

[![es](https://img.shields.io/badge/lang-es-green.svg)](https://github.com/UBIOESGD/REVS-Chagas/blob/main/README.md)
[![en](https://img.shields.io/badge/lang-en-blue.svg)](https://github.com/UBIOESGD/REVS-Chagas/blob/main/README-en.md)
[![ct](https://img.shields.io/badge/lang-ct-yellow.svg)](https://github.com/UBIOESGD/REVS-Chagas/blob/main/README-ct.md)

REVS (REDCap ELISA Validation System) is a comprehensive toolkit for validating and integrating ELISA laboratory results and subject/patient information using REDCap.  
This project contains the R code that is part of REVS, for validating and transferring ELISA plates used in the diagnosis of Chagas disease.  
The code can easily be extended to work with other ELISA plates, either for Chagas or other applications.

## Toolkit components
REVS-Chagas consists of:

- REDCap project *REVS-Chagas - Subject*, which manages data for subjects (patients), including their ELISA test results  
- REDCap project *REVS-Chagas - ELISA Plate*, which manages results obtained in the lab after running ELISA plate assays (multiple samples from different subjects)  
- **validacion_ELISA.Rmd**: Validation report of ELISA lab assays stored in *REVS-Chagas - ELISA Plate* and their relationship and transfer to *REVS-Chagas - Subject*  
- **ELISA_transfer.R**: Data transfer script, moving results collected in *REVS-Chagas - ELISA Plate* into the *REVS-Chagas - Subject* project  
- **config.R**: Configuration file  

Current ELISA types supported by REVS-Chagas:

1. Wiener - Chagatest ELISA Recombinant 3.0  
2. Wiener - Chagatest ELISA Recombinant 4.0  
3. Wiener - Chagatest ELISA Lysate  
4. Lemos - Biozima Chagas Recombinant  
5. Lemos - Biozima Chagas Lysate  
6. IICS - Chagas V1  
7. IICS - Chagas V2  

### validacion_ELISA.Rmd
Markdown report (HTML output) for control and validation of the data collected in ELISA plates: results and data transfers performed.  
Validation of plates and results in the *REVS-Chagas - ELISA Plate* project with the ELISA plate results (patient samples).

Sections included in the report:

1. **ELISA Plates**. List of ELISA plates in the *REVS-Chagas - ELISA Plate* project  
2. **Validation of ELISA Plates**. Table with control parameters for each plate and validation calculations, depending on plate type  
3. **Results (samples) processed in ELISA Plates**. Number of samples per result (Positive/Negative/Indeterminate) in each plate  
4. **Sample Validation**
   1. *Unidentifiable samples (optional)*. If samples follow a defined pattern, a list of those not matching the pattern  
   2. *Invalid individual sample results*. Table of individual results failing the manufacturer's validation criteria  
5. **Results in the *REVS-Chagas - Subject* project**. Control listings for validated results transferred to each subject/patient  
   1. Results transferred to the project  
   2. Results per plate transferred to the project  
   3. Results not transferred to the project  
   4. Results per plate not transferred to the project  

### ELISA_transfer.R
Script to transfer results from the *REVS-Chagas - ELISA Plate* project to the *REVS-Chagas - Subject* project.  
The process includes several stages of validation for both the ELISA plate and its results. The following validations are performed:

1. Check for plate errors, such as cutoff calculation issues, missing values, or plate-type-specific control parameters  
2. Check for duplicate subject codes within the same plate  
3. Check for subject codes that do not exist in the *REVS-Chagas - Subject* project  
4. Check for discrepancies between optical densities and positivity results  

These checks generate dialog boxes where the user can decide whether the issues are minor (non-blocking) or critical and must be resolved before proceeding with data transfer.

### config.R
Configuration file: contains the variables used by the *ELISA_transfer.R* script to import and export data. You must define the following:

- Variable *language*: language for messages/warnings. E.g., 'es' (Spanish) / 'en' (English)  
- Variable *api_url*: REDCap server URL  
- Variable *REDCap_token_lab*: token for the *REVS-Chagas - ELISA Plate* project (data to export)  
- Variable *REDCap_token_reg*: token for the *REVS-Chagas - Subject* project (data to import)  
- Variable *lock_forms*: TRUE/FALSE to indicate whether to lock an ELISA plate after transferring its results. Requires REDCap external module “Locking API”  

Tokens are found in the 'API' section on the left-hand menu of each REDCap project. The user must have API rights, which can be enabled under the "User Rights" section.

(*): The language dictionary is defined in the files inside the *languages* folder/sub-directory. To add a new language, copy an existing dictionary, manually translate the messages, and update the config.R file with the new language code.

## Getting started

To use the REVS-Chagas tool, access to a REDCap server is required.  
REDCap is available free of charge for non-profit organizations but is not open-source software.  
To install and use REDCap, an organization must join the REDCap consortium. Instructions are available on the official REDCap website. The process typically involves submitting an application, providing details about the intended use, and accepting the standard license terms.  
If your organization already uses REDCap, contact your REDCap administrator to request a new user account to access the system.

Two new REDCap projects must be created using the option *Upload a REDCap project XML file (CDISC ODM format)*.  
The XML files needed to create the two projects (*REVS-Chagas - Subject* and *REVS-Chagas - ELISA Plate*) are available in the `XML_files` folder.

Configure the `config.R` file with the information needed to connect to your REDCap server via the API.
