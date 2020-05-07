library(dplyr)
#install.packages("kmeans")
#install.packages("factoextra")
library(factoextra)

library(NbClust)
library(tidyr)

df<-select(closures_recent, -unitid, -city, -zip, -insturl, -npcurl, -accredagency, -locale:-sat_avg_all, -pcip03, -pcip04, -pcip19, -pcip25, -pcip29) %>%
  mutate(hcm2=ifelse(is.na(hcm2), 0, hcm2)) 
df<-as.data.frame(df)
rownames(df)<-paste(df$instnm, df$opeid)

df2 = as.data.frame(sapply(df, as.numeric)) 
df2 <- scale(df2)
df2<-as.data.frame(df2)
rownames(df2)<-rownames(df)

df2<-select_if(df2, function(x) any(is.finite(x)))

for(i in 1:ncol(df2)){
  df2[is.na(df2[,i]), i] <- mean(df2[,i], na.rm = TRUE)
}

fviz_nbclust(df2, FUNcluster=kmeans, method="wss", k.max=10) +
  geom_vline(xintercept = 6, linetype = 2)+
  labs(subtitle = "Elbow method, K-means")
# #7
# fviz_nbclust(df2, FUNcluster=kmeans, method="silhouette")+
#   labs(subtitle = "Silhouette, K-means")
# #2
# #fviz_nbclust(df2, FUNcluster=kmeans, nstart=25, method="gap_stat",nboot=50)
# 
# fviz_nbclust(df2, FUNcluster=hcut, method="wss", k.max=10)+
#   geom_vline(xintercept = 4, linetype = 2)+
#   labs(subtitle = "Elbow method, Hierarchical")
# #4
# fviz_nbclust(df2, FUNcluster=hcut, method="silhouette")
#   labs(subtitle = "Silhouette, Hierarchical")
# #2
#   set.seed(616)
# #fviz_nbclust(df2, FUNcluster=kmeans, nstart=25, method="gap_stat", nboot=50)
# 
# #NbClust(data = df2, diss = NULL, distance = "euclidean",
#  #         min.nc = 2, max.nc = 10, method ="kmeans")
# 
set.seed(616)
km.res <- kmeans(df2, 6, nstart = 25)
km.res$size
cluster<-km.res$cluster

output<-cbind(df, cluster)
means<-output %>% group_by(cluster) %>%
  summarize_all(mean, na.rm=TRUE) %>%
  ungroup() %>%
  select(numbranch, highdeg, pcip11, pcip12, pcip43, pcip51, pcip52, ugds, ugds_women, pctfloan, pctpell, contains("discharge")) %>%
  mutate_at(vars(contains("pcip")), round, 3) %>%
  mutate(pcip11=pcip11*100, pcip12=pcip12*100, pcip43=pcip43*100, pcip51=pcip51*100, pcip52=pcip52*100) %>%
  mutate_at(vars(contains("ugds"), contains("pct"), contains("discharge")), round, 3) %>%
  mutate(ugds_women=ugds_women*100, pctfloan=pctfloan*100, pctpell=pctpell*100)
means<-cbind(km.res$size, means) 

##larger clusters have more branch campuses, award high degrees, degree concentrations vary across clusters, enrollment levels and demographics, high clusters cost more, 

fviz_cluster(km.res, df2, geom="point")

rownames(df2)<-c()
# clusters <- hclust(dist(df2))
# plot(clusters)

#pca
closures.pca <- prcomp(df2, center = TRUE, scale. = TRUE)

library(ggbiplot)

ggbiplot(closures.pca)
