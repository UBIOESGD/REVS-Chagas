# Import data directly through the API
# v1.0
#https://www.rdocumentation.org/packages/redcapAPI/versions/2.3 
##  packageVersion("redcapAPI")

#' @param rcon A REDCap connection object as created by redcapConnection.
#' @param data A data.frame to be imported to the REDCap project.
#' @param overwriteBehavior Character string. 'normal' prevents blank fields from overwriting populated fields. 'overwrite' causes blanks to overwrite data in the REDCap database.
#' @param returnContent Character string. 'count' returns the number of records imported; 'ids' returns the record ids that are imported; 'nothing' returns no message.
importData = function(api_url = "", api_token = "", data = "", overwriteBehavior  = "normal", returnContent  = "count") {
  #api_token<-bisc_token
  rcon = redcapConnection(api_url, api_token)
  
  #returnData Logical. Prevents the REDCap import and instead returns the data frame that would have been given for import. This is sometimes helpful if the API import fails without providing an informative message. The data frame can be written to a csv and uploaded using the interactive tools to troubleshoot the problem. Please shoot me an e-mail if you find errors I havne't accounted for.
  #logfile An optional filepath (preferably .txt) in which to print the log of errors and warnings about the data. If "", the log is printed to the console.
  
  #data<-B_ImpAmb12
  ret = importRecords(rcon, data, overwriteBehavior, returnContent,FALSE, "")

  return(ret)
}
