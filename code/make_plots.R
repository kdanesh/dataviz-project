# load packages
library(foreign)
library(hexbin)
library(ggplot2)
library(readr)
library(dplyr)
#library(plyr)
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
# Series 1. Who's prescribing the most opioids? It's your primary care doc
## a. bar chart: total prescriptions for top 10 specialties
## b. densities: prescriptions per patient prescribed opioids for each specialty
## c. map: percent of opioids prescribed by primary care docs, by county
# Series 2. Are dollars for docs fueling the opioid epidemic?
## a. scatterplot: prescriptions vs number of payments
## b. scatterplot: prescriptions vs number of payments, top 5 specialties
## c. line graph: prescriptions over time, by payment intensity
###

setwd("/Users/Kaveh/GitHub/dataviz-project/plots")

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
# pal = c("#cccccc","#cccccc","#cccccc","#cccccc","#cccccc",
#       "#377eb8", "#e41a1c", "#4daf4a", "#984ea3", "#ff7f00")

pal <- c("#a6cee3", "#1f78b4", "#b2df8a",
         "#33a02c", "#fb9a99", "#e31a1c",
         "#fdbf6f", "#ff7f00", "#cab2d6",
         "#6a3d9a")
ggplot(opioid2015_collapse_specialty_t10spre, aes(x = reorder(specialty, sumpre), y=sumpre)) +
  xlab("") +
  ylab("Total prescriptions (millions)") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_bar(stat="identity", fill=pal) +
  coord_flip()
ggsave("specialty_top10pre_total.png", dpi = 300, width = 6, height = 4, units = "in")

# plot top 10 prescription by mean
ggplot(opioid2015_collapse_specialty_t10mpre, aes(x = reorder(specialty, meanpre), y=meanpre)) +
  xlab("") +
  ylab("Mean prescriptions (per physician)") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_bar(stat="identity", fill="red") +
  coord_flip() 

##### PLOT 1b #####

opioid2015trunc <- subset(opioid2015, total_30_day_fill_count<2000)

opioid2015trunc_t10 <- subset(opioid2015trunc, specialty=="Family Medicine" | specialty=="Pain Management" | 
                                specialty=="Internal Medicine" | specialty=="Anesthesiology" | 
                                specialty=="Orthopedic Surgery" | specialty=="Emergency Medicine" |
                                specialty=="Physical Medicine and Rehabilitation" | specialty=="Emergency Medicine" |
                                specialty=="General Practice" | specialty=="Surgery" | specialty=="Dentistry")

opioid2015trunc_t10 <- opioid2015trunc_t10 %>%
  mutate(prescriptions_pp = total_30_day_fill_count/bene_count)

opioid2015trunc_t10 <- subset(opioid2015trunc_t10, prescriptions_pp<12)

opioid2015trunc_t5$specialty <- factor(opioid2015trunc_t5$specialty, levels = c( "Pain Management", "Anesthesiology", "Family Medicine", "Internal Medicine", "Orthopedic Surgery"))
opioid2015trunc_t5$specialty <- factor(opioid2015trunc_t5$specialty, levels = c("Orthopedic Surgery", "Pain Management", "Anesthesiology", "Family Medicine", "Internal Medicine"))

pal = c("#4daf4a", "#984ea3", "#ff7f00", "#377eb8", "#e41a1c")
ggplot(opioid2015trunc_t5, aes(prescriptions_pp, fill = specialty)) +
  geom_density(position="stack")+
  scale_fill_manual("legend", values = pal) +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  theme(legend.position="bottom", legend.title=element_blank(), legend.text=element_text(size=9)) +
  xlab("Opioid prescriptions (per patient prescribed opioids)") +
  ylab("Number of physicians") +
  scale_x_continuous(breaks=c(3,6,9,12)) +
  guides(fill=guide_legend(keywidth=0.1, keyheight=0.1, default.unit="inch"))
ggsave("prescriptions_hist_by_specialty.png", dpi = 300, width = 6, height = 4, units = "in")

means <- opioid2015trunc_t10 %>%
  group_by(specialty) %>%
  summarize(mean=mean(prescriptions_pp))
  

###



# create a vector containing top 10 specialties and their associated colors
list <- c("Family Medicine", "Pain Management", "Anesthesiology", "Internal Medicine", 
          "Physical Medicine and Rehabilitation", "General Practice",
          "Orthopedic Surgery", "Surgery", "Emergency Medicine",
          "Dentistry")

pal <- c("#a6cee3", "#1f78b4", "#b2df8a",
            "#33a02c", "#fb9a99", "#e31a1c",
            "#fdbf6f", "#ff7f00", "#cab2d6",
            "#6a3d9a")

#guides(fill=guide_legend(keywidth=0.1, keyheight=0.1, default.unit="inch")) +
  

# loop through and create densities
for(i in 1:10) {
  subset <- subset(opioid2015trunc_t10, specialty==list[i])
  assign(paste0("p",i,sep=""), 
    ggplot(subset, aes(prescriptions_pp, fill=specialty)) +
    geom_density() +
    theme_minimal(base_size = 12, base_family = "Georgia") +
    theme(legend.position="bottom", legend.title=element_blank(), legend.text=element_text(size=9)) +
    xlab("") +
    ylab("") +
    guides(fill=guide_legend(keywidth=0.1, keyheight=0.1, default.unit="inch"))+
    scale_x_continuous(breaks=c(0,6,12), limits=c(0,12)) +
    scale_y_continuous(breaks=c(), limits=c(0,1)) +
    scale_fill_manual(values = pal[i])
  )
  print(eval(as.name(paste0("p",i,sep=""))))
}

grid.arrange(p1, p2, p3, p4, p5, p6, p7,p8, p9, p10, ncol=5)
ggsave("prescriptions_dens_by_specialty.png", dpi = 300, width = 6, height = 4, units = "in")


# geom_histogram

######### PLOT 1c ###########
# map: percent by primary care docs by county
############################

# done elsewhere

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
  geom_point(alpha=0.5, size=3) +
  geom_smooth(method="lm", se=FALSE, colour="navy") 
ggsave("meetings_30dayfill.png", dpi = 300, width = 6, height = 4, units = "in")


######### PLOT 2b ###########
# prescriptions vs number of payments, by specialty
############################

# collapse by payment count
opioid2015_collapse_paymentcount <- opioid2015 %>% 
  group_by(payment_count, specialty) %>%
  summarize(mean = mean(total_30_day_fill_count, na.rm=TRUE), n=n())

# subset to deal with sample size issue
opioid2015_collapse_paymentcount_trunc <- subset(opioid2015_collapse_paymentcount, payment_count<=15)
#opioid2015_collapse_paymentcount_trunc$mean[opioid2015_collapse_paymentcount_trunc$payment_count>15] <- NA

# keep only top 5 specialties
opioid2015_collapse_paymentcount_trunc <- opioid2015_collapse_paymentcount_trunc %>%
  filter(specialty=="Orthopedic Surgery" | specialty=="Pain Management" | specialty=="Anesthesiology" | specialty=="Family Medicine" | specialty=="Internal Medicine")


pal = c("#377eb8", "#984ea3", "#ff7f00", "#e41a1c", "#4daf4a")
ggplot(subset(opioid2015_collapse_paymentcount_trunc), aes(x=payment_count, y=mean, colour = specialty)) +
  geom_point(alpha=0.4) +
  geom_smooth(method='lm', se=FALSE) + 
  xlab("Number of opioid-related payments received") +
  ylab("Mean opioid prescriptions") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  theme(legend.position="bottom", legend.title=element_blank(), legend.text=element_text(size=9)) +
  scale_color_manual(values=pal) 
ggsave("prescriptions_meetings_by_specialty.png", dpi = 300, width = 6, height = 4, units = "in")


######### PLOT 2c #########
# mean number of payment, by county
##########################

# done in map software 

######### PLOT 2d #########
# mean payments and prescriptions by year, movers vs nonmovers
##########################

setwd("/Users/Kaveh/Dropbox/Berkeley/projects/econ/opioid/data_derived")
staymove <- read.csv("staymove.csv")

# change label names
staymove$staymove <- as.character(staymove$staymove)
staymove$staymove[as.character(staymove$staymove)=="s"] <- "stayers"
staymove$staymove[as.character(staymove$staymove)=="m"] <- "movers"

p1 <- ggplot(staymove, aes(year, payment_count)) +
        geom_point(aes(colour = factor(staymove))) +
        ggtitle("Average payments received") +
        xlab("") + 
        ylab("") +
        scale_x_continuous(breaks = c(2013, 2014, 2015)) +
        theme_minimal(base_size = 12, base_family = "Georgia") +
        geom_line(data=staymove[staymove$staymove=="stayers",], colour="steelblue1") +
        geom_line(data=staymove[staymove$staymove=="movers" & staymove$year<2015,], colour="tomato1", arrow=arrow(type="closed", length=unit(0.30,"cm"))) +
        geom_line(data=staymove[staymove$staymove=="movers" & staymove$year>2013,], colour="tomato1", arrow=arrow(type="closed", length=unit(0.30,"cm"))) +
        theme(legend.position="bottom", legend.title=element_blank(), plot.title = element_text(size=11, hjust=0.5))

p2 <- ggplot(staymove, aes(year, total_30_day_fill_count)) +
        geom_point(aes(colour = factor(staymove))) +
        ggtitle("Average prescriptions given") +
        ylab("") +
        xlab("") + 
        scale_x_continuous(breaks = c(2013, 2014, 2015)) +
        theme_minimal(base_size = 12, base_family = "Georgia") +
        geom_line(data=staymove[staymove$staymove=="stayers",], colour="steelblue1") +
        geom_line(data=staymove[staymove$staymove=="movers" & staymove$year<2015,], colour="tomato1", arrow=arrow(type="closed", length=unit(0.30,"cm"))) +
        geom_line(data=staymove[staymove$staymove=="movers" & staymove$year>2013,], colour="tomato1", arrow=arrow(type="closed", length=unit(0.30,"cm"))) +
        theme(legend.position="none", plot.title = element_text(size=11, hjust=0.5))  

g_legend<-function(a.gplot){
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)}

mylegend<-g_legend(p1)

grid.arrange(arrangeGrob(p1 + theme(legend.position="none"),
                               p2 + theme(legend.position="none"),
                               nrow=1), mylegend, nrow=2,heights=c(10, 1))
ggsave("staymove.png", dpi = 300, width = 6, height = 4, units = "in")


setwd("/Users/Kaveh/GitHub/dataviz-project/plots")

######### PLOT 2e #########
# mean payments and prescriptions by year, movers vs nonmovers
##########################

setwd("/Users/Kaveh/Dropbox/Berkeley/projects/econ/opioid/data_derived")
county <- read.csv("county_pre_pay_deaths.csv")
setwd("/Users/Kaveh/GitHub/dataviz-project/plots")


county_pctpay <- county %>%
  group_by(pct_pay) %>%
  summarize(deaths = mean(deaths, na.rm=TRUE))

ggplot(county_pctpay, aes(x=pct_pay, y=deaths)) +
  xlab("50 quantiles of payments") +
  ylab("Mean deaths") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_point(alpha=0.5, size=3) +
  geom_smooth(method="lm", se=FALSE, color="blue") 
ggsave("county_payments_deaths.png", dpi = 400, width = 8, height = 6, units = "in")

county_pctpre <- county %>%
  group_by(pct_pre) %>%
  summarize(deaths = mean(deaths, na.rm=TRUE))

ggplot(county_pctpre, aes(x=pct_pre, y=deaths)) +
  xlab("50 quantiles of primary care prescription rate") +
  ylab("Mean deaths") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_point(alpha=0.5, size=3) +
  geom_smooth(method="lm", se=FALSE, color="red") 
ggsave("county_prescriptions_deaths", dpi = 400, width = 8, height = 6, units = "in")

setwd("/Users/Kaveh/Dropbox/Berkeley/projects/econ/opioid/data_derived")
county <- read.csv("county_pre_pay_deaths.csv")
setwd("/Users/Kaveh/GitHub/dataviz-project/plots")


county_pctpay <- county %>%
  group_by(pct_pay) %>%
  summarize(deaths = mean(deaths, na.rm=TRUE))

ggplot(county_pctpay, aes(x=pct_pay, y=deaths)) +
  xlab("50 quantiles of payments") +
  ylab("Mean deaths") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_point(alpha=0.5, size=3) +
  geom_smooth(method="lm", se=FALSE, color="blue") 
ggsave("county_payments_deaths.png", dpi = 400, width = 8, height = 6, units = "in")

county_pctpre <- county %>%
  group_by(pct_pre) %>%
  summarize(deaths = mean(deaths, na.rm=TRUE))

ggplot(county_pctpre, aes(x=pct_pre, y=deaths)) +
  xlab("50 quantiles of primary care prescription rate") +
  ylab("Mean deaths") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_point(alpha=0.5, size=3) +
  geom_smooth(method="lm", se=FALSE, color="red") 
ggsave("county_prescriptions_deaths.png", dpi = 400, width = 8, height = 6)


  




##### OTHER STUFF #####

ggplot(opioid2015trunc_t5, aes(total_30_day_fill_count, fill = specialty)) +
  geom_histogram(binwidth = 10, alpha=0.6) +
  scale_fill_manual("legend", values = c("Family Medicine" = "orange", "Pain Management" = "green", "Internal Medicine" = "blue", "Anesthesiology" = "purple", "Orthopedic Surgery" = "red")) +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  theme(legend.position="bottom", legend.title=element_blank(), legend.text=element_text(size=9)) +
  xlab("Opioid prescriptions (per patient prescribed opioids)") +
  ylab("Number of physicians") +
  guides(fill=guide_legend(keywidth=0.1, keyheight=0.1, default.unit="inch"))


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

######### PLOT 1d ###########
# histogram: total prescriptions by primary care docs
############################

# create truncated version of dataset
opioid2015trunc <- subset(opioid2015, total_30_day_fill_count<2500)

# make histogram
ggplot(opioid2015trunc, aes(x=total_30_day_fill_count)) + 
  xlab("Total opioid prescriptions") +
  ylab("Number of physicians") +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  geom_histogram(binwidth=50, data = subset(opioid2015trunc, specialty=="Family Medicine"), fill = "orange", alpha = 0.6)


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
  annotate("text", family="Georgia", hjust=0, x = 15.25, y = 845, label = "Internal Medicine", color="blue", size=3, fontface=1.2) +
  annotate("text", family="Georgia", hjust=0, x = 15.25, y = 630, label = "Orthopedic Surgery", color="red", size=3, fontface=1.2) +
  annotate("text", family="Georgia", hjust=0, x = 15.25, y = 1715, label = "Pain Management", color="green", size=3, fontface=1.2) +
  annotate("text", family="Georgia", hjust=0, x = 15.25, y = 1490, label = "Anesthesiology", color="purple", size=3, fontface=1.2) +
  annotate("text", family="Georgia", hjust=0, x = 15.25, y = 785, label = "Family Medicine", color="orange", size=3, fontface=1.2) 


annotate("text", family="Georgia", hjust=0, x = 15.25, y = 845, label = "Internal Medicine", color="blue", size=3, fontface=1.2) +
  annotate("text", family="Georgia", hjust=0, x = 15.25, y = 630, label = "Orthopedic Surgery", color="red", size=3, fontface=1.2) +
  annotate("text", family="Georgia", hjust=0, x = 15.25, y = 1715, label = "Pain Management", color="green", size=3, fontface=1.2) +
  annotate("text", family="Georgia", hjust=0, x = 15.25, y = 1490, label = "Anesthesiology", color="purple", size=3, fontface=1.2) +
  annotate("text", family="Georgia", hjust=0, x = 15.25, y = 785, label = "Family Medicine", color="orange", size=3, fontface=1.2) 

