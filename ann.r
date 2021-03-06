##################################################################################################################
####  Purpose: Final Project - Classification - ANN
####  Group: Ravi P., Derek P., Aneesh K., Ninad K.
####  Date: 11/28/2018
####  Comment:
####    setwd("~/Stevens/Fall2018/CS513_Knowledge_Discovery/Final Project/Classification")
####
##################################################################################################################
setwd("~/Stevens/Fall2018/CS513_Knowledge_Discovery/Final Project/Classification")

#### 0. Cleaning Environment ####

rm(list = ls())


#### 1. Importing Data and Libraries ####
library(neuralnet)

df_train <- read.csv("./data/train_new.csv")
df_test <- read.csv("./data/test_new.csv")

#### 2. Removing Column ####
df_train <- df_train[,-1]
df_test <- df_test[,-1]

levels(df_test$SimpleColor) <- levels(df_train$SimpleColor)

#### 3. Neural Net ####

df_train$OutcomeType <- as.integer(df_train$OutcomeType)
df_train$AnimalType <- as.integer(df_train$AnimalType)
df_train$SimpleColor <- as.integer(df_train$SimpleColor)
df_train$Gender <- as.integer(df_train$Gender)
df_train$AgeinDays <- as.integer(df_train$AgeinDays)
df_train$HasName <- as.integer(df_train$HasName)
df_train$IsNeutered <- as.integer(df_train$IsNeutered)
df_train$IsMix <- as.integer(df_train$IsMix)

df_test$OutcomeType <- as.integer(df_test$OutcomeType)
df_test$AnimalType <- as.integer(df_test$AnimalType)
df_test$SimpleColor <- as.integer(df_test$SimpleColor)
df_test$Gender <- as.integer(df_test$Gender)
df_test$AgeinDays <- as.integer(df_test$AgeinDays)
df_test$HasName <- as.integer(df_test$HasName)
df_test$IsNeutered <- as.integer(df_test$IsNeutered)
df_test$IsMix <- as.integer(df_test$IsMix)


df_ann <- neuralnet(OutcomeType~ AnimalType + AgeinDays + HasName + IsNeutered + IsMix, data = df_train,linear.output = T, hidden=c(30,15,5))

# + IsMix + Gender

#### 4. Error Checking ####
plot(df_ann)
summary(df_ann)

net_result <- compute(df_ann, df_test[,c("OutcomeType", "AnimalType", "AgeinDays", "HasName","IsNeutered", "IsMix")])
ann <- as.numeric(net_result$net.result)
ANN_cat<-ifelse(ann<1.5,1,
        ifelse(ann<2.5,2,
        ifelse(ann<3.5,3,
        ifelse(ann<4.5,4,
        ifelse(ann<5.5,5,6)))))

table(df_test$OutcomeType, ANN_cat)

wrong <- (df_test$OutcomeType != ANN_cat)
wrong
rate<-sum(wrong)/length(wrong)
rate
