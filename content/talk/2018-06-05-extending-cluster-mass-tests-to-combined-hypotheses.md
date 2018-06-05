+++
date = 2018-06-05T00:00:00  # Schedule page publish date.

title = "Extending cluster-mass tests to combined hypotheses"
time_start = 2018-06-11T18:30:00
time_end = 2017-06-11T19:30:00
abstract = "Extending cluster-mass tests"
abstract_short = "Extending cluster-mass tests"
event = "ISNPS2018"
event_url = "http://www.isnps2018.it/"
location = "Salerno, Italy"
  
# Links (optional).
url_pdf = "pdf/2018_06_isnps2018_poster.pdf"

# Does the content use math formatting?
math = true

# Does the content use source code highlighting?
highlight = true

# Featured image
# Place your image in the `static/img/` folder and reference its filename below, e.g. `image = "example.jpg"`.
[header]
image = ""
caption = ""

#Embed your slides or video here using [shortcodes](https://sourcethemes.com/academic/post/writing-markdown-latex/). Further details can easily be added using *Markdown* and $\rm \LaTeX$ math code.
+++

To analyse data from experiments using EEG, we test a null hypothesis at each time point of the signal $H_0^t:~ \beta_t = 0$ for $t \in 1,\dots,T$ where $\beta_t$ is the difference between two experimental conditions at time $t$, with $T$ usually larger than $400$. To take into account the multiple hypotheses, permutation tests using the cluster-mass statistics control the FWER and are a powerful approach when effects happen by cluster. However, usually effects are composed of positive difference immediately followed by a negative difference (or vice versa) between two experimental conditions. Because of zero crossing of the parameters and of the statistics, cluster-mass statistics using F-test or t-test are sub-optimal. We propose to use cluster-mass statistics on the combined null hypothesis that both the mean and the slope of the signal are zero: $H_0^t:~ \beta_t = 0$ and $H_0^t:~ \dot{\beta}_t = 0$ for $t \in 1,\dots,T$ where $\dot{\beta}_t$ is the difference in slope between the experimental conditions. Using this combined hypotheses with the cluster-mass statistics, we create bigger clusters which results in more powerful test while keeping the FWER at the nominal level. We compare different methods of smoothing used to produce the estimate of the slope of the signals.

