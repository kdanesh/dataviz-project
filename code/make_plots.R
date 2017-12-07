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

# plot top 10 prescription by sum
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
    theme(legend.position="bottom", legend.title=element_blank(), legend.text=element_text(size=9), panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank()) +
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


#### PLOT 1c ###########
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

# keep only top 5 specialties
opioid2015_collapse_paymentcount_trunc <- opioid2015_collapse_paymentcount_trunc %>%
  filter(specialty=="Orthopedic Surgery" | specialty=="Pain Management" | specialty=="Anesthesiology" | specialty=="Family Medicine" | specialty=="Internal Medicine")


pal <- c("#a6cee3", "#1f78b4", "#b2df8a",
         "#33a02c", "#fb9a99")
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
# mean payments and prescriptions by year, by advertising intensity
##########################

setwd("/Users/Kaveh/Dropbox/Berkeley/projects/econ/opioid/data_derived")
pot <- read.csv("payments_over_time.csv")
setwd("/Users/Kaveh/GitHub/dataviz-project/plots")

# change label names
pot$meetings <- as.character(pot$meetings)
pot$meetings[as.character(pot$meetings)=="0"] <- "attended 0 meetings"
pot$meetings[as.character(pot$meetings)=="1-9"] <- "attended 1-9 meetings"
pot$meetings[as.character(pot$meetings)=="10+"] <- "attended 10+ meetings"

pal <- c("#fee6ce", "#fdae6b", "#e6550d")
p1 <- ggplot(pot, aes(year, payment_count, colour = meetings)) +
  geom_line(size=1.5) +
  ggtitle("Average meetings attended") +
  xlab("") + 
  ylab("") +
  scale_x_continuous(breaks = c(2013, 2014, 2015)) +
  theme_minimal(base_size = 12, base_family = "Georgia") +
  scale_color_manual(values=pal) +
  theme(legend.position="bottom", legend.title=element_blank(), plot.title = element_text(size=11, hjust=0.5))

p2 <- ggplot(pot, aes(year, total_30_day_fill_count, colour = meetings)) +
    geom_line(size=1.5) +
    ggtitle("Average opioids prescribed") +
    xlab("") + 
    ylab("") +
    scale_x_continuous(breaks = c(2013, 2014, 2015)) +
    theme_minimal(base_size = 12, base_family = "Georgia") +
    scale_color_manual(values=pal) +
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
ggsave("pot.png", dpi = 300, width = 6, height = 4, units = "in")
