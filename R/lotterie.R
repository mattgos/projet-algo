#P=c("projet 1","projet 2","projet 3")
#p=list(c(2,2),c(3),c(3,2))
#G=list(c(1,5,3),c(2,6),c(4),c(7,10),c(8),c(9))
#R=list(c(1,3),c(2,3,1),c(3),c(1,2,3),c(2,1),c(1,3))

lotterie<-function(P,p,G,R){
  ind_group=1:length(G)
  nb_proj=length(P)
  nb_gr=length(G)
  h=1
  X=list()
  for (i in 1:nb_proj){
    c=length(p[[i]])
    Y=list()
    for (i in 1:c){
      Y=append(Y,list(0))
    }
    X=append(X,list(Y))
  }
  Y=NULL
  while (length(ind_group)!=0){
    #liste C
    C=list(rep(0,nb_proj))
    for (i in 1:nb_proj){
      c=c()
      for (j in ind_group){
        if (length(R[[j]])>=h){
          if (R[[j]][h]==i) c=c(c,j)
        }
      }

      C[[i]]=c
    }
    
    print(C)

    #boucle attribution
    for (i in 1:nb_proj){
      if (length(C[[i]])!=0){
        c_pi=C[[i]]
        if (length(c_pi)>1){c_pi=sample(c_pi)}
        for (j in c_pi){
          for (k in 1:length(p[[i]])){
            al=0
            if (sum(X[[i]][[k]])!=0){
              for (l in X[[i]][[k]]){
                al=al+length(G[[l]])
              }
            }
            if(al+length(G[[j]])<=p[[i]][k]){
              if(sum(X[[i]][[k]])==0){
                X[[i]][[k]]=j
              }
              else{
                X[[i]][[k]]=append(X[[i]][[k]],j)
              }
              ind_group=ind_group[ind_group!=j]
              break
            }
            
            
          }
          
          if (is.element(j,ind_group) & h==length(R[[j]])) ind_group=ind_group[ind_group!=j]
        }
      }
    }
    h=h+1
  }
  
  return(X)
}

