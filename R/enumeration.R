objectif = function(X,G,R){
  s = 0
  for(i in 1:nrow(X)){
    for(j in 1:ncol(X)){
      s = s + length(G[[i]])*X[i,j]*which(R[i,] == j)
    }
  }
  return(s)
}

taille_groupe = function(G){
  res = c()
  for(i in 1:length(G)){
    res = c(res,length(G[[i]]))
  }
  return(res)
}

binarise = function(i,n,m){
  res = rep(0,n*m)
  cpt = 1
  while(i != 0){
    r = i%%2
    res[cpt] = r
    i = (i-r)/2
    cpt = cpt + 1
  }
  return(res)
}


#' Affectation par énumération des possibilités
#'
#' @description Affectation des élèves à un projet par ordre des voeux et d'inscription
#' @param G une liste des groupes d'élèves
#' @param P une liste de projets
#' @param R une mactrice de voeux de chaque groupe de G
#' @return la matrice d'attribution des projets par élève et par groupe
enumeration = function(G,P,R){
  n = length(G)
  m = length(P)
  t = taille_groupe(G)
  condition_projet_1 = rep(1,n)
  condition_projet_2 = rep(0,m)
  f = m*sum(t)
  for(i in 0:(2^(n*m)-1)){
    if (i == 0){
      X = matrix(0,n,m)
    }
    else{
      X = matrix((binarise(i,n,m)),n,m)
    }
    C = t%*%X - P
    if(sum(rowSums(X)) == length(G) && setequal(rowSums(X),condition_projet_1) && setequal(C,condition_projet_2)){
      new_f = objectif(X,G,R)
      if(new_f < f){
        sol = X
        f = new_f
      }
    }
  }
  taille_g = c()
  for (i in 1:length(G)){
    taille_g=c(taille_g,length(G[[i]]))
  }
  nb_eleve=sum(taille_g)
  resultat = matrix(0,ncol=3,nrow = nb_eleve)
  colnames(resultat)<-c("Eleve","Groupe","Projet")
  for(i in 1:length(G)) {
    for(j in 1:length(P)) {
      if(sol[i,j] == 1) {
        for(k in G[[i]]){
          resultat[k, 1] = k
          resultat[k, 2] = i
          resultat[k, 3] = j
        }
      }
    }
  }
  return(resultat)
}
