# G décroissant

taille_groupe<-function(G){
  res<-c()
  for (i in 1:length(G)){
    res=c(res,length(G[[i]]))
  }
  return(res)
}

#' Affectation par méthode gloutonne
#'
#' @description Affectation des élèves à un projet par ordre des voeux et d'inscription
#' @param G une liste des groupes d'élèves
#' @param P une liste de projets
#' @param R une matrice de voeux de chaque groupe de G
#' @return la matrice d'attribution des projets par élève et par groupe
glouton_algorithm = function(G,P,R){
  X = matrix(0,length(G),length(P))
  c = sum(colSums(X))
  t=taille_groupe(G)
  while (c != length(G)) { #chaque groupe doit avoir un projet
    for(i in 1:length(G)){
      for(voeu in 1:length(P)){
        projet = R[i,voeu]
        if((t%*%X[,projet] + t[i] <= P[projet]) && !is.element(1,X[i,])){ 
          X[i,projet] = 1
          break
        }
      }
    }
    c = sum(colSums(X))
  }
  
  nb_eleve=sum(t)
  res=matrix(0,ncol=3,nrow = nb_eleve)
  res[,1]=1:nb_eleve
  gr<-rep(0,nb_eleve)
  for (i in 1:length(G)){
    for (j in 1:length(G[[i]])){
      gr[G[[i]][[j]]]<-i
    }
  }
  res[,2]<-gr
  for (i in 1:nb_eleve){
    res[i,3]<-which(X[res[i,2],]==1)
  }
  colnames(res)<-c("Eleve","Groupe","Projet")
  return(res)
}