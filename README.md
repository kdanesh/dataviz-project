# Should Big Pharma Market Opioids to Doctors?

In light of [past](http://www.nytimes.com/2007/05/10/business/11drug-web.html?mcubz=0) and [recent](http://www.npr.org/sections/thetwo-way/2017/09/19/552135830/41-states-to-investigate-pharmaceutical-companies-over-opioids) news that pharmaceutical companies may have fueled the opioid epidemic, I plan to study the association between payments made by opioid manufacturers to physicians and opioid prescriptions. In particular, I would like to explore whether payments are significantly associated with prescriptions.

In order to study this assocation, I use the following measures:
- number of opioid-related payments: the number of times a physician was paid by a pharmaceutical company to learn about an opioid
- opioid prescriptions: the number of 30-day prescriptions of any opioid

As a start, I have made the following three plots (see plots folder in GitHub):
- mean number of opioid-related payments by county in 2015 (map; currently lacking legend)
- mean opioid prescriptions by county in 2015 (map; also currently lacking legend)
- mean opioid prescriptions vs number of opioid-related payments in 2015 (scatterplot)

### Challenges and next steps

Challenges:
- What is the right measure of marketing intensity? number of times a physician was paid by a pharma company, or total dollars received?
- How do I get closer to saying something about causality?
- Will there be space to bring in data on deaths?

Next steps:
- Break down payments and prescriptions by physician specialty
- Think about using data from multiple years (2013-15) to get at causality