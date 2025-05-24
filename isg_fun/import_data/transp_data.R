# Reestructurar les dades de LAB (ELISAS)

transp_data <- function(new_lab_data){
  vars <- c("elisa_id", "elisa_date", "elisa_type", "elisa_observations", "elisa_batch", "elisa_cutoff", "elisa_calc_cutoff") # falta dag
  new_data <- new_lab_data[1, vars]
  
  new_data$studyno <- new_lab_data$elisa_sample_id_1[1]
  new_data$do      <- new_lab_data$elisa_od_1[1]
  new_data$result  <- new_lab_data$elisa_result_1[1]
  new_data$nom     <- new_lab_data$elisa_operator[1]
  new_data$pocillo <- new_lab_data$elisa_well_1[1]
  
  for(i in 1:nrow(new_lab_data)){
    for(j in 1:96){
      studyno <- new_lab_data[i, paste0('elisa_sample_id_', j)]
      do      <- new_lab_data[i, paste0('elisa_od_', j)]
      result  <- new_lab_data[i, paste0('elisa_result_', j)]
      pocillo <- new_lab_data[i, paste0('elisa_well_', j)]
      data_aux <- new_lab_data[i, vars]
      data_aux$studyno <- studyno
      data_aux$pocillo <- pocillo
      data_aux$do      <- do
      data_aux$result  <- result
      data_aux$nom     <- new_lab_data$elisa_operator[1]
      new_data <- rbind(new_data, data_aux)
    }
  }
  
  new_data <- new_data[-c(1),]
  levels(new_data$result) <- c(1, 0, 9)
  new_data$result <- as.character(new_data$result)
  new_data <- new_data %>% drop_na(studyno)
  if (TRUE %in% is.na(new_data[,6:12])) return("missing info")
  new_data <- new_data[!is.na(new_data$pocillo) & new_data$pocillo == "Muestra",]
  
  return(new_data)
}








