library(mlr3extralearners)
library(mlr3learners)
library(mlr3oml)
library(data.table)
library(mlr3misc)
library(mlr3batchmark)
library(mlr3benchmark)

# unlink("/gscratch/mbecke16/benchmark-mlr3extralearners/registry_binary", recursive = TRUE)

# reg = makeExperimentRegistry(
#   file.dir = "/gscratch/mbecke16/benchmark-mlr3extralearners/registry_binary",
#   seed = 1,
#   conf.file = "batchtools_conf.R",
#   packages = c("renv", "mlr3extralearners", "mlr3learners")
# )

reg = loadRegistry(
  file.dir = "/gscratch/mbecke16/benchmark-mlr3extralearners/registry_binary",
  conf.file = "batchtools_conf.R",
  writeable = TRUE)

# learner
tab = list_mlr3learners()
tab = tab[class == "classif"]
tab[, twoclass := map(properties, function(x) "twoclass" %in% x)]

learners = lrns(tab$id)

walk(learners, function(learner) {
  if ("prob" %in% learner$predict_types) {
    learner$predict_type = "prob"
  }
  learner$encapsulate(method = "callr", fallback = lrn("classif.featureless", predict_type = learner$predict_type))
})

# tasks and resamplings
task_ids = c(10101L, 9971L, 125920L, 10093L, 37L, 15L, 49L, 146818L, 29L, 
  146819L, 3913L, 9946L, 31L, 14954L, 3918L, 146820L, 9952L, 9957L, 
  3917L, 3902L, 3903L, 167141L, 168912L, 3021L, 3L, 9978L, 3904L, 
  43L, 34539L, 14952L, 219L, 168911L, 7592L, 14965L, 9976L, 167120L, 
  146606L, 9977L, 167125L, 9910L, 168908L, 3945L, 168868L, 168337L, 
  168338L)

otasks = map(task_ids, otsk)
tasks = as_tasks(otasks)
resamplings = as_resamplings(otasks)

design = benchmark_grid(
  tasks = tasks[1:20],
  learners = learners,
  resamplings = resamplings[1:20],
  paired = TRUE
)

batchmark(design, reg = reg, renv_project = ".")
submitJobs()
waitForJobs()

bmr = reduceResultsBatchmark()
saveRDS("bmr.rds", bmr)