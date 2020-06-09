

#' PLUS main function.
#'
#' @param train_data train_data N*M matrix which has N samples and M variables.
#' @param Label.obs Positive Unlabeled for each sample, 1 means true positive label, 0 means unlabeled labels.
#' @param Sample_use_time used in stop criteria, how many times each samples to be used in training process.
#' @param l.rate control how much information from last iteration will be used in next.
#' @param qq quantile of the probability for positive samples, used to determine the cutoff between positive and negtive.
#' @return A list consist of three objects including predicted y, predicted coefficient, cutoff. (output 1. probability for each sample to be labeled as positive;output 2. cutoff to distinguish probability between positive and negtive samples; output 3. variable coeffecient non-zero means used in modeling)
PLUS <- function(train_data=train_data,Label.obs=Label.obs,Sample_use_time=30,l.rate=1,qq=0.1){

  N=dim(train_data)[1]
  Label=Label.obs
  train.X=train_data
  pred.y0 = Label.obs
  valid.id=which(pred.y0==1)

  delta.p = array(Inf, N)
  PP = NULL
  invalid.id=seq(N)[-valid.id]
  prob_choosen=rep(1,length(invalid.id))
  names(prob_choosen)=invalid.id
  change_propor=c(0,0,0,0,0)


  for ( i in 1:10000 ) {
    # Randomly select the same amount of subjects to train with valid samples
    sample.id = sample(invalid.id, length(valid.id), replace = T ,prob = prob_choosen)
    sample.id = unique(sample.id)
    #Used_time controls how many time each sample are selected
    prob_choosen[as.character(sample.id)]=prob_choosen[as.character(sample.id)]-(1/Sample_use_time)

    # train cv PLR model and do prediction
    fit.pi = cv.glmnet(train.X[c(valid.id, sample.id),], Label.obs[c(valid.id, sample.id)], family = "binomial")
    pred.y = predict(fit.pi, newx = train.X, s = "lambda.min", type = 'response')
    #valid id in Label is true positive
    cutoff = quantile(pred.y[valid.id], qq)

    # rescale
    map.pred.y = pred.y - cutoff
    map.pred.y[map.pred.y>0] = map.pred.y[map.pred.y>0]/max(map.pred.y[map.pred.y>0])
    map.pred.y[map.pred.y<0] = map.pred.y[map.pred.y<0]/abs(min(map.pred.y[map.pred.y<0]))
    pred.y = 1/(1+exp(-10*(map.pred.y)))

    # record something
    delta.p[sample.id] = pred.y[sample.id] - pred.y0[sample.id]

    # if there need learning rate: l.rate controls change rate from old to new
    pred.y0[sample.id] = pred.y[sample.id]*l.rate + (1-l.rate)*pred.y0[sample.id]

    # shuffle:only change label of sample.id
    Label.sample.id.old=Label.obs[sample.id]
    Label.obs[sample.id] = rbinom(length(sample.id), 1, pred.y0[sample.id])
    Label.sample.id.new=Label.obs[sample.id]

    prob_choosen[which(prob_choosen<=0)]=0
    #stop criteria 1: if 90% of prob_choosen<=0.01 stop
    if(sum(prob_choosen<=0.01)>(0.9*length(prob_choosen))){
      break
    }
    #stop criteria 2: convergency
    change_propor=c(change_propor,sum(Label.sample.id.old==Label.sample.id.new)/length(sample.id))
    if(mean(change_propor[(i+1):(i+5)])>0.9)
    {
      break
    }
  }

  # overall model, use all data which is given accurate labels from previous steps
  fit.pi = cv.glmnet(train.X, Label.obs, family = "binomial")
  pred.y = predict(fit.pi, newx = train.X, s = "lambda.min", type = 'response')
  cutoff = quantile(pred.y[valid.id], qq)
  pred.coef1=coef(fit.pi, s = "lambda.min")

  return(list(pred.y=pred.y,cutoff=cutoff,pred.coef1=pred.coef1))

}


