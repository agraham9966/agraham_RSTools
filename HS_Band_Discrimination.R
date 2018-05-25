##Hyperspectral Optimal Band Selection with Spectrometer Data
rm(list=ls())
install.packages("mclust")
library(lattice)
library(reshape2)

##uses stats package for PCA which is an R base package
rawdat<-read.csv("BatGal_Sept28.csv", header = T)
as.data.frame(rawdat)
rawdat <- rawdat[c(185:946),c(1,2:7)]
rawdat<- t(rawdat)
rawdat <- rawdat[c(2:7),c(1:946)] ##temporary solutio to remove the header name with wavelengths
##perform PCA
model.pca <- prcomp(rawdat, scale=TRUE)
summary(model.pca)
load<- model.pca$rotation
pc.load<- cbind(load[, 1:3])
colnames(pc.load) <- c("PC1", "PC2", "PC3")
pc.df <- melt(pc.load)
xyplot(value ~ Var1, data = pc.df, group = Var2, type = "l",
       ylab = "PC Loadings", xlab = "Spectral Bands", 
       auto.key = list(corner = c(0.98, 0.98), points = FALSE, lines = TRUE),
       panel = function (x, y, ...) {
         panel.grid(h = -1, v = -1)
         panel.xyplot(x, y, ...)
         panel.abline(h = 0, lty = "dashed")
       })

?subset.data.frame


library(klaR)
library(MASS)
gw_obj <- greedy.wilks(PHASEN ~ ., data = B3, niveau = 0.1)
x<- lda(gw_obj$formula, data = B3) ##Linear discriminant analysis 
plot(x)
?prcomp()
?prcomp
biplot(prcomp(rawdat, scale = T))
