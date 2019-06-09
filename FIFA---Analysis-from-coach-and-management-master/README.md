# FIFA-Analysis

Detailed report can be found in  [Report](https://github.com/NishaPardeshi/FIFA-Analysis/tree/master/Report) section of github.
</br>

FIFA 2019 dataset was taken from Kaggle website, since soccer is an interesting international game and it has multiple dimensions to perform Multivariate Analysis between players, can identify cluster among players, performance and also from management (money, profitable player) and coach(performance) perspective.

![alt text](https://github.com/NishaPardeshi/FIFA-Analysis/blob/master/images/dashboard.png)

## Data Cleaning & Data Visualizations

Dropped unnecessary columns. </br>
Converted the wage variable into numerical values from the previous values that were specified in terms of thousands with the “K” symbol and “M” for million in dollars. </br>
There were no duplicates in the dataset.
Dataset consisted of 0.1% NA values, which were replaced by the median.


![alt text](https://github.com/NishaPardeshi/FIFA-Analysis/blob/master/images/MV_before.png)
![alt text](https://github.com/NishaPardeshi/FIFA-Analysis/blob/master/images/MV_after.png)

## Dimension Reduction Analysis

### Principal Component analysis

3 principal components are chosen as they account for 75.28% of the variation in our data. Principal component 1 is a measure of crossing, dribbling, long passing, ball control,stamina, and penalties. Hence, we name this component as coach perspective. Principal component 2 is a measure of value, wage, and international reputation. Hence, we name this component as management perspective since these are the dimensions that the management cares about. Principal component 3 is a measure of the contrast between (age, heading accuracy, interceptions) and agility. Hence, we name this component as player experience since experience of a players improves with an increase in age, which also improves heading accuracy and interceptions, while agility reduces over time.
</br>
Biplot between the first 2 principal components wherein the points represent the overall of the players
![alt text](https://github.com/NishaPardeshi/FIFA-Analysis/blob/master/images/pca1.png)

3D plot of the principal components

![](https://github.com/NishaPardeshi/FIFA-Analysis/blob/master/images/pca3d.gif)

![](https://github.com/NishaPardeshi/FIFA-Analysis/blob/master/images/pca3d_scores.gif)

## Multidimensional scaling between variables

The Multidimensional Scaling constructs a map and an easier interpretation for showing the relationship between the variables.
![alt text](https://github.com/NishaPardeshi/FIFA-Analysis/blob/master/images/mds1.png)

## Clustering

### Elbow Test

We identified that there are three clusters, from the elbow test.

![alt text](https://github.com/NishaPardeshi/FIFA-Analysis/blob/master/images/ca_elbow.png)

### Assumption: True Cluster - Overall Variable

![alt text](https://github.com/NishaPardeshi/FIFA-Analysis/blob/master/images/ca_overall.png)

### HC Complete 

![alt text](https://github.com/NishaPardeshi/FIFA-Analysis/blob/master/images/ca_hc.png)

### K-Means Cluster

![alt text](https://github.com/NishaPardeshi/FIFA-Analysis/blob/master/images/ca_km.png)

### Model Based Cluster - 3 CLusters

![alt text](https://github.com/NishaPardeshi/FIFA-Analysis/blob/master/images/ca_mc.png)

## Factor Analysis

### Exploratory factor analysis

Exploratory Factor Analysis is used to identify the latent variables related to the manifest variables from the factors without assumptions. </br>
We identified three factors: </br>
Factor 1 is the coach perspective. </br>
Factor 2 is the management perspective. </br>
Factor 3 is the player experience.

### Confirmatory Factor Analysis

Confirmatory Factor Analysis is performed using lavaan project. In Confirmatory Factor Analysis, we assume that the factors build in EFA are correlated to each other.
![alt text](https://github.com/NishaPardeshi/FIFA-Analysis/blob/master/images/fa.png)

From the analysis, the players are identified by their Game Skills(Long Passing, Dribbling, Ball Control, Stamina) , Management Perspective(Value, Wage, International Reputation)  and Player Experience(Age, Heading Accuracy, Interceptions). The top interested players from management and coach perspective are L..Messi, L..Suárez, Neymar.Jr, Cristiano.Ronaldo, K..De.Bruyne, E..Hazard, L..Modrić, T..Kroos. 
</br>
All these players are top performers and few players like Messi and Cristiano Ronaldo have high wages. Using, Hierarchal clustering complete linkage, we could identify the proper clustering compare to other cluster models. These dimension reduction techniques performed in the above analysis has helped to visualize the relations among the variables for the multi dimension data. 
</br>
As these analyses has found the latent variables which helps to understand the recruiter on what basis the players are selected for and what are the other correlated factors which can influence the overall balance of a team. Since for a team it is always required to have a reputation and as well performers. 


