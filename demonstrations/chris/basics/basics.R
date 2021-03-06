# basics.R
# plot maturity, selectivities, and weight at age

library(tidyverse)

dat <- read.csv("demonstrations/chris/basics/atage.csv")
dat

datlong <- dat %>%
  pivot_longer(cols = -1, names_to = "metric", values_to = "value")
datlong

matselplot <- ggplot(filter(datlong, metric != "Weight"), aes(x=Age, y=value)) +
  geom_line(aes(color = metric), lwd=2) +
  scale_x_continuous(breaks = seq(2, 10, 2), labels = c("2", "4", "6", "8", "10+")) +
  theme_bw()
ggsave(filename = "demonstrations/chris/basics/matselplot.png", matselplot, width = 6, height = 4, units = "in")

waaplot <- ggplot(filter(datlong, metric == "Weight"), aes(x=Age, y=value)) +
  geom_line(lwd=2) +
  scale_x_continuous(breaks = seq(2, 10, 2), labels = c("2", "4", "6", "8", "10+")) +
  labs(y="Weight (kg)") +
  theme_bw()
ggsave(filename = "demonstrations/chris/basics/waaplot.png", waaplot, width = 5, height = 4, units = "in")

dat2 <- read.csv("demonstrations/chris/basics/surveysel.csv")
dat2

dat2long <- dat2 %>%
  pivot_longer(cols = -1, names_to = "Survey", values_to = "value")
dat2long

survselplot <- ggplot(dat2long, aes(x=Age, y=value, color=Survey)) +
  geom_line(lwd=2) +
  scale_x_continuous(breaks = seq(2, 10, 2), labels = c("2", "4", "6", "8", "10+")) +
  labs(y="Selectivity") +
  theme_bw()
ggsave(filename = "demonstrations/chris/basics/survselplot.png", survselplot, width = 4, height = 3, units = "in")
