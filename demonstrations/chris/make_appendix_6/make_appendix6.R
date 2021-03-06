# make_appendix6.R
# uses officeR package to make Word doc of pngs with captions

library(tidyverse)
library(officer)

mydir <- "C:/Users/chris.legault/Desktop/myIBMWG/figs_for_report"
od <- mydir # in case want to save docx file somewhere else

ifig <- 0 # counter for figures

# start the docx file
my_doc <- officer::read_docx()

# add figures, incrementing ifig appropriately
ifig <- ifig + 1
myfile <- file.path(mydir, "nsim_plot_0.png")
mycaption <- paste0("Figure A6.", ifig, ". Number of successfull simulations by scenario.")

my_doc <- my_doc %>%
  officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
  officer::body_add_par(mycaption, style = "Normal") %>%
  officer::body_add_par("", style = "Normal") %>% # blank line
  officer::body_add_break(pos = "after") # page break

## scores for base scenarios
score.txt <- "Two sets of scores, Rank and Resid, for the base analyses for the"
period <- c("in the long term.", "in the short term.", "in both the long and short term.")
metrics <- c("3 metrics of SSB, F, and Catch relative to their MSY reference points (denoted X/Xmsy)", "SSB relative to SSBmsy", "F relative to Fmsy", "catch relative to MSY")
mlab <- c("x", "ssb", "f", "catch")
plab <- c("l", "s", "b")
for (i in 1:3){
  for (j in 1:4){
    ifig <- ifig + 1
    myfile <- file.path(mydir, paste0(mlab[j],"msy_",plab[i],"_plot_1.png"))
    mycaption <- paste0("Figure A6.", ifig, ". ", score.txt, " ", metrics[j], " ", period[i])
    
    my_doc <- my_doc %>%
      officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
      officer::body_add_par(mycaption, style = "Normal") %>%
      officer::body_add_par("", style = "Normal") %>% # blank line
      officer::body_add_break(pos = "after") # page break
  }
}
ifig <- ifig + 1
myfile <- file.path(mydir, "c_only_plot_1.png")
mycaption <- paste0("Figure A6.", ifig, ". Two sets of scores, Rank and Resid, for the base analyses for the 2 metrics of interannual variability in catch over the entire feedback period and the short term mean Catch/MSY.")

my_doc <- my_doc %>%
  officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
  officer::body_add_par(mycaption, style = "Normal") %>%
  officer::body_add_par("", style = "Normal") %>% # blank line
  officer::body_add_break(pos = "after") # page break

### boxplots
mlab <- c("SSB", "F", "catch")
mlablower <- c("ssb", "f", "catch")
tlab <- c("IBM", "scenario")
tlabshort <- c("IBM", "Scen")
for (i in 1:3){ # SSB, F, catch
  for (j in 1:3){ # set, e.g., probs, ns, ratios 
    if (i != 3){
      slab <- c("probs", "ns", "ratios")
    }else{
      slab <- c("means", "ratios", "other")
    }
    for (k in 1:2){ # IBM, Scen
      mymain <- paste0("Boxplot of the mean values for the ", mlab[i], " metrics in the base analyses by ", tlab[k], ".")
      ifig <- ifig + 1
      myfile <- file.path(mydir, paste0(mlablower[i],"_box_",slab[j],"_",tlabshort[k],"_1.png"))
      mycaption <- paste0("Figure A6.", ifig, ". ", mymain) 
      my_doc <- my_doc %>%
        officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
        officer::body_add_par(mycaption, style = "Normal") %>%
        officer::body_add_par("", style = "Normal") %>% # blank line
        officer::body_add_break(pos = "after") # page break
    }
  }
}

### trade off plots
basetext1 <- "Trade off plot by IBM for the base analyses between "
tdtext <- c("the probability of a rebuilt stock and the mean catch relative to MSY", "the probability the stock is overfished and the probability that overfishing is occurring", "the average SSB and catch relative to their MSY reference points")
plab <- c(" in the long term.", " in the short term.")
basetext2 <- " Each point represents one scenario with the color indicating the source of the retrospective pattern for that scenario."
plabshort <- c("l", "s")
for (i in 1:3){ # number of td plots
  for (j in 1:2){ # long and short term
    ifig <- ifig + 1
    myfile <- file.path(mydir, paste0("td", i, "_", plabshort[j], "_plot_1.png"))
    mycaption <- paste0("Figure A6.", ifig, ". ", basetext1, tdtext[i], plab[j], basetext2)
    my_doc <- my_doc %>%
      officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
      officer::body_add_par(mycaption, style = "Normal") %>%
      officer::body_add_par("", style = "Normal") %>% # blank line
      officer::body_add_break(pos = "after") # page break
  }  
}


### 1,000 point plots for trade off 4
flab <- c("scenario", "IBM") # reversed because describing top left of fig
flabshort <- c("IBM", "Scen")
nplots <- c(16, 13) # number of plots by IBM and Scen
plab <- c("long", "short")
plabshort <- c("l", "s")
basetext1 <- "Spawning stock biomass (SSB) relative to the SSB at maximum sustainable yield (SSBmsy) and catch relative to MSY for the "
basetext2 <- " defined in the top left in the "
basetext3 <- " term with each dot representing one of the 1,000 simulations." 
for (i in 1:2){ # IBM and Scen
  for (j in 1:2){ # long and short term
    for (k in 1:nplots[i]){
      ifig <- ifig + 1
      myfile <- file.path(mydir, paste0("td4_", plabshort[j], "_", flabshort[i],"_plot_", k, "_list.png"))
      mycaption <- paste0("Figure A6.", ifig, ". ", basetext1, flab[i], basetext2, plab[j], basetext3)
      my_doc <- my_doc %>%
        officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
        officer::body_add_par(mycaption, style = "Normal") %>%
        officer::body_add_par("", style = "Normal") %>% # blank line
        officer::body_add_break(pos = "after") # page break
    }
  }
}

## bagplots (using same caption for IBM and Scen plots)
bagIBMtext <- "Bagplots (a bivariate generalization of the boxplot) for long term (black) and short term (blue) SSB/SSBmsy and catch/MSY for each IBM in the scenario defined in the top left. The solid dot is the median, the dark shading is the 2D equivalent of the inner quartile range, the light shading encompasses an area three times the bag, and the unfilled dots are outliers."
bagScentext <- "Bagplots (a bivariate generalization of the boxplot) for long term (black) and short term (blue) SSB/SSBmsy and catch/MSY for each scenario using the IBM defined in the top left. The solid dot is the median, the dark shading is the 2D equivalent of the inner quartile range, the light shading encompasses an area three times the bag, and the unfilled dots are outliers."
for (i in 1:29){
  ifig <- ifig + 1
  myfile <- file.path(mydir, paste0("bagplots_td4_base_", i, "_list.png"))
  if (i <= 16){
    mymain <- bagIBMtext   
  }else{
    mymain <- bagScentext
  }
  mycaption <- paste0("Figure A6.", ifig, ". ", mymain)
  my_doc <- my_doc %>%
    officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
    officer::body_add_par(mycaption, style = "Normal") %>%
    officer::body_add_par("", style = "Normal") %>% # blank line
    officer::body_add_break(pos = "after") # page break
}

### 8 panel relative MSY plots
met <- c("ssb_ssbmsy", "f_fmsy", "catch_msy")
metshort <- c("SSB", "F", "catch")
plab <- c("long", "short")
plabshort <- c("l", "s")
basetext1 <- "Mean values of "
basetext2 <- " relative to its maximum sustainable yield reference point by IBM in the "
basetext3 <- " term with color denoting the catch advice multiplier for the 8 combinations of F history (F = Fmsy in second half of base period, O = overfishing throughout), number of fishery selectivity blocks (1 or 2), and retrospective source (catch or natural mortality, M). The IBMs are sorted by the mean across the 16 scenarios and arranged so that higher values are at the top."
for (i in 1:2){ # long and short term
  for (j in 1:3){ # SSB, F, catch
    ifig <- ifig + 1
    myfile <- file.path(mydir, paste0(met[j], "_", plabshort[i], "_1.png"))
    mycaption <- paste0("Figure A6.", ifig, ". ", basetext1, metshort[j], basetext2, plab[i], basetext3)
    my_doc <- my_doc %>%
      officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
      officer::body_add_par(mycaption, style = "Normal") %>%
      officer::body_add_par("", style = "Normal") %>% # blank line
      officer::body_add_break(pos = "after") # page break
  }
}

### status plots
met <- c("Probability", "Number of years")
metshort <- c("prob", "nyrs")
basetext <- " stock is overfished or undergoing overfishing in the short or long term for each IBM averaged across all base analyses."

for (i in 1:2){
  ifig <- ifig + 1
  myfile <- file.path(mydir, paste0(metshort[i], "_status_plot_1.png"))
  mycaption <- paste0("Figure A6.", ifig, ". ", met[i], basetext)
  my_doc <- my_doc %>%
    officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
    officer::body_add_par(mycaption, style = "Normal") %>%
    officer::body_add_par("", style = "Normal") %>% # blank line
    officer::body_add_break(pos = "after") # page break
}

#### confetti plots (base analyses only)
mlab <- c("SSB", "F", "catch")
mlablower <- c("ssb", "f", "catch")
for (i in 1:3){ # SSB, F, catch
  for (j in 1:3){ # set, e.g., probs, ns, ratios 
    if (i != 3){
      slab <- c("probs", "ns", "ratios")
    }else{
      slab <- c("means", "ratios", "other")
    }
    for (k in 1:6){ # confetti by factor
      mymain <- paste0("Confetti plot of the mean values for some of the ", mlab[i], " metrics in the base analyses by the combinations of IBM and scenario (denoted scenario in these plots). If colored, the colors denote differnt levels of one factor.")
      ifig <- ifig + 1
      myfile <- file.path(mydir, paste0(mlablower[i],"_",slab[j],"_plot_",k,"_confetti.png"))
      mycaption <- paste0("Figure A6.", ifig, ". ", mymain) 
      my_doc <- my_doc %>%
        officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
        officer::body_add_par(mycaption, style = "Normal") %>%
        officer::body_add_par("", style = "Normal") %>% # blank line
        officer::body_add_break(pos = "after") # page break
    }
  }
}

### No retro scenarios section
## scores for base scenarios
score.txt <- "Two sets of scores, Rank and Resid, for the no retro analyses for the"
period <- c("in the long term.", "in the short term.", "in both the long and short term.")
metrics <- c("3 metrics of SSB, F, and Catch relative to their MSY reference points (denoted X/Xmsy)", "SSB relative to SSBmsy", "F relative to Fmsy", "catch relative to MSY")
mlab <- c("x", "ssb", "f", "catch")
plab <- c("l", "s", "b")
for (i in 1:3){
  for (j in 1:4){
    ifig <- ifig + 1
    myfile <- file.path(mydir, paste0(mlab[j],"msy_",plab[i],"_plot_2.png"))
    mycaption <- paste0("Figure A6.", ifig, ". ", score.txt, " ", metrics[j], " ", period[i])
    
    my_doc <- my_doc %>%
      officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
      officer::body_add_par(mycaption, style = "Normal") %>%
      officer::body_add_par("", style = "Normal") %>% # blank line
      officer::body_add_break(pos = "after") # page break
  }
}
ifig <- ifig + 1
myfile <- file.path(mydir, "c_only_plot_2.png")
mycaption <- paste0("Figure A6.", ifig, ". Two sets of scores, Rank and Resid, for the no retro analyses for the 2 metrics of interannual variability in catch over the entire feedback period and the short term mean Catch/MSY.")

my_doc <- my_doc %>%
  officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
  officer::body_add_par(mycaption, style = "Normal") %>%
  officer::body_add_par("", style = "Normal") %>% # blank line
  officer::body_add_break(pos = "after") # page break

### boxplots
mlab <- c("SSB", "F", "catch")
mlablower <- c("ssb", "f", "catch")
tlab <- c("IBM", "scenario")
tlabshort <- c("IBM", "Scen")
for (i in 1:3){ # SSB, F, catch
  for (j in 1:3){ # set, e.g., probs, ns, ratios 
    if (i != 3){
      slab <- c("probs", "ns", "ratios")
    }else{
      slab <- c("means", "ratios", "other")
    }
    for (k in 1:2){ # IBM, Scen
      mymain <- paste0("Boxplot of the mean values for the ", mlab[i], " metrics in the no retro analyses by ", tlab[k], ".")
      ifig <- ifig + 1
      myfile <- file.path(mydir, paste0(mlablower[i],"_box_",slab[j],"_",tlabshort[k],"_2.png"))
      mycaption <- paste0("Figure A6.", ifig, ". ", mymain) 
      my_doc <- my_doc %>%
        officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
        officer::body_add_par(mycaption, style = "Normal") %>%
        officer::body_add_par("", style = "Normal") %>% # blank line
        officer::body_add_break(pos = "after") # page break
    }
  }
}

### trade off plots
basetext1 <- "Trade off plot by IBM for the no retro analyses between "
tdtext <- c("the probability of a rebuilt stock and the mean catch relative to MSY", "the probability the stock is overfished and the probability that overfishing is occurring", "the average SSB and catch relative to their MSY reference points")
plab <- c(" in the long term.", " in the short term.")
basetext2 <- " Each point represents one scenario with the color indicating the source of the retrospective pattern for that scenario."
plabshort <- c("l", "s")
for (i in 1:3){ # number of td plots
  for (j in 1:2){ # long and short term
    ifig <- ifig + 1
    myfile <- file.path(mydir, paste0("td", i, "_", plabshort[j], "_plot_2.png"))
    mycaption <- paste0("Figure A6.", ifig, ". ", basetext1, tdtext[i], plab[j], basetext2)
    my_doc <- my_doc %>%
      officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
      officer::body_add_par(mycaption, style = "Normal") %>%
      officer::body_add_par("", style = "Normal") %>% # blank line
      officer::body_add_break(pos = "after") # page break
  }  
}


### 1,000 point plots for trade off 4
flab <- c("scenario", "IBM") # reversed because describing top left of fig
flabshort <- c("IBM", "Scen")
nplots <- c(6, 12) # number of plots by IBM and Scen
plab <- c("long", "short")
plabshort <- c("l", "s")
basetext1 <- "Spawning stock biomass (SSB) relative to the SSB at maximum sustainable yield (SSBmsy) and catch relative to MSY for the "
basetext2 <- " defined in the top left in the "
basetext3 <- " term with each dot representing one of the 1,000 simulations." 
for (i in 1:2){ # IBM and Scen
  for (j in 1:2){ # long and short term
    for (k in 1:nplots[i]){
      ifig <- ifig + 1
      myfile <- file.path(mydir, paste0("td4_", plabshort[j], "_", flabshort[i],"_noretro_plot_", k, "_list.png"))
      mycaption <- paste0("Figure A6.", ifig, ". ", basetext1, flab[i], basetext2, plab[j], basetext3)
      my_doc <- my_doc %>%
        officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
        officer::body_add_par(mycaption, style = "Normal") %>%
        officer::body_add_par("", style = "Normal") %>% # blank line
        officer::body_add_break(pos = "after") # page break
    }
  }
}

## bagplots (using same caption for IBM and Scen plots)
# bagplots did not work for noretro analyses - do not know why
# bagIBMtext <- "Bagplots (a bivariate generalization of the boxplot) for long term (black) and short term (blue) SSB/SSBmsy and catch/MSY for each IBM in the scenario defined in the top left. The solid dot is the median, the dark shading is the 2D equivalent of the inner quartile range, the light shading encompasses an area three times the bag, and the unfilled dots are outliers."
# bagScentext <- "Bagplots (a bivariate generalization of the boxplot) for long term (black) and short term (blue) SSB/SSBmsy and catch/MSY for each scenario using the IBM defined in the top left. The solid dot is the median, the dark shading is the 2D equivalent of the inner quartile range, the light shading encompasses an area three times the bag, and the unfilled dots are outliers."
# for (i in 1:29){
#   ifig <- ifig + 1
#   myfile <- file.path(mydir, paste0("bagplots_td4_noretro_", i, "_list.png"))
#   if (i <= 16){
#     mymain <- bagIBMtext   
#   }else{
#     mymain <- bagScentext
#   }
#   mycaption <- paste0("Figure A6.", ifig, ". ", mymain)
#   my_doc <- my_doc %>%
#     officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
#     officer::body_add_par(mycaption, style = "Normal") %>%
#     officer::body_add_par("", style = "Normal") %>% # blank line
#     officer::body_add_break(pos = "after") # page break
# }

### 8 panel relative MSY plots
met <- c("ssb_ssbmsy", "f_fmsy", "catch_msy")
metshort <- c("SSB", "F", "catch")
plab <- c("long", "short")
plabshort <- c("l", "s")
basetext1 <- "Mean values of "
basetext2 <- " relative to its maximum sustainable yield reference point by IBM in the "
basetext3 <- " term with color denoting the catch advice multiplier for the 8 combinations of F history (F = Fmsy in second half of base period, O = overfishing throughout), number of fishery selectivity blocks (1 or 2), and retrospective source (catch or natural mortality, M). The IBMs are sorted by the mean across the 16 scenarios and arranged so that higher values are at the top."
for (i in 1:2){ # long and short term
  for (j in 1:3){ # SSB, F, catch
    ifig <- ifig + 1
    myfile <- file.path(mydir, paste0(met[j], "_", plabshort[i], "_2.png"))
    mycaption <- paste0("Figure A6.", ifig, ". ", basetext1, metshort[j], basetext2, plab[i], basetext3)
    my_doc <- my_doc %>%
      officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
      officer::body_add_par(mycaption, style = "Normal") %>%
      officer::body_add_par("", style = "Normal") %>% # blank line
      officer::body_add_break(pos = "after") # page break
  }
}

### status plots
met <- c("Probability", "Number of years")
metshort <- c("prob", "nyrs")
basetext <- " stock is overfished or undergoing overfishing in the short or long term for each IBM averaged across all no retro analyses."

for (i in 1:2){
  ifig <- ifig + 1
  myfile <- file.path(mydir, paste0(metshort[i], "_status_plot_2.png"))
  mycaption <- paste0("Figure A6.", ifig, ". ", met[i], basetext)
  my_doc <- my_doc %>%
    officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
    officer::body_add_par(mycaption, style = "Normal") %>%
    officer::body_add_par("", style = "Normal") %>% # blank line
    officer::body_add_break(pos = "after") # page break
}

### SCAA analyses section
## scores for SCAA scenarios
score.txt <- "Two sets of scores, Rank and Resid, for the SCAA analyses for the"
period <- c("in the long term.", "in the short term.", "in both the long and short term.")
metrics <- c("3 metrics of SSB, F, and Catch relative to their MSY reference points (denoted X/Xmsy)", "SSB relative to SSBmsy", "F relative to Fmsy", "catch relative to MSY")
mlab <- c("x", "ssb", "f", "catch")
plab <- c("l", "s", "b")
for (i in 1:3){
  for (j in 1:4){
    ifig <- ifig + 1
    myfile <- file.path(mydir, paste0(mlab[j],"msy_",plab[i],"_plot_3.png"))
    mycaption <- paste0("Figure A6.", ifig, ". ", score.txt, " ", metrics[j], " ", period[i])
    
    my_doc <- my_doc %>%
      officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
      officer::body_add_par(mycaption, style = "Normal") %>%
      officer::body_add_par("", style = "Normal") %>% # blank line
      officer::body_add_break(pos = "after") # page break
  }
}
ifig <- ifig + 1
myfile <- file.path(mydir, "c_only_plot_3.png")
mycaption <- paste0("Figure A6.", ifig, ". Two sets of scores, Rank and Resid, for the SCAA analyses for the 2 metrics of interannual variability in catch over the entire feedback period and the short term mean Catch/MSY.")

my_doc <- my_doc %>%
  officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
  officer::body_add_par(mycaption, style = "Normal") %>%
  officer::body_add_par("", style = "Normal") %>% # blank line
  officer::body_add_break(pos = "after") # page break

### boxplots
mlab <- c("SSB", "F", "catch")
mlablower <- c("ssb", "f", "catch")
tlab <- c("IBM", "scenario")
tlabshort <- c("IBM", "Scen")
for (i in 1:3){ # SSB, F, catch
  for (j in 1:3){ # set, e.g., probs, ns, ratios 
    if (i != 3){
      slab <- c("probs", "ns", "ratios")
    }else{
      slab <- c("means", "ratios", "other")
    }
    for (k in 1:2){ # IBM, Scen
      mymain <- paste0("Boxplot of the mean values for the ", mlab[i], " metrics in the SCAA analyses by ", tlab[k], ".")
      ifig <- ifig + 1
      myfile <- file.path(mydir, paste0(mlablower[i],"_box_",slab[j],"_",tlabshort[k],"_3.png"))
      mycaption <- paste0("Figure A6.", ifig, ". ", mymain) 
      my_doc <- my_doc %>%
        officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
        officer::body_add_par(mycaption, style = "Normal") %>%
        officer::body_add_par("", style = "Normal") %>% # blank line
        officer::body_add_break(pos = "after") # page break
    }
  }
}

### trade off plots
basetext1 <- "Trade off plot by IBM for the SCAA analyses between "
tdtext <- c("the probability of a rebuilt stock and the mean catch relative to MSY", "the probability the stock is overfished and the probability that overfishing is occurring", "the average SSB and catch relative to their MSY reference points")
plab <- c(" in the long term.", " in the short term.")
basetext2 <- " Each point represents one scenario with the color indicating the source of the retrospective pattern for that scenario."
plabshort <- c("l", "s")
for (i in 1:3){ # number of td plots
  for (j in 1:2){ # long and short term
    ifig <- ifig + 1
    myfile <- file.path(mydir, paste0("td", i, "_", plabshort[j], "_plot_3.png"))
    mycaption <- paste0("Figure A6.", ifig, ". ", basetext1, tdtext[i], plab[j], basetext2)
    my_doc <- my_doc %>%
      officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
      officer::body_add_par(mycaption, style = "Normal") %>%
      officer::body_add_par("", style = "Normal") %>% # blank line
      officer::body_add_break(pos = "after") # page break
  }  
}


### 1,000 point plots for trade off 4
flab <- c("scenario", "IBM") # reversed because describing top left of fig
flabshort <- c("IBM", "Scen")
nplots <- c(4, 14) # number of plots by IBM and Scen
plab <- c("long", "short")
plabshort <- c("l", "s")
basetext1 <- "Spawning stock biomass (SSB) relative to the SSB at maximum sustainable yield (SSBmsy) and catch relative to MSY for the "
basetext2 <- " defined in the top left in the "
basetext3 <- " term with each dot representing one of the 1,000 simulations." 
for (i in 1:2){ # IBM and Scen
  for (j in 1:2){ # long and short term
    for (k in 1:nplots[i]){
      ifig <- ifig + 1
      myfile <- file.path(mydir, paste0("td4_", plabshort[j], "_", flabshort[i],"_scaa_plot_", k, "_list.png"))
      mycaption <- paste0("Figure A6.", ifig, ". ", basetext1, flab[i], basetext2, plab[j], basetext3)
      my_doc <- my_doc %>%
        officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
        officer::body_add_par(mycaption, style = "Normal") %>%
        officer::body_add_par("", style = "Normal") %>% # blank line
        officer::body_add_break(pos = "after") # page break
    }
  }
}

## bagplots (using same caption for IBM and Scen plots)
bagIBMtext <- "Bagplots (a bivariate generalization of the boxplot) for long term (black) and short term (blue) SSB/SSBmsy and catch/MSY for each IBM in the scenario defined in the top left. The solid dot is the median, the dark shading is the 2D equivalent of the inner quartile range, the light shading encompasses an area three times the bag, and the unfilled dots are outliers."
bagScentext <- "Bagplots (a bivariate generalization of the boxplot) for long term (black) and short term (blue) SSB/SSBmsy and catch/MSY for each scenario using the IBM defined in the top left. The solid dot is the median, the dark shading is the 2D equivalent of the inner quartile range, the light shading encompasses an area three times the bag, and the unfilled dots are outliers."
for (i in 1:18){
  ifig <- ifig + 1
  myfile <- file.path(mydir, paste0("bagplots_td4_scaa_", i, "_list.png"))
  if (i <= 4){
    mymain <- bagIBMtext
  }else{
    mymain <- bagScentext
  }
  mycaption <- paste0("Figure A6.", ifig, ". ", mymain)
  my_doc <- my_doc %>%
    officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
    officer::body_add_par(mycaption, style = "Normal") %>%
    officer::body_add_par("", style = "Normal") %>% # blank line
    officer::body_add_break(pos = "after") # page break
}

### 8 panel relative MSY plots
met <- c("ssb_ssbmsy", "f_fmsy", "catch_msy")
metshort <- c("SSB", "F", "catch")
plab <- c("long", "short")
plabshort <- c("l", "s")
basetext1 <- "Mean values of "
basetext2 <- " relative to its maximum sustainable yield reference point by IBM in the "
basetext3 <- " term with color denoting the catch advice multiplier for the 8 combinations of F history (F = Fmsy in second half of base period, O = overfishing throughout), number of fishery selectivity blocks (1 or 2), and retrospective source (catch or natural mortality, M). The IBMs are sorted by the mean across the 16 scenarios and arranged so that higher values are at the top."
for (i in 1:2){ # long and short term
  for (j in 1:3){ # SSB, F, catch
    ifig <- ifig + 1
    myfile <- file.path(mydir, paste0(met[j], "_", plabshort[i], "_3.png"))
    mycaption <- paste0("Figure A6.", ifig, ". ", basetext1, metshort[j], basetext2, plab[i], basetext3)
    my_doc <- my_doc %>%
      officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
      officer::body_add_par(mycaption, style = "Normal") %>%
      officer::body_add_par("", style = "Normal") %>% # blank line
      officer::body_add_break(pos = "after") # page break
  }
}

### status plots
met <- c("Probability", "Number of years")
metshort <- c("prob", "nyrs")
basetext <- " stock is overfished or undergoing overfishing in the short or long term for each IBM averaged across all SCAA analyses."

for (i in 1:2){
  ifig <- ifig + 1
  myfile <- file.path(mydir, paste0(metshort[i], "_status_plot_3.png"))
  mycaption <- paste0("Figure A6.", ifig, ". ", met[i], basetext)
  my_doc <- my_doc %>%
    officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
    officer::body_add_par(mycaption, style = "Normal") %>%
    officer::body_add_par("", style = "Normal") %>% # blank line
    officer::body_add_break(pos = "after") # page break
}


#### now switch over to Liz's ANOVA and Heatmap results
mydir <- "tables_figs/anova_tables_figs"
xx <- tibble(files = list.files(mydir)) %>% 
  filter(grepl(".png", files)) %>%
  head(13) %>%
  mutate(model = substr(files, 25, nchar(files) - 4))
mymod <- xx$model
mytype <- c("hist", "qq")
mymet1 <- c("SSB_SSBmsy", "F_Fmsy", "Catch_MSY")
mymet2 <- c("SSB/SSBmsy", "F/Fmsy", "Catch/MSY")
mytext <- c(" histograms for all simulation iterations by IBM for untransformed data (top left), natural logarithm transformed data (top right), and square root transformed data (bottom left)", " qq plots of the normalized residuals from the linear model fit for the ANOVAs")

for (i in 1:3){ # SSB, F, Catch
  for (j in 1:length(mymod)){ # models
    for (k in 1:2){ # hist, qq
      ifig <- ifig + 1
      myfile <- file.path(mydir, paste0("Dist_AVG_",mymet1[i],"_",mytype[k],"_",mymod[j],".png"))
      mycaption <- paste0("Figure A6.", ifig, ". ", mymet2[i], mytext[k])
      my_doc <- my_doc %>%
        officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
        officer::body_add_par(mycaption, style = "Normal") %>%
        officer::body_add_par("", style = "Normal") %>% # blank line
        officer::body_add_break(pos = "after") # page break
    }
  }
}

# and now heatmaps from Liz
mydir <- "tables_figs/heatmap_tables_figs"
mytext <- c("IBM, time horizon (short- or long-term summary, ‘S’ or ‘L’), and catch advice multiplier (1 or 0.75)", "IBM, catch advice multiplier (1 or 0.75), and fishing history (1=overfishing then F=FMSY, 2=always overfishing)", "IBM, fishing history (1=overfishing then F=FMSY, 2=always overfishing), and time horizon (short- or long-term summary, ‘S’ or ‘L’)", "IBM, source of retrospective pattern (C=Catch, M=Natural mortality), and fishing history (1=overfishing then F=FMSY, 2=always overfishing)", "IBM, source of retrospective pattern (C=Catch, M=Natural mortality), and time horizon (short- or long-term summary, ‘S’ or ‘L’)")
myfiles <- c("heatmap.ibm.cmult.time_median.png",
             "heatmap.ibm.fhist.cmult_median.png",
             "heatmap.ibm.fhist.time_median.png",
             "heatmap.ibm.retro.fhist_median.png",
             "heatmap.ibm.retro.time_median.png")
basetext1 <- "Heatmap of median values for SSB/SSBmsy, F/Fmsy, and catch/MSY by "
basetext2 <- ". The cells are colored according to where they fall in the normalized distribution of all values summarized in the heatmap, and location in that distribution is provided by the key at the top left.  A cyan histogram in the key indicates distribution of the data. The cyan lines within the heatmap indicate position of that cell relative to the mean. Values for each cell in the heatmap can be found in the associated table (rows in the same order as the heatmap)."

for (i in 1:5){
  ifig <-  ifig + 1
  myfile <- file.path(mydir, myfiles[i])
  mycaption <- paste0("Figure A6.", ifig, ". ", basetext1, mytext[i], basetext2)
  my_doc <- my_doc %>%
    officer::body_add_img(src=myfile, width = 6.5, height = 6.5, style = "centered") %>%
    officer::body_add_par(mycaption, style = "Normal") %>%
    officer::body_add_par("", style = "Normal") %>% # blank line
    officer::body_add_break(pos = "after") # page break
}


### finally
# make the docx file
print(my_doc, target = file.path(od, "Appendix6.docx"))
