#devtools::install_github("timjmiller/wham", dependencies=TRUE)
library(wham)
#source("demonstrations/gavin/wham_mse_functions.R")
#source("demonstrations/tim/wham_retro_functions.R")
#source("demonstrations/gavin/base_input.R")

source("code/wham_mse_functions.R")
source("code/wham_retro_functions.R")
source("demonstrations/tim/base_input.R") #make it possible to exclude projections
#source("code/base_input.R")

#Retro type definitions
#size of retro: ~0.5
#Catch/F:  2.75 times higher than reported. Change 10 years from end of base period
# results in Mohn's rho approx 0.50 for SSB, -0.34 for F, 0.33 for Recruitment
#fit SCAA model to estimate retro.

wham_like_asap = function(nsim = 1){

  #input = get_base_input()
  new_in = get_base_input(nprojyrs = 0)
  na = new_in$data$n_ages
  nf = new_in$data$n_fleets
  ni = new_in$data$n_indices
  F = matrix(rep(c(seq(0.1,0.7,length.out = 1995-1971+1),
                      seq(0.7,0.25,length.out = 2010-1995+1)[-1],
                      rep(0.25,2020-2010)),nf),
                    ncol = nf)
  new_in$par$log_F1 = log(F[1,])
  new_in$par$F_devs = apply(log(F),2,diff)
  #na = input$na #number of ages
  #nf=input$nf #number of fleets (we only need 1)
  #ni=input$ni #number of indices 
  #input$F =   input$F <- matrix(rep(c(seq(0.1,0.7,length.out = 1995-1971+1),
  #                    seq(0.7,0.25,length.out = 2010-1995+1)[-1],
  #                    rep(0.25,2020-2010)),nf),
  #                  ncol = nf)

    
  if(nf + ni != 3) stop("number of fleets must = 1 and number of indices must = 2")
  sel.list=list(model=rep("logistic",ni+nf), re=rep("none",ni+nf), 
    initial_pars= list(
      c(3.57,1), #fishery (see factorial pruning)
      c(1.8, 1/6), #survey 1 (see factorial pruning)
      c(1.2, 1/5.5))) #survey 2 (see factorial pruning)

  #set up initial numbers at age according to equilibrium assumptions as determined by IBMWG
  if("input" %in% names(new_in)) input = new_in$input$basic_info
  else input = new_in$basic_info
  h = input$mean_rec_pars[1]
  R0 = input$mean_rec_pars[2]
  sel = 1/(1+exp(-sel.list$initial_pars[[1]][2]*(1:na - sel.list$initial_pars[[1]][1])))
  spr0 = wham:::get_SPR(0, M=input$M, sel, mat=input$maturity, waassb=input$waa_catch, fracyrssb=input$fracyr_spawn, at.age = FALSE)
  a = 4*h/((1-h)*spr0)
  b = (a - 1/spr0)/R0
  F1 = F[1]
  #F1 = input$F[1]
  sprF1 = wham:::get_SPR(F1, M=input$M, sel, mat=input$maturity, waassb=input$waa_catch, fracyrssb=input$fracyr_spawn, at.age = FALSE)
  nprF1 = wham:::get_SPR(F1, M=input$M, sel, mat=rep(1,na), waassb=rep(1,na), fracyrssb=input$fracyr_spawn, at.age = TRUE)
  R_F1 = (a - 1/sum(sprF1))/b
  
  new_in$par$log_N1_pars = log(R_F1*nprF1)
  #input$N1 <- R_F1*nprF1 #Initial numbers at age
  om = new_in
  #generate the input for fit_wham. Data (indices, catch) are not populated though.
  #om = prepare_wham_om_input(input, recruit_model = input$recruit_model, selectivity=sel.list, NAA_re = input$NAA.list)#, proj.opts = proj.list)
  #om$data$Fbar_ages = 10
  #source("~/work/IBMWG/wham/sandbox/prepare_wham_om_input.R")
  om_wham = fit_wham(om, do.fit = FALSE)
  seed = 8675309
  set.seed(seed)
  simsets = lapply(1:nsim, function(x) om_wham$simulate(complete = TRUE))
  scaa_input = input
  scaa_input = om
  scaa_input$data$use_steepness = 0
  #scaa_input$use_steepness = 0
  scaa_input$par$mean_rec_pars = scaa_input$par$mean_rec_pars[2]
  scaa_input$data$recruit_model = 2
  scaa_input$random = NULL
  scaa_input$map$log_NAA_sigma = factor(rep(NA, length(scaa_input$par$log_NAA_sigma)))
  #scaa_input$mean_rec_pars = scaa_input$mean_rec_pars[2]
  #scaa_input = prepare_wham_om_input(scaa_input, recruit_model = 2, selectivity=sel.list)
  #scaa_input$data$Fbar_ages = 10
  #fit = fit_wham(tinput, do.osa = FALSE, do.sdrep = FALSE, MakeADFun.silent = TRUE)

  simres = list()
  for(i in 1:length(simsets))
  {
    print(paste0("i = ", i))
    tinput = scaa_input
    tinput$data = simsets[[i]]
    tinput$data$Fbar_ages = 10
    tinput$data$use_steepness = 0
    tinput$data$recruit_model = 2
    tinput$random = NULL
    tinput$map$mean_rec_pars = factor(rep(NA, length(scaa_input$par$mean_rec_pars)))
    tinput$map$log_NAA_sigma = factor(rep(NA, length(scaa_input$par$log_NAA_sigma)))
    tinput$map$trans_NAA_rho = factor(rep(NA, length(scaa_input$par$trans_NAA_rho)))
    tfit = fit_wham(tinput, do.osa = FALSE, do.sdrep = FALSE, MakeADFun.silent = TRUE, do.retro = FALSE)
    simres[[i]] = tfit$rep
  }
  return(list(simsets, simres, tfit))
}
x = wham_like_asap()

saveRDS(x, "demonstrations/tim/wham_res.RDS")

