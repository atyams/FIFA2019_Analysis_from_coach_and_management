library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(visdat)
library(ggplot2)
library(GGally)
library(plotly)
library(MVA)
library(scatterplot3d)
library(sem)
library(semPlot)
library(mclust)
library(igraph)
library(ResourceSelection)
library(KernSmooth)
library(lavaan)
library(lavaanPlot)
library(visdat)
library(CCA)
library(factoextra)
library(raster)
library(cubeview)

library(shinyRGL)
library(pca3d)
library(rgl)
library(ggfortify)
library(magick)
library(purrr)
library(animation)
library(semPlot)
library(qgraph)
library(htmltools)

# Reading the data set and saving it to fifa dataframe.
fifa <- read.csv("../data/FIFA.csv", stringsAsFactors=FALSE)

# Function to convert M and K to numeric equivalent:
convert_money <- function(x) {
  # Check if M exist in x
  if(grepl('M',x)) {
    # Convert to numeric, replace M by blank and convert to its equivalent
    x = as.numeric(gsub('M', '', x)) * 1000000
    # Check if K exist in x
  } else if (grepl('K',x)) {
    x = as.numeric(gsub('K', '', x)) * 1000
  }
}

# create a custom function to fill NA with median:
fill_NA_with_median <- function(x){
  #First convert each column into numeric if it is from factor
  x <- as.numeric(as.character(x)) 
  #Convert the item with NA to median value from the columns
  x[is.na(x)] = median(x, na.rm=TRUE) 
  #Display the column
  x 
}

wage_break = function(row) {
  if (row['Wage'] < 100000) {
    x = "0-100k"
  } else if (100000 < row['Wage'] & row['Wage'] < 200000) {
    x = "100k-200k"
  }  else if (200000< row['Wage'] & row['Wage'] < 300000)
    x = "200k-300k"
  else if (300000< row['Wage'] & row['Wage'] < 400000)
    x = "300k-400k"
  else if (400000< row['Wage'] & row['Wage'] < 500000)
    x = "400k-500k"
  else
    x = "500k+"
  x
}

overall_break = function(row) {
  if (row['Overall'] < 67) {
    x = 1
  } else if (67 < row['Overall'] & row['Overall'] < 94) {
    x = 2
  }  else
    x = 3
  x
}

# Subset by age group, select only players whose age is less than 35
fifa = subset(fifa, fifa$Age < 35)

# ******** PREPROCESSING SETPS *************#
# Checking for duplicate values.
which(duplicated(fifa)) #No duplicates

# Create wage brackets for the plot
wage_breaks <- c(0, 100000, 200000, 300000, 400000, 500000, Inf)
wage_labels <- c("0-100k", "100k-200k", "200k-300k", "300k-400k", "400k-500k", "500k+")
wage_brackets <- cut(x=fifa$Wage, breaks=wage_breaks, 
                     labels=wage_labels, include.lowest = TRUE)

# Creating a new column wage_break as categorical factors.
fifa$wage_break <- apply(fifa, 1, wage_break)

fifa$Value <- sapply(fifa$Value,  FUN=convert_money)

fifa_before <- fifa
# Checking dataset contains null
#apply(fifa, 2, function(x) any(is.na(x)))
# HeadingAccuracy, Agility, Dribbling, Stamina, International.Reputation, LongPassing, Interceptions,
# Crossing, BallControl, Penalties contain NA

# Replacing columns of NA with median
# as mean will be affected by outliers, we replace the NA with median
fifa[,c(8:21)] = data.frame(apply(fifa[,c(8:21)],2,fill_NA_with_median))

# Again Checking dataset contains null
apply(fifa, 2, function(x) any(is.na(x)))

fifa_subset <- fifa

# convert only the numerical columns in the dataset (columns 8 to 21) to 
# matrix format and assign the names to rownames:
mtrx_fifa <- as.matrix(fifa_subset[,c(8:21)])
rownames(mtrx_fifa) <- fifa_subset$Name

# Convert the matrix to data frame:
fifa_num_data = as.data.frame(mtrx_fifa)

# Scale this data frame:
fifa_num_data_scaled <- scale(fifa_num_data)

# Creating a new column overall_break as categorical factors.
fifa_num_data$overall_break <- apply(fifa_num_data, 1, overall_break)

dist.var <- 1 - cor(fifa_num_data[,1:13])
cmd.var = cmdscale(dist.var)

# d <- dist(fifa_num_data[,1:13])
# cmd <- cmdscale(d)

# Principal Component
pc <- princomp(fifa_num_data[, 1:13], cor = T)
gr <- factor(fifa_num_data[,14])
scores <- pc$scores

lab <- c("L..Messi", "Cristiano.Ronaldo", "Cristian.Tello", "De.Gea", "Sergio.Ramos")
out_players <- match(lab, rownames(fifa_num_data))

# Canonical Correlation Analysis
X <- fifa_subset[, 8:11]  # Management perspective
Y <- fifa_subset[, 12:20]  # Coach perspective

cca_fifa = cc(X,Y)
# Correlations
mat_corr <- matcor(X, Y)

# display the canonical correlations
cca_cor <- cca_fifa$cor

# Cluster Analysis

# Elbow Test:
plot.wgss = function(mydata, maxc) {
  wss = numeric(maxc)
  for (i in 1:maxc) 
    wss[i] = kmeans(mydata, centers=i, nstart = 10)$tot.withinss 
  plot(1:maxc, wss, type="b", xlab="Number of Clusters",
       ylab="Within groups sum of squares", main="Scree Plot") 
}

# Complete HC
fifa_dist = dist(fifa_num_data_scaled[, 1:13])
hc_comp_fifa <- hclust(fifa_dist)
ct_fifa = cutree(hc_comp_fifa,3)
ct_tb = table(ct_fifa, fifa_num_data$Overall)
ct_chsq = chisq.test(ct_tb) 

# KMeans Cluster
km2 <- kmeans(fifa_num_data, 3, nstart = 10)
km_clust = km2$cluster
km_tb = table(km2$cluster, fifa_num_data$Overall)
km_chsq = chisq.test(km_tb)


#Model based clustering
mc_fifa <- Mclust(fifa_num_data_scaled, 3)
mc_clust = mc_fifa$classification
mc_tb = table(mc_clust, fifa_num_data$Overall)
mc_chsq = chisq.test(mc_tb)

# Exploratory Factor Analysis
fa_fifa <- factanal(fifa_num_data[, 1:13], factors = 3)
fa_fifa
f_loading = fa_fifa$loadings[, 1:3]
corHat = f_loading %*% t(f_loading) + diag(fa_fifa$uniquenesses)
corr <- cor(fifa_num_data[, 1:13])

# Check the root mean square error:
rmse = sqrt(mean((corHat-corr)^2))
rmse

# Confirmatory Factor Analysis
hs_model <- "management =~ Value + Wage + International.Reputation
skill =~ Crossing + Dribbling + LongPassing + BallControl + Agility + Penalties 
experience =~ Stamina + HeadingAccuracy"

fit <- cfa(hs_model, data = fifa_num_data_scaled)
fifa_sem <- sem(hs_model, data=fifa_num_data_scaled)