# Positive Unlabeled data simulation
To comprehensively assess the proposed method, we designed a series of simulation studies. Four different scenarios for the noise distribution are simulated that correspond to: population balanced with two classes well separated, or clear balanced scenario; population balanced with two classes not well separated, or noisy balance scenario; population unbalanced with two classes well separated, or clear unbalanced scenario; population unbalanced with two classes not well separated, or the noisy unbalanced scenario. The alteration of population unbalancedness and separation are achieved by designing different propensity score function as follows:
![image](https://github.com/xiaoyulu95/PLUS/blob/master/fig/distribution.png)


## Usage
```
simul_data=PU_data_simulation(p=100,N=200,confident_rate=0.5,scenario='noisy_balance',valid='01')
```

## Arguments

* `train_data`: Gene expression matrix which has N samples and M variables

* `Label.obs`: Positive Unlabeled for each sample, 1 means true positive label, 0 means unlabeled labels

* `Sample_use_time`: Used in stop criteria, how many times each samples to be used in training process

* `l.rate`: Control how much information from last iteration will be used in next

* `qq`: Quantile of the probability for positive samples, used to determine the cutoff between positive and negtive

## Value
Result list contains three elements: `pred.y` shows the probability for each same to be predicted as positive; `cutoff` is the reference cutoff to transfer continues probability to binary 0/1 label; `pred.coef1` take the variable coefficient used in prediction model. 

## Example
```
### The R packages involved in PLUS package
library(PLUS)
library(glmnet)

X=PLUS::example_data$train_data
Label=PLUS::example_data$Label.obs
Prediction=PLUS(train_data=X,Label.obs=Label,Sample_use_time=30,l.rate=1,qq=0.1)
```

## Contact Information

- [Xiaoyu Lu](https://zcslab.github.io/people/xiaoyu/)
(lu14@iu.edu)

Ph.D. candidate, Indiana University School of Medicine

- [Junyi Zhou](https://fsph.iupui.edu/about/directory/zhou-junyi.html)
(junyzhou@iu.edu)

Ph.D. candidate, Department of Biostatistics, Indiana University


## Reference
Zhou, J., Lu, X., Chang, W., Wan, C., Zhang, C. and Cao, S., 2020. PLUS: predicting pan-cancer metastasis potential based on positive and unlabeled learning

