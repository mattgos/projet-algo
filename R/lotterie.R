# P=c("projet 1","projet 2","projet 3")
# p=list(c(2,2),c(3),c(3,2))
# G=list(c(1,5,3),c(2,6),c(4),c(7,10),c(8),c(9))
# R=list(c(1,3),c(2,3,1),c(3),c(1,2,3),c(2,1),c(1,3))
# 
# P=c("projet 1","projet 2")
# p=list(c(3),c(3))
# G=list(c(4,2),c(3),c(5),c(1),c(6))
# R=list(c(2,1),c(1,2),c(1,2),c(2,1),c(2,1))


#' Affectation par lotterie
#'
#' @description Affectation des élèves à un projet par ordre des voeux et d''inscription'un système de lotterie
#' @param P une liste de projets
#' @param p contient les capacités maximum des projets
#' @param G une liste des groupes d'élèves
#' @param R une mactrice de voeux de chaque groupe de G
#' @return la matrice d'attribution des projets par élève et par groupe
lotterie<-function(P,p,G,R){
  
  # p=list()
  # for (i in P){
  #   p=append(p,c(i))
  # }
  # 
  # R_new=R
  # R=list()
  # for (i in 1:length(R_new[,1])){
  #   R=append(R,list(R_new[i,]))
  # }
  # 
  # P_new=P
  # P=c()
  # for (i in 1:length(P_new)){
  #   P=c(P,paste("projet",i))
  # }
  # 
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
    C=list(rep(list(),nb_proj))
    for (i in 1:nb_proj){
      c=c()
      for (j in ind_group){
        if (length(R[[j]])>=h){
          if (R[[j]][h]==i) c=c(c,j)
        }
      }
      C[[i]]=c
    }
    
    #boucle attribution
    for (i in 1:nb_proj){
      if (i<=length(C)){
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
    }
    h=h+1
  }
  
  nb_eleve=0
  for (i in G){
    nb_eleve=nb_eleve+length(i)
  }
  
  res<-matrix(rep(0,4*nb_eleve),ncol=4)
  res[,1]<-1:(nb_eleve)
  for (i in 1:nb_eleve){
    for (j in 1:nb_gr){
      if (i%in%G[[j]]){
        res[i,2]<-j
        break
      }
    }
  }
  
  for (i in 1:nb_proj){
    for (j in 1:length(p[[i]])){
      g<-G[X[[i]][[j]]]
      for (k in g){
        res[k,3]<-i
        res[k,4]<-j
      }
    }
  }
  
  colnames(res)<-c("Eleve","Groupe","Projet","Equipe-projet")
  return(res)
}
