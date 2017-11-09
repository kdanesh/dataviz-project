# Should Big Pharma Market Opioids to Doctors?

In light of [past](http://www.nytimes.com/2007/05/10/business/11drug-web.html?mcubz=0) and [recent](http://www.npr.org/sections/thetwo-way/2017/09/19/552135830/41-states-to-investigate-pharmaceutical-companies-over-opioids) news that pharmaceutical companies may have fueled the opioid epidemic, I plan to study the association between payments made by opioid manufacturers to physicians and opioid prescriptions. In particular, I would like to explore whether payments are significantly associated with prescriptions.

In order to study this assocation, I use the following measures:
- number of opioid-related payments: the number of times a physician was paid by a pharmaceutical company to learn about an opioid
- opioid prescriptions: the number of 30-day prescriptions of any opioid

As a start, I've made the following three plots (see below):
- mean number of opioid-related payments by county in 2015 (map)
- mean opioid prescriptions by county in 2015 (map)
- mean opioid prescriptions vs number of opioid-related payments in 2015 (scatterplot)

###### Mean Number of Opioid-Related Payments Received by Physicians in 2015

![Alt text](/Users/Kaveh/Dropbox/Berkeley/projects/econ/opioid/output/map_meetings.png "Mean Number of Opioid-Related Payments")

###### Mean Number of Opioid Prescriptions in 2015

![Alt text](/Users/Kaveh/Dropbox/Berkeley/projects/econ/opioid/output/map_30dayfill.png "Mean Number of Opioid Prescriptions")

###### Association between Number of Payments and 30-Day Fill Count in 2015

![Alt text](/Users/Kaveh/Dropbox/Berkeley/projects/econ/opioid/output/meetings_30dayfill.png "Association between Number of Opioid-Related Payments and Opioid Prescriptions")

### Challenges and next steps

Challenges:
- What is the right measure of marketing intensity? number of times a physician was paid by a pharma company, or total dollars received?
- How do I get closer to saying something about causality?
- Will there be space to bring in data on deaths?

Next steps:
- Break down payments and prescriptions by physician specialty
- Think about using data from multiple years (2013-15) to get at causality