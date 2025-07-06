library(benchmarkme)

single_core_res <- benchmark_std(runs = 8, 
    verbose = FALSE)

sc_test_level <- single_core_res |> 
    split(~test_group) |> 
    lapply(function(x) {
        no_of_reps <- length(x$test)/length(unique(x$test))
        split(x, ~test) |> 
            sapply(function(xx) {
                c(
               mean =  mean(xx$elapsed),
                sd = sd(xx$elapsed),
                var = var(xx$elapsed),
                se = sd(xx$elapsed)/sqrt(nrow(xx))
                )
            })

        # sum(x[, 3])/no_of_reps
    })

sc_group_level <- sc_test_level |> 
    sapply(function(x) {
        x["sd", ] <- x["sd", ]^2
        x["se", ] <- x["se", ]^2
        x <- rowSums(x)
        x["sd"] <- sqrt(x["sd"])
        x["se"] <- sqrt(x["se"])
        x
    })



multicore_res <- benchmark_std(runs = 8, 
    verbose = FALSE,
    cores = 4)

mc_test_level <- multicore_res |> 
    split(~test_group) |> 
    lapply(function(x) {
        no_of_reps <- length(x$test)/length(unique(x$test))
        split(x, ~test) |> 
            sapply(function(xx) {
                c(
               mean =  mean(xx$elapsed),
                sd = sd(xx$elapsed),
                var = var(xx$elapsed),
                se = sd(xx$elapsed)/sqrt(nrow(xx))
                )
            })

        # sum(x[, 3])/no_of_reps
    })

mc_group_level <- mc_test_level |> 
    sapply(function(x) {
        x["sd", ] <- x["sd", ]^2
        x["se", ] <- x["se", ]^2
        x <- rowSums(x)
        x["sd"] <- sqrt(x["sd"])
        x["se"] <- sqrt(x["se"])
        x
    })

sc_group_level
mc_group_level