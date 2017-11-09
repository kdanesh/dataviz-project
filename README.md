# Should Big Pharma Market Opioids to Doctors?

In light of [past](http://www.nytimes.com/2007/05/10/business/11drug-web.html?mcubz=0) and [recent](http://www.npr.org/sections/thetwo-way/2017/09/19/552135830/41-states-to-investigate-pharmaceutical-companies-over-opioids) news that pharmaceutical companies may have fueled the opioid epidemic, I plan to study the association between payments made by opioid manufacturers to physicians and opioid prescriptions. In particular, I would like to explore whether payments are significantly associated with prescriptions.

In order to study this assocation, I use the following measures:
- number of opioid-related payments: the number of times a physician was paid by a pharmaceutical company to learn about an opioid
- opioid prescriptions: the number of 30-day prescriptions of any opioid

I use two other variables, county and physician specialty, to further break down the association.

Let's start by looking at the relationship between prescriptions and payments:

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/master/plots/meetings_30dayfill.png)

We see a strong positive relationship here. In other words, physicians who receive more payments prescribe more opioids on average.

Let's further break down this relationship, first by geography. The following two maps plot the mean number of opioid-related payments and mean opioid prescriptions by county:

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/master/plots/map_meetings.png)

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/master/plots/map_30dayfill.png)

The maps look somewhat similar.  We can confirm this with a correlation plot, which restricts to counties with at least 50 physicians:

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/gh-pages/plots/cty_scatterplot.png)

It may be worth further playing around with this plot, e.g., by coloring the points so that they correspond to certain regions of the U.S., or by having the size of the points vary with population.

Having broken down the relationship between payments and prescriptions by geography, let's now turn to another useful variable: physician specialty.

The following two bar charts plot the 10 specialities receiving the most payments and prescribing the most opioids:

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/gh-pages/plots/specialty_top10pay.png)

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/gh-pages/plots/specialty_top10pre.png)

The bar charts look somewhat similar.  Again, we can confirm this with a correlation plot, which restricts to specialties with at least 1,000 physicians:

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/gh-pages/plots/specialty_scatter.png)

So far we've looked at mean payments and prescriptions by specialty.  This does not convey how much each specialty is prescribing in an absolute sense.  To get a sense for this, let's now plot total prescriptions by specialty:

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/gh-pages/plots/specialty_top10pre_total.png)

Woah!  It looks like primary care specialties like family practice and internal medicine account for the majority of opioid prescriptions, even though the average primary care physician doesn't prescribe nearly as much as the average pain specialist.  (There are many more primary care physicians, after all.)

But just because the average primary care physician doesn't prescribe as much as the average pain specialist doesn't mean that some primary care physicians don't prescribe a lot.  To explore this thought, we can compare density plots of prescriptions for each group (family practitioners in red, and pain specialists in blue):

![Image](https://raw.githubusercontent.com/kdanesh/dataviz-project/gh-pages/plots/density_fam_vs_pain.png)

It looks like a nontrivial share of family practitioners prescribe more than the average pain specialist&mdash;probably not the best thing for public health.

### Challenges and next steps

Challenges:
- What is the right measure of marketing intensity? number of times a physician was paid by a pharma company, or total dollars received?
- How much should I focus on characterizing payments and prescriptions separately vs together?
- How do I get closer to saying something about causality?
- Will there be space to bring in data on deaths?

Next steps:
- Develop a clear narrative
- Think about using data from multiple years (2013-15) to get at causality