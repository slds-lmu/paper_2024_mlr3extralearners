read_memory = function(batch_ids) {
  map_dbl(batch_ids, function(batch_id) {
    cmd = sprintf("seff %s", batch_id)
    cmd_output = system(cmd, intern = TRUE)
    output = gsub("Memory\\sUtilized:\\s", "", grep("Memory\\sUtilized:", cmd_output, value = TRUE))

    if (grepl("KB", output)) {
      as.numeric(gsub("KB", "", output)) / 1024
    } else if (grepl("MB", output)) {
      as.numeric(gsub("MB", "", output))
    } else if (grepl("GB", output)) {
      as.numeric(gsub("GB", "", output)) * 1024
    } else {
      print(output)
      NA_real_
    }
  })
}
