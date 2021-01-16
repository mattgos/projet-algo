Init_b_and_b = function(G,P,R) {
  SP = c()
  cout_ideal = 0
  for(i in 2:length(G)){
    cout_ideal = cout_ideal + length(G[[i]])
  }
  for(j in 1:length(P)){
    voeu = which(R[1,] == j)
    new_cout = length(G[[1]]) * voeu + cout_ideal
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


projet_dispo = function(chemin, G, P) {
  liste_projet_dispo = c()
  new_P = P
  liste_projet = 1:length(P)
  nb_groupe_designe = (length(chemin)-1)
  taille_g = length(G[[nb_groupe_designe + 1]])
  for(i in 1:nb_groupe_designe) {
    new_P[chemin[i]] = new_P[chemin[i]] - length(G[[i]])
  }
  for(j in 1:length(new_P)) {
    if(new_P[j] - taille_g >= 0) {
      liste_projet_dispo = c(liste_projet_dispo, j)
    }
  }
  return(liste_projet_dispo)  
}

branch = function(chemin, G, P, R) {
  SP = c()
  nb_groupe_designe = (length(chemin)-1)
  cout_ideal = tail(chemin,1) - length(G[[nb_groupe_designe + 1]])
  liste_projet_dispo = projet_dispo(chemin,G,P)
  for(j in liste_projet_dispo) {
    new_chemin = chemin[1:nb_groupe_designe]
    voeu = which(R[nb_groupe_designe+1,] == j)
    new_cout = length(G[[nb_groupe_designe + 1]])*voeu + cout_ideal
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


#' Affectation par branch and bound
#'
#' @description Affectation des élèves à un projet par ordre des voeux et d'inscription
#' @param G une liste des groupes d'élèves
#' @param P une liste de projets
#' @param R une matrice de voeux de chaque groupe de G
#' @return la matrice d'attribution des projets par élève et par groupe
branch_and_bound = function(G,P,R) {
  SP = Init_b_and_b(G,P,R)
  taille_g = c()
  for (i in 1:length(G)){
    taille_g=c(taille_g,length(G[[i]]))
  }
  nb_eleve=sum(taille_g)
  U = length(P)*nb_eleve+1
  while(length(SP) != 0) {
    chemin_pot = cout_min(SP)
    SP = delete_chemin(chemin_pot, SP)
    branche = branch(chemin_pot, G, P, R)
    SP = c(branche, SP)
    SP = elagage(U,SP) 
    t = test_chemin_trouve(SP,G)
    if(t != 0) {
      U = tail(SP[[t]],1)
      chemin_opti = head(SP[[t]],length(SP[[t]])-1)
      SP = elagage(U,SP)
    }
  }
  res = list(chemin = chemin_opti, cout = U)
  Sol = matrix(0,ncol=3,nrow = nb_eleve)
  colnames(Sol)<-c("Eleve","Groupe","Projet")
  for(i in 1:length(res$chemin)) {
    for(k in G[[i]]){
      eleve = k
      Sol[k, 1] = k;
      Sol[k, 2] = i;
      Sol[k, 3] = chemin_opti[i];
    }
  }
  return(Sol)
}