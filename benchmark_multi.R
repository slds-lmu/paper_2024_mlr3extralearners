library(mlr3extralearners)
library(mlr3learners)
library(mlr3oml)
library(data.table)
library(mlr3misc)
library(mlr3batchmark)
library(mlr3benchmark)
source("helper.R")

unlink("/gscratch/mbecke16/benchmark-mlr3extralearners/registry_multi", recursive = TRUE)

reg = makeExperimentRegistry(
  file.dir = "/gscratch/mbecke16/benchmark-mlr3extralearners/registry_multi",
  seed = 1,
  conf.file = "batchtools_conf.R",
  packages = c("renv", "mlr3extralearners", "mlr3learners")
)

# reg = loadRegistry(
#   file.dir = "/gscratch/mbecke16/benchmark-mlr3extralearners/registry_multi",
#   conf.file = "batchtools_conf.R",
#   writeable = TRUE)

# learner
tab = list_mlr3learners()
tab = tab[class == "classif"]
tab[, multiclass := map_lgl(properties, function(x) "multiclass" %in% x)]
tab = tab[multiclass == TRUE]

learners = lrns(tab$id)

walk(learners, function(learner) {
  if ("prob" %in% learner$predict_types) {
    learner$predict_type = "prob"
  }
  learner$encapsulate(method = "callr", fallback = lrn("classif.featureless", predict_type = learner$predict_type))
  learner$timeout = c(train = 3600, predict = 3600)
})

# tasks and resamplings
task_ids = c(11L, 3560L, 23L, 146821L, 53L, 2079L, 18L, 3549L, 146822L, 
  146817L, 9960L, 45L, 146800L, 167119L, 22L, 16L, 2074L, 14L, 
  14969L, 167140L, 32L, 9985L, 28L, 146212L, 9964L, 12L, 146824L, 
  9981L, 146195L, 168330L, 14970L, 168910L, 168909L, 168331L, 146825L, 
  3573L, 168332L, 167124L)[1:20]

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
saveRDS(bmr, "results/bmr_multi.rds")

job_table = getJobTable()
memory = read_memory(job_table$batch.id)
job_table[, memory := memory]
job_table = unnest(job_table, c("prob.pars", "algo.pars"))
tab_memory = job_table[, list(task_id, learner_id, memory)]
fwrite(tab_memory, "results/memory_multi.csv")
