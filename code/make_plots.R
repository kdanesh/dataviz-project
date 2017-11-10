# load packages
library(foreign)
library(hexbin)
library(ggplot2)
library(readr)
library(dplyr)

# set working directory
setwd("/Users/Kaveh/Dropbox/Berkeley/projects/econ/opioid/data_derived")

# load data
opioid <- read.csv("opioid_microdata_updated_specialty.csv")

# subset data to 2015
opioid2015 <- subset(opioid, year==2015)

# create alternate version that collapses all years together
opioidavg <- opioid %>%
  group_by(cms_id) %>%
  summarize(total_30_day_fill_count = mean(total_30_day_fill_count, na.rm=TRUE), 
            payment_count = mean(payment_count, na.rm=TRUE),
            specialty=first(specialty))
opioidavg$payment_count <- round(opioidavg$payment_count)

##### PLOT 1 #####

# collapse by payment count
opioid2015_collapse_paymentcount <- opioid2015 %>% 
  group_by(payment_count) %>%
  summarize(mean_30 = mean(total_30_day_fill_count, na.rm=TRUE), mean_b = mean(bene_count, na.rm=TRUE), n=n())

# subset to deal with sample size issue
opioid2015_collapse_paymentcount_trunc <- subset(opioid2015_collapse_paymentcount, payment_count<=50)

# subset raw data as well
opioid2015_trunc <- subset(opioid2015, payment_count<=50)

# plot payment vs prescriptions
ggplot(opioid2015_collapse_paymentcount_trunc, aes(x=payment_count, y=mean_30)) +
  xlab("Number of opioid-related payments received") +
  ylab("Mean opioid prescriptions") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_point(alpha=0.5) +
  geom_smooth(method="lm") 



##### PLOT 2 #####

# clean up credentials
## change to character
opioid2015$credentials <- as.character(opioid2015$credentials)
## remove all white space
opioid2015$credentials <- gsub(" ", "", opioid2015$credentials, fixed = TRUE)
## everything uppercase
opioid2015$credentials <- toupper(opioid2015$credentials)
## everything that contains MD should be MD
opioid2015$credentials[grepl("MD",opioid2015$credentials)]<-"MD"
## everything that contains DO should be DO
opioid2015$credentials[grepl("DO",opioid2015$credentials)]<-"DO"
## everything that contains DDS or DMD should be DDS
opioid2015$credentials[grepl("DDS",opioid2015$credentials) | grepl("DMD",opioid2015$credentials)]<-"DDS"
## everything that is not MD, DO, or DDS should be OTHER
opioid2015$credentials[(grepl("DDS",opioid2015$credentials) | grepl("DO",opioid2015$credentials) | grepl("MD",opioid2015$credentials))==FALSE]<-"OTHER"

# collapse by specialty
opioid2015_collapse_specialty <- opioid2015 %>% 
  group_by(specialty) %>%
  summarize(meanpre = mean(total_30_day_fill_count, na.rm=TRUE), 
            sumpre = sum(total_30_day_fill_count, na.rm=TRUE), 
            meanpay = mean(payment_count, na.rm=TRUE), 
            sumpay = sum(payment_count, na.rm=TRUE), 
            n=n())
  
# remove specialties with fewer than 1000 doctors
opioid2015_collapse_specialty_trunc <- subset(opioid2015_collapse_specialty, n>=1000)
  
# top 10 payments by mean
opioid2015_collapse_specialty <- arrange(opioid2015_collapse_specialty, desc(meanpay))
opioid2015_collapse_specialty_t10mpay <- opioid2015_collapse_specialty[1:10,]

# top 10 payments by sum
opioid2015_collapse_specialty <- arrange(opioid2015_collapse_specialty, desc(sumpay))
opioid2015_collapse_specialty_t10spay <- opioid2015_collapse_specialty[1:10,]

# top 10 prescriptions by mean
opioid2015_collapse_specialty <- arrange(opioid2015_collapse_specialty_trunc, desc(meanpre))
opioid2015_collapse_specialty_t10mpre <- opioid2015_collapse_specialty[1:10,]

# top 10 prescriptions by sum
opioid2015_collapse_specialty <- arrange(opioid2015_collapse_specialty, desc(sumpre))
opioid2015_collapse_specialty_t10spre <- opioid2015_collapse_specialty[1:10,]
opioid2015_collapse_specialty_t10spre$sumpre <- opioid2015_collapse_specialty_t10spre$sumpre/10^6

# replace ridiculous name
# opioid2015_collapse_specialty_trunc$specialty <- as.character(opioid2015_collapse_specialty_trunc$specialty)
# opioid2015_collapse_specialty_trunc$specialty[opioid2015_collapse_specialty_trunc$specialty=="STUDENTINANORGANIZEDHEALTHCAREEDUCATIONTRAININGPROGRAM"] <- "STUDENTTRAINING"

# plot top 10 payments by mean
ggplot(opioid2015_collapse_specialty_t10mpay, aes(x = reorder(specialty, meanpay), y=meanpay)) +
  xlab("") +
  ylab("Mean payments (per physician)") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_bar(stat="identity", fill="blue") +
  coord_flip() 

# plot top 10 payments by sum
ggplot(opioid2015_collapse_specialty_t10spay, aes(x = reorder(specialty, sumpay), y=sumpay)) +
  xlab("") +
  ylab("Total payments") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_bar(stat="identity", fill="blue") +
  coord_flip()

# plot top 10 prescription by mean
ggplot(opioid2015_collapse_specialty_t10mpre, aes(x = reorder(specialty, meanpre), y=meanpre)) +
  xlab("") +
  ylab("Mean prescriptions (per physician)") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_bar(stat="identity", fill="red") +
  coord_flip()

# plot top 10 prescription by sum
ggplot(opioid2015_collapse_specialty_t10spre, aes(x = reorder(specialty, sumpre), y=sumpre)) +
  xlab("") +
  ylab("Total prescriptions (millions)") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_bar(stat="identity", fill="red") +
  coord_flip()

# scatterplot
ggplot(opioid2015_collapse_specialty_trunc, aes(meanpay, meanpre)) + 
  geom_point() +
  geom_smooth(method="lm", color="darkgreen", fill=NA) +
  xlab("Mean Number of Payments") +
  ylab("Mean Prescriptions") +
  theme_minimal(base_size = 12, base_family = "Georgia") 

##### PLOT XX #####

opioid2015trunc <- subset(opioid2015, total_30_day_fill_count<5000)

ggplot(opioid2015trunc, aes(x=total_30_day_fill_count, ..density..)) + 
  xlab("Total prescriptions") +
  ylab("Fraction of physicians") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_histogram(data = subset(opioid2015trunc, specialty=="Family Medicine"), fill = "red", alpha = 0.2) + 
  geom_histogram(data = subset(opioid2015trunc, specialty=="Pain Management"), fill = "blue", alpha = 0.2)

ggplot(opioid2015trunc, aes(x=total_30_day_fill_count)) + 
  xlab("Total prescriptions") +
  ylab("Number of physicians") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_histogram(data = subset(opioid2015trunc, specialty=="FAMILYPRACTICE"), fill = "red", alpha = 0.2) + 
  geom_histogram(data = subset(opioid2015trunc, specialty=="PAINMANAGEMENT"), fill = "blue", alpha = 0.2)

##### PLOT 3 #####

# collapse by credential
opioid2015_collapse_credentials <- opioid2015 %>% 
  group_by(credentials) %>%
  summarize(sum = sum(total_30_day_fill_count, na.rm=TRUE), n=n()) %>%
  arrange(desc(sum))

# subset to common credentials
opioid2015_collapse_credentials_trunc <- subset(opioid2015_collapse_credentials, n>1000)

# plot
ggplot(opioid2015_collapse_credentials_trunc, aes(x = reorder(credentials, -sum), y=sum)) +
  xlab("Credential") +
  ylab("Mean prescriptions") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_bar(stat="identity") +
  theme(axis.text.x = element_text(angle = 90, hjust=1))

##### PLOT 4 #####

# collapse by payment count
opioid2015_collapse_paymentcount <- opioid2015 %>% 
  group_by(payment_count, specialty) %>%
  summarize(mean = mean(total_30_day_fill_count, na.rm=TRUE), n=n())

# subset to deal with sample size issue
opioid2015_collapse_paymentcount_trunc <- subset(opioid2015_collapse_paymentcount, payment_count<=17)
opioid2015_collapse_paymentcount_trunc$mean[opioid2015_collapse_paymentcount_trunc$payment_count>15] <- NA

ggplot(subset(opioid2015_collapse_paymentcount_trunc, specialty=="Internal Medicine"), aes(x=payment_count, y=mean)) +
  xlab("Number of opioid-related payments received") +
  ylab("Mean opioid prescriptions") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_point(alpha=0.5, colour="blue") +
  geom_smooth(method='lm', colour="blue", fill=NA) +
  geom_point(alpha=0.5, data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Orthopedic Surgery"), colour="red") +
  geom_smooth(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Orthopedic Surgery"), method='lm', colour="red", fill=NA) +
  geom_point(alpha=0.5, data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Pain Management"), colour="green") +
  geom_smooth(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Pain Management"), method='lm', colour="green", fill=NA) +
  geom_point(alpha=0.5, data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Anesthesiology"), colour="purple") +
  geom_smooth(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Anesthesiology"), method='lm', colour="purple", fill=NA) +
  geom_point(alpha=0.5, data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Family Medicine"), colour="orange") +
  geom_smooth(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Family Medicine"), method='lm', colour="orange", fill=NA) +
  annotate("text", family="Georgia", hjust=0, x = 15.25, y = 850, label = "Internal Medicine", color="blue", size=3, fontface=1) +
  annotate("text", family="Georgia", hjust=0, x = 15.25, y = 625, label = "Orthopedic Surgery", color="red", size=3, fontface=1) +
  annotate("text", family="Georgia", hjust=0, x = 15.25, y = 1725, label = "Pain Management", color="green", size=3, fontface=1) +
  annotate("text", family="Georgia", hjust=0, x = 15.25, y = 1485, label = "Anesthesiology", color="purple", size=3, fontface=1) +
  annotate("text", family="Georgia", hjust=0, x = 15.25, y = 795, label = "Family Medicine", color="orange", size=3, fontface=1) 
  

# plot payment vs prescriptions
ggplot(subset(opioid2015_collapse_paymentcount_trunc, specialty=="Pain Management"), aes(x=payment_count, y=mean)) +
  xlab("Number of opioid-related payments received") +
  ylab("Mean opioid prescriptions") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_point(alpha=0.5, colour="blue") +
  geom_smooth(method='lm', colour="blue", fill=NA) +
  geom_point(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Physical Medicine and Rehabilitation"), colour="red") +
  geom_smooth(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Physical Medicine and Rehabilitation"), method='lm', colour="red", fill=NA) +
  geom_point(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Anesthesiology"), colour="green") +
  geom_smooth(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Anesthesiology"), method='lm', colour="green", fill=NA) +
  geom_point(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Surgery"), colour="navy") +
  geom_smooth(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Surgery"), method='lm', colour="navy", fill=NA) +
  geom_point(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Internal Medicine"), colour="purple") +
  geom_smooth(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Internal Medicine"), method='lm', colour="purple", fill=NA) +
  geom_point(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Family Medicine"), colour="orange") +
  geom_smooth(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Family Medicine"), method='lm', colour="orange", fill=NA) +
  geom_point(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Emergency Medicine"), colour="black") +
  geom_smooth(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Emergency Medicine"), method='lm', colour="black", fill=NA) +
  geom_point(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Obstetrics and Gynecology"), colour="grey") +
  geom_smooth(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Obstetrics and Gynecology"), method='lm', colour="grey", fill=NA) +
  geom_point(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="General Practice"), colour="darkgreen") +
  geom_smooth(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="General Practice"), method='lm', colour="darkgreen", fill=NA) +
  geom_point(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Thoracic Surgery"), colour="black") +
  geom_smooth(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Thoracic Surgery"), method='lm', colour="black", fill=NA) +
  geom_point(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Plastic Surgery"), colour="black") +
  geom_smooth(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Plastic Surgery"), method='lm', colour="black", fill=NA)

# plot payment vs prescriptions
ggplot(opioid2015_collapse_paymentcount_trunc_im, aes(x=payment_count, y=mean)) +
  xlab("Number of opioid-related payments received") +
  ylab("Mean opioid prescriptions") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_point(colour="blue") +
  geom_smooth(method='lm', colour="blue", fill=NA) +
  geom_point(data = opioid2015_collapse_paymentcount_trunc_s, colour="red") +
  geom_smooth(data = opioid2015_collapse_paymentcount_trunc_s, method='lm', colour="red", fill=NA) +
  geom_point(data = opioid2015_collapse_paymentcount_trunc_pm, colour="green") +
  geom_smooth(data = opioid2015_collapse_paymentcount_trunc_pm, method='lm', colour="green", fill=NA) 


##### PLOT 5 #####




# collapse by payment count
opioid2015_collapse_paymentcount <- opioid2015 %>% 
  group_by(payment_count, state) %>%
  summarize(mean = mean(total_30_day_fill_count, na.rm=TRUE), n=n())

# subset to deal with sample size issue
opioid2015_collapse_paymentcount_trunc <- subset(opioid2015_collapse_paymentcount, payment_count<=15)

# subset to la
opioid2015_collapse_paymentcount_trunc_la <- subset(opioid2015_collapse_paymentcount_trunc, state=="LA")

# subset to co
opioid2015_collapse_paymentcount_trunc_co <- subset(opioid2015_collapse_paymentcount_trunc, state=="CO")

# subset to co
opioid2015_collapse_paymentcount_trunc_al <- subset(opioid2015_collapse_paymentcount_trunc, state=="AL")

# plot payment vs prescriptions
ggplot(opioid2015_collapse_paymentcount_trunc_al, aes(x=payment_count, y=mean)) +
  xlab("Number of opioid-related payments received") +
  ylab("Mean opioid prescriptions") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_point(colour="blue") +
  geom_smooth(method='lm', colour="blue", fill=NA) +
  geom_point(data = opioid2015_collapse_paymentcount_trunc_co, colour="red") +
  geom_smooth(data = opioid2015_collapse_paymentcount_trunc_co, method='lm', colour="red", fill=NA) 

###### PLOT 6 #####

opioid2015_collapse_cty <- opioid2015 %>% 
  group_by(cty) %>%
  summarize(meanpay = mean(payment_count, na.rm=TRUE), meanpre = mean(total_30_day_fill_count, na.rm=TRUE),  n=n()) %>%
  filter(n>50)

ggplot(opioid2015_collapse_cty, aes(meanpay, meanpre)) + 
  geom_point(alpha=0.4) +
  xlab("Mean Number of Payments") +
  ylab("Mean Prescriptions") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_smooth(method="lm", fill=NA, color="darkgreen")

###### 

# remove outliers
opioid2015_noutliers <- subset(opioid2015, payment<1000 & total_30_day_fill_count<1000)

# hexbinplot
hexbinplot(total_30_day_fill_count ~ payment, opioid2015_noutliers, xbins=30)

# geom_hex(data=opioid2015_trunc, aes(x=payment_count, y=total_30_day_fill_count), alpha=0.3)



