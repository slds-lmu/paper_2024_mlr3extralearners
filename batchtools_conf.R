cluster.functions = batchtools::makeClusterFunctionsSlurm("slurm.tmpl", array.jobs = TRUE)
default.resources = list(walltime = 7800L, memory = 4000L, ntasks = 1L, ncpus = 1L, nodes = 1L, chunks.as.arrayjobs = TRUE)
max.concurrent.jobs = 1500L
