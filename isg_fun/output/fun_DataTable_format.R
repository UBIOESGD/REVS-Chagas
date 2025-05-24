
#############################################################################
## functions to formatting DataTables
#############################################################################

#Script version
fun_version<-"1.1"

tab_color <- function(var, var_error) { 
  ifelse(var_error,"firebrick",ifelse(is.na(var),"lightgrey","steelblue"))
}

# tab_errors <- function(err_no, err_low) { 
#   ifelse(err_no,"steelblue",ifelse(err_low,"orange","firebrick"))
# }
# 
# tab_backg <- function(var, var_highlight) { 
#   ifelse(var_highlight,"lightgreen","")
# }

concat_multicheck_5<- function(op1,op2,op3,op4,op5){
  paste(op1,op2,op3,op4,op5,sep = "-")
}
concat_multicheck_7<- function(op1,op2,op3,op4,op5,op6,op7){
  paste(op1,op2,op3,op4,op5,op6,op7,sep = "-")
}
concat_multicheck_4<- function(op1,op2,op3,op4){
  paste(substr(op1, 1, 10)
        ,substr(op2, 1, 10)
        ,substr(op3, 1, 10)
        ,substr(op4, 1, 10)
        ,sep = "-")
}

format_nocomplete_table <- function(dat, select_var){
  z <- dat %>%
    mutate(
      cuestionario_paciente_esp_complete = cell_spec(cuestionario_paciente_esp_complete, "html", color = tab_color(cuestionario_paciente_esp_complete, f1_c)),
      calidad_vida_complete = cell_spec(calidad_vida_complete, "html", color = tab_color(calidad_vida_complete, f2_c)),
    ) %>%
    select(all_of(select_var))
  
  return(z)
}


format_missings_table <- function(missings_data, miss_var){
  z <- missings_data %>%
    mutate(
      d_interview = cell_spec(d_interview, "html", color = tab_color(d_interview, m0)),
      sex = cell_spec(sex, "html", color = tab_color(sex, m1)),
      d_born = cell_spec(d_born, "html", color = tab_color(d_born, m2)),
      niv_esc = cell_spec(niv_esc, "html", color = tab_color(niv_esc, m3)),
      ocup = cell_spec(ocup, "html", color = tab_color(ocup, m4)),
      eq5d_healthtoday_spa_qol = cell_spec(eq5d_healthtoday_spa_qol, "html", color = tab_color(eq5d_healthtoday_spa_qol, m5))
    ) %>%
    select(all_of(miss_var))
  
  return(z)
  
}

#Rangos oor_data
format_range_table <- function(oor_data, oor_var){
  z <- oor_data %>%
    mutate(
      edad = cell_spec(edad, "html", color = tab_color(edad, r1)),
      eq5d_healthtoday_spa_qol = cell_spec(eq5d_healthtoday_spa_qol, "html", color = tab_color(eq5d_healthtoday_spa_qol, r2))
    ) %>%
    select(all_of(oor_var))
  
  return(z)
  
}

