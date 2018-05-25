library(gridExtra)
library(reshape2)
library(ggplot2)
library (plyr)
library(dplyr)
rm(list=ls())
##uses stats package for PCA which is an R base package
temp = list.files(pattern="*.csv")
#temp = read.csv("FML.csv", header = T)
##reads a directory of dataframes and splits them up 
for (i in 1:length(temp)) assign(temp[i], read.csv(temp[i]))
df_adj <- lapply(ls(pattern="*_adj.csv"), function(x) get(x))
df_og <- lapply(ls(pattern="*_og.csv"), function(x) get(x))
###melts and elongates list of dataframes into single dataframe 
Molten_adj<- bind_rows(df_adj)
Molten_adj<- melt(Molten_adj, id.vars = "id", na.rm = T)
Molten_adj$CAT<- "ADJ"
Molten_og<-  bind_rows(df_og)
Molten_og<- melt(Molten_og, id.vars = "id", na.rm = T)
Molten_og$CAT<- "OG"

bind<- rbind(Molten_adj, Molten_og) ##binds two dataframes and stacks similar column names 
Final.df<- bind[order(bind$id), ] ##resorts dataframe numerically by ID 

######Make Multiple Plots  
b1_means<- Final.df[Final.df$variable == "X_b1mean", ]
b1_means_plot<- ggplot(b1_means, aes(x = id, y = value, group = CAT, colour = CAT)) + 
  geom_line() + geom_point() + xlab("Point_ID") + ylab("DN") + ggtitle("Mean @650nm")

b2_means<- Final.df[Final.df$variable == "X_b2mean", ]
b2_means_plot<- ggplot(b2_means, aes(x = id, y = value, group = CAT, colour = CAT)) + 
  geom_line() + geom_point() + ggtitle("Mean @532nm")+ xlab("Point_ID") + ylab("DN")

b3_means<- Final.df[Final.df$variable == "X_b3mean", ]
b3_means_plot<- ggplot(b3_means, aes(x = id, y = value, group = CAT, colour = CAT)) + 
  geom_line() + geom_point() + ggtitle("Mean @450nm")+ xlab("Point_ID") + ylab("DN")

b4_means<- Final.df[Final.df$variable == "X_b4mean", ]
b4_means_plot<- ggplot(b4_means, aes(x = id, y = value, group = CAT, colour = CAT)) + 
  geom_line() + geom_point() + ggtitle("Mean @850nm")+ xlab("Point_ID") + ylab("DN")

Band_Means_Comparison<-grid.arrange(b1_means_plot, b2_means_plot, b3_means_plot, b4_means_plot)

##Outputs
ggsave(filename = "Band_Means_Comparison.png", plot = Band_Means_Comparison)
