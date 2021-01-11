Init_b_and_b = function(G,P,R) {
  SP = c()
  cout_ideal = length(G) - 1
  for(j in 1:length(P)){
    voeu = which(R[1,] == j)
    new_cout = voeu + cout_ideal
    SP = c(SP,list(c(j,new_cout)))
  }
  return(SP)
}

cout_min = function(SP) {
  cout = c()
  for(i in 1:length(SP)) {
    cout = c(cout, tail(SP[[i]],1))
  }
  return(SP[[which.min(cout)]])
}

branch = function(chemin, G, P, R) {
  SP = c()
  nb_groupe_designe = (length(chemin)-1)
  cout_ideal = tail(chemin,1) - 1
  liste_projet_dispo = (1:length(P))[-chemin[1:nb_groupe_designe]]
  for(j in liste_projet_dispo) {
    new_chemin = chemin[1:nb_groupe_designe]
    voeu = which(R[nb_groupe_designe+1,] == j)
    new_cout = voeu + cout_ideal
    new_chemin = append(new_chemin,c(j,new_cout))
    SP = c(SP,list(new_chemin))
  }
  return(SP)
}

test_chemin_trouve = function(SP, G) {
  for(i in 1:length(SP)) {
    taille = length(SP[[i]])
    if(taille == length(G)+1) {
      return(i)
    }
  }
  return(0)
}

elagage = function(cout_opti,SP) {
  new_SP = c()
  for(i in 1:length(SP)) {
    if(tail(SP[[i]],1) < cout_opti) {
      new_SP = c(new_SP,list(SP[[i]]))
    }
  }
  return(new_SP)
}

delete_chemin = function(chemin,SP) {
  new_SP = c()
  for(i in 1:length(SP)) {
    if(!setequal(SP[[i]],chemin)) {
      new_SP = c(new_SP,list(SP[[i]]))
    }
  }
  return(new_SP)
}

branch_and_bound = function(G,P,R) {
  SP = Init_b_and_b(G,P,R)
  U = length(P)*length(G)
  while(length(SP) != 0) {
    chemin_pot = cout_min(SP)
    SP = delete_chemin(chemin_pot, SP)
    branche = branch(chemin_pot, G, P, R)
    SP = c(branche, SP)
    t = test_chemin_trouve(SP,G)
    if(t != 0) {
      U = tail(SP[[t]],1)
      chemin_opti = head(SP[[t]],length(SP[[t]])-1)
      SP = elagage(U,SP)
    }
  }
  return(list(chemin = chemin_opti, cout = U))
}