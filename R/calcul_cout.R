calcul_cout = function(Matrice_affiliation, R) {
  cout = 0
  for(i in 1:nrow(Matrice_affiliation)){
    groupe = Matrice_affiliation[i,2]
    cout = cout + which(R[groupe,] == Matrice_affiliation[i,3])
  }
  return(cout)
}