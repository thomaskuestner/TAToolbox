library(xlsx)

data<-read.table("Measured_vs_Simulated_allDosis_Mask_TK.csv", sep=";", header=T, dec=",")
View(data)


corPearson<-corSpearman<-pTtest<-pWilcoxon<-vector()

for(i in 1:nrow(data)){
  x<-t(data[i,3:6])
  y<-t(data[i,8:11])
  corPearson[i]<-cor(x,y )
  corSpearman[i]<-cor(x,y, method = "spearman")
  pTtest[i]<-t.test(x,y, paired = T)$p.value
  pWilcoxon[i]<-  wilcox.test(x,y, paired = T)$p.value
}


pdf("Scatterplots.pdf")
par(mfrow=c(1,1))
for(i in 1:nrow(data)){
  x<-t(data[i,3:6])
  y<-t(data[i,8:11])
  plot(x,y, main=data[i,1], xlab=paste0("Measured"), ylab="Simulation")
  lhelp<-c(paste0("Pearson Correlation: ", round(corPearson[i], 2)), 
           paste0("Spearman Correlation: ", round(corSpearman[i], 2)),
            paste0("t-Test (p-Value): ", round(pTtest[i], 2)), 
           paste0("Wilcoxon (p-Value): ", round(pWilcoxon[i], 2)))
  legend("topleft", legend = lhelp)
  points(x,y, main=data[i,1])
  abline(0,1)
}
dev.off()
