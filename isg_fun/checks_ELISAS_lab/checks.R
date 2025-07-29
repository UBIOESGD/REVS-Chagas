###############################################
####  SUPPORT FUNCTIONS TO ELISA_transf.R  ####
####          ISGLOBAL - UBIOESDM          ####
###############################################

# Wiener Recombinante v3
wierec_v3 <- function(new_lab_data){
  message0 <- ""
  message1 <- ""
  message2 <- ""
  message3 <- ""
  
  # CRITERIA 0: Check if missing data
  vars <- c("elisa_neg_ctrl_1", "elisa_neg_ctrl_2", "elisa_neg_ctrl_3", "elisa_pos_ctrl_1", "elisa_pos_ctrl_2", "elisa_cutoff")
  error0 <- sum(is.na(new_lab_data[, vars]))
  if(error0>0){
    message0 <- ini_data$strings$string8
    return(message0)}
  
  # CRITERIA 1: The O.D. readings of at least two of the three negative controls are ≤ 0.150
  error1 <- sum(ifelse(new_lab_data$elisa_neg_ctrl_1 <= 0.150, 1, 0), 
                ifelse(new_lab_data$elisa_neg_ctrl_2 <= 0.150, 1, 0),
                ifelse(new_lab_data$elisa_neg_ctrl_3 <= 0.150, 1, 0))
  
  if(error1<2){message1 <- ini_data$strings$string19}
  
  # EXTRA: Select NC <= 0.150
  CN <- c(new_lab_data$elisa_neg_ctrl_1, new_lab_data$elisa_neg_ctrl_2, new_lab_data$elisa_neg_ctrl_3)
  if (error1 >= 2){
    CN <- CN[which(CN <= 0.150)]}
  
  # CRITERIA 2: OD averahe of positive controls must be >=0.600.
  CP <- c(new_lab_data$elisa_pos_ctrl_1, new_lab_data$elisa_pos_ctrl_2)
  error2 <- ifelse(mean(CP)>=0.6, 1, 0)
  if(error2==0){
    message2 <- ini_data$strings$string10}
  
  # CRITERIA 3: Cut-off = NC average + 0.300
  cut_off <- round(mean(CN), 3) + 0.300
  if (round(cut_off, 3)  != round(new_lab_data$elisa_cutoff, 3)){
    message3 <- ini_data$strings$string11}
  
  vec <- c(message0, message1, message2, message3)
  vec <- vec[nchar(vec) > 0]
  if (length(vec) == 0) vec <- "Everything ok"
  
  return(vec)
}

# Wiener Recombinante v4
wierec_v4 <- function(new_lab_data){
  message0 <- ""
  message1 <- ""
  message2 <- ""
  message3 <- ""
  message4 <- ""
  
  # CRITERIA 0: Check if missing data
  vars <- c("elisa_neg_ctrl_1", "elisa_neg_ctrl_2", "elisa_neg_ctrl_3", "elisa_pos_ctrl_1", "elisa_pos_ctrl_2", "elisa_cutoff")
  error0 <- sum(is.na(new_lab_data[, vars]))
  if(error0>0){
    message0 <- ini_data$strings$string8
    return(message0)}
  
  # CRITERIA 1: The O.D. readings of at least two of the three negative controls are <=0.100.
  error1 <- sum(ifelse(new_lab_data$elisa_neg_ctrl_1 <= 0.100, 1, 0), 
                ifelse(new_lab_data$elisa_neg_ctrl_2 <= 0.100, 1, 0),
                ifelse(new_lab_data$elisa_neg_ctrl_3 <= 0.100, 1, 0))
  
  if(error1<2) message1 <- ini_data$strings$string9
  
  # EXTRA: Select NC <= 0.100
  CN <- c(new_lab_data$elisa_neg_ctrl_1, new_lab_data$elisa_neg_ctrl_2, new_lab_data$elisa_neg_ctrl_3)
  if (error1 >= 2){
    CN <- CN[which(CN <= 0.100)]}
  
  # CRITERIA 2: OD average of positive controls must be >=1.300
  CP <- c(new_lab_data$elisa_pos_ctrl_1, new_lab_data$elisa_pos_ctrl_2)
  error2 <- ifelse(mean(CP) >= 1.300, 1, 0)
  if(error2==0) message2 <- ini_data$strings$string12
  
  # CRITERIA 3: Cut-off = NC average + 0.200
  cut_off <- round(mean(CN), 3) + 0.200
  if (round(cut_off, 3)  != round(new_lab_data$elisa_cutoff, 3)) message3 <- ini_data$strings$string11
  
  # CRITERIA 4: Difference between PC average and NC must be >= 1.200
  if (mean(CP) - mean(CN) < 1.200) message4 <- ini_data$strings$string11
  
  vec <- c(message0, message1, message2, message3, message4)
  vec <- vec[nchar(vec) > 0]
  if (length(vec) == 0) vec <- "Everything ok"
  
  return(vec)
}

# Wiener Lisado
wielis <- function(new_lab_data){
  message0 <- ""
  message1 <- ""
  message2 <- ""
  message3 <- ""
  message4 <- ""
  
  # CRITERIA 0: Check if missing data
  vars <- c("elisa_neg_ctrl_1", "elisa_neg_ctrl_2", "elisa_neg_ctrl_3", "elisa_pos_ctrl_1", "elisa_pos_ctrl_2", "elisa_cutoff")
  error0 <- sum(is.na(new_lab_data[, vars]))
  if(error0>0){
    message0 <- ini_data$strings$string8
    return(message0)}
  
  # CRITERIA 1: The O.D. readings of at least two of the three negative controls are <=0.100.
  error1 <- sum(ifelse(new_lab_data$elisa_neg_ctrl_1 <= 0.100, 1, 0), 
                ifelse(new_lab_data$elisa_neg_ctrl_2 <= 0.100, 1, 0),
                ifelse(new_lab_data$elisa_neg_ctrl_3 <= 0.100, 1, 0))
  
  if (error1<2) message1 <- ini_data$strings$string9
  
  # EXTRA: Select NC <= 0.100
  CN <- c(new_lab_data$elisa_neg_ctrl_1, new_lab_data$elisa_neg_ctrl_2, new_lab_data$elisa_neg_ctrl_3)
  if (error1 >= 2){
    CN <- CN[which(CN <= 0.100)]}
  
  # CRITERIA 2: OD average of positive controls must be >=1.300
  CP <- c(new_lab_data$elisa_pos_ctrl_1, new_lab_data$elisa_pos_ctrl_2)
  error2 <- ifelse(mean(CP)>=1.300, 1, 0)
  if(error2==0) message2 <- ini_data$strings$string12
  
  # CRITERIA 3: Cut-off = NC average + 0.200
  cut_off <- round(mean(CN), 3)  + 0.200
  if (round(cut_off, 3) != round(new_lab_data$elisa_cutoff, 3)) message3 <- ini_data$strings$string11
  
  # CRITERIA 4: Difference between PC average and NC must be >= 1.200
  if (mean(CP) - mean(CN) < 1.200) message4 <- ini_data$strings$string13
  
  vec <- c(message0, message1, message2, message3, message4)
  vec <- vec[nchar(vec) > 0]
  if (length(vec) == 0) vec <- "Everything ok"
  
  return(vec)
}

# Biozima Lisado
biolis <- function(new_lab_data){
  message0 <- ""
  message1 <- ""
  message2 <- ""
  message3 <- ""
  
  # CRITERIA 0: Check if missing data
  vars <- c("elisa_neg_ctrl_1", "elisa_neg_ctrl_2", "elisa_pos_ctrl_1", "elisa_cutoff")
  error0 <- sum(is.na(new_lab_data[, vars]))
  if(error0>0){
    message0 <- ini_data$strings$string8
    return(message0)}
  
  # CRITERIA 1: OD average of negative controls must be < 0.250
  CN <- c(new_lab_data$elisa_neg_ctrl_1, new_lab_data$elisa_neg_ctrl_2)
  error1 <- mean(CN) 
  if (error1 >= 0.250) message1 <- ini_data$strings$string14
  
  # CRITERIA 2: OD average of positive controls must be >= cutoff
  CP <- c(new_lab_data$elisa_pos_ctrl_1)
  error2 <- ifelse(CP >= new_lab_data$elisa_cutoff, 1, 0)
  if(error2==0) message2 <- ini_data$strings$string15
  
  # CRITERIA 3: Cut-off = NC average + 0.100
  cut_off <- round(mean(CN), 3) + 0.100
  if (round(cut_off, 3) != round(new_lab_data$elisa_cutoff, 3)) message3 <- ini_data$strings$string11
  
  vec <- c(message0, message1, message2, message3)
  vec <- vec[nchar(vec) > 0]
  if (length(vec) == 0) vec <- "Everything ok"
  
  return(vec)
}

# Biozima Recombinante
biorec <- function(new_lab_data){
  message0 <- ""
  message1 <- ""
  message2 <- ""
  message3 <- ""
  message4 <- ""
  
  # CRITERIA 0: Check if missing data
  vars <- c("elisa_neg_ctrl_1", "elisa_neg_ctrl_2", "elisa_pos_ctrl_1", "elisa_cutoff")
  error0 <- sum(is.na(new_lab_data[, vars]))
  if(error0>0){
    message0 <- ini_data$strings$string8
    return(message0)}
  
  # CRITERIA 1: Average of negative controls must be < 0.250
  CN <- c(new_lab_data$elisa_neg_ctrl_1, new_lab_data$elisa_neg_ctrl_2)
  if (mean(CN) >= 0.250) message1 <- ini_data$strings$string16
  
  # CRITERIA 2: OD of positive controls must be >=0.500
  CP <- new_lab_data$elisa_pos_ctrl_1
  error2 <- ifelse(CP >= 0.500, 1, 0)
  if(error2==0) message2 <- ini_data$strings$string12
  
  # CRITERIA 3: Cut-off = NC average + 0.100
  cut_off <- round(mean(CN), 3) + 0.100
  if (round(cut_off, 3) != round(new_lab_data$elisa_cutoff, 3)) message3 <- ini_data$strings$string11
  
  vec <- c(message0, message1, message2, message3)
  vec <- vec[nchar(vec) > 0]
  if (length(vec) == 0) vec <- "Everything ok"
  
  return(vec)
}

# IICS v1
iics_v1 <- function(new_lab_data){
  message0 <- ""
  message1 <- ""
  message2 <- ""
  message3 <- ""
  
  # CRITERIA 0: Check if missing data
  vars <- c("elisa_neg_ctrl_1", "elisa_neg_ctrl_2", "elisa_pos_ctrl_1", "elisa_pos_ctrl_2", "elisa_pos_ctrl_weak_1", "elisa_pos_ctrl_weak_2", "elisa_cutoff")
  error0 <- sum(is.na(new_lab_data[, vars]))
  if(error0 > 0){
    message0 <- ini_data$strings$string8
    return(message0)}
  
  # CRITERIA 1: Average negative controls must be < 0.250
  CN <- c(new_lab_data$elisa_neg_ctrl_1, new_lab_data$elisa_neg_ctrl_2)
  if (mean(CN) >= 0.250){
    message1 <- ini_data$strings$string16}
  
  # CRITERIA 2: Average weak positive controls must be >= 0.400
  CP_weak <- c(new_lab_data$elisa_pos_ctrl_weak_1, new_lab_data$elisa_pos_ctrl_weak_2)
  if (mean(CP_weak) < 0.400){
    message2 <- ini_data$strings$string17}
  
  # CRITERIA 3: Cut-off = NC average + 0.200
  cut_off <- round(mean(CN), 3) + 0.200
  if (round(cut_off, 3) != round(new_lab_data$elisa_cutoff, 3)){
    message3 <- ini_data$strings$string11}
  
  vec <- c(message0, message1, message2, message3)
  vec <- vec[nchar(vec) > 0]
  if (length(vec) == 0) vec <- "Everything ok"
  
  return(vec)
}

# IICS v2
iics_v2 <- function(new_lab_data){
  message0 <- ""
  message1 <- ""
  message2 <- ""
  message3 <- ""
  
  # CRITERIA 0: Check if missing data
  vars <- c("elisa_neg_ctrl_1", "elisa_neg_ctrl_2", "elisa_pos_ctrl_1", "elisa_pos_ctrl_2", "elisa_pos_ctrl_weak_1", "elisa_pos_ctrl_weak_2", "elisa_cutoff")
  error0 <- sum(is.na(new_lab_data[, vars]))
  if(error0 > 0){
    message0 <- ini_data$strings$string8
    return(message0)}
  
  # CRITERIA 1: Average of negative controls must be <= 0.150
  CN <- c(new_lab_data$elisa_neg_ctrl_1, new_lab_data$elisa_neg_ctrl_2)
  if (mean(CN) > 0.150) message1 <- ini_data$strings$string18
  
  # CRITERIA 2: Average of weak positive controls must be >= 0.400
  CP_weak <- c(new_lab_data$elisa_pos_ctrl_weak_1, new_lab_data$elisa_pos_ctrl_weak_2)
  if (mean(CP_weak) < 0.400) message2 <- ini_data$strings$string17
  
  # CRITERIA 3: Cut-off = NC average + 0.200
  cut_off <- round(mean(CN), 3) + 0.2
  if (round(cut_off, 3) != round(new_lab_data$elisa_cutoff, 3)) message3 <- ini_data$strings$string11
  
  vec <- c(message0, message1, message2, message3) 
  vec <- vec[nchar(vec) > 0]
  if (length(vec) == 0) vec <- "Everything ok"
  
  return(vec)
}


#'@find_instance 
#'  --> finds the corresponding instance of the record
find_instance <- function(rep_data, id){
  df1 <- rep_data[rep_data$subject_id == id,]
  if (nrow(df1) == 0) return(0)
  instance <- as.numeric(ifelse(length(df1$redcap_repeat_instance) == 1, 0, max(df1$redcap_repeat_instance, na.rm = TRUE)))
  return(instance)
}


#'@compl_data 
#'  --> completes data from lab and adapts it to the required format
compl_data <- function(df, rep_data){
  
  ids <- df$studyno
  df_aux <- as.data.frame(matrix(NA, length(ids), 16))
  colnames(df_aux) <- colnames(rep_data)
  df_aux$subject_id <- ids
  df_aux$dob <- as.Date(df_aux$dob)
  
  for (i in 1:nrow(df_aux)){
    pat_id <- df_aux$subject_id[i]
    elisa_type <- df$elisa_type[df$studyno == pat_id]
    df_aux$elisa_id <- df$elisa_id[i]
    df_aux$redcap_repeat_instrument[i] <- 'resultados_elisa'
    df_aux$redcap_repeat_instance[i]   <- find_instance(rep_data, pat_id) + 1
    df_aux$elisa_observations[i]       <- df$elisa_observations[df$studyno == pat_id]
    
    df_aux$elisa_operator[i] <- df$nom[df$studyno == pat_id]
    #df_aux$elisa_date[i]     <- as.character(as.Date(df$elisa_date[df$studyno == pat_id]))
    df_aux$elisa_date[i]     <- format(df$elisa_date[df$studyno == pat_id], "%Y-%m-%d")
    df_aux$elisa_batch[i]    <- df$elisa_batch[df$studyno == pat_id]
    df_aux$elisa_cutoff[i]   <- df$elisa_cutoff[df$studyno == pat_id]
    df_aux$elisa_od[i]       <- df$do[df$studyno == pat_id]
    df_aux$elisa_result[i]   <- df$result[df$studyno == pat_id]
    
    df_aux$elisa_type[i] <- ifelse(elisa_type == "Chagatest ELISA Recombinante v.3.0 (laboratorio Wiener)", "wierec3",
                                   ifelse(elisa_type == "Chagatest ELISA Recombinante v.4.0 (laboratorio Wiener)", "wierec4",
                                          ifelse(elisa_type == "Chagatest ELISA Lisado (laboratorio Wiener)", "wielis", 
                                                 ifelse(elisa_type == "Biozima Chagas Recombinante (laboratorio Lemos)", "lemrec",
                                                        ifelse(elisa_type == "Biozima Chagas Lisado (laboratorio Lemos)", "lemlis",
                                                               ifelse(elisa_type == "ELISA Chagas test IICS v.1.0", "iics1", "iics2"))))))
  }
  
  ids_modif <- make.unique(df_aux$subject_id)
  for (i in 1:nrow(df_aux)){
    if (df_aux$subject_id[i] != ids_modif[i]){
      df_aux$redcap_repeat_instance[i] <- as.numeric(strsplit(ids_modif[i], split = '\\.')[[1]][2]) + 1}}
  
  return(df_aux)
}


#'@check_result
#'  --> compares the result between the expected and the introduced depending on the ELISA type
check_result <- function(df){
  
  wrong_res <- c()
  for (i in 1:nrow(df)){
    
    #### First criteria type ####
    if (df$elisa_type[i] == "ELISA Chagas test IICS v.2.0"){
      
      prom <- df$do[i]/df$elisa_cutoff[i]
      if (prom <= 1.1 & df$result[i] != 0) wrong_res <- append(wrong_res, df$studyno[i])               # check incorrect negatives
      if (prom >= 1.3 & df$result[i] != 1) wrong_res <- append(wrong_res, df$studyno[i])               # check incorrect positives
      if (prom >  1.1 & prom < 1.3 & df$result[i] != 9) wrong_res <- append(wrong_res, df$studyno[i])} # check incorrect indeterminates
    
    #### Second criteria type ####
    if (df$elisa_type[i] == "Chagatest ELISA Recombinante v.4.0 (laboratorio Wiener)" |
        df$elisa_type[i] == "Chagatest ELISA Lisado (laboratorio Wiener)" |
        df$elisa_type[i] == "Biozima Chagas Lisado (laboratorio Lemos)" |
        df$elisa_type[i] == "ELISA Chagas test IICS v.1.0"){
      
      if (df$do[i] >= df$elisa_cutoff[i] & df$result[i] != 1) wrong_res <- append(wrong_res, df$studyno[i])  # check incorrect negatives
      if (df$do[i] <  df$elisa_cutoff[i] & df$result[i] != 0) wrong_res <- append(wrong_res, df$studyno[i])} # check incorrect positives
    
    #### Third criteria type ####
    if (df$elisa_type[i] == "Chagatest ELISA Recombinante v.3.0 (laboratorio Wiener)" |
        df$elisa_type[i] == "Biozima Chagas Recombinante (laboratorio Lemos)"){
      
      cutoff_down <- df$elisa_cutoff[i] - 0.1* df$elisa_cutoff[i]
      cutoff_up   <- df$elisa_cutoff[i] + 0.1* df$elisa_cutoff[i]
      
      if (df$do[i] <  cutoff_down & df$result[i] != 0) wrong_res <- append(wrong_res, df$studyno[i])                         # check incorrect positives
      if (df$do[i] >= cutoff_up   & df$result[i] != 1) wrong_res <- append(wrong_res, df$studyno[i])                         # check incorrect negatives
      if (df$do[i] >= cutoff_down & df$do[i] < cutoff_up & df$result[i] != 9) wrong_res <- append(wrong_res, df$studyno[i])} # check incorrect indeterminates
  }
  
  return(wrong_res)
}


#'@lock_elisa
#'  --> locks ELISA plate on lab REDCap 
lock_elisa <- function(ELISA_to_import, token, instrument, api_url, action){
  curl <- paste0("curl -d token=", REDCap_token_lab, "&returnFormat=csv&record=", ELISA_to_import, "&instrument=", 
                 instrument, " ", api_url, "?NOAUTH&type=module&prefix=locking_api&page=", action)
  system(curl)}


#'@check_imported_results
#'  --> check if elisa was previously imported
check_imported_results <- function(df, rep_data){
  foo1 <- paste(df$studyno, df$elisa_batch, sep = '|||')
  foo2 <- paste(rep_data$subject_id, rep_data$elisa_batch, sep = '|||')
  
  already <- foo1[sapply(foo1, function (x) (x %in% foo2) == TRUE)]
  already <- as.character(sapply(already, function (x) strsplit(x, "|||", fixed = TRUE)[[1]][1]))
  
  if (length(already) == 0) return(list(FALSE))
  
  return(list(TRUE, already))
}


















