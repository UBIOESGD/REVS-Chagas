##------------------------------------------------------------------
## RED_Cha_ELISA: Importacion ELISAs
## Traslado de resultados de *REDCap laboratorio* a *REDCap principal* 
## Created by: UBIOESGD - ISGlobal
## Last Modified on: Jan 2024
## -----------------------------------------------------------------

######## USING REDCAP, API CONNECTION #########

#### 0.1 Packages and settings ####
if (!require('ini'))   install.packages('ini');   require('ini')
if (!require('dplyr')) install.packages('dplyr'); require('dplyr')
if (!require('tidyr')) install.packages('tidyr'); require('tidyr')
if (!require('tcltk')) install.packages('tcltk'); require('tcltk')
if (!require('rjson')) install.packages('rjson'); require('rjson')
if (!require('redcapAPI')) install.packages('redcapAPI'); require('redcapAPI')
if (!require('svDialogs')) install.packages('svDialogs'); require('svDialogs')

#### 0.2 User-written functions ####
source("config.R")
source("isg_fun/checks_ELISAS_lab/checks.R")
source("isg_fun/read_data/rcApi-getData.R")
source("isg_fun/import_data/transp_data.R")
source("isg_fun/import_data/rcAPI-importData.R")

#### 0.3 Import external strings ####
ini_data <- read.ini(paste0('languages/', language, '.ini'))

#### 1.0 Import Laboratory Data ####
lab_data <- readData(api_url, REDCap_token_lab)
lab_data <- lab_data[lab_data$placa_elisa_complete == "Complete", ]
rownames(lab_data) <- 1:nrow(lab_data)

#### 2.0 Import selected ELISA ####
while (TRUE){
  ELISA_to_import <- dlgList(choices = lab_data$elisa_id, title = ini_data$strings$string4)$res
  i = which(lab_data$elisa_id == ELISA_to_import, arr.ind = TRUE)
  ELISA_to_import <- lab_data$elisa_id
  
  # 0- Check if ELISA was imported previously
  if (is.na(lab_data$elisa_transfer[i])) lab_data$elisa_transfer[i] <- "No"
  if (as.character(lab_data$elisa_transfer[i]) == "Si"){
    answer <- winDialog("yesno", paste(ini_data$strings$string2, ELISA_to_import[i], ini_data$strings$string26))
  if (answer=='NO') break}
  
  # 1- Read records on REDCap-Pacientes
  rep_data <- readData(api_url, REDCap_token_reg)
  if (nrow(rep_data) == 0){
    rep_data <- data.frame(t(rep(NA, 16)))
    colnames(rep_data) <- c("subject_id", "redcap_repeat_instrument", "redcap_repeat_instance", "dob", "sex", "formulario_paciente_complete", "elisa_id", "elisa_date",
                            "elisa_type", "elisa_batch", "elisa_operator", "elisa_cutoff", "elisa_od", "elisa_result", "elisa_observations", "resultados_elisa_complete")}
  
  # 2- Select the ELISA plate
  new_lab_data <- lab_data[lab_data$elisa_id == ELISA_to_import[i],]
  elisa_type <- as.character(new_lab_data$elisa_type)
  elisa_id <- as.character(new_lab_data$elisa_id)
  
  # 2.1- Clean Controls
  for (i in 1:96){
    if (as.character(new_lab_data[1, paste0("elisa_well_", i)]) %in% c("Control +", "Control -")){
      new_lab_data[1, paste0("elisa_well_", i)]      <- NA
      new_lab_data[1, paste0("elisa_sample_id_", i)] <- NA
      new_lab_data[1, paste0("elisa_od_", i)]        <- NA
      new_lab_data[1, paste0("elisa_result_", i)]    <- NA
    }
  }

  ### ERROR 1 --> PLATE VALIDATION ###
  error1 <- c()
  if (new_lab_data$elisa_type == "Chagatest ELISA Recombinante v.3.0 (laboratorio Wiener)"){
    error1 <- wierec_v3(new_lab_data)}
  if (new_lab_data$elisa_type == "Chagatest ELISA Recombinante v.4.0 (laboratorio Wiener)"){
    error1 <- wierec_v4(new_lab_data)}
  if (new_lab_data$elisa_type == "Chagatest ELISA Lisado (laboratorio Wiener)"){
    error1 <- wielis(new_lab_data)}
  if (new_lab_data$elisa_type == "Biozima Chagas Lisado (laboratorio Lemos)"){
    error1 <- biolis(new_lab_data)}
  if (new_lab_data$elisa_type == "Biozima Chagas Recombinante (laboratorio Lemos)"){
    error1 <- biorec(new_lab_data)}
  if (new_lab_data$elisa_type == "ELISA Chagas test IICS v.1.0"){
    error1 <- iics_v1(new_lab_data)}
  if (new_lab_data$elisa_type == "ELISA Chagas test IICS v.2.0"){
    error1 <- iics_v2(new_lab_data)}
  
  if (TRUE %in% (error1 != "Everything ok")){
    answer <- winDialog("yesno", paste(ini_data$strings$string1, elisa_id, '\n\n', paste(error1, collapse = '\n\n'), '\n\n', ini_data$strings$string3))
    if (answer=='NO') break}
  
  ### ERROR 2 --> DUPLICATE RECORDS ###
  ids <- as.character(subset(new_lab_data, select = grepl("elisa_sample_id_", colnames(new_lab_data)) & !is.na(new_lab_data)))
  ids_dupl <- unique(ids[ids %>% duplicated() == TRUE])
  if (length(ids_dupl) > 0){
    error2 <- paste(ini_data$strings$string7, '\n\n', paste(ids_dupl, collapse = ', '), '\n\n')
    answer <- winDialog("yesno", paste(ini_data$strings$string2, elisa_id, '\n\n', error2, ini_data$strings$string20, '\n\n', ini_data$strings$string3))
    if (answer=='NO') break}
  
  ### ERROR 3 --> NON-EXISTENT RECORDS IN PATIENT REDCAP ###
  ids <- as.character(subset(new_lab_data, select = grepl("elisa_sample_id_", colnames(new_lab_data)) & !is.na(new_lab_data)))
  ids_inex <- unique(ids[ids %in% rep_data$subject_id == F])
  if (length(ids_inex) > 0){
    error3 <- paste(ini_data$strings$string22, '\n\n', paste(ids_inex, collapse = ', '), '\n\n')
    answer <- winDialog("yesno", paste(ini_data$strings$string2, elisa_id, '\n\n', error3, ini_data$strings$string23, '\n', ini_data$strings$string3))
    if (answer=='NO') break}
  
  ### Transpose data
  df <- transp_data(new_lab_data)
  
  ### MISSING DATA VALIDATION
  if (is.character(df)){
    answer <- winDialog('ok', ini_data$strings$string29)
    break}
  
  if (nrow(df) == 0){
    answer <- winDialog('ok', paste0(ini_data$strings$string1, elisa_id, '\n\n', ini_data$strings$string28))
    break}
  
  ### ERROR 4 --> RESULTS DO NOT MATCH O.D.
  error4 <- check_result(df)
  if (length(error4) > 0){
    error4 <- paste0(ini_data$strings$string24, '\n\n', paste(error4, collapse = ', '), '\n\n')
    answer <- winDialog('ok', paste0(ini_data$strings$string1, elisa_id, '\n\n', error4, ini_data$strings$string25))
    break}
  
  ### ERROR 5 --> RESULT WAS PREVIOUSLY IMPORTED
  error5 <- check_imported_results(df, rep_data)
  if (error5[[1]]){
    answer <- winDialog("yesno", paste0(ini_data$strings$string21, '\n\n', paste(error5[[2]], collapse = ', '), '\n\n', ini_data$strings$string3))
    if (answer=='NO') break}
  
  ### --> IMPORT RESULTS --> ###
  new_rep_data <- compl_data(df, rep_data)
  new_rep_data$elisa_date <- as.Date(new_rep_data$elisa_date)
  new_rep_data$resultados_elisa_complete <- 2
  
  if (nrow(new_rep_data) > 0) importData(api_url, REDCap_token_reg, new_rep_data)
  
  ### SHOW SUCCESSFUL IMPORT OF RESULTS
  answer <- winDialog("ok", paste(ini_data$strings$string5, nrow(new_rep_data), ini_data$strings$string6, elisa_id))
  
  ### MARK PLATE AS IMPORTED
  new_lab_data$elisa_transfer[1] <- factor('Si') 
  importData(api_url, REDCap_token_lab, new_lab_data)
  
  ### BLOCK ELISA
  if (lock_forms) lock_elisa(elisa_id, REDCap_token_lab, "placa_elisa", api_url, action = "lock")
  
  ### Continue?
  answer <- winDialog("yesno", ini_data$strings$string27)
  if (answer == "NO")  break
}




























