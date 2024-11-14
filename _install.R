# install base packages
renv::init(bare = TRUE)
renv::install(c(
  "mlr-org/mlr3extralearners@rweka", 
  "mlr-org/mlr3proba", 
  "mlr-org/mlr3batchmark@renv_project",
  "mlr3learners", 
  "mlr3oml",
  "qs",
  "remotes",
  "RWeka",
  "DiceKriging",
  "mda",
  "rsm"))

# install learner dependencies
library(mlr3extralearners)

tab = list_mlr3learners()
tab_classif = tab[class == "classif"]

install_learners(tab_classif$id)

remotes::install_url('https://github.com/catboost/catboost/releases/download/v1.2.7/catboost-R-linux-x86_64-1.2.7.tgz', INSTALL_opts = c("--no-multiarch", "--no-test-load"))
remotes::install_github("PlantedML/randomPlantedForest")