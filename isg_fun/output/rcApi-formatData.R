############################################################################
####                       FORMATTING REDCap data                       ####
####                           ISGlobal UBIOESGD                        ####
####                           Abr 2022 - v1.0                          ####
############################################################################

#### TIPS ####
## Link to the REDCap record: https://datacapture.isglobal.org/redcap_v10.7.1/DataEntry/index.php?pid=213&id=10000111&page=reclutament_mare&event_id=547&instance=1
# pid=213 El codi del projecte REDCap
# id=10000111 El record_id
# page=reclutament_mare Form
# event_id=547 Event si hi ha
# instance=1 Aixo no se que pot ser....

link_redcap = function(pid, id, form="")
{
  if (form!="")
    ## https://datacapture.isglobal.org/redcap_v10.7.1/DataEntry/index.php?pid=60&id=152&event_id=634&page=informacin_clnica_tratamiento_contactos_segui_6aa0
    link=paste0("<a href='https://datacapture.isglobal.org/redcap_v10.7.1/DataEntry/index.php?pid=",pid,"&id=",id,"&event_id=634&page=",form,"'>",id,"</a>")
  else
    #https://datacapture.isglobal.org/redcap_v10.7.1/DataEntry/record_home.php?pid=60&id=152&arm=1
    link=paste0("<a href='https://datacapture.isglobal.org/redcap_v10.7.1/DataEntry/record_home.php?pid=",pid,"&arm=1&id=",id,"'>",id,"</a>")
  
  return(link)
}
