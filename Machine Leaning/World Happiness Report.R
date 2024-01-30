# Team 19 Case 2
# By: Caitlin Bryant, Lingli Jin, Sabrina Rodriguez
setwd("C:/Users/17578/Machine Learning")
df <- read.csv("Case2.csv")
summary(df)
cor(df[-1:-2])
pairs(df[-1:-2])
# GDP.per.capita, Social.support, and Healthy.life.expectancy seem to have strong positive relationships with happiness


###GDP.per.capita vs Happiness####
#Happiness~GDP.per.capita
M1 <- lm(Happiness~GDP.per.capita, data = df)
summary(M1)
#Residuals part: the distribution of the residuals appear to be slightly skewed.

#Coefficients part: 
#Estimate: Yhat=3.3993+2.2181*GDP.per.capita
#The standard error is pretty low compared to the estimates, which is good.
#t-value: The t values are relatively far away from 0, which means we have a good chance of rejecting null hypothesis and stating that there is a relationship between happiness and GDP.per.capita that exists.
#Pr(>t): the p-values are very low for the intercept and slope which means we can reject the null hypothesis and conclude there is a relationship between happiness and GDP.per.capita

#Residual standard error: The average amount that happiness will deviate from the true regression line 0.679.

#Adjusted multiple R squared: 62.78% of the variance found in happiness can be explained by GDP.per.capita

#F-statistic is really big and the p-value is really small, which means that we can reject the null hypothesis and state that there is a strong significant relationship between GDP.per.capita and happiness.


plot(df$GDP.per.capita,df$Happiness)
abline(M1,col="red",lwd=5)
#looking at the graph the variables look like they have a strong positive linear relationship.

par(mfrow=(c(2,2)))
plot(M1)
#residuals vs fitted: The residuals bounce randomly around the 0 line, which suggests the assumption that the relationship is linear.

#normal q-q: The residuals do not follow the straight line well in the beginning or end so data may be slightly skewed.

#scale-location: The residuals bounce randomly so the assumption of homoscedasticity is likely satisfied. That is, the spread of the residuals is roughly equal at all fitted values.

#residuals vs leverage:  There seems to be no points that fall outside cook's distance. So no influential cases.

confint(M1)
#95% confident that the equation is between 3.132016 +1.947689 *GDP.per.capita and 3.666675 +2.488607 *GDP.per.capita

hist(M1$residuals)
mean(M1$residuals)
#residuals slightly left skewed

lmtest::bptest(M1)
#BP = 0.054916, df = 1, p-value = 0.8147
#we fail to reject the null hypothesis, not enough evidence for heteroscedasticity exist, it is homoscedastic

### M1 ASSESSMENT ###

# There is a significant relationship between GDP.per.capita and Happiness, 
# in which GDP.per.capita positively affects the Happiness, 62.78% variance in Happiness can 
# be explained by variable GDP.per.capita, the data is left skewed and homoscadastic.


###M2####
#Happiness~Social.support
M2 <- lm(Happiness~Social.support, data = df)

summary(M2)
#Residuals part: the distribution of the residuals appear to be symmetrical.

#Coefficients part: 
#Estimate: Yhat=1.9124+2.8910 *Social.support
#The standard error is pretty low compared to the estimates, which is good.
#t-value: The t values are relatively far away from 0, which means we have a good chance of rejecting null hypothesis and stating that there is a relationship between happiness and GDP.per.capita that exists.
#Pr(>t): the p-values are very low for the intercept and slope which means we can reject the null hypothesis and conclude there is a relationship between happiness and GDP.per.capita

#Residual standard error: The average amount that happiness will deviate from the true regression line 0.7029.

#Adjusted multiple R squared: 60.12% of the variance found in happiness can be explained by Social.support.

#F-statistic is really big and the p-value is really small, which means that we can reject the null hypothesis and state that there is a strong significant relationship between Social.support and happiness.


plot(df$Social.support,df$Happiness)
abline(M2,col="red",lwd=5)
#looking at the graph the variables look like they have a strong positive linear relationship.

par(mfrow=(c(2,2)))
plot(M2)
#residuals vs fitted: The residuals bounce randomly around the 0 line, which suggests the assumption that the relationship is linear.

#normal q-q: The residuals follow the straight line well so data may be normally distributed.

#scale-location: The residuals bounce randomly so the assumption of homoscedasticity is likely satisfied.

#residuals vs leverage: There seems to be no points that fall outside cook's distance. So no influential cases.

confint(M2)
#95% confident that the equation is between 1.448296 +2.518206 *Social.support and 2.376565 +3.263768 *Social.support

hist(M2$residuals)
mean(M2$residuals)
#residuals seems normally distributed and mean is close to 0

lmtest::bptest(M2)
#BP = 0.037595, df = 1, p-value = 0.8463
#we fail to reject the null hypothesis, not enough evidence for heteroscedasticity exist, it is homoscedastic

### M2 ASSESSMENT ###

# There is a significant relationship between Social.support and Happiness, 
# in which Social.support positively affects Happiness, 60.12% variance in Happiness 
# can be explained by variable Social.support, the data is normally distributed and homoscadastic.


###M3####
#Happiness~Healthy.life.expectancy
M3 <- lm(Happiness~Healthy.life.expectancy, data = df)
summary(M3)

#Residuals part: the distribution of the residuals appear to be slightly skewed. Just a little.

#Coefficients part: 
#Estimate: Yhat=2.8068+3.5854*Healthy.life.expectancy
#The standard error is pretty low compared to the estimates, which is good.
#t-value: The t values are relatively far away from 0, which means we have a good chance of rejecting null hypothesis and stating that there is a relationship between happiness and Healthy.life.expectancy that exists.
#Pr(>t): the p-values are very low for the intercept and slope which means we can reject the null hypothesis and conclude there is a relationship between happiness and Healthy.life.expectancy

#Residual standard error: The average amount that happiness will deviate from the true regression line 0.699.

#Adjusted multiple R squared: 60.57% of the variance found in happiness can be explained by Health.life.expectancy.

#F-statistic is really big and the p-value is really small, which means that we can reject the null hypothesis and state that there is a strong significant relationship between Healthy.life.expectancy and happiness.


plot(df$Healthy.life.expectancy,df$Happiness)
abline(M3,col="red",lwd=5)
#looking at the graph the variables look like they have a strong positive linear relationship.

par(mfrow=(c(2,2)))
plot(M3)
#residuals vs fitted: The residuals bounce randomly around the 0 line, which suggests the assumption that the relationship is linear.

#normal q-q: The residuals follow the straight line well except towards beginning and end so data may be slightly skewed.

#scale-location: The residuals bounce randomly so the assumption of homoscedasticity is likely satisfied.

#residuals vs leverage: There seems to be no points that fall outside cook's distance. So no influential cases.

confint(M3)
#95% confident that the equation is between 2.456700 +3.127288 *Healthy.life.expectancy and 3.156963 + 4.043446*Healthy.life.expectancy

hist(M3$residuals)
mean(M3$residuals)
#residuals seems just slightly right skewed and mean is close to 0

lmtest::bptest(M3)
#BP = 0.41888, df = 1, p-value = 0.5175
#we fail to reject the null hypothesis, not enough evidence for heteroscedasticity exist, it is homoscedastic

### M3 ASSESSMENT ###

# There is a significant relationship between Healthy.life.expectancy and Happiness, 
# in which Healthy.life.expectancy positively affects the Happiness, 60.57% variance in Happiness 
# can be explained by variable Healthy.life.expectancy , the data is slightly right skewed and homoscadastic.



###Perceptions.of.corruption###
summary(df$Perceptions.of.corruption)
M4 <- lm(Happiness~Perceptions.of.corruption, data = df)
summary(M4)

#Residuals part: the distribution of the residuals appear to be a little skewed.

#Coefficients part: 
#Estimate: Yhat=4.9049+4.5403*Perceptions.of.corruption
#The standard error is pretty low compared to the estimates, which is good.
#t-value: The t values are relatively far away from 0, which means we have a good chance of rejecting null hypothesis and stating that there is a relationship between happiness and Perceptions.of.corruption that exists.
#Pr(>t): the p-values are very low for the intercept and slope which means we can reject the null hypothesis and conclude there is a relationship between happiness and Perceptions.of.corruption

#Residual standard error: The average amount that happiness will deviate from the true regression line 1.03.

#Adjusted multiple R squared: 14.32% of the variance found in happiness can be explained by Perceptions.of.corruption.

#F-statistic is really big and the p-value is really small, which means that we can reject the null hypothesis and state that there is a strong significant relationship between Perceptions.of.corruption.


plot(df$Perceptions.of.corruption,df$Happiness)
abline(M4,col="red",lwd=5)
#looking at the graph the variables have a weak positive linear relationship.

par(mfrow=(c(2,2)))
plot(M4)
#residuals vs fitted: The residuals do not seem to bounce randomly around the 0 line, which suggests the assumption that the relationship is non-linear.

#normal q-q: The residuals does not follow the straight line well so data may be a little skewed.

#scale-location: The residuals do not seem to bounce randomly. Plot suggests data may be heteroscedastic.

#residuals vs leverage: There is one point that is close to being an influential case (152). Further investigation is needed.

confint(M4)
#95% confident that the equation is between 4.653638+ 2.810949*Perceptions.of.corruption and 5.156209 + 6.269724*Perceptions.of.corruption

hist(M4$residuals)
mean(M4$residuals)
#residuals seems to be left skewed.

lmtest::bptest(M4)
#BP = 5.7408, df = 1, p-value = 0.01658
#we reject the null hypothesis, there is enough evidence for heteroscedasticity to exist.

### M4 ASSESSMENT ###

# There is a not significant relationship between Perceptions.of.corruption and Happiness, 
# but the relationship is positive. Perceptions.of.corruption positively affects the Happiness, 
# 14.32% variance in Happiness can be explained by variable Perceptions.of.corruption, 
# the data is left skewed and heteroscadastic.

### taking out influential points###

library(broom)
library(tidyverse)
library(ggplot2)
modelResults <- augment(M4) %>% mutate(index = 1:n())
ggplot(modelResults, aes(index, .std.resid))+geom_point()
sum(abs(modelResults$.std.resid)>3) 
subset(modelResults$index,(abs(modelResults$.std.resid)>3)) 


new_data <- M4$model[c(-152),]
Revised_cor <- lm(Happiness~Perceptions.of.corruption, data = new_data)
coef(Revised_cor)
confint(Revised_cor)
summary(Revised_cor)
hist(Revised_cor$residuals)
lmtest::bptest(Revised_cor)
# now we failed to reject the null hypothesis, the model appears to be homoskedastcity now and data becomes more normally distributed.
par(mfrow=(c(2,2)))
plot(Revised_cor)
#now there are no influential points

# GDP.per.capita is the number one factor that can best explain happiness, because it has the highest R-square in predicting Happiness among all variables. 
# Doing these tests lets us know what variables matter at predicting happiness.
# Looking at the test, it gives you the insight how the data looks.
# Nevertheless, we found Perceptions.of.corruption is not a significant factor to predict Happiness, and there are outliers in observations. Also, the R-square is relatively low.
