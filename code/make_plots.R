# load packages
library(foreign)
library(hexbin)
library(ggplot2)
library(readr)
library(dplyr)
library(plyr)
library(grid)
library(gridExtra)

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


### 
# This script creates two sets of plots:
# Series 1. Your primary care doc prescribes more opioids than you might think 
## a. bar chart: total prescriptions by specialty
## b. map: percent of opioids prescribed by primary care docs, by county
## c. histogram: total prescriptions by primary care docs
# Series 2. Are dollars for docs fueling the opioid epidemic?
## a. scatterplot: prescriptions vs number of payments
## b. scatterplot: prescriptions vs number of payments, top 5 specialties
## c. map: mean number of payment, by county
## d. scatterplots: mean payments and prescriptions by year, movers vs nonmovers
###

######### PLOT 1a ###########
# bar chart: presciptions by specialty
############################

# collapse by specialty
opioid2015_collapse_specialty <- opioid2015 %>% 
  group_by(specialty) %>%
  summarize(meanpre = mean(total_30_day_fill_count, na.rm=TRUE), 
            sumpre = sum(total_30_day_fill_count, na.rm=TRUE), 
            meanpay = mean(payment_count, na.rm=TRUE), 
            sumpay = sum(payment_count, na.rm=TRUE), 
            sumbene = sum(bene_count, na.rm=TRUE),
            n=n())

opioid2015_collapse_specialty %>%
  mutate(sumpresumpre/sumbene)
# remove specialties with fewer than 1000 doctors
opioid2015_collapse_specialty_trunc <- subset(opioid2015_collapse_specialty, n>=1000)

# top 10 prescriptions by sum
opioid2015_collapse_specialty <- arrange(opioid2015_collapse_specialty, desc(sumpre))
opioid2015_collapse_specialty_t10spre <- opioid2015_collapse_specialty[1:10,]
opioid2015_collapse_specialty_t10spre$sumpre <- opioid2015_collapse_specialty_t10spre$sumpre/10^6

# top 10 prescriptions by mean
opioid2015_collapse_specialty <- arrange(opioid2015_collapse_specialty_trunc, desc(meanpre))
opioid2015_collapse_specialty_t10mpre <- opioid2015_collapse_specialty[1:10,]

# plot top 10 prescription by sum
ggplot(opioid2015_collapse_specialty_t10spre, aes(x = reorder(specialty, sumpre), y=sumpre)) +
  xlab("") +
  ylab("Total prescriptions (millions)") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_bar(stat="identity", fill="red") +
  coord_flip()

# plot top 10 prescription by mean
ggplot(opioid2015_collapse_specialty_t10mpre, aes(x = reorder(specialty, meanpre), y=meanpre)) +
  xlab("") +
  ylab("Mean prescriptions (per physician)") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_bar(stat="identity", fill="red") +
  coord_flip()

######### PLOT 1b ###########
# map: percent by primary care docs by county
############################

# done elsewhere

######### PLOT 1c ###########
# histogram: total prescriptions by primary care docs
############################

# creat truncated version of dataset
opioid2015trunc <- subset(opioid2015, total_30_day_fill_count<2500)

# make histogram
ggplot(opioid2015trunc, aes(x=total_30_day_fill_count)) + 
  xlab("Total opioid prescriptions") +
  ylab("Number of physicians") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_histogram(binwidth=50, data = subset(opioid2015trunc, specialty=="Family Medicine"), fill = "orange", alpha = 0.6)

######### PLOT 2a ###########
# prescriptions vs number of payments
############################

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

######### PLOT 2b ###########
# prescriptions vs number of payments, by specialty
############################

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
  geom_point(alpha=0.4, colour="blue") +
  geom_smooth(method='lm', colour="blue", fill=NA) +
  geom_point(alpha=0.4, data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Orthopedic Surgery"), colour="red") +
  geom_smooth(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Orthopedic Surgery"), method='lm', colour="red", fill=NA) +
  geom_point(alpha=0.4, data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Pain Management"), colour="green") +
  geom_smooth(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Pain Management"), method='lm', colour="green", fill=NA) +
  geom_point(alpha=0.4, data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Anesthesiology"), colour="purple") +
  geom_smooth(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Anesthesiology"), method='lm', colour="purple", fill=NA) +
  geom_point(alpha=0.4, data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Family Medicine"), colour="orange") +
  geom_smooth(data = subset(opioid2015_collapse_paymentcount_trunc, specialty=="Family Medicine"), method='lm', colour="orange", fill=NA) +
  annotate("text", family="Georgia", hjust=0, x = 15.25, y = 830, label = "Internal Medicine", color="blue", size=3, fontface=1.2) +
  annotate("text", family="Georgia", hjust=0, x = 15.25, y = 620, label = "Orthopedic Surgery", color="red", size=3, fontface=1.2) +
  annotate("text", family="Georgia", hjust=0, x = 15.25, y = 1675, label = "Pain Management", color="green", size=3, fontface=1.2) +
  annotate("text", family="Georgia", hjust=0, x = 15.25, y = 1475, label = "Anesthesiology", color="purple", size=3, fontface=1.2) +
  annotate("text", family="Georgia", hjust=0, x = 15.25, y = 775, label = "Family Medicine", color="orange", size=3, fontface=1.2) 

######### PLOT 2c #########
# mean number of payment, by county
##########################

# done in map software 

######### PLOT 2d #########
# mean payments and prescriptions by year, movers vs nonmovers
##########################

staymove <- read.csv("staymove.csv")

p1 <- ggplot(staymove, aes(year, payment_count)) +
        geom_point(aes(colour = factor(staymove))) +
        ggtitle("Average payments received") +
        xlab("") + 
        ylab("") +
        scale_x_continuous(breaks = c(2013, 2014, 2015)) +
        theme_minimal(base_size = 12, base_family = "Georgia") +
        geom_line(data=staymove[staymove$staymove=="s",], colour="steelblue1") +
        geom_line(data=staymove[staymove$staymove=="m" & staymove$year<2015,], colour="tomato1", arrow=arrow(type="closed", length=unit(0.30,"cm"))) +
        geom_line(data=staymove[staymove$staymove=="m" & staymove$year>2013,], colour="tomato1", arrow=arrow(type="closed", length=unit(0.30,"cm"))) +
        theme(legend.position="none", plot.title = element_text(size=11, hjust=0.5))

p2 <- ggplot(staymove, aes(year, total_30_day_fill_count)) +
        geom_point(aes(colour = factor(staymove))) +
        ggtitle("Average prescriptions given") +
        ylab("") +
        xlab("") + 
        scale_x_continuous(breaks = c(2013, 2014, 2015)) +
        theme_minimal(base_size = 12, base_family = "Georgia") +
        geom_line(data=staymove[staymove$staymove=="s",], colour="steelblue1") +
        geom_line(data=staymove[staymove$staymove=="m" & staymove$year<2015,], colour="tomato1", arrow=arrow(type="closed", length=unit(0.30,"cm"))) +
        geom_line(data=staymove[staymove$staymove=="m" & staymove$year>2013,], colour="tomato1", arrow=arrow(type="closed", length=unit(0.30,"cm"))) +
        theme(legend.position="none", plot.title = element_text(size=11, hjust=0.5))  

grid.arrange(p1, p2, ncol=2)

##### PLOT 4 #####

opioid2015trunc <- subset(opioid2015, total_30_day_fill_count<2000)

opioid2015trunc_t5 <- subset(opioid2015trunc, specialty=="Family Medicine" | specialty=="Pain Management" | specialty=="Internal Medicine" | specialty=="Anesthesiology" | specialty=="Orthopedic Surgery")

opioid2015trunc_t5 <- opioid2015trunc_t5 %>%
  mutate(prescriptions_pp = total_30_day_fill_count/bene_count)

opioid2015trunc_t5 <- subset(opioid2015trunc_t5, prescriptions_pp<12)

ggplot(opioid2015trunc_t5, aes(prescriptions_pp, fill = specialty)) +
  geom_histogram(binwidth = .1, alpha=0.6) +
  scale_fill_manual("legend", values = c("Family Medicine" = "orange", "Pain Management" = "green", "Internal Medicine" = "blue", "Anesthesiology" = "purple", "Orthopedic Surgery" = "red")) +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  theme(legend.position="bottom", legend.title=element_blank(), legend.text=element_text(size=9)) +
  xlab("Opioid prescriptions (per patient prescribed opioids)") +
  ylab("Number of physicians") +
  scale_x_continuous(breaks=c(3,6,9,12)) +
  guides(fill=guide_legend(keywidth=0.1, keyheight=0.1, default.unit="inch"))
  
ggplot(opioid2015trunc_t5, aes(total_30_day_fill_count, fill = specialty)) +
  geom_histogram(binwidth = 10, alpha=0.6) +
  scale_fill_manual("legend", values = c("Family Medicine" = "orange", "Pain Management" = "green", "Internal Medicine" = "blue", "Anesthesiology" = "purple", "Orthopedic Surgery" = "red")) +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  theme(legend.position="bottom", legend.title=element_blank(), legend.text=element_text(size=9)) +
  xlab("Opioid prescriptions (per patient prescribed opioids)") +
  ylab("Number of physicians") +
  guides(fill=guide_legend(keywidth=0.1, keyheight=0.1, default.unit="inch"))

##### OTHER STUFF #####

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

# collapse by credential
opioid2015_collapse_credentials <- opioid2015 %>% 
  group_by(credentials) %>%
  summarize(sum = sum(total_30_day_fill_count, na.rm=TRUE), n=n()) %>%
  arrange(desc(sum))

# subset to common credentials
opioid2015_collapse_credentials_trunc <- subset(opioid2015_collapse_credentials, n>1000)
