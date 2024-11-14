# add problems 
# tasks and resamplings

collection_218 = ocl(218)
collection_99 = ocl(99)

tab_218 = list_oml_tasks(
  task_id = collection_218$task_ids,
  number_classes = c(2, 10),
  number_instances = c(1, 100000)
)

tab_99 = list_oml_tasks(
  task_id = collection_99$task_ids,
  number_classes = c(2, 10),
  number_instances = c(1, 100000)
)

tab_99 = tab_99[!tab_218$name, , on = "name"]
tab = rbindlist(list(tab_218, tab_99))
tab = tab[, c("task_id", "name", "NumberOfClasses", "NumberOfFeatures", "NumberOfInstances", "NumberOfInstancesWithMissingValues", "NumberOfNumericFeatures", "NumberOfSymbolicFeatures"), with = FALSE]
tab[, Size := NumberOfClasses * NumberOfFeatures * NumberOfInstances]
tab = tab[order(Size)]
knitr::kable(tab)

task_binary_ids = tab[NumberOfClasses == 2]$task_id

task_ids = c(10101L, 9971L, 125920L, 10093L, 37L, 15L, 49L, 146818L, 29L, 
  146819L, 3913L, 9946L, 31L, 14954L, 3918L, 146820L, 9952L, 9957L, 
  3917L, 3902L, 3903L, 167141L, 168912L, 3021L, 3L, 9978L, 3904L, 
  43L, 34539L, 14952L, 219L, 168911L, 7592L, 14965L, 9976L, 167120L, 
  146606L, 9977L, 167125L, 9910L, 168908L, 3945L, 168868L, 168337L, 
  168338L)

