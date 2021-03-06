##################################################################################################################
####  Purpose: Final Project - Classification
####  Group: Ravi P., Derek P., Aneesh K., Ninad K.
####  Date: 11/28/2018
####  Comment:
####    setwd("~/Stevens/Fall2018/CS513_Knowledge_Discovery/Final Project/Classification")
####
##################################################################################################################

setwd("~/Stevens/Fall2018/CS513_Knowledge_Discovery/Final Project/Classification")
#### 0. Clean environment ####
rm(list = ls())

#### 1. Import dataset and libraries ####
df_train <- read.csv("./data/train.csv", na.strings = "?")
df_test <- read.csv("./data/test.csv", na.strings = "?")

library(dplyr)
#### 1a. Cleaning of data ####

#### Renaming of columns ####
names(df_train)[1] <- 'ID'
df_test$ID <- as.integer(df_test$ID)
df_train$ID <- as.integer(df_train$ID)
full_df <- bind_rows(df_train, df_test)
rm(df_test)
rm(df_train)

#### Has name ####
full_df$HasName <- ifelse(full_df$Name == "", "No", "Yes")
full_df$HasName <- as.factor(full_df$HasName)
### Removing Blanks in SexuponOutcome ###
i <- 1
temp <- c()
for(x in full_df$SexuponOutcome){
  if(x == "" || x == "Unknown"){
    temp <- c(temp,i)
  }
  i <- i+1
}
full_df <- full_df[-temp,]
rm(i)
rm(temp)
rm(x)

#### Removing blanks from AgeuponOutcome ####
i<-1
temp <- c()
for(x in full_df$AgeuponOutcome){
  if(x == ""){
    temp<-c(temp,i)
  }
  i<-i+1
}
full_df<- full_df[-temp,]
rm(i)
rm(temp)
rm(x)

#### Converting to Age to Days ####
full_df$TimeValue <- as.numeric(sapply(full_df$AgeuponOutcome, function(x) strsplit(x, split= ' ')[[1]][1]))
full_df$TimeUnit <- sapply(full_df$AgeuponOutcome, function(x) strsplit(x, split= ' ')[[1]][2])
full_df$TimeUnit <- gsub('s', '',full_df$TimeUnit)

mult_vector <- ifelse(full_df$TimeUnit == 'day', 1,
               ifelse(full_df$TimeUnit == 'week',7,
               ifelse(full_df$TimeUnit == 'month',30,
               ifelse(full_df$TimeUnit == 'year', 365, NA))))
full_df$AgeinDays <- full_df$TimeValue * mult_vector

full_df$AgeinDays <- ifelse(full_df$AgeinDays <= 365, "Less than a year",
                     ifelse(full_df$AgeinDays <= 730, "Less than 2 years",
                     ifelse(full_df$AgeinDays <= 1095, "Less than 3 years","Over 3 years")))
full_df$AgeinDays <- factor(full_df$AgeinDays)

rm(mult_vector)

#### Breed -> Mix or Not ####
full_df$IsMix <- ifelse(grepl('Mix', full_df$Breed), "Yes",
                 ifelse(grepl('/',full_df$Breed),"Yes","No")) 
full_df$IsMix <- as.factor(full_df$IsMix)

#### Color -> One Word Color ####
full_df$SimpleColor <- sapply(full_df$Color, function(x) strsplit(x, split = '/| ')[[1]][1])
full_df$SimpleColor <- factor(full_df$SimpleColor)

### Is Neutered ####
full_df$IsNeutered <- ifelse(grepl('Intact', full_df$SexuponOutcome), "No", "Yes")
full_df$IsNeutered <- as.factor(full_df$IsNeutered)

### Gender ####
full_df$Gender <- ifelse(grepl('Male', full_df$SexuponOutcome), "M", "F")
full_df$Gender <- factor(full_df$Gender)

#### 1b. New Full Dataset with good columns ####

df_full_new <- full_df[,c("ID", "OutcomeType", "AnimalType", "HasName", "AgeinDays","IsMix","SimpleColor","IsNeutered","Gender")]
# df_full_new$Gender <- as.integer(df_full_new$Gender)
# df_full_new$SimpleColor <- as.integer(df_full_new$SimpleColor)
# df_full_new$AnimalType <- as.integer(df_full_new$AnimalType)
# df_full_new$OutcomeType <- as.integer(df_full_new$OutcomeType)

#### 2. Remove all NA Values in OutcomeType ####
i<-1
temp<- c()
for(x in df_full_new$OutcomeType){
  if( is.na(x) | x == "" ){
    temp <- c(temp,i)
  }
  i <- i + 1
}
df_full_new <- df_full_new[-temp,]
rm(i)
rm(x)
rm(temp)


#### 3. Summary of Full Dataset ####

summary(df_full_new)

print("Table Animal Type vs Outcome Type")
table(df_full_new$AnimalType, df_full_new$OutcomeType)

print("Table Has Name vs Outcome Type")
table(df_full_new$HasName, df_full_new$OutcomeType)

print("Table Age in Days vs Outcome Type")
table(df_full_new$AgeinDays, df_full_new$OutcomeType)

print("Table Is Mix vs Outcome Type")
table(df_full_new$IsMix, df_full_new$OutcomeType)

print("Table Simple Color vs Outcome Type")
table(df_full_new$SimpleColor, df_full_new$OutcomeType)

print("Table Is Neutered vs Outcome Type")
table(df_full_new$IsNeutered, df_full_new$OutcomeType)

print("Table Gender vs Outcome Type")
table(df_full_new$Gender, df_full_new$OutcomeType)


#### 4. Splitting the data into training and test ####
index <- sample(1:nrow(df_full_new), .25*nrow(df_full_new))
df_test_new <- df_full_new[index,]
df_train_new <- df_full_new[-index,]
rm(index)
rm(df_full_new)

#### 5. Summary of Training/Test dataset ####

#### Train Dataset ####
summary(df_train_new)

print("Table Animal Type vs Outcome Type")
table(df_train_new$AnimalType, df_train_new$OutcomeType)

print("Table Has Name vs Outcome Type")
table(df_train_new$HasName, df_train_new$OutcomeType)

print("Table Age in Days vs Outcome Type")
table(df_train_new$AgeinDays, df_train_new$OutcomeType)

print("Table Is Mix vs Outcome Type")
table(df_train_new$IsMix, df_train_new$OutcomeType)

print("Table Simple Color vs Outcome Type")
table(df_train_new$SimpleColor, df_train_new$OutcomeType)

print("Table Is Neutered vs Outcome Type")
table(df_train_new$IsNeutered, df_train_new$OutcomeType)

print("Table Gender vs Outcome Type")
table(df_train_new$Gender, df_train_new$OutcomeType)


#### Test Dataset ####

summary(df_test_new)

print("Table Animal Type vs Outcome Type")
table(df_test_new$AnimalType, df_test_new$OutcomeType)

print("Table Has Name vs Outcome Type")
table(df_test_new$HasName, df_test_new$OutcomeType)

print("Table Age in Days vs Outcome Type")
table(df_test_new$AgeinDays, df_test_new$OutcomeType)

print("Table Is Mix vs Outcome Type")
table(df_test_new$IsMix, df_test_new$OutcomeType)

print("Table Simple Color vs Outcome Type")
table(df_test_new$SimpleColor, df_test_new$OutcomeType)

print("Table Is Neutered vs Outcome Type")
table(df_test_new$IsNeutered, df_test_new$OutcomeType)

print("Table Gender vs Outcome Type")
table(df_test_new$Gender, df_test_new$OutcomeType)


#### 6. Exports into csv ####

write.csv(df_train_new, file = "./data/train_new.csv")
write.csv(df_test_new, file = "./data/test_new.csv")




