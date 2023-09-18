##In this R notebook i load in all data, analyze it, delete outliers and build my model



# Packages required fo ranalysis
library(lme4)
library(ggplot2)
library(tidyverse)
library(dplyr)
library(ggcorrplot)
library(pdp)
library(gam)
library(mgcv)
library(lattice)      
library(mgcv)
library(car)
library(MASS)
library(RColorBrewer)
install.packages("cowplot")
library(cowplot)

# Here I look at the data and distibution o fresiduals to see what is causing problems. 
setwd("/Users/patrick/desktop/Gradu/Processed data")
mastertable <- read.csv("Mastertable_tropical.csv", header=T)

#Indentify outliers, here you can change the different variables to look for outliers in other variables
par(mfrow = c(1, 1))
plot(x = mastertable$pa_increase_percent, 
     y = mastertable$Total_dif)
identify(x = mastertable$pa_increase_percent, 
         y = mastertable$Total_dif)

#Create new df without outliers
mastertable2 <- mastertable[-c(1, 3,7, 13, 17, 20, 27,39, 40),]


# Fit GAM model 
whole_model <- gam(Total_dif ~ s(log_funding_ppp) + CPI2009 + pa_number + Total_def_rate + pa_expansion_rank, data = mastertable2)
summary(whole_model)

#Build correlation matrix
correlation <- cor(mastertable2$Total_def_rate, mastertable2$pa_expansion_rank)
print(correlation)


# Plot every covariate versus Y
MyX  <- c("log_funding_ppp", "CPI2009", "Total_def_rate", "pa_number")


# Here I check the data ########################---------------------------
par(mfrow = c(2, 2))
## QQ plot
qqnorm(whole_model$residuals)
qqline(whole_model$residuals)
shapiro.test(resid(whole_model))

## Residuals VS Fitted
resid <- residuals(whole_model)
plot(fitted(whole_model), resid, xlab = "Fitted values", ylab = "Residuals", main = "Residuals vs Fitted Values")
abline(h = 0, lty = 2) # Add a horizontal reference line at y = 0


# Scale-location plot
plot(whole_model$fitted.values, sqrt(abs(resid(whole_model))), 
     xlab = "Fitted values", ylab = "Square root of standardized residuals",
     main = "Scale-Location Plot")

plot(resid(whole_model) ~ seq_along(resid(whole_model)), xlab = "Order of Observations", ylab = "Residuals", main = "Residuals vs Order of Observations")


##------------------------------------------------------------------------





## Here i try different models to explore the data and relationships between variables

# Normal model
whole_model <- gam(Total_dif ~ s(log_funding_ppp) + CPI2009 + Total_def_rate + pa_number + forestcover, data = mastertable2)
summary(whole_model)

# Model without deforestation
model1 <- gam(Total_dif ~ s(log_funding_ppp) + CPI2009, data = mastertable2)
summary(model1)

# Model without CPI
model2 <- gam(Total_dif ~ s(log_funding_ppp) + pa_number + pa_expansion_rank, data = mastertable2)
summary(model2)

# Model
model3 <- gam(Total_dif ~ s(log_funding_ppp) + Total_def_rate, data = mastertable2)
summary(model3)

model16 <- gam(Total_dif ~ s(log_funding_ppp) + Total_def_rate + CPI2009, data = mastertable2)
summary(model16)


model4 <- gam(Total_dif ~ s(log_funding_ppp) + Total_def_rate + pa_expansion_rank + end_coverage_percent, data = mastertable2)
summary(model4)

model5 <- gam(Total_dif  ~  s(log_funding_ppp) + end_coverage_percent, data = mastertable2)
summary(model5)

model6 <- gam(Total_dif  ~  s(log_funding_ppp) + end_coverage_percent + forestcover + pa_number, data = mastertable2)
summary(model6)

model7 <- gam(Total_dif ~ s(log_funding_ppp) + pa_expansion_rank + Total_def_rate, data = mastertable2)
summary(model7)

model8 <- gam(Total_dif ~ s(log_funding_ppp) + forestcover + Total_def_rate, data = mastertable2)
summary(model8)

model9 <- gam(Total_dif ~ s(log_funding_ppp) + pa_number + pa_expansion_rank + Total_def_rate + forestcover, data = mastertable2)
summary(model9)

model12 <- gam(Total_dif ~ s(log_funding_ppp) + end_coverage_percent + pa_expansion_rank + Total_def_rate, data = mastertable2)
summary(model12)


model10 <- gam(Total_dif ~ s(log_funding_ppp) + pa_number + pa_expansion_rank + Total_def_rate + forestcover + CPI2009, data = mastertable2)
summary(model10)

model11 <- gam(Total_dif  ~  s(log_funding_ppp) + end_coverage_percent + forestcover, data = mastertable2)
summary(model11)

model16 <- gam(Total_dif ~ s(log_funding_ppp) + Total_def_rate + CPI2009, data = mastertable2)
summary(model16)


# Compare AIC values
AIC(whole_model, model1, model2, model3, model4, model5, model6, model7, model8, model9, model10, model16)






### MODEL 16 BEST

model16 <- gam(Total_dif ~ s(log_funding_ppp) + Total_def_rate + CPI2009, data = mastertable2)


# Create scatterplots using ggplot2
scatterplot_funding <- ggplot(mastertable2, aes(x = log_funding_ppp, y = Total_dif)) +
  geom_point() +
  labs(title = "Funding & Conservation Effectiveness", x = "Funding", y = "Conservation Effectiveness")+
  theme(aspect.ratio = 1)

scatterplot_cpi <- ggplot(mastertable2, aes(x = CPI2009, y = Total_dif)) +
  geom_point() +
  labs(title = "Corruption & Conservation Effectiveness", x = "Corruption", y = "Conservation Effectiveness")+
  theme(aspect.ratio = 1)

scatterplot_def_rate <- ggplot(mastertable2, aes(x = Total_def_rate, y = Total_dif)) +
  geom_point() +
  labs(title = "Deforestation & Conservation Effectiveness", x = "Deforestation", y = "Conservation Effectiveness")+
  theme(aspect.ratio = 1)

# Arrange the scatterplots side by side
multiplot <- cowplot::plot_grid(scatterplot_funding, scatterplot_cpi, scatterplot_def_rate, ncol = 3)

# Display the combined scatterplots
print(multiplot)


scatter_plot <- ggplot(mastertable2, aes(x = pa_expansion_rank, y = Total_dif)) +
  geom_point() +
  labs(title = "PA Coverage & Conservation Effectiveness", x = "PA Coverage Percent", y = "Conservation Effectiveness")

print(scatter_plot)



### BEST MODEL
par(mfrow = c(2, 2))
## QQ plot
qqnorm(model16$residuals)
qqline(model16$residuals)
shapiro.test(resid(model16))

## Residuals VS Fitted
resid <- residuals(model16)
plot(fitted(model16), resid, xlab = "Fitted values", ylab = "Residuals", main = "Residuals vs Fitted Values")
abline(h = 0, lty = 2) # Add a horizontal reference line at y = 0


# Scale-location plot
plot(model9$fitted.values, sqrt(abs(resid(model16))), 
     xlab = "Fitted values", ylab = "Square root of standardized residuals",
     main = "Scale-Location Plot")

plot(resid(model16) ~ seq_along(resid(model16)), xlab = "Order of Observations", ylab = "Residuals", main = "Residuals vs Order of Observations")






## DATA PREDICTION
model69 <- gam(Total_dif ~ s(log_funding_ppp) + forestcover + CPI2009 + Total_def_rate, data = mastertable2)
summary(model69)

predictmodel69 <- data.frame(
  log_funding_ppp = rep(1:20, each = 20 * 20),
  Total_def_rate = rep(rep(1:20, each = 20), 20),
  forestcover = rep(rep(1:100, each = 20), 20),
  CPI2009 = rep(seq(5, 60, length.out = 20), 20 * 20)
)

dim(predictmodel69)


predict_values69 <- predict(model69, newdata = predictmodel69)
str(predict_values69)
plot(predict_values69)

combined69 <- cbind(predictmodel69,  dif_predicted =as.vector(predict_values69))
str(combined69)

combined69 <- combined69[order(combined69$CPI2009, combined69$Total_def_rate, combined69$forestcover), ]


plot(dif_predicted ~ log_funding_ppp, data= combined69)


ggplot(combined69, aes(x = log_funding_ppp, y = dif_predicted, color = factor(CPI2009))) +
  geom_point()


ggplot(combined69, aes(x = Total_def_rate, y = dif_predicted, color = factor(log_funding_ppp))) +
  geom_line(stat = "summary", fun = mean) +
  labs(title = "Conservation Effectiveness vs. Total Deforestation and Funding",
       x = "Deforestation",
       y = "Consrevation Effectiveness",
       color = "Relative Amounts of Funding") +
  scale_color_discrete(guide = guide_legend(reverse = TRUE)) 



n <- 20  # Number of colors needed
colors <- colorRampPalette(c("darkred", "deepskyblue1"))(n)

####################



## DATA PREDICTION
model16 <- gam(Total_dif ~ s(log_funding_ppp) + forestcover + CPI2009, data = mastertable2)
summary(model16)

model166 <- gam(Total_dif ~ s(log_funding_ppp), data = mastertable2)
summary(model166)
plot(model166)



# Here i build a new dataset based on the parameters for the best model (model16)
predictmodel <- data.frame(
  log_funding_ppp = rep(1:20, each = 20 * 20),
  forestcover = rep(rep(1:100, each = 20), 20), 
  CPI2009 = rep(seq(5, 60, length.out = 20), 20 * 20)
)

#Check dimension
dim(predictmodel)


#Predict new values
predict_values <- predict(model16, newdata = predictmodel)
str(predict_values)
plot(predict_values)

combined <- cbind(predictmodel,  dif_predicted =as.vector(predict_values))
str(combined)

#Order the numbers and structure the model
combined <- combined[order(combined$CPI2009, combined$forestcover, combined$log_funding_ppp), ]

combined$CPI2009 <- factor(round(combined$CPI2009))

plot(dif_predicted ~ log_funding_ppp, data= combined)


ggplot(combined, aes(x = log_funding_ppp, y = dif_predicted, color = factor(CPI2009))) +
  geom_point()

combined$CPI2009=as.numeric(levels(combined$CPI2009))[combined$CPI2009]

ggplot(combined, aes(x = log_funding_ppp, y = dif_predicted, color = factor(CPI2009))) +
  geom_line(stat = "summary", fun = mean) +
  labs(title = "Conservation Effectiveness vs. Governance and Funding",
       x = "Amount of funding to PPP",
       y = "Conservation Effectiveness",
       color = "Level of Governance") +
  scale_color_manual(values = colors) +
  scale_color_discrete(guide = guide_legend(reverse = TRUE))

## Individual Parameters
ggplot(combined, aes(x = log_funding_ppp, y = dif_predicted)) +
  geom_line(stat = "summary", fun = mean) +
  labs(title = "Conservation Effectiveness vs.  Funding",
       x = "Funding",
       y = "Conservation Effectiveness",
       color = "Level of Governance") +
  scale_color_manual(values = colors) +
  scale_color_discrete(guide = guide_legend(reverse = TRUE))

library(RColorBrewer)

n <- 20  # Number of colors needed
colors <- colorRampPalette(c("darkred", "deepskyblue1"))(n)
blues <- colorRampPalette(c('#132B43', '#56B1F7'))(n)


ggplot(combined, aes(x = Total_def_rate, y = dif_predicted, color = factor(log_funding_ppp))) +
  geom_point(stat = "summary", fun = mean) +
  labs(title = " Forestcover and Funding",
       x = "Percentage of country covered in forest",
       y = "Predicted Outcomes",
       color = "Amount of Conservation Funding") +
  scale_color_discrete(guide = guide_legend(reverse = TRUE)) + 
  scale_color_manual(values = blues)
  


