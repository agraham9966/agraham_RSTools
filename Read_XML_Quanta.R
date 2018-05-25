library (XML)
library (plyr)
library (dplyr)
rm(list=ls())
##retrieves timestamp, filter, exposure, lat, long, altitude, yaw, pitch, roll 

files <- list.files(pattern = "*.xml") 
parse_xml <-function(FileName) {
  doc1 <- xmlParse(FileName) 
  doc <- xmlToDataFrame(nodes=getNodeSet(doc1,"//Cameras/Camera"))[c("Filter","Exposure")] 
} 
parse_xml2 <-function(FileName) {
  doc1 <- xmlParse(FileName) 
  doc <- xmlToDataFrame(nodes=getNodeSet(doc1,"//IMU"))[c("Yaw","Pitch", "Roll")] 
} 
parse_xml3 <-function(FileName) {
  doc1 <- xmlParse(FileName) 
  doc <- xmlToDataFrame(nodes=getNodeSet(doc1,"//GPS"))[c("TimeStamp", "Lat", "Long", "Alt")] 
} 
##write to seperate dataframes because R makes things difficult 
Data <- ldply(files,parse_xml) 
Data2 <- ldply(files, parse_xml2)
Data3 <- ldply(files, parse_xml3)
Data2Rep<- Data2[rep(seq_len(nrow(Data2)), each=4),] ##create reps so row #s are equal to 'Data' dataframe
Data3Rep<- Data3[rep(seq_len(nrow(Data3)), each=4),] ##create reps so row #s are equal to 'Data' dataframe

Final_DataFrame<- bind_cols(Data, Data2Rep, Data3Rep) ##merges dataframes into a final dataframe 
write.csv(Final_DataFrame, file = "Camera_Metadata.csv")
