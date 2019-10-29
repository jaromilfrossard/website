# R Lunch 2017.12.05  Permutation tests
# http://use-r-carlvogt.github.io/
# Jaromil Frossard, jaromil.frossard@unige.ch
# 


## Generate some data (t-test, ANOVA)
set.seed(48)
n <- 8
IV <- c(rep("A",n),rep("B",n))
mu <- 95 + 10*(IV == "A")
df  <- data.frame(IV = IV,DV = rnorm(2*n,mu,9))


## parametric ANOVA
summary( aov( DV ~ IV, df))


# Install permuco
install.packages( "devtools")
library( devtools)

install_github( "jaromilfrossard/permuco")
library( permuco)

## permutation test
model_oneway <- aovperm( DV ~ IV, df, method = "manly")
model_oneway

## plot the results
plot( model_oneway)


## Analysis of emergency cost data
## centrering the covariate to the mean
emergencycost$LOSc <- scale( emergencycost$LOS, scale = F)

## ANCOVA using terBraack
ancova_terBraak <- aovperm(cost ~ LOSc*sex*insurance,data = emergencycost, method = "terBraak")
ancova_terBraak 

## Change coding of factors
contrasts(emergencycost$insurance) <- contr.sum
contrasts(emergencycost$sex) <- contr.sum

## Check the coding of the factor sex
contrasts(emergencycost$sex)
lm_dekker <- lmperm(cost ~ LOSc*sex*insurance,
                    data = emergencycost, method = "dekker")




## Multiple comparison procedures
## EEG signal
erp <- t(attentionshifting_signal)
ts.plot(erp, ylim = rev( range( erp)))

## Means over by visibility
erpm = aggregate(attentionshifting_signal, by = list(
  attentionshifting_design$visibility),
  FUN = mean)[,-1]
ts.plot(t(erpm), ylim = rev( range( erpm)))

## Permutation test 
## Cluster-mass statistics
## WARNING np should be higher (>=5000)
## It takes around 5 minutes with np = 5000
cl_mass <- clusterlm(attentionshifting_signal ~ visibility*emotion*direction
                     + Error(id/(visibility*emotion*direction)), 
                     data = attentionshifting_design, np = 50)
plot(cl_mass)

## Shows all clusters for the factor visibility
print(cl_mass, effect = "visibility")


## Shows all clusters for all factors
cl_mass

## Permutation test 
## All multiple comparisons procedure
## WARNING np should be higher (>=5000)
## It takes around 10 minutes with np = 5000
all_multcomp <- clusterlm(attentionshifting_signal ~ visibility*emotion*direction
                          + Error(id/(visibility*emotion*direction)), 
                          multcomp = c("maris_oostenveld", "tfce","bonferroni",
                                       "holm", "troendle","benjaminin_hochberg"),              
                          data = attentionshifting_design, np = 50)

plot(all_multcomp, multcomp = "tfce", enhanced_stat = T)

## Shows pvalues and enhanced_statistic for all effects.
summary(all_multcomp, multcomp = "tfce")



