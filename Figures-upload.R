library(Rfast)
library(rvMF)
library(latex2exp)
library(scModels)

########### Fig 1. 6 x 12 plot
par(mfrow=c(1,2))

#### Histogram
p <- 10
kappa <- 100
set.seed(0)
r <- rvMFangle(1e6,p,kappa)
hist(r,breaks=100,freq = F, main=TeX(paste0("Histogram of r (p=",p,", $\\kappa$=",kappa,")")))
xs <- seq(-1,1,by=0.0001)
lines(xs,dvMFangle(xs,p,kappa),col="red",lwd=2)

#### Comparison with Wood's method

set.seed(0)
mu <- c(rep(1/sqrt(10),10))
kappa <- 100
samp.prop <- rvMF(1e6,mu,kappa)
wood.prop <- rvmf(1e6,mu,kappa)
ks.test(wood.prop, samp.prop)

plot(sort(samp.prop[(1:1e5)*2,1]),sort(wood.prop[(1:1e5)*2,1]),
     main=TeX(paste0("QQ plot of the first component ($\\mu$=$\\bf{1}_{10}/\\sqrt{10}$, $\\kappa$=",kappa,")")),
     xlab="Proposed method",ylab="Wood's method")
abline(0,1,col="red",lwd=2)


########### Fig 2. 6 x 12 plot
par(mfrow=c(1,2))

#### k asymptotic

dch <- \(l,p,kappa){
  exp(lgamma((p-1)/2+l)-lgamma((p-1)/2)+lgamma(p-1)-lgamma(p-1+l)+l*log(2*kappa)-chf_1F1(2*kappa,(p-1)/2,p-1)-lgamma(l+1))
}

par(mfrow=c(1,2))
p <- 2
xlims = 0:250
plot(xlims, dch(xlims,p,10),type="h",col="blue",
     xlab="l",ylab=TeX("P(X=l)"))
lines(xlims, dch(xlims,p,50),type="h",col="red")
lines(xlims, dch(xlims,p,100),type="h",col="black")
legend("topright",col=c("blue","red","black"),legend=TeX(c("$\\kappa=10$","$\\kappa=50$","$\\kappa=100$")),lwd=4,bty="n")

#### p asymptotic 

kappa <- 10
xlims = 0:30
plot(xlims-0.2, dch(xlims,p=10,kappa),type="h",lwd=4,ylim=c(0,0.13),col="blue",
     xlab="l",ylab=TeX("P(X=l)"))
# lines(xlims+0.2, dch(xlims,p=100,kappa),type="h",col="red",lwd=4)
# lines(xlims+0.2, dch(xlims,p=1000,kappa),type="h",col="red",lwd=4)
lines(xlims+0.2, dch(xlims,p=10000,kappa),type="h",col="red",lwd=4)
lines(xlims, dpois(xlims,lambda=kappa),type="h",lwd=4)
legend("topright",col=c("blue","red","black"),legend=TeX(c("p=10","p=10000","Poisson($\\kappa$)")),lwd=4,bty="n")
