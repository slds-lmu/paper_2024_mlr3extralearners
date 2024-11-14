cluster.functions = batchtools::makeClusterFunctionsSlurm("slurm.tmpl", array.jobs = FALSE)
default.resources = list(walltime = 3600L, memory = 4000L, ntasks = 1L, ncpus = 1L, nodes = 1L, chunks.as.arrayjobs = FALSE)
max.concurrent.jobs = 5000L
