library(mlr3benchmark)
library(mlr3)
library(ggplot2)

bmr = readRDS("results/bmr_binary.rds")
ba = as_benchmark_aggr(bmr, measures = msrs("classif.ce"))
ba$friedman_test()
ba$friedman_posthoc(meas = "ce")

autoplot(ba, type = "cd", meas = "ce", minimize = TRUE, style = 2)

autoplot(ba, type = "fn", meas = "ce", minimize = TRUE)
autoplot(ba, type = "box", meas = "ce", minimize = TRUE)

autoplot(ba, meas = "ce") + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
ggsave("plot.png", bg = "white", scale = 1.5)
