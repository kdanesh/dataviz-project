# load packages
library(foreign)
library(hexbin)
library(ggplot2)
library(readr)
library(dplyr)

# set working directory
setwd("/Users/Kaveh/Dropbox/Berkeley/projects/econ/opioid/data_derived")

# load data
opioid <- read.csv("opioid_microdata.csv")

# subset data to 2015
opioid2015 <- subset(opioid, year==2015)

##### PLOT 1 #####

# collapse by payment count
opioid2015_collapse_paymentcount <- opioid2015 %>% 
  group_by(payment_count) %>%
  summarize(mean = mean(total_30_day_fill_count, na.rm=TRUE), n=n())

# subset to deal with sample size issue
opioid2015_collapse_paymentcount_trunc <- subset(opioid2015_collapse_paymentcount, payment_count<=50)

# plot payment vs prescriptions
ggplot(opioid2015_collapse_paymentcount_trunc, aes(x=payment_count, y=mean)) +
  xlab("Number of payments received from opioid manufacturer") +
  ylab("Mean 30-day prescriptions") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_point(alpha=0.5) +
  geom_smooth()

##### PLOT 2 #####

# collapse by specialty
opioid2015_collapse_specialty <- opioid2015 %>% 
  group_by(specialty) %>%
  summarize(mean = mean(total_30_day_fill_count, na.rm=TRUE), n=n()) %>%
  arrange(desc(mean))
  
# subset to common specialties
opioid2015_collapse_specialty_trunc <- subset(opioid2015_collapse_specialty, n>1000)

# replace ridiculous name
opioid2015_collapse_specialty_trunc$specialty <- as.character(opioid2015_collapse_specialty_trunc$specialty)
opioid2015_collapse_specialty_trunc$specialty[opioid2015_collapse_specialty_trunc$specialty=="STUDENTINANORGANIZEDHEALTHCAREEDUCATIONTRAININGPROGRAM"] <- "STUDENTTRAINING"

# plot
ggplot(opioid2015_collapse_specialty_trunc, aes(x = reorder(specialty, -mean), y=mean)) +
  xlab("Medical specialty") +
  ylab("Mean 30-day prescriptions") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_bar(stat="identity") +
  theme(axis.text.x = element_text(angle = 90, hjust=1))

##### PLOT 3 #####

# collapse by credential
opioid2015_collapse_credentials <- opioid2015 %>% 
  group_by(credentials) %>%
  summarize(mean = mean(total_30_day_fill_count, na.rm=TRUE), n=n()) %>%
  arrange(desc(mean))

# subset to common specialties
opioid2015_collapse_credentials_trunc <- subset(opioid2015_collapse_credentials, n>1000)

# plot
ggplot(opioid2015_collapse_credentials_trunc, aes(x = reorder(credentials, -mean), y=mean)) +
  xlab("Credential") +
  ylab("Mean 30-day prescriptions") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_bar(stat="identity") +
  theme(axis.text.x = element_text(angle = 90, hjust=1))

###### 

# work in progress
plot(opioid_nozero$payment, opioid_nozero$total_claim_count)
hexbinplot(total_claim_count ~ payment, data=opioid_nozero_2, , xlim = c(0, 1000), ylim = c(0, 1000))

