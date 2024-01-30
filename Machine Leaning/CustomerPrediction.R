
rm(list=ls())
options(scipen=999) #so we can see the zeros
setwd("C:/Users/sabri/classMachine")
churn <- read.csv("Case4(1).csv", stringsAsFactors = TRUE)
churn$Exited<-as.factor(churn$Exited)
churn$IsActiveMember<-as.factor(churn$IsActiveMember)
churn$HasCrCard<-as.factor(churn$HasCrCard)

# inspect the data frame
str(churn)
summary(churn)


### Part 1 Interpreting Logistic Regression Results ### 

shortlogmodel<-glm(Exited~Gender+Age, family=binomial, data=churn)
summary(shortlogmodel)
coef(shortlogmodel)
exp(coef(shortlogmodel))

# We can see that "coefficient of Age is 0.063; 
# this indicates that an increase in age is associated with an increase in 
# the probability of churned. To be precise, a one-unit increase in age is associated with an increase 
# in the log odds of churned by 0.063 units.
# The coefficient of Gender with Male is -0.537; 
# this indicates that male customer would decrease the probability of churned.
# if a customer is male, then the log odds of churned would decrease 0.537 units on average.

# i.e the odds of the customer churned increases by a factor of 1.065, 
# the odds of the customer churned would decreases by a factor of 0.585 on average if the customer is male. 


### Part 2: Comparing Methods ### 

# Divide the data into training (80%) and testing (20%) group.
library(caret)
set.seed(1234)
#The list = FALSE avoids returning the data as a list.
divideData<-createDataPartition(churn$Exited, p=.8, list=FALSE) 
train<-churn[divideData,]
test<-churn[-divideData,]
names(train)

### Create a logistic regression model using all the applicable predictor variables
logisticmodel<-glm(Exited~CreditScore+Geography+Gender+Age+
                   Tenure+Balance+NumOfProducts+HasCrCard+
                   IsActiveMember+EstimatedSalary, 
                 family=binomial, data=train)
summary(logisticmodel)

# Center and scale your data and create a LDA model using centered and scaled training/test data.
### centering and scaling of my data
library(tidyverse)
preprocessing <- train %>% preProcess(method=c("center","scale"))
traintransformed<-preprocessing %>% predict(train)
testtransformed <- preprocessing %>% predict(test)
names(traintransformed)

### lda model
library(MASS)
ldamodel<- lda(Exited~CreditScore+Geography+Gender+Age+
                 Tenure+Balance+NumOfProducts+HasCrCard+
                 IsActiveMember+EstimatedSalary, 
               data=traintransformed)

### Using that same centered and scaled data, create a QDA model
qdamodel<-qda(Exited~CreditScore+Geography+Gender+Age+
                Tenure+Balance+NumOfProducts+HasCrCard+
                IsActiveMember+EstimatedSalary, 
              data=traintransformed)

### Create a knn model that also includes centered and scaled data
knnmodel <- train(Exited~CreditScore+Geography+Gender+Age+
                  Tenure+Balance+NumOfProducts+HasCrCard+
                  IsActiveMember+EstimatedSalary, 
                data = traintransformed, 
                method = "knn")


# Provide the accuracy rates of the validation set for each test conducted above.

### calculating the testing accuracy for logistic model
probs<-predict(logisticmodel, test, type="response")

## Using 0.5 as the threshold for logistic regression
pred.logistic<-as.factor(ifelse(probs>.5, "1", "0"))
confusionMatrix(pred.logistic,test$Exited,positive = "1")
## test accuracy is 0.8094, 
## TP is 85, TN is 1533, FP is 59, FN is 322, sensitivity is 0.20885, specificity is 0.96294.

## Using 0.4 as the threshold for logistic regression
pred.logistic<-as.factor(ifelse(probs>.4, "1", "0"))
confusionMatrix(pred.logistic,test$Exited,positive = "1")
## test accuracy is 0.8064, 
## TP is 139, TN is 1473, FP is 119, FN is 268, sensitivity is 0.34152 , specificity is 0.92525 

## Using 0.3 as the threshold for logistic regression
pred.logistic<-as.factor(ifelse(probs>.3, "1", "0"))
confusionMatrix(pred.logistic,test$Exited,positive = "1")
## test accuracy is 0.7734, 
## TP is 185, TN is 1361, FP is 231, FN is 222, sensitivity is 0.45455, specificity is 0.85490

# Observation of logistic regression: When using different thresholds for classification, 
# we found if we set the threshold too low(0.3), even though the sensitivity increases
# the overall accuracy was compromised, and specificity also dropped
# thus we figure setting threshold 0.4 is the optimal cutoff point for our logistic regression model
# thus the optimal result for logistic regression is
## test accuracy is 0.8064, 
## TP is 139, TN is 1473, FP is 119, FN is 268, sensitivity is 0.34152 , specificity is 0.92525



### calculate the testing accuracy for lda model
pred.lda<-ldamodel %>% predict(testtransformed)
confusionMatrix(pred.lda$class,test$Exited,positive = "1")
# for lda model, its test accuracy is 0.8094, 
# TP is 97, TN is 1521, FP is 71, FN is 310, sensitivity is 0.23833, specificity is 0.9554

### calculate the testing accuracy for qda model
pred.qda<-qdamodel %>% predict(testtransformed)
confusionMatrix(pred.qda$class,test$Exited,positive = "1")
# for qda model, its test accuracy is 0.8279, 
# TP is 140, TN is 1515, FP is 77, FN is 267, sensitivity is 0.34398, specificity is 0.95163

### calculate the testing accuracy for knn model
pred.knn<-predict(knnmodel,newdata=testtransformed)
confusionMatrix(pred.knn,test$Exited,positive = "1")
# for knn model, its test accuracy is 0.8319, 
# TP is 119, TN is 1512, FP is 80, FN is 288, sensitivity is 0.37838, specificity is 0.94786              


### conclusion ### 
# It turned out that KNN model has the highest overall accuracy rate on the test data set,
# the model also has the highest sensitivity, the specificity is also high, 
# thus select this model as the best model, 
# KNN is a lazy-learning algorithm, and is non-parametric.
# When making prediction of if customer is going to churn, we will look at the nearest 9 customers in the historical data
