# Part 1: Who's Prescribing the Most Opioids? It's Your Primary Care Doc

A recent study found that of all physician specialties, pain specialists and anesthesiologists prescribe the most opioids. This is true on average, as shown in the following bar chart:

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/gh-pages/plots/specialty_top10pre.png)


But this fails to convey how much each specialty prescribes in total.  The following bar chart plots the 10 specialities prescribing the most opioids in total:

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/gh-pages/plots/specialty_top10pre_total.png)

So primary care specialties like family practice and internal medicine account for the majority of opioid prescriptions, even though the average primary care physician doesn't prescribe as much as the average pain specialist.  (There are many more primary care physicians, after all.)

This could just be because primary care physicians see more patients.  We can account for this by plotting prescriptions per patient prescribed opioids:

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/gh-pages/plots/prescriptions_hist_by_specialty)

We see that primary care doctors prescribe more&mdash;even on a per-patient basis.  But we also that prescription habits vary significantly from doctor to doctor.  To further explore this, let's zoom in on the histogram of family medicine doctors:

x% prescribe more than the average anesthesiologist, and y% prescribe more than the average pain specialist.  This makes little sense given that family medicine doctors are not usually trained to treat chronic pain.

Finally, we can see how prescription rates vary across the country:

# Part 2: Are Dollars for Docs Fueling the Opioid Epidemic?

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

We will consider physicians who live in a light-colored area (about 0 meetings/doctor) in 2013 and move to a dark-colored area (more than 0.5 meetings/doctor) in 2014 or 2015.  We will conpare these physicians to those who stay in light colored areas for all three years.

Given these definitions, we find the following ("movers" in red, "stayers" in blue):

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/master/plots/staymove.png)



### Challenges and next steps

Challenges:
- What is the right measure of marketing intensity? number of times a physician was paid by a pharma company, or total dollars received?
- How much should I focus on characterizing payments and prescriptions individually?  Given the richness of the data, I almost feel as if it would be worth doing an entire project on just one or the other.
- How do I get closer to saying something about causality?
- Will there be space to bring in data on deaths?

Next steps:
- Develop a clear narrative
- Think about using data from multiple years (2013-15) to get at causality