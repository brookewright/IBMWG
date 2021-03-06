#devtools::install_github("timjmiller/wham", dependencies=TRUE)
library(wham)
source("demonstrations/gavin/wham_mse_functions.R")
source("demonstrations/tim/wham_retro_functions.R")
source("demonstrations/gavin/base_input.R")

#Retro type definitions
#size of retro: ~0.5
#M: 10 year ramp ending 10 years before the end of the base period 
#M_ratio = 1.65 = 65% increase in M by the end of the ramp.
# results in Mohn's rho approx 0.51 for SSB, -0.36 for F, 0.61 for Recruitment
#fit SCAA model to estimate retro.

estimate_retro_M_rho = function(M_ratio = 1.65, nsim = 50, n_selblocks = 1, Fhist = 1, Fmsy_scale = 2.5){

  input = get_base_input()
  om = get_base_input(n_selblocks, Fhist, Fmsy_scale)

  #na = input$na #number of ages
  #nf=input$nf #number of fleets (we only need 1)
  #ni=input$ni #number of indices 
  #input$recruit_model = 3 #Beverton-Holt
    
  #a50 = 5 and slope = 1 for logistic selectivity for each fleet and index
  #sel.list=list(model=rep("logistic",ni+nf), re=rep("none",ni+nf), initial_pars=lapply(1:(ni+nf), function(x) c(5,1)))
  #if(nf + ni != 3) stop("number of fleets must = 1 and number of indices must = 2")
  #sel.list=list(model=rep("logistic",ni+nf), re=rep("none",ni+nf), 
  #  initial_pars= list(
  #    c(3.57,1), #fishery (see factorial pruning)
  #    c(1.8, 1/6), #survey 1 (see factorial pruning)
  #    c(1.2, 1/5.5))) #survey 2 (see factorial pruning)

  #AR1 deviations of rececruitment only over time. To include abundances at older ages as random effects use "rec+1"
  #NAA.list = list(sigma='rec',cor='ar1_y')
  #NAA.list = list(sigma='rec',cor='iid') #this would make recruitment deviations iid.
  #```

  #```{r base-period}
  #set up projections to repopulate 
  #proj.list = list(n.yrs=length(input$modyears), use.last.F=TRUE, use.avg.F=FALSE, use.FXSPR=FALSE,
  #                                              proj.F=NULL, proj.catch=NULL, avg.yrs=NULL,
  #                                              cont.ecov=TRUE, use.last.ecov=FALSE, avg.ecov.yrs=NULL, proj.ecov=NULL, cont.Mre=NULL)

  #set up initial numbers at age according to equilibrium assumptions as determined by IBMWG
  #h = input$mean_rec_pars[1]
  #R0 = input$mean_rec_pars[2]
  #sel = 1/(1+exp(-sel.list$initial_pars[[1]][2]*(1:na - sel.list$initial_pars[[1]][1])))
  #spr0 = wham:::get_SPR(0, M=input$M, sel, mat=input$maturity, waassb=input$waa_catch, fracyrssb=input$fracyr_spawn, at.age = FALSE)
  #a = 4*h/((1-h)*spr0)
  #b = (a - 1/spr0)/R0
  #F1 = input$F[1]
  #sprF1 = wham:::get_SPR(F1, M=input$M, sel, mat=input$maturity, waassb=input$waa_catch, fracyrssb=input$fracyr_spawn, at.age = FALSE)
  #nprF1 = wham:::get_SPR(F1, M=input$M, sel, mat=rep(1,na), waassb=rep(1,na), fracyrssb=input$fracyr_spawn, at.age = TRUE)
  #R_F1 = (a - 1/sum(sprF1))/b
  #input$N1 <- R_F1*nprF1 #Initial numbers at age

  #generate the input for fit_wham. Data (indices, catch) are not populated though.
  #om = prepare_wham_om_input(input, recruit_model = input$recruit_model, selectivity=sel.list, NAA_re = NAA.list)#, proj.opts = proj.list)
  #om$data$Fbar_ages = 10
  #source("~/work/IBMWG/wham/sandbox/prepare_wham_om_input.R")
  om_wham = fit_wham(om, do.fit = FALSE)
  scaa_input = get_base_input(n_selblocks, Fhist, Fmsy_scale, scaa=TRUE)
  #scaa_input = input
  #scaa_input$use_steepness = 0
  #scaa_input$mean_rec_pars = scaa_input$mean_rec_pars[2]
  #scaa_input = prepare_wham_om_input(scaa_input, recruit_model = 2, selectivity=sel.list)
  #scaa_input$data$Fbar_ages = 10
  om_M_change = change_M_om(om, M_new_ratio = M_ratio, year_change = 2009) 
  om_M_change_wham = fit_wham(om_M_change, do.fit = FALSE)

  seed = 8675309
  set.seed(seed)
  simsets = lapply(1:nsim, function(x) om_M_change_wham$simulate(complete = TRUE))
  simres = matrix(NA, length(simsets), om$data$n_ages+2)
  for(i in 1:length(simsets))
  {
    print(paste0("i = ", i))
    tinput = scaa_input
    tinput$data = simsets[[i]]
    tinput$data$Fbar_ages = 10
    tinput$data$use_steepness = 0
    tinput$data$recruit_model = 2
    tfit = fit_wham(tinput, do.osa = FALSE, do.sdrep = FALSE, MakeADFun.silent = TRUE)
    print(tfit$opt$par)
    simres[i,] = mohns_rho(tfit)
    print(apply(simres,2,mean,na.rm=TRUE))
  }
  colnames(simres) = names(mohns_rho(tfit))
  apply(simres,2, mean)

  return(list(simres, tfit))
}

#x = estimate_retro_M_rho()

