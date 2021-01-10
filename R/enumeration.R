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

enumeration = function(G,P,R){
  n = length(G)
  m = length(P)
  t = taille_groupe(G)
  condition_projet = rep(1,n)
  f = m*sum(t)
  for(i in 0:(2^(n*m)-1)){
    if (i == 0){
      X = matrix(0,n,m)
    }
    else{
      X = matrix((binarise(i,n,m)),n,m)
    }
    if(sum(rowSums(X)) == length(G) && setequal(rowSums(X),condition_projet) && setequal(t%*%X,P)){
      new_f = objectif(X,G,R)
      if(new_f < f){
        sol = X
        f = new_f
      }
    }
  }
  return(sol)
}
