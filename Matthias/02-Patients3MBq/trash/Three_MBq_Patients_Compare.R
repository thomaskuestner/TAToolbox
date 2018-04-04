#library(R.matlab)

fileNames<-list.files("data2R")
fileNames_TF_values<-fileNames[!grepl("ROI", fileNames)]
fileNames_ROI_Sizes<-fileNames[grepl("ROI", fileNames)]
dataMatthieu<-data.frame()

dataSize<-vector()
for(i in 1:length(fileNames_TF_values)){
  df<-read.csv(paste0("data2R/", fileNames_TF_values[i]), header=F)[,1:11]
  colnames(df)<-paste0("dose", 1:11)
  rownames(df)<-paste0("TF", 1:42)
  
  dataMatthieu<-rbind(dataMatthieu, df)
  
  df2<-read.csv(paste0("data2R/", fileNames_ROI_Sizes[i]), header=F)
  dataSize[i]<-df2[1,1]
}

w1<-which(dataSize<6000 | dataSize>7500)

dataMatthieu<-cbind(PID=factor(rep(1:19, each=42)), dataMatthieu)
dataMatthieu<-cbind(TF=factor(rep(1:42, 19)), dataMatthieu)
dataMatthieu$colour<-1*(dataMatthieu$PID %in% w1)

library("tidyr")
library(tidyr)
library(ggplot2)

data_long <- gather(dataMatthieu, dose, value, dose1:dose11, factor_key=TRUE)

df_mean<-aggregate(data_long$value, by=list(data_long$TF,data_long$dose), mean)
df_sd<-aggregate(data_long$value, by=list(data_long$TF,data_long$dose), sd)

cols<-c("#9999CC","#CC6666")

for(i in 1:42){
  cc<-cols[data_long$colour+1]
  p <- ggplot(data = data_long[data_long$TF==i,], 
              aes(x = dose, y = value, group = PID))
  p+geom_line()+geom_point(colour=cc[data_long$TF==i])
  
  ggsave(paste0("plot_",i,".tiff"))
}



p <- ggplot(data = df_mean[which(df_mean$Group.1==2),], aes(x = Group.2, y = x, group = Group.1))
p+geom_line()

outlierdf<-data.frame(TF=vector(), PID=vector())

for(i in 1:42){
  temp<-data_long[data_long$TF==i,]
  vv<-temp$value
  iqr<-(quantile(vv, 0.75) -  quantile(vv, 0.25))
  
  outliers<-unique(temp[which(vv> median(vv)+1.5*iqr  | vv < median(vv) - 1.5*iqr),"PID"])
  outlierdf<-rbind(outlierdf, data.frame(TF=rep(i, length(outliers)), PID=outliers))
}


summary(outlierdf)
unique(outlierdf$PID)

write.csv(outlierdf, file="outlier_per_TF.csv", quote=F)


