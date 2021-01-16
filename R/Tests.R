<<<<<<< HEAD
################################################
############# A simple test ####################
################################################

n <- 15 #nombre d'élèves
m <- 4 #nombre de projets
s <- simu(n,m) #generate data


# algorithms

# lotterie(s)
# algo_glouton(s)
# enumeration(s)
# branch_and_bound(s)
# lotterie_rcpp(s)
# glouton_rcpp(s)
# enumeration_rcpp(s)
# branch_and_bound_rcpp(s)


################################################################################################
# We define the function one.simu which returns the execution time of a given algorithm
one.simu <- function(n=10,m=2, type = "sample", custom = None, func = "lotterie")
{
  if(type == "sample"){v <- simu(n,m)}else{v = custom}
  if(func == "lotterie"){tm <- system.time(lotterie(v))[[1]]}
  if(func == "algo_glouton"){tm <- system.time(algo_glouton(v))[[1]]}
  if(func == "enumeration"){tm <- system.time(enumeration(v))[[1]]}
  if(func == "branch_and_bound"){tm <- system.time(branch_and_bound(v))[[1]]}
  if(func == "lotterie_rcpp"){tm <- system.time(lotterie_rcpp(v))[[1]]}
  if(func == "glouton_rcpp"){tm <- system.time(glouton_rcpp(v))[[1]]}
  if(func == "enumeration_rcpp"){tm <- system.time(enumeration_rcpp(v))[[1]]}
  if(func == "branch_and_bound_rcpp"){tm <- system.time(branch_and_bound_rcpp(v))[[1]]}

  return(tm)
}
################################################################################################

###########################################################
############# One time complexity test ####################
###########################################################
#we evaluate the time with a given n for algorithms
print_onesimu <- function()
{one.simu(n,m,func = "lotterie")
one.simu(n,m,func = "algo_glouton")
one.simu(n,m,func = "enumeration")
one.simu(n,m,func = "branch_and_bound")
one.simu(n,m,func = "lotterie_rcpp")
one.simu(n,m,func = "glouton_rcpp")
one.simu(n,m,func = "enumeration_rcpp")
one.simu(n,m,func = "branch_and_bound_rcpp")}

# #########################################################################
# ############# A short simulation study at fixed vector size #############
# #########################################################################
# # 
# # #we compare the running time at a given length n with repeated executions (nbSimus times)
# # nbSimus <- 10
# # time1 <- 0
# # time2 <- 0
# # time3 <- 0
# # time4 <- 0
# # for(i in 1:nbSimus){time1 <- time1 + one.simu(n,m, func = "lotterie")}
# # for(i in 1:nbSimus){time2 <- time2 + one.simu(n,m, func = "algo_glouton")}
# # for(i in 1:nbSimus){time3 <- time3 + one.simu(n,m, func = "enumeration")}
# # for(i in 1:nbSimus){time4 <- time4 + one.simu(n,m, func = "heap_sort_Rcpp")}
# # 
# # #gain R -> Rcpp
# # time1/time3
# # time2/time4
# # 
# # #gain insertion -> heap
# # time1/time2
# # time3/time4
# # 
# # #max gain
# # time1/time4
# # 
# # 
# # ####### MY RESULT #######
# # #> #gain R -> Rcpp
# # #  > time1/time3
# # #[1] 154.6497
# # #> time2/time4
# # #[1] 184.1053
# # #>
# # #  > #gain insertion -> heap
# # #  > time1/time2
# # #[1] 8.709548
# # #> time3/time4
# # #[1] 10.36842
# # #>
# # #  > #max gain
# # #  > time1/time4
# # #[1] 1603.474
# # 
# # 
# # #HERE : R to Rcpp => at least 150 times faster
# # #HERE : insertion to heap => 10 times faster
# # 
# # 
# # ##########################################
# # ############# microbenchmark #############
# # ##########################################
# # 
# # 
# # library(microbenchmark)
# # library("ggplot2")
# # n <- 10000
# # res <- microbenchmark(one.simu(n, func = "insertion_sort_Rcpp"), one.simu(n, func = "heap_sort_Rcpp"), times = 50)
# # autoplot(res)
# # res
# # 
# # 
# # ##########################################
# # ############# time complexity ############
# # ##########################################
# # 
# # 
# # nbSimus <- 10
# # vector_n <- seq(from = 10000, to = 100000, length.out = nbSimus)
# # nbRep <- 10
# # res_Heap <- data.frame(matrix(0, nbSimus, nbRep + 1))
# # colnames(res_Heap) <- c("n", paste0("Rep",1:nbRep))
# # 
# # j <- 1
# # for(i in vector_n)
# # {
# #   res_Heap[j,] <- c(i, replicate(nbRep, one.simu(i, func = "heap_sort_Rcpp")))
# #   print(j)
# #   j <- j + 1
# # }
# # 
# # res <- rowMeans(res_Heap[,-1])
# # plot(vector_n, res, xlab = "data length", ylab = "time in second")
# # 
# # 
# # ####
# # 
# # nbSimus <- 40
# # vector_n <- seq(from = 5000, to = 50000, length.out = nbSimus)
# # nbRep <- 10
# # res_Insertion <- data.frame(matrix(0, nbSimus, nbRep + 1))
# # colnames(res_Insertion) <- c("n", paste0("Rep",1:nbRep))
# # 
# # j <- 1
# # for(i in vector_n)
# # {
# #   res_Insertion[j,] <- c(i, replicate(nbRep, one.simu(i, func = "insertion_sort_Rcpp")))
# #   print(j)
# #   j <- j + 1
# # }
# # 
# # res <- rowMeans(res_Insertion[,-1])
# # plot(vector_n, res, xlab = "data length", ylab = "time in second")
# # lm(log(res) ~ log(vector_n))
=======
################################################
############# A simple test ####################
################################################

n <- 15 #nombre d'élèves
m <- 4 #nombre de projets
s <- simu(n,m) #generate data


# algorithms

lotterie(s)
algo_glouton(s)
enumeration(s)
branch_and_bound(s)
lotterie_rcpp(s)
glouton_rcpp(s)
enumeration_rcpp(s)
branch_and_bound_rcpp(s)


################################################################################################
# We define the function one.simu which returns the execution time of a given algorithm
one.simu <- function(n=10,m=2, type = "sample", custom = None, func = "lotterie")
{
  if(type == "sample"){v <- simu(n,m)}else{v = custom}
  if(func == "lotterie"){tm <- system.time(lotterie(v))[[1]]}
  if(func == "algo_glouton"){tm <- system.time(algo_glouton(v))[[1]]}
  if(func == "enumeration"){tm <- system.time(enumeration(v))[[1]]}
  if(func == "branch_and_bound"){tm <- system.time(branch_and_bound(v))[[1]]}
  if(func == "lotterie_rcpp"){tm <- system.time(lotterie_rcpp(v))[[1]]}
  if(func == "glouton_rcpp"){tm <- system.time(glouton_rcpp(v))[[1]]}
  if(func == "enumeration_rcpp"){tm <- system.time(enumeration_rcpp(v))[[1]]}
  if(func == "branch_and_bound_rcpp"){tm <- system.time(branch_and_bound_rcpp(v))[[1]]}
  
  return(tm)
}
################################################################################################

###########################################################
############# One time complexity test ####################
###########################################################
#we evaluate the time with a given n for algorithms

one.simu(n,m,func = "lotterie")
one.simu(n,m,func = "algo_glouton")
one.simu(n,m,func = "enumeration")
one.simu(n,m,func = "branch_and_bound")
one.simu(n,m,func = "lotterie_rcpp")
one.simu(n,m,func = "glouton_rcpp")
one.simu(n,m,func = "enumeration_rcpp")
one.simu(n,m,func = "branch_and_bound_rcpp")

#########################################################################
############# A short simulation study at fixed vector size #############
#########################################################################
# 
# #we compare the running time at a given length n with repeated executions (nbSimus times)
# nbSimus <- 10
# time1 <- 0
# time2 <- 0
# time3 <- 0
# time4 <- 0
# for(i in 1:nbSimus){time1 <- time1 + one.simu(n,m, func = "lotterie")}
# for(i in 1:nbSimus){time2 <- time2 + one.simu(n,m, func = "algo_glouton")}
# for(i in 1:nbSimus){time3 <- time3 + one.simu(n,m, func = "enumeration")}
# for(i in 1:nbSimus){time4 <- time4 + one.simu(n,m, func = "heap_sort_Rcpp")}
# 
# #gain R -> Rcpp
# time1/time3
# time2/time4
# 
# #gain insertion -> heap
# time1/time2
# time3/time4
# 
# #max gain
# time1/time4
# 
# 
# ####### MY RESULT #######
# #> #gain R -> Rcpp
# #  > time1/time3
# #[1] 154.6497
# #> time2/time4
# #[1] 184.1053
# #>
# #  > #gain insertion -> heap
# #  > time1/time2
# #[1] 8.709548
# #> time3/time4
# #[1] 10.36842
# #>
# #  > #max gain
# #  > time1/time4
# #[1] 1603.474
# 
# 
# #HERE : R to Rcpp => at least 150 times faster
# #HERE : insertion to heap => 10 times faster
# 
# 
# ##########################################
# ############# microbenchmark #############
# ##########################################
# 
# 
# library(microbenchmark)
# library("ggplot2")
# n <- 10000
# res <- microbenchmark(one.simu(n, func = "insertion_sort_Rcpp"), one.simu(n, func = "heap_sort_Rcpp"), times = 50)
# autoplot(res)
# res
# 
# 
# ##########################################
# ############# time complexity ############
# ##########################################
# 
# 
# nbSimus <- 10
# vector_n <- seq(from = 10000, to = 100000, length.out = nbSimus)
# nbRep <- 10
# res_Heap <- data.frame(matrix(0, nbSimus, nbRep + 1))
# colnames(res_Heap) <- c("n", paste0("Rep",1:nbRep))
# 
# j <- 1
# for(i in vector_n)
# {
#   res_Heap[j,] <- c(i, replicate(nbRep, one.simu(i, func = "heap_sort_Rcpp")))
#   print(j)
#   j <- j + 1
# }
# 
# res <- rowMeans(res_Heap[,-1])
# plot(vector_n, res, xlab = "data length", ylab = "time in second")
# 
# 
# ####
# 
# nbSimus <- 40
# vector_n <- seq(from = 5000, to = 50000, length.out = nbSimus)
# nbRep <- 10
# res_Insertion <- data.frame(matrix(0, nbSimus, nbRep + 1))
# colnames(res_Insertion) <- c("n", paste0("Rep",1:nbRep))
# 
# j <- 1
# for(i in vector_n)
# {
#   res_Insertion[j,] <- c(i, replicate(nbRep, one.simu(i, func = "insertion_sort_Rcpp")))
#   print(j)
#   j <- j + 1
# }
# 
# res <- rowMeans(res_Insertion[,-1])
# plot(vector_n, res, xlab = "data length", ylab = "time in second")
# lm(log(res) ~ log(vector_n))
>>>>>>> testbranch
