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

dput(tab[NumberOfClasses == 2]$task_id)
# c(10101L, 9971L, 125920L, 10093L, 37L, 15L, 49L, 146818L, 29L, 
#   146819L, 3913L, 9946L, 31L, 14954L, 3918L, 146820L, 9952L, 9957L, 
#   3917L, 3902L, 3903L, 167141L, 168912L, 3021L, 3L, 9978L, 3904L, 
#   43L, 34539L, 14952L, 219L, 168911L, 7592L, 14965L, 9976L, 167120L, 
#   146606L, 9977L, 167125L, 9910L, 168908L, 3945L, 168868L, 168337L, 
#   168338L)

dput(tab[NumberOfClasses > 2]$task_id)
# c(11L, 3560L, 23L, 146821L, 53L, 2079L, 18L, 3549L, 146822L, 
#   146817L, 9960L, 45L, 146800L, 167119L, 22L, 16L, 2074L, 14L, 
#   14969L, 167140L, 32L, 9985L, 28L, 146212L, 9964L, 12L, 146824L, 
#   9981L, 146195L, 168330L, 14970L, 168910L, 168909L, 168331L, 146825L, 
#   3573L, 168332L, 167124L)

collection_269 = ocl(269)

tab_269 = list_oml_tasks(
  task_id = collection_269 $task_ids,
  number_instances = c(1, 100000)
)

tab_269[, Size := NumberOfFeatures * NumberOfInstances]
tab_269 = tab_269[order(Size)]
knitr::kable(tab_269)

dput(tab_269$task_id)
# c(359931L, 359932L, 359950L, 359930L, 167210L, 359933L, 359934L, 
#   359944L, 359935L, 359951L, 359938L, 360945L, 359945L, 359936L, 
#   359942L, 359952L, 359949L, 359948L, 233211L, 359946L, 233215L, 
#   359940L, 359939L, 359941L, 360932L, 360933L, 233214L)