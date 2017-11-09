# Should Big Pharma Market Opioids to Doctors?

In light of [past](http://www.nytimes.com/2007/05/10/business/11drug-web.html?mcubz=0) and [recent](http://www.npr.org/sections/thetwo-way/2017/09/19/552135830/41-states-to-investigate-pharmaceutical-companies-over-opioids) news that pharmaceutical companies may have fueled the opioid epidemic, I plan to study the association between payments made by opioid manufacturers to physicians, physician prescribing of opioids, and opioid-related deaths. In particular, I would like to see whether payments influenced prescribing patterns, and if so, whether those altered prescribing patterns led to an increase in deaths.

I will use four main data sources:
- CMS Open Payments data (2013-2016) [[here](https://www.cms.gov/OpenPayments/Explore-the-Data/Dataset-Downloads.html)]
- ProPublica's Dollars for Docs Archive (2009-2013) [[here](https://www.propublica.org/datastore/dataset/dollars-for-docs-data-archive)]
- Medicare Part D Public Use Files (2013-2015) [[here](https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/Part-D-Prescriber.html)]
- Center for Disease Control (CDC) WONDER database [[here](https://wonder.cdc.gov/)]

I will use the first two sources to assemble a panel dataset on payments to physicians by opioid manufactureres from 2009-2016. I will then link that to the Medicare prescribing data at the individual (or individual-year) level to see whether payments influenced the prescribing of opioids. Lastly, to study the relationship between prescribing patterns and deaths, I will collapse the Medicare data by county and link the resulting dataset to opioid-related deaths at the county level from CDC.

I plan to address the following questions:
- Which doctors are more likely to be paid by pharmaceutical companies? (e.g., those in certain specialties? those who work close to a certain pharmaceutical company's headquarters? etc.)
- Are doctors paid by pharmaceutical companies more likely to prescribe opioids? (still need to brainstorm a good "control" group here to get at a causal interpretation.)
- Are prescription patterns correlated with opioid-related deaths?

Here are some preliminary ideas for ways to visualize the data:
- A table with (mean payment received) and (mean prescribing rate) broken down by physician specialty. 
- A binned scatterplot with payments on the x-axis and prescription rate on the y-axis.
- A line plot of (opioid prescribing rate vs time) and (opioid-related deaths vs time) on the same graph.
- A county-level map of %(change in opioid prescription rate, 2013-2015) alongside a county-level map of %(change in opioid-related death rate, 2013-2015).

Lastly, here are some challenges I'll have to deal with:
- Studying payments, prescribing, and deaths might end up being a bit too much. If so, I'll plan to drop the deaths part of the project.
- ProPublica's Dollars for Docs data only goes back to 2009. It would be nice to have data going back to the early 2000s since that is when the epidemic really took off.
- Similarly, Medicare Part D public use files only go back to 2013. 
- In general, it will not be difficult to show correlations, but it will be difficult to make causal interpretations of them. So I will need to think carefully about how to phrase my results.