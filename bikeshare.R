library(glmnet)
library(dummies)
library(grplasso)
setwd(getwd())
source("functions_refit_bic.R")
mydata=read.csv("bikehour.csv",header=T)
y=log(mydata[,ncol(mydata)])


mydata$weathersit=(mydata$weathersit==1)
cate_x=mydata[,c(3:10)]
cate_x=as.data.frame(sapply(cate_x,as.character))
temp=rep(0,ncol(cate_x))
for(i in 1:ncol(cate_x)){
  temp[i]=length(levels(cate_x[,i]))
}
index=c(NA,rep(c(1:length(temp)),(temp-1)))

temp0=rep(0,length(temp))
for(i in 1:length(temp)){
  temp0[i]=sum(temp[1:i])
}
cate_x=dummy.data.frame(cate_x)
cate_x=cate_x[,-temp0]

scale_x=scale(mydata[,11:16])
x=cbind(1,scale(cate_x),scale_x)
data=as.matrix(data.frame(x,y))
index=c(index,(max(index,na.rm=T)+1):(max(index,na.rm=T)+6))
dim(data)
head(data)

p=ncol(data)-2  ###covariate number
n=nrow(data)
tau=0.8
iter.num=50

outputPath=paste("./results_bike")
if(!dir.exists(outputPath)){
  dir.create(outputPath)
}

##################################################################################
#################################################
################ gamma=0.6 ######################
#grouplasso
res_06<-BLB_grp(data,0.6,index,iter.num,tau,s=30,
                family="gaussian")
write.csv(res_06$beta_hat,paste(outputPath,"/beta_06.csv",sep=""),row.names = F)
write.csv(res_06$tim_cum,paste(outputPath,"/time_06.csv",sep=""),row.names = F)


################ gamma=0.7 ######################
res_07<-BLB_grp(data,0.7,index,iter.num,tau,s=20,
                family="gaussian")
write.csv(res_07$beta_hat,paste(outputPath,"/beta_07.csv",sep=""),row.names = F)
write.csv(res_07$tim_cum,paste(outputPath,"/time_07.csv",sep=""),row.names = F)


################ gamma=0.8 ######################
res_08<-BLB_grp(data,0.8,index,iter.num,tau,s=10,
                family="gaussian")
write.csv(res_08$beta_hat,paste(outputPath,"/beta_08.csv",sep=""),row.names=F)
write.csv(res_08$tim_cum,paste(outputPath,"/time_08.csv",sep=""),row.names=F)


################ gamma=0.9 ######################
res_09<-BLB_grp(data,0.9,index,iter.num,tau,s=10,
                family="gaussian")
write.csv(res_09$beta_hat,paste(outputPath,"/beta_09.csv",sep=""),row.names=F)
write.csv(res_09$tim_cum,paste(outputPath,"/time_09.csv",sep=""),row.names=F)


######### bootstrap
res_boot<-BOOT_grp(data,index,iter.num=500,tau,
                   family="gaussian")
write.csv(res_boot$beta_hat,paste(outputPath,"/beta_boot.csv",sep=""),row.names=F)
write.csv(res_boot$tim_cum,paste(outputPath,"/time_boot.csv",sep=""),row.names=F)

