##################################################################################################################
####  Purpose: Final Project - Classification - CART
####  Group: Ravi P., Derek P., Aneesh K., Ninad K.
####  Date: 11/28/2018
####  Comment:
####    setwd("~/Stevens/Fall2018/CS513_Knowledge_Discovery/Final Project/Classification")
####
##################################################################################################################
setwd("~/Stevens/Fall2018/CS513_Knowledge_Discovery/Final Project/Classification")
rm(list = ls())

library(rpart)
library(rpart.plot)
library(rattle)
library(RColorBrewer)

df_train <- read.csv("./data/train_new.csv")
df_test <- read.csv("./data/test_new.csv")

df_train <- df_train[,-1]
df_test <- df_test[,-1]

# levels(df_test$SimpleColor) <- levels(df_train$SimpleColor)

# df_train$OutcomeType <- as.integer(df_train$OutcomeType)
# df_train$AnimalType <- as.integer(df_train$AnimalType)
df_train$SimpleColor <- as.integer(df_train$SimpleColor)

# df_test$AnimalType <- as.integer(df_test$AnimalType)
df_test$SimpleColor <- as.integer(df_test$SimpleColor)


#Make three trees with different complexity parameters
# mytree1 <- rpart(OutcomeType~., data = df_train[,c(-1)], control=rpart.control(minsplit=1, minbucket=1, cp=0.001))
mytree3 <- rpart(OutcomeType~ AnimalType + AgeinDays + HasName + IsNeutered + IsMix + Gender + SimpleColor, data = df_train,  control=rpart.control(minsplit=1, minbucket=1, cp=0.01))
mytree2 <- rpart(OutcomeType~ AnimalType + AgeinDays + HasName + IsNeutered + IsMix + Gender + SimpleColor, data = df_train,  control=rpart.control(minsplit=1, minbucket=1, cp=0.005))
mytree1 <- rpart(OutcomeType~ AnimalType + AgeinDays + HasName + IsNeutered + IsMix + Gender + SimpleColor, data = df_train,  control=rpart.control(minsplit=1, minbucket=1, cp=0.001))

##Check error rate of tree with cp = .01
prediction<-predict( mytree3 ,df_test , type="class" )
table(actual=df_test[,2],prediction)
wrong<- (df_test[,2]!=prediction)
rate<-sum(wrong)/length(wrong)
print(rate)

##Check error rate of tree with cp = .005
prediction<-predict( mytree2 ,df_test , type="class" )
table(actual=df_test[,2],prediction)
wrong<- (df_test[,2]!=prediction)
rate<-sum(wrong)/length(wrong)
print(rate)

##Check error rate of tree with cp = .001
prediction<-predict( mytree1 ,df_test , type="class" )
table(actual=df_test[,2],prediction)
wrong<- (df_test[,2]!=prediction)
rate<-sum(wrong)/length(wrong)
print(rate)

summary(mytree1)

rpart.plot(mytree1)
prp(mytree1)
fancyRpartPlot(mytree1)
