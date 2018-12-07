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

#### 3. Neural Net ####

df_train$OutcomeType <- as.integer(df_train$OutcomeType)
df_train$AnimalType <- as.integer(df_train$AnimalType)
df_train$SimpleColor <- as.integer(df_train$SimpleColor)
df_train$Gender <- as.integer(df_train$Gender)
df_train$AgeinDays <- as.integer(df_train$AgeinDays)
df_train$HasName <- as.integer(df_train$HasName)
df_train$IsNeutered <- as.integer(df_train$IsNeutered)
df_train$IsMix <- as.integer(df_train$IsMix)


df_ann <- neuralnet(OutcomeType~ AnimalType + AgeinDays + HasName + IsNeutered, data = df_train,linear.output = T, hidden=c(10,4,2))

# + HasName+ IsNeutered + IsMix + Gender

plot(df_ann)
df_ann <- neuralnet(OutcomeType~ AnimalType + AgeinDays + HasName + IsNeutered + IsMix + Gender, data = df_train, threshold = 0.001, hidden = 10, stepmax = 10000)

plot(df_ann)

net_result <- compute(df_ann, df_test[,c(-1)])
ann <- as.numeric(net_result$net.result)

table(Actual=df_test$OutcomeType)