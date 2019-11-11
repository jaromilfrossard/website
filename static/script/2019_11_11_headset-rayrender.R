# jaromil.frossard@gmail.com
# 2019.11.11

library(tidyr)
library(dplyr)
library(rayrender)
library(xlsx)
library(permuco)
# devtools::install_github("jaromilfrossard/clustergraph")
library(clustergraph)

## Import data from the clustergraph() object
load("model.RData")

effect <- 6
image(model, effect = effect)

df <- (model$multiple_comparison[[effect]]$maris_oostenveld$data)%>%
  rename(channel="electrode")%>%
  mutate(channel = as.character(channel))

## Import the position of electrods
#download.file("https://www.biosemi.com/download/Cap_coords_all.xls","Cap_coords_all.xls",mode="wb")
df_head <-  read.xlsx(file="Cap_coords_all.xls", sheetIndex = 3, header =T,startRow=34)
df_head <- df_head[1:64,c(1,5:7)]
colnames(df_head) <- c("channel","x","y","z")

## Rename channel, center position and do a first rescale of the electrodes
ratio <- 100
df_head <- df_head%>%
  mutate(channel = plyr::revalue(channel, 
                                 c("T7 (T3)" = "T7", "Iz (inion)" = "Iz", "T8 (T4)" = "T8", "Afz" = "AFz")))%>%
  mutate(channel = as.character(channel))%>%
  mutate(z = (z-mean(z))/ratio,
         x = (x-mean(x))/ratio,
         y = (y-mean(y))/ratio)

## Join the to data frames
df<- df%>%
  inner_join(df_head, by = "channel")

## Download the Female Head from free3d.com
## Unzip the folder named FemaleHead
## Save the path of the .obj file
head_obj <-  "FemaleHead/11091_FemaleHead_v4.obj"

## Define the color of the face
face_col <- rgb(50,25,00, maxColorValue = 255)

## Add the face in a scene
scene_head <- NULL
scene_head <- scene_head%>%
  add_object(obj_model(head_obj, 
                       y= -.8, scale_obj =.15,angle =c(90,180,0),
                       material = lambertian(color=face_col,noise=.02)))

render_scene(scene_head)


## Define colors of the electodes
red_col <- rgb(255,0,0,maxColorValue = 255)
grey_col <- rgb(128,128,128,maxColorValue = 255)

## Select a particular time
ti <- 40
df_ti <- filter(df,time==ti)

## Create a 3D headset at time ti
eeg_object  <- NULL

for(channeli in 1:nrow(df_ti)){
  if((df_ti$cluster_id[channeli])==0){
    ## transparent electrod without outside clusters
    materiali <- dielectric(color = grey_col)
  }else if((df_ti$pvalue[channeli])<0.05){
    ## Red electrodes for significative cluster
    materiali <- metal(color = red_col)
  }else if((df_ti$pvalue[channeli])>0.05){
    ## Grey electrodes for non-significative cluster
    materiali <- metal(color = grey_col)
  }
  
  ## add the new electrodes
  eeg_object <- 
    eeg_object%>%
    add_object(sphere(x = df_ti$x[channeli], y = df_ti$y[channeli],
                      z = df_ti$z[channeli], radius = .05,
                      material = materiali))
}

## Group the electrode into a headset, finale rescale of the electrode.
head_set <- group_objects(eeg_object,group_translate = c(0,1.45,.2),
                          group_angle = c(90,0,0),group_scale = 1.15*c(.92,1,1))

## Add the electrode on the scene/head
scene <- 
  scene_head%>%
  add_object(head_set)

## select the point of view
lookfrom_list <- list(c(3,5,7),
                     c(3,5,-7),
                     c(-3,5,7),
                     c(-3,5,-7))

lookat_list <- list(c(0,.75,0),
                   c(0,.8,0),
                   c(0,.75,0),
                   c(0,.8,0))

## select the quality of the scene
sample <- 20 #2000
width <- height <- 200# 400

png(filename = paste0("headset.png"),width = 800, height = 800)
par(mfrow=c(2,2),oma=c(0,0,5,0),mar=c(0,0,0,0))
for(i in 1:4){
  render_scene(scene, parallel=TRUE,lookfrom=lookfrom_list[[i]],
               lookat = lookat_list[[i]],ambient_light =T,
               sample=sample,width = width ,height=height)
}
title_txt <- paste0(names(model$multiple_comparison)[[effect]],", time: ",round(ti/512*1000)," [ms]")
title(main = title_txt,outer=T,cex.main = 2)
dev.off()

################################################
## Save image for all time-point in the img folder
################################################


for (ti in 1:max(df$time)){
  df_ti <- filter(df,time==ti)
  
  eeg_object  <- NULL
  for(channeli in 1:nrow(df_ti)){
    if((df_ti$cluster_id[channeli])==0){
      materiali <- dielectric(color = grey_col)
    }else if((df_ti$pvalue[channeli])<0.05){
      materiali <- metal(color = red_col)
    }else if((df_ti$pvalue[channeli])>0.05){
      materiali <- metal(color = grey_col)
    }
    ## add the new electrodes
    eeg_object <- 
      eeg_object%>%
      add_object(sphere(x = df_ti$x[channeli], y = df_ti$y[channeli],
                        z = df_ti$z[channeli], radius = .05,
                        material = materiali))
  }
  ## Group the electrode into a headset, finale rescale of the electrode.
  head_set <- group_objects(eeg_object,group_translate = c(0,1.45,.2),
                            group_angle = c(90,0,0),group_scale = 1.15*c(.92,1,1))
  
  ## Add the electrode on the scene/head
  scene <-
    scene_head%>%
    add_object(head_set)
  
  
  ## select the quality of the scene
  sample <- 20 ##2000
  width <- height <- 200# 400
  
  png(filename = paste0("img/img",sprintf("%04d",ti),".png"), width = 800, height = 800)
  par(mfrow=c(2,2),oma=c(0,0,5,0),mar=c(0,0,0,0))
  for(i in 1:4){
    render_scene(scene, parallel=TRUE,lookfrom=lookfrom_list[[i]],
                 lookat = lookat_list[[i]],ambient_light =T,
                 sample=sample,width = width ,height=height)
  }
  title_txt <- paste0(names(model$multiple_comparison)[[effect]],", time: ",round(ti/512*1000)," [ms]")
  title(main = title_txt,outer=T,cex.main = 2)
  dev.off()}


## create a video
system("ffmpeg -framerate 30 -pix_fmt yuv420p -i img/img%04d.png headset.mp4")



