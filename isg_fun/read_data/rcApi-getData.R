############################################################################
####                    READING REDCap data with API                    ####
####                           ISGlobal UBIOESGD                        ####
####                           May 2025 - v2.0                     ####
############################################################################

#### 0.1 Packages and setting ####
if (!require('redcapAPI')) install.packages('redcapAPI'); require('redcapAPI')
library(dplyr)

rcApi_getData_version<-"2.0"
rcApi_packageVersion<-packageVersion("redcapAPI")

# Read data directly through the API
#https://www.rdocumentation.org/packages/redcapAPI/versions/2.10.0
##  packageVersion("redcapAPI")
# UPDATED:  update.packages(ask = FALSE, repos = "https://cran.rstudio.com")

# v2.0 readData uses removeEmptyRecords to remove the records that actually has no data collected. TESTS reviewed

# v1.13 exportRecordsTyped dag=TRUE has to be specified
# v1.12 removeEmptyRecords, posREDCapVars: si es formulario o evento repetitivo redcap_repeat_instrument, redcap_repeat_instance
# v1.11 versionREDCap
# v1.10 removeEmptyRecords: Si el formulari nomes te una pregunta (no redcp_vars), rowSums falla.  Afegim una columna mock. Info logs printed
# v1.9 Removing forms not in the event. Removing Complete in empty forms
# v1.8 all_data flag to indicate not to remove empty forms
# v1.7 USING redcapAPI 2.8 exportRecordsTyped. Remove empty forms. No fieldsFromForm
# v1.6 USING redcapAPI 2.7.4 exportRecordsTyped when exporting records from a Form (not using fieldsFromForm) https://www.rdocumentation.org/packages/redcapAPI/versions/2.7.4/topics/exportRecordsTyped
##  redcapAPI 2.7.0+ includes exportRecordsTyped which is a major move forward for the package. It replaces exportRecords. (has a useful validation report attached when things fail)
# v1.5 to_export: if we want the field names to export the data, the descriptive fields should not be returned
# v1.4 Error https://www.giters.com/nutterb/redcapAPI/issues/162 FYI -- we found we do not get this error if we set labels=FALSE when using exportRecords.
# v1.3 readData specific columns for forms, with new fieldsFromForm function

##
# BISC error: Error in set_label.default(x[[nm]], lab) : labels may not be added to `NULL` objects.
# Very possible this was related to the issue of capital letters in the checkbox coding.
#devtools::install_github("nutterb/redcapAPI") (the master branch) will install 2.3.1. 
#https://github.com/nutterb/redcapAPI/issues/158

##
#INTERESTING FUNCTIONS
#redcapFactorFlip(all_data$cons). redcapFactorFlip: Convert REDCap factors between labelled and coded
#recodeCheck: Change labelling of checkbox variables
##

##
#parseBranchingLogic:Branching logic from the REDCap Data Dictionary is parsed into R Code and returned as expressions. These can be evaluated if desired and allow the user to determine if missing values are truly missing or not required because the branching logic prevented the variable from being presented.
#exportMetaData: Export Meta Data from a REDCap Database
#md<-exportMetaData(rcon); md$branching_logic
#Parsing the logic allowed me to determine which values we expected to be missing and narrow the search to just those subjects with legitimately missing values.
# meta_data <- exportMetaData(rcon)
# meta_data <- meta_data[meta_data$field_type != "descriptive", ]
# logic <- parseBranchingLogic(meta_data$branching_logic)
# names(logic) <- meta_data$field_name

readData = function(api_url = "", api_token = "", fields=c(), forms=c(), events = c(), all_data=FALSE, dag=FALSE) {
  
  rcon = redcapConnection(api_url, api_token)
  mapping=exportMappings(rcon)
  
  if (all_data) {
    
    if (length(events)==0){
      if (length(forms)==0){
        if (length(fields)==0) rc_data = exportRecordsTyped(rcon, dag=dag)
        else rc_data = exportRecordsTyped(rcon, fields = fields, dag=dag)
      }
      else {
        if (length(fields)==0) rc_data = exportRecordsTyped(rcon, forms = forms, dag=dag)
        else rc_data = exportRecordsTyped(rcon, fields = fields, forms = forms, dag=dag)
      }
    }
    else{
      if (length(forms)==0){
        if (length(fields)==0) {
          # Si indico un event pero no forms ni fields, nomes vull els forms del event
          forms = mapping[mapping$unique_event_name=="intervention_arm_1",3]
          rc_data = exportRecordsTyped(rcon,  events=events, forms = forms, dag=dag)
        }
        else rc_data = exportRecordsTyped(rcon, fields = fields, events = events, dag=dag)
      }
      else {
        if (length(fields)==0) rc_data = exportRecordsTyped(rcon, forms = forms, events = events, dag=dag)
        else rc_data = exportRecordsTyped(rcon, fields = fields, forms = forms, events = events, dag=dag)
      }
    }
    
  }
  
  # all_data =FALSE: remove empty forms
  else {
    
    if (length(events)==0){
      
      if (length(forms)==0){
        
        if (length(fields)==0){
          print(paste0("Extracting all records"))
          rc_data = exportRecordsTyped(rcon, dag=dag)
        }
        else{ #fields!=""
          print(paste0("Extracting records WITH INFORMATION in field  ",fields))
          # fields: Vector of fields to be returned. If NULL, all fields are returned (unless forms is specified).
          rc_data = exportRecordsTyped(rcon, fields=fields, dag=dag)
          # exportRecordsTyped RETURNS ONLY data informed
        }
        
      }
      else{ #events=="", forms!=""
        
        if (length(fields)==0){
          print(paste0("Extracting NOT EMPTY records from the form/s ",forms))
          rc_data_all = exportRecordsTyped(rcon, forms = forms, dag=dag)
          rc_data = removeEmptyRecords(rc_data_all)
        }
        else{ #fields!="" 
          print(paste0("ALERT!! fields is ignored. Extracting NOT EMPTY records from the form/s ",forms, " (AND from the fields: ",fields,")"))
          # fields: Vector of fields to be returned. If NULL, all fields are returned (unless forms is specified). 
          # exportRecordsTyped IGNORES fields, it exports ALL fields from the form
          rc_data_all = exportRecordsTyped(rcon, forms = forms, fields=fields, dag=dag)
          rc_data = removeEmptyRecords(rc_data_all)
        }
        
      }
      
    }
    
    else{ #events!=""
      if (length(forms)==0){
        
        if (length(fields)==0){ #events!="", forms==""
          print(paste0("Extracting data from each form in the event ",events))
          
          # Si indico un event pero no forms ni fields, nomes vull els forms/data de l'event
          forms = mapping[mapping$unique_event_name %in% events,3]
          rc_data = exportRecordsTyped(rcon,  events=events, forms = forms, dag=dag)
          
        }
        else{ #events!="", fields!=""
          rc_data = exportRecordsTyped(rcon, fields=fields, events=events, dag=dag)
          # TODO remove records with empty forms? rc_data = removeEmptyRecords(rc_data)
        }
        
      }
      else{ #events!="", forms!=""
        print(paste0("Extracting NOT EMPTY records from the form/s ",forms, " and events ", events))
        rc_data_all = exportRecordsTyped(rcon,  events=events, forms = forms, dag=dag)
        rc_data = removeEmptyRecords(rc_data_all)
      }
      
    }
    
  }
  
  #rc_check = head(exportBundle(rcon),1)
  
  return(rc_data)
  
}

namesREDCapVars = function(rc_df){
  rc_names = c("redcap_event_name","redcap_data_access_group","redcap_survey_identifier","redcap_repeat_instrument","redcap_repeat_instance")
  
  # solo las que están en los nombres de columnas de rc_df
  existing_rc_names <- rc_names[rc_names %in% names(rc_df)]
  
  # si hay mas de un form, todas las variables _complete
  comp_names = names(rc_df)[grep("_complete",x=colnames(rc_df))]
  
  # id in first position (normally record_id)
  id_name = names(rc_df)[1]
  
  return (c(id_name,existing_rc_names,comp_names))
  #return (c(1,rc_vars,grep("_complete",x=colnames(rc_df))))
}

removeEmptyRecords <- function(rc_df) {
  
  ignore_cols = namesREDCapVars(rc_df)
  
  # Identificar columnas Checked/Unchecked
  check_vars <- rc_df %>% 
    select(where(is.factor)) %>% 
    select(where(~ setequal(levels(.), c("Unchecked","Checked")))) %>% 
    names()
  
  # Determinar las columnas restantes a chequear por NA
  other_vars <- setdiff(names(rc_df), c(check_vars, ignore_cols))
  
  # Filtrar filas “vacías”
  rc_data = rc_df %>%filter(!(if_all(all_of(check_vars), ~ . == "Unchecked") & if_all(all_of(other_vars), ~ is.na(.))))
}

#dir="../pdf",filename_prefix = "info_vac",records=data,events="seguimiento_mes_12_arm_1",instruments="informacin_vacunacin",all_records=FALSE
exportFormsToPdf = function(rcon, dir="pdf", filename_prefix = "redcap_form", 
                            records, all_records=FALSE, events, instruments) {
  
  if(!all_records)
    for(i in 1:nrow(records)) {
      row <- records[i,]
      exportPdf(rcon, dir, filename_prefix,  record=row[,"study_id"], events, instruments)
    }
  else
    exportPdf(rcon, dir, filename_prefix, NULL, events, instruments, all_records)
  
}

versionREDCap = function(api_url = "", api_token = "") {
  
  rcon = redcapConnection(api_url, api_token)
  vrc=exportVersion(rcon)
  
  return (vrc)
  
}