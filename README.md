# Part 1: Who's Prescribing the Most Opioids? It's Your Primary Care Doc

In the early 2000s, when opioid manufacturers were seeking ways to spread new drugs to more patients, a new plan was formed: target the primary care docs.

These were not doctors trained to treat chronic pain.  Nor were they routinely performing painful procedures.  They were the doctors who helped give birth, treated children sick with the flu, performed annual physical exams, and cared for the elderly.

In other words, they saw the most patients.  And that's precisely what made them attractive to opioid manufacturers.

Over 15 years later, it looks as though their marketing plan has paid off.  In 2015, only pain management, anesthesiologists, and rehabilitation doctors prescribed more than primary care doctors on average.  And in total, primary care specialties like family and internal medicine prescribed over X% of all opioids in the U.S., amounting to $X in revenue.

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/gh-pages/plots/specialty_top10pre_total.png)

This may not come as a surprise since primary care doctors see more patients than specialists.  But the trend holds even when controlling for the number of patients seen.  For almost any amount of opioids prescribed per patient ranging from 0 to 12 prescriptions per year, there are more primary care doctors prescribing that amount than any other type of doctor.

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/gh-pages/plots/prescriptions_hist_by_specialty.png)

This is partly due to the sheer number of internal medicine and family practice doctors in the U.S.  But it is also due to striking variation in the amount of opioids prescribed per patient by primary care doctors.  Orthopedic surgeons are a useful comparison: nearly all of them prescribed between zero and three opioid prescriptions per patient in 2015, meaning prescribing behavior was relatively consistent across physicians.


On the other hand, internal and family medicine doctors had a much wider range of prescribing behavior.  For example, X% of family physicians prescribed more than the average anesthesiologist, and Y% prescribed more than the average pain specialist.  Across the country, family physicians prescribed more opioids per patient than anesthesiologists in Z% of counties.

Nearly all of those counties have seen an unprecedented rise in opioid deaths over the past 15 years.  That is evidence, perhaps, of a marketing plan gone wrong.


# Part 2: Are Dollars for Docs Fueling the Opioid Epidemic?

_NOTE: STILL NEED TO DRAFT THE WRITTEN TEXT FOR THIS PART_

Let's start by looking at the relationship between prescriptions and payments:

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/master/plots/meetings_30dayfill.png)

We see a strong positive relationship here. In other words, physicians who receive more payments prescribe more opioids on average.

But this relationship could be driven by differences in physician specialty.  We can rule this out by replicating this plot for the five specialties that prescribe the most opioids:

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/master/plots/prescriptions_payments_by_specialty.png)

This plot shows that the positive association between payments and prescriptions  holds within specialties.  It also shows that certain specialties prescribe more (indicated by higher intercepts) and are more influenced by payments (indicated by  higher slopes) than others, on average.

Even within specialties, it may be the case that prescription habits are fixed&mdash;i.e., do not change in response to payments or other factors.  According to this theory, pharmaceutical companies pay more to physicians with a higher inherent propensity for prescribing opioids, and payments are a form of compensation rather than influence.

We can test this theory by considering physicians who move from a place with high pharmaceutical payment intensity to a place with low pharmaceutical payment intensity.  The theory would predict that these physicians prescribe the same amount of opioids before and after their move.

As a start, here is a map of payment intensity, where payment intensity is measured as the mean number of payments received by a physician in a given county:

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/master/plots/map_meetings.png)

We will consider physicians who live in a light-colored area (about 0 meetings/doctor) in 2013 and move to a dark-colored area (more than 0.5 meetings/doctor) in 2014 or 2015.  We will compare these physicians to those who stay in light colored areas for all three years.

Given these definitions, we find the following ("movers" in red, "stayers" in blue):

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/master/plots/staymove.png)

These plots show that physicians who move from low- to high-payment areas receive more payments and prescribe more opioids.  While this is evidence that physicians change their prescribing patterns in response to a new environment, it does not indicate what about the new environment&mdash;be it payments, the patient population, their practice setting, or something else&mdash;motivates the change.

### Challenges and next steps

Challenges:
- What is the right measure of marketing intensity? number of times a physician was paid by a pharma company, or total dollars received?
- How much should I focus on characterizing payments and prescriptions individually?  Given the richness of the data, I almost feel as if it would be worth doing an entire project on just one or the other.
- How do I get closer to saying something about causality?
- Will there be space to bring in data on deaths?

Next steps:
- Develop a clear narrative
- Think about using data from multiple years (2013-15) to get at causality