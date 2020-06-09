#ccc=PU_data_simulation(p=100,N=200,confident_rate=0.5,scenario='noisy_balance',valid='01')

PU_data_simulation=function(p,N,confident_rate=0.5,scenario='noisy_balance',valid='01'){

  noisy_rate=confident_rate
  X = matrix(rnorm(N * p, 0,1), ncol = p, nrow = N)

  if(scenario=='noisy_balance'){
    Lx = 2*X[,1] + 4*X[,2]*X[,3] - 3*sin(X[,4] + X[,5]) - 0.1*(X[,6])^4 # noisy balanced allocation
  }else if(scenario=='clear_balanced'){
    Lx = 2*X[,1] + 4*X[,2]*(X[,3]+5) - 3*sin(X[,4] + X[,5]) - 0.1*X[,6]^4 # clear balanced allocation
  }else if(scenario=='clear_unbalanced'){
    Lx = 2*X[,1] + 8*X[,2]*X[,3] - 3*sin(X[,4] + X[,5]) - 3*(X[,6]-1.2)^4 # clear unbalanced allocation
  }else if(scenario=='noisy_unbalanced'){
    Lx = 2*X[,1] + 1.5*X[,2]*X[,3] - 3*sin(X[,4] + X[,5]) - (X[,6]-1)^4 # noisy unbalanced allocation
  }

  pr = 1/(1 + exp(-Lx))

  Label = rbinom(N, 1, pr)

  if(valid=='both'){
    valid.id1 = sample(which(Label==1), max(round(noisy_rate*sum(Label==1)),50))
    valid.id0 = sample(which(Label==0), max(round(noisy_rate*sum(Label==0)),50))
  }else if(valid=='01'){
    valid.id1 = sample(which(Label==1), max(round(noisy_rate*sum(Label==1)),50))
    valid.id0 = NULL
  }else if(valid=='10'){
    valid.id1 = NULL
    valid.id0 = sample(which(Label==0),max(round(noisy_rate*sum(Label==0)),50))
  }

  valid.id  = c(valid.id1, valid.id0)

  Label.obs_111 = Label; Label.obs_111[-valid.id] = rbinom(N-length(valid.id),1,0.5)

  if (valid=='both'){
    TPR.PUlasso1 = 0
    TNR.PUlasso1 = 0
    AUC.PUlasso1 = 0
    TPR.PUlasso2 = 0
    TNR.PUlasso2 = 0
    AUC.PUlasso2 = 0
  }else{
    #PU setting
    if(valid=='01'){
      true_Label=Label
      true.pi = (sum(true_Label==1)-length(valid.id))/(N-length(valid.id))
    }else if(valid=='10'){
      true_Label_tem=Label
      true_Label_tem[which(true_Label_tem==0)]=2
      true_Label_tem[which(true_Label_tem==1)]=0
      true_Label_tem[which(true_Label_tem==2)]=1
      true_Label=true_Label_tem
      #how many 0 in -valid
      true.pi = (sum(Label==0)-length(valid.id))/(N-length(valid.id))
    }

    Label.obs = rep(NA,length(true_Label))
    Label.obs[valid.id] = 1
    Label.obs[-valid.id] = 0
  }
  example_data=list(train_data=X,Label.obs=Label.obs,Label.true=true_Label)
  return(example_data)
}
