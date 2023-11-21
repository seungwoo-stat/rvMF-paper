library(rvMF)
library(microbenchmark)
library(rotasym)
library(Rcpp)

# we require Rfast version 2.0.8 or *lower*, for fair comparison. Specifically, 
# from 2.0.9 of Rfast, Rfast::rvmf is completely written in C.
# install.packages("Rfast_2.0.8.tar", repos = NULL, type="source")
library(Rfast)


## Experiments-upload.R
## Table 1 and 2 are reproduced with 'rvMF-modified.cpp' 
## Table 3 and 4 are reproduced with the rvMF package.

## Table 1
sourceCpp("rvMF-modified.cpp")
for(p in c(2,3,4,5,10,100,1000,10000)){
  for(kappa in c(0.1,0.5,1,5,10,100,1000,10000)){
    print(paste0("p:",p,", kappa:",kappa,", "))
    .rvMF64(0, p, kappa, scModels::chf_1F1(2 * kappa, (p - 1)/2,p - 1))    
  }
}

## Table 2
sourceCpp("rvMF-modified.cpp")
timedata <- data.frame()
for(p in c(2,3,4,5,10,100,1000,10000)){
  for(kappa in c(0.1,0.5,1,5,10,100,1000,10000)){
    print(paste0("p:",p,", kappa:",kappa,", "))
    res <- microbenchmark(
      "chf" = {scModels::chf_1F1(2 * kappa, (p - 1)/2,p - 1)},
      "all" = {lutbuild(p, kappa, scModels::chf_1F1(2 * kappa, (p - 1)/2, p - 1))},
    times=100)
    temp <- aggregate(res$time,list(res$expr),function(s)c(mean(s),median(s)))
    timedata <- rbind(timedata,
                      cbind(p,kappa,
                            temp[temp$Group.1 == "all","x"],
                            temp[temp$Group.1 == "chf","x"]/temp[temp$Group.1 == "all","x"]))
  }
}
colnames(timedata) <- c("p","kappa","mean","median","percent(mean)","percent(median)")
timedata #unit: ns (1e-9 seconds)

## Table 3
timedata <- data.frame()
for(p in c(2,3,4,5,10,100,1000,10000)){
  for(kappa in c(0.1,0.5,1,5,10,100,1000,10000)){
    print(paste0("p:",p,", kappa:",kappa))
    res <- microbenchmark(
      "rvMF101" = {rvMFangle(101,p,kappa)},
      "rvMF1" = {rvMFangle(1,p,kappa)},
      "Rfast101" = {d1 <- p - 1
        b <- (-2 * kappa + sqrt(4 * kappa^2 + d1^2))/d1
        x0 <- (1 - b)/(1 + b)
        m <- 0.5 * d1
        ca <- kappa * x0 + (p - 1) * log(1 - x0^2)
        .Call("Rfast_rvmf_h", PACKAGE = "Rfast", 101, ca,
              d1, x0, m, kappa, b)},
      "Rfast1" = {
        d1 <- p - 1
        b <- (-2 * kappa + sqrt(4 * kappa^2 + d1^2))/d1
        x0 <- (1 - b)/(1 + b)
        m <- 0.5 * d1
        ca <- kappa * x0 + (p - 1) * log(1 - x0^2)
        .Call("Rfast_rvmf_h", PACKAGE = "Rfast", 1, ca,
              d1, x0, m, kappa, b)},
      "rotasym101" = {r_g_vMF(101,p,kappa)},
      "rotasym1" = {r_g_vMF(1,p,kappa)},
      times=1e5)
    temp <- aggregate(res$time,list(res$expr),mean)
    
    timedata <- rbind(timedata,cbind(p,kappa,
                      (temp[temp$Group.1 == "rvMF101","x"] - temp[temp$Group.1 == "rvMF1","x"])/100,
                      (temp[temp$Group.1 == "Rfast101","x"] - temp[temp$Group.1 == "Rfast1","x"])/100),
                      (temp[temp$Group.1 == "rotasym101","x"] - temp[temp$Group.1 == "rotasym1","x"])/100)
  }
}
colnames(timedata) <- c("p","kappa","rvMF","Rfast","rotasym")
timedata #unit: ns (1e-9 seconds)

## Table 4: compare with Wood (1994)
p <- 10000 # 2, 3, 10, 100, 1000 ...
set.seed(0)
timedata <- data.frame()
for(n in 10^(3:8)){
  for(kappa in c(0.1,0.5,1,5,10,100,1000,10000)){
    res <- microbenchmark("proposed" = {
      rvMFangle(n,p,kappa)
    },
    "Rfast" = {
      d1 <- p - 1
      b <- (-2 * kappa + sqrt(4 * kappa^2 + d1^2))/d1
      x0 <- (1 - b)/(1 + b)
      m <- 0.5 * d1
      ca <- kappa * x0 + (p - 1) * log(1 - x0^2)
      .Call("Rfast_rvmf_h", PACKAGE = "Rfast", n, ca,
            d1, x0, m, kappa, b)
    },
    "rotasym" = {
      r_g_vMF(n,p,kappa)
    },
    times = 100)
    temp = cbind(res$expr,res$time,
                 rep(n,length(res$time)),
                 rep(kappa,length(res$time)))
    timedata <- rbind(timedata,aggregate(temp[,2],list(temp[,1],temp[,3],temp[,4]),
                                         function(s)c(mean(s),median(s))))
    message(paste0("p=",p," / n = ",n," / kappa=",kappa))
  }
}
colnames(timedata) <- c("group","n","kappa","summary(mean,med)")
timedata$group <- c("rvMF","Rfast","rotasym")[timedata$group]
timedata #unit: 1e-9 seconds
# saveRDS(timedata,"timedata_p10000.rds")