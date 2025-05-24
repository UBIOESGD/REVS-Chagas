############################################################################
####                         ELISA data management                      ####
####                           ISGlobal UBIOESGD                        ####
####                            Feb 2024 - v2.2                         ####
############################################################################

# v2.0: Estudio con DAG: flag dag_enabled, Estudio orden elisa relevante: orden_elisas, expresion identificacion elisa_id: regexp_elisa_id
# v2.1: Limpieza de variables no necesarias, vienen calculadas en lab_results
# v2.2: Inclusion del limite en el calculo de la media de los controles negativos

mean_ctrl <- function(ctr1,ctr2)
{
  m = round(((ctr1+ctr2)/2), 3)
}

mean_ctrl3 <- function(ctr1,ctr2,ctr3)
{
  #print(paste("control 3: ",ctr3))
  m = round(((ctr1+ctr2+ctr3)/3), 3)
  # vect=c(ctr1,ctr2,ctr3)
  # m = mean(vect)
  # print(paste("vect: ",vect, " media=",m))
}

mean_ctrl_limit <- function(ctr1,ctr2,ctr3,limit)
{
  #print(paste("control 3: ",ctr3))
  vect=c(ctr1,ctr2,ctr3)
  m = mean(vect[vect<=limit])
  #m = round(((ctr1+ctr2+ctr3)/3), 3)
}

media_ctrl_old <- function(elisa_controls,limit=0)
{
  
  m = mean(elisa_controls)
  
  if (limit!=0)
    m = mean(elisa_controls[elisa_controls<=limit])
  
  round(m, 3)
}

# Reestructurar les dades de LAB (ELISAS)
resultados_elisas <- function(lab_results, dag_enabled=TRUE, orden_elisas=TRUE, regexp_elisa_id=""){
  resultados <- list()
  if (dag_enabled & orden_elisas)
    res<-data.frame(matrix(ncol=14,nrow=0, 
                           dimnames=list(NULL, c("elisa_id","sitio","elisa_date","elisa_type_desc","elisa_val","orden_elisa","elisa_cutoff","cut_off_calc","elisa_transfer","placa_elisa_complete","well","sample_id","od","result"))
    ))
  else if(!dag_enabled&!orden_elisas)
    res<-data.frame(matrix(ncol=12,nrow=0, 
                           dimnames=list(NULL, c("elisa_id","elisa_date","elisa_type_desc","elisa_val","elisa_cutoff","cut_off_calc","elisa_transfer","placa_elisa_complete","well","sample_id","od","result"))
    ))
  else{
    #TODO: If REDCap is defined with DAGs (dag_enabled: sitio) or the order of ELISA is important for diagnostic (orden_elisas: orden_elisa
  } 
    
  data<-lab_results
  # fins a 96 mostres per placa ELISA: coordenades A1,B1,C1..H1, A2..H2,...A12..H12
  for(i in 1:96) {
    
    var_we<-paste("elisa_well_",i,sep="")
    var_sn<-paste("elisa_sample_id_",i,sep="")
    var_do<-paste("elisa_od_",i,sep="")
    var_rs<-paste("elisa_result_",i,sep="")
    
    posiciones_placa = paste0(rep(LETTERS[1:8]), rep(1:12, each=8))
    
    if (dag_enabled & orden_elisas){
      res_tmp<-data[,c("elisa_id","sitio","elisa_date","elisa_type_desc","elisa_val","orden_elisa","elisa_cutoff","cut_off_calc","elisa_transfer","placa_elisa_complete",var_we, var_sn,var_do,var_rs)]
      res_tmp<-res_tmp%>%mutate(pos=posiciones_placa[i]) #posicion_placa
      colnames(res_tmp)<-c("elisa_id","sitio","elisa_date","elisa_type_desc","elisa_val","orden_elisa","elisa_cutoff","cut_off_calc","transferida","completa","well","sample_id","od","result","posicion_placa")
    }else if(!dag_enabled&!orden_elisas){
      res_tmp<-data[,c("elisa_id","elisa_date","elisa_type_desc","elisa_val","elisa_cutoff","cut_off_calc","elisa_transfer","placa_elisa_complete",var_we, var_sn,var_do,var_rs)]
      res_tmp<-res_tmp%>%mutate(pos=posiciones_placa[i]) #posicion_placa
      colnames(res_tmp)<-c("elisa_id","elisa_date","elisa_type_desc","elisa_val","elisa_cutoff","cut_off_calc","transferida","completa","well","sample_id","od","result","posicion_placa")
    }else{
      #TODO: If REDCap is defined with DAGs (dag_enabled: sitio) or the order of ELISA is important for diagnostic (orden_elisas: orden_elisa)
      res_tmp<-data.frame()
    }
    
    res <- rbind(res,res_tmp)
  }
  
  if (regexp_elisa_id=="") { 
    errors <- res %>% filter(FALSE)
  }
  else {
    if (regexp_elisa_id=="ChagasLAMP"){ #ChagasLAMP mares i bebes
      errors <- res %>% 
        filter((!is.na(elisa_id) & !grepl("ChL-LB|SE|AS|VH|SU|TA|CB|YA|SC-M-\\d",elisa_id)) & (!is.na(elisa_id) & !grepl("ChL-LB|SE|AS|VH|SU|TA|CB|YA|SC-B-\\d",elisa_id)))
      
      res <- res %>% 
        filter((!is.na(elisa_id)&grepl("ChL-LB|SE|AS|VH|SU|TA|CB|YA|SC-M-\\d",elisa_id)) & !is.na(elisa_id)&grepl("ChL-LB|SE|AS|VH|SU|TA|CB|YA|SC-B-\\d",elisa_id))
    }
    else{
      errors <- res %>% 
        filter(
          (!is.na(elisa_id) & !grepl(regexp_elisa_id,elisa_id))
        ) 
      res <- res %>% 
        filter(
          (!is.na(elisa_id)&grepl(regexp_elisa_id,elisa_id))
        )
    }
  }
  #print(errors[,c("elisa_id","elisa_id","posicion_placa")])
  resultados[["errors"]] <- errors
  resultados[["res"]] <- res
  
  return(resultados)
}
