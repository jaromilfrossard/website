# Jaromil.frossard@gmail.com
# 20th October 2019


library(tidyr)
library(dplyr)
library(tibble)
library(ggplot2)
library(gganimate)
#install.packages("gifti")
# install.packages("gifski")
#devtools::install_github("thomasp85/transformr")


nball <- 130
njump <- 6
df <- tibble(ball = rep(paste0("b",sprintf("%03.f",1:nball)),each=njump),
             jump = rbinom(njump*nball,size = 1,prob = c(.5))*2-1)

###add jumps
df<- 
  df%>%group_by(ball)%>%
  mutate(lane = c(cumsum(jump)),
         state = 1:n())%>%
  select(-jump)

###add state 0
df0 <- tibble(ball = paste0("b",sprintf("%03.f",1:nball)),
              lane =0, state=0)

df<-bind_rows(df0,df)%>%
  arrange(ball,state)

###add state njump+1

df_fin <-
  df%>%
  filter(state==njump)%>%
  ungroup()%>%
  group_by(lane)%>%
  mutate(order = 1:n(),
         state=njump+1)


df<-bind_rows(df,df_fin)%>%
  ungroup()%>%
  arrange(ball,state)

### add timing

oball = 1:nball
names(oball)=paste0("b",sprintf("%03.f",1:nball))

df<- df%>%
  mutate(ball_order = recode(ball,!!!oball))%>%
  mutate(time = 1+state+(ball_order-1)*3)





### add position
h_ball = .6
h_jump = 1
max_ball = max(df$order,na.rm = T)

h_hist_max = max(12,max_ball*h_ball)

y_state = seq(from = h_hist_max + 2 +h_jump*njump,to = h_hist_max + 2,by =-h_jump)

names(y_state) = 0:njump

df<- df%>%
  mutate(y = recode(state,!!!y_state))%>%
  mutate(y = if_else(state==njump+1,order*h_ball,y))

### add keep last state
time_max = max(df$time)

df_keep<-
  df%>%
  filter(state==(njump+1))%>%
  group_by(ball)%>%
  uncount(time_max-time)%>%
  mutate(time_temp = 1:n())%>%
  mutate(time = time +time_temp-1)%>%
  select(-time_temp)


df<-bind_rows(df,df_keep)%>%
  ungroup()%>%
  arrange(ball,state)


### add count:

df<-df%>%
  arrange(time)%>%
  mutate(count=cumsum(state==(njump+1)))

### data lines

df_line_up <- expand.grid(x=seq(from=-njump,to = njump,length.out =njump+1),y = y_state[length(y_state)])%>%
  mutate(id = 1:n())%>%
  bind_rows(
    data.frame(x=seq(from=0,to = njump,length.out =njump+1),
               y = seq(from=y_state[1],to = y_state[length(y_state)],length.out =njump+1),
               id = 1:(njump+1)))
df_line_down <- expand.grid(x=seq(from=njump,to = -njump,length.out =njump+1),y = y_state[length(y_state)])%>%
  mutate(id = (n()+1):(2*n()))%>%
  bind_rows(
    data.frame(x=seq(from=0,to = -njump,length.out =njump+1),
               y = seq(from=y_state[1],to = y_state[length(y_state)],length.out =njump+1),
               id = (njump+2):(2*(njump+1))))

df_line = rbind(df_line_up,df_line_down)


### data rect

df_rect = data.frame(xmin=-njump,xmax=njump,ymin=y_state[length(y_state)],ymax=y_state[1])

p<- ggplot(df,aes(x=lane,y=y,group=ball))+
  xlim(c(-njump,njump))+
  geom_rect(aes(xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax),data = df_rect,fill="gray",inherit.aes = FALSE)+
  geom_line(aes(x=x,y=y,group=id),data=df_line,inherit.aes = FALSE,lwd=4,col="white")+
  geom_point(size=2.1)+
  ggtitle("Galton board.")+
  theme_bw()+
  theme(title = element_text(hjust = 0.5),
        panel.border = element_rect(colour = "black",fill = NA),
        panel.grid = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank())

p 


p+transition_time(time)+shadow_trail()


(max(df$time)+24)/24

anim <- p+transition_states(time,transition_length = 6, state_length = 2)+view_static()

anim <- animate(anim, fps = 24,start_pause = 12, end_pause=12,duration =42)


anim_save("galton.gif", animation = anim)

#animate(anim,nframes = 2000,fps = 40)
#animate(anim,nframes = max(df$time))

