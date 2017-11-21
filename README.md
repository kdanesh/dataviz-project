# Part 1: Who's Prescribing the Most Opioids? It's Your Primary Care Doc

In the early 2000s, when opioid manufacturers were seeking ways to spread new drugs to more patients, a [new plan](http://ajph.aphapublications.org/doi/abs/10.2105/AJPH.2007.131714) was formed: target the primary care docs.

These doctors were not trained to treat chronic pain.  Nor were they routinely performing painful procedures.  They helped give birth, treated children sick with the flu, performed annual physical exams, and cared for the elderly.

In other words, they saw the most patients.  And that's precisely what made them attractive to opioid manufacturers.

Over 15 years later, it looks like the marketing plan has paid off.  In 2015, only pain management, anesthesiologists, and rehabilitation doctors prescribed more than primary care doctors on average.  And in total, primary care specialties like family and internal medicine prescribed the most by far: X% of all opioids in the U.S., amounting to $X in revenue.

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/gh-pages/plots/specialty_top10pre_total.png)

This may not come as a surprise since primary care doctors likely see more patients than specialists.  But the trend holds even when controlling for the number of patients seen.  For almost any amount of opioids prescribed per patient ranging from 0 to 12 prescriptions per year, there are more primary care doctors prescribing that amount than any other type of doctor.

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/gh-pages/plots/prescriptions_hist_by_specialty.png)

This is partly due to the sheer number of primary care doctors in the U.S.  But it is also due to striking variation in the amount of opioids prescribed by primary care doctors.  Orthopedic surgeons are a useful comparison: nearly all of them prescribed between zero and three opioid prescriptions per patient in 2015, meaning prescribing behavior was relatively consistent across physicians.  In contrast, primary care doctors had a much wider range of prescribing behavior: X% of primary care doctors prescribed more than the average anesthesiologist, and Y% prescribed more than the average pain specialist.


Prescription rates of primary care doctors also varied across the country.  In  places like Hancock County, Kentucky, and Randolph County, Georgia, rates were less than 2 prescriptions per person prescribed opioids.  But in places like Summit County, Colorado, and Sitka County, Alaska, rates were over 12 per person&mdash;more than one prescription a month per patient.

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/gh-pages/plots/map_prescriptions_primarycare.png)

Many of the counties with high primary care prescription rates have experienced a [dramatic rise](https://www.theguardian.com/society/ng-interactive/2016/may/25/opioid-epidemic-overdose-deaths-map) in overdose deaths over the past 15 years.  That is evidence, perhaps, of a marketing plan gone wrong.

# Part 2: Are Dollars for Docs Fueling the Opioid Epidemic?

_NOTE: STILL NEED TO DRAFT WRITTEN TEXT FOR THIS PART_

Let's start by looking at the relationship between prescriptions and payments:

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/master/plots/meetings_30dayfill.png)

We see a strong positive relationship here. In other words, physicians who receive more payments prescribe more opioids on average.

But this relationship could be driven by differences in physician specialty.  We can rule this out by replicating this plot for the five specialties that prescribe the most opioids:

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/master/plots/prescriptions_payments_by_specialty.png)

This plot shows that the positive association between payments and prescriptions  holds within specialties.  It also shows that certain specialties prescribe more (indicated by higher intercepts) and are more influenced by payments (indicated by  higher slopes) than others, on average.

Even within specialties, it may be the case that prescription habits do not change in response to payments or other factors.  This would be true if pharmaceutical companies simply gave more payments to physicians with a higher inherent propensity for prescribing opioids, purely as a form of compensation rather than influence.

We can test this theory by considering physicians who move from a place with high pharmaceutical payment intensity to a place with low pharmaceutical payment intensity.  The theory would predict that these physicians get paid the same amount by pharmaceutical companies, and prescribe the same amount of opioids, before and after their moves.

As a start, here is a map of payment intensity, where payment intensity is measured as the mean number of payments received by a physician in a given county:

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/master/plots/map_meetings.png)

We will consider physicians who live in a light-colored area (about 0 meetings/doctor) in 2013 and move to a dark-colored area (more than 0.5 meetings/doctor) in 2014 or 2015.  We will compare these physicians to those who stay in light colored areas for all three years.

Given these definitions, we find the following ("movers" in red, "stayers" in blue):

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/master/plots/staymove.png)

These plots show that physicians who moved from low- to high-payment areas received more payments and prescribed more opioids.  While this is evidence that physicians change their prescribing patterns in response to new environments, it does not indicate what about the new environments&mdash;be it new payments, patients, practice settings, or something else&mdash;motivates the change.

### Next steps

Part 1:
- clean up definition of primary care: for now I'm using family med + internal med + general practice as a proxy, so i'm omitting pediatricians and obgyn; it's also the case, i think, that some internal med docs are not considered primary care doctors (e.g., endocrinologists)
- check if primary care docs are prescribing lots of opioids in places where there are no pain specialists. are death rates particularly high in these areas? this would be an interesting take -- basically the lack of specialty care in rural areas has perpetuated the opioid epidemic. could get at this by comparing overdose rates in rural areas with specialty docs vs rural areas without
- play around with other ways to display the data in the stacked histogram (i like that it shows a fair amount, but i don't think it does so in the clearest way)
- add in Alaska and Hawaii on QGIS map
- bring in data on deaths?

Part 2:
- think about whether the movers vs nonmovers comparison is useful; if so, clean up the design of the experiment, including definitions of the two groups
- consider repeating movers comparison for people who moved from high- to low-payment areas
- maybe bring in geographic data on incidence of chronic pain to control for patient population?
- brainstorm other ways to isolate effect of payments on prescriptions