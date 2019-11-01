# Jaromil.frossard@gmail.com
# 1st November 2019

library(tidyr)
library(dplyr)
library(tibble)
library(ggplot2)
library(gganimate)

library(robustbase)
library(MASS)
set.seed(42)
n = 15


x=rnorm(n)+1
sde=0.4
y = 1+x*1+rnorm(n,sd=sde)


epsilon = seq(from =0, to =-5,by = -0.1)

which.out = which.max(x)

out= list()

for(i in 1:length(epsilon)){
  yeps = y;yeps[which.out] = yeps[which.out]+epsilon[i]
  coef_ols = coef(lm(yeps~x))
  coef_sm = coef(lmrob(yeps~x,setting = "KS2014"))
  coef_hub = coef(rlm(yeps~x))
  df = data.frame(y = yeps, x= x)
  df$epsilon = epsilon[i]
  df$simi =i
  df$ols_a = coef_ols[1]
  df$ols_b = coef_ols[2]
  df$sm_a = coef_sm[1]
  df$sm_b = coef_sm[2]
  df$hub_a = coef_hub[1]
  df$hub_b = coef_hub[2]
  out[[i]]=df
}
df = do.call("rbind",out)
lwd=1
p<- df%>%
  ggplot(aes(x= x,y = y,group=simi))+
  geom_point(size=2)+
  geom_abline(aes(slope = hub_b, intercept = hub_a,colour = "Huber"),lwd=lwd)+
  geom_abline(aes(slope = ols_b, intercept = ols_a,colour = "OLS"),lwd=lwd)+
  geom_abline(aes(slope = sm_b, intercept = sm_a,colour = "Robust-KS2014"),lwd=lwd)+
  scale_colour_manual(name="", values = c("red","black","orange"))+
  theme_bw()+
  theme(title = element_text(hjust = 0.5),
        panel.border = element_rect(colour = "black",fill = NA),
        panel.grid = element_blank(),
        axis.text = element_text(size = 20),
        axis.title = element_blank(),
        legend.position = "top")
p

anim <- p+transition_time(simi)+shadow_wake(wake_length = 0.02,exclude_layer = c(2,3))

anim <- animate(anim, fps = 24,start_pause = 12, end_pause=12, duration = 4)

anim
#anim_save("robust.gif", animation = anim)


