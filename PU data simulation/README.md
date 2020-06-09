# Positive Unlabeled data simulation
**P**ositive and unlabeled **L**earning from **U**nbalanced cases and **S**parse structures, or **PLUS**, represents the first one to use positive and unlabeled learning framework to specifically model the under-diagnosis issue in predicting cancer metastasis potential. PLUS is specifically tailored for studying metastasis that deals with the unbalanced instance allocation as well as unknown metastasis prevalence, which are not capable by any other methods. Its robustness grants the possibility to harness the power of big data by integrating large scale datasets from different cancer types. Insights gleaned from this research will prove useful to the diagnosis and treatment of clinical metastatic disease.

## The motivation of PLUS
![image](https://github.com/xiaoyulu95/PLUS/blob/master/fig/data_simulation.pdf)

(a) Among the patients who were diagnosed as non-metastatic, some were under-diagnosed. Traditional classification using diagnosis as response may underestimate the cancer metastasis potential. PLUS is designed to recognize the bias in under-diagnosis, so that patients with higher metastasis potential could be accurately classified. (b) In TCGA Pan-cancer study, for patients who are clinically diagnosed as non-metastatic (M0) at baseline in each cancer type (columns), the top three rows shows the proportions of patients with follow-up information who were found alive and with non- progressed disease (NP-Alive), alive and with progressed disease (P-Alive), and dead (Dead); and the bottom three rows show the same proportions for patients who were diagnosed as metastatic (M1) at baseline. (c) The median follow-up time for patients who were diagnosed as non-metastatic (blue) and as metastatic (yellow) at baseline for each cancer type.



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

