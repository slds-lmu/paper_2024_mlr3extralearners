library(mlr3extralearners)
library(mlr3learners)
library(mlr3oml)
library(data.table)
library(mlr3misc)
library(mlr3batchmark)
library(mlr3benchmark)
source("helper.R")


unlink("/gscratch/mbecke16/benchmark-mlr3extralearners/registry_regression", recursive = TRUE)

reg = makeExperimentRegistry(
  file.dir = "/gscratch/mbecke16/benchmark-mlr3extralearners/registry_regression",
  seed = 1,
  conf.file = "batchtools_conf.R",
  packages = c("renv", "mlr3extralearners", "mlr3learners")
)

# reg = loadRegistry(
#   file.dir = "/gscratch/mbecke16/benchmark-mlr3extralearners/registry_regression",
#   conf.file = "batchtools_conf.R",
#   writeable = TRUE)

# learner
tab = list_mlr3learners()
tab = tab[class == "regr"]

learners = lrns(tab$id)

walk(learners, function(learner) {
  learner$encapsulate(method = "callr", fallback = lrn("regr.featureless"))
  learner$timeout = c(train = 3600, predict = 3600)
})

# tasks and resamplings
task_ids = c(359931L, 359932L, 359950L, 359930L, 167210L, 359933L, 359934L, 
  359944L, 359935L, 359951L, 359938L, 360945L, 359945L, 359936L, 
  359942L, 359952L, 359949L, 359948L, 233211L, 359946L, 233215L, 
  359940L, 359939L, 359941L, 360932L, 360933L, 233214L)[1:20]

otasks = map(task_ids, otsk)
tasks = as_tasks(otasks)
resamplings = as_resamplings(otasks)

design = benchmark_grid(
  tasks = tasks,
  learners = learners,
  resamplings = resamplings,
  paired = TRUE
)

ids = batchmark(design, reg = reg, renv_project = ".")
ids[, chunk := chunk(job.id, chunk.size = 10, shuffle = FALSE)]
submitJobs(ids)
waitForJobs()

bmr = reduceResultsBatchmark()
saveRDS(bmr, "results/bmr_regression.rds")

job_table = getJobTable()
memory = read_memory(job_table$batch.id)
job_table[, memory := memory]
job_table = unnest(job_table, c("prob.pars", "algo.pars"))
tab_memory = job_table[, list(task_id, learner_id, memory)]
fwrite(tab_memory, "results/memory_regression.csv")