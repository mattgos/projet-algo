#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
bool is_elem(int n, IntegerVector v) {
  for(int i = 0; i < v.size(); i++) {
    if(v[i] == n){
      return(true);
    }
  }
  return(false);
}

// [[Rcpp::export]]
int produit_scalaire(IntegerVector U, IntegerVector V) {
  int s = 0;
  for(int i = 0; i < U.size(); i++){
    s += U[i]*V[i];
  }
  return(s);
}

// [[Rcpp::export]]
IntegerMatrix glouton_rcpp(List G, IntegerVector P, IntegerMatrix R) {
  IntegerMatrix X(G.size(),P.size());
  IntegerVector taille_g(G.size());
  for(int j = 0; j < G.size(); j++){
    IntegerVector v = G[j];
    taille_g[j] = v.size();
  }
  int nb_eleve = sum(taille_g);
  IntegerMatrix Sol(nb_eleve,3);
  CharacterVector nom_colonnes = CharacterVector::create("Eleve","Groupe","Projet");
  colnames(Sol) = nom_colonnes;
  int voeu = 0;
  int c = sum(rowSums(X));
  while(c != G.size()){
    for(int i = 0; i < G.size(); i++){
      int projet = R(i,voeu);
      IntegerVector col = X(_,projet-1);
      IntegerVector row = X(i,_);
      if((produit_scalaire(taille_g,col) + taille_g[i] <= P[projet-1]) && (!is_elem(1,row))){
        X(i,projet-1) = 1;
      }
    }
    voeu += 1;
    c = sum(rowSums(X));
  }
  for(int groupe = 0; groupe < G.size(); groupe ++){
    IntegerVector individu = G[groupe];
    for(int projet = 0; projet < P.size(); projet ++){
      if(X(groupe,projet) == 1){
        for(int k = 0; k < individu.size(); k++){
          Sol(individu[k] - 1, 0) = individu[k];
          Sol(individu[k] - 1, 1) = groupe + 1;
          Sol(individu[k] - 1, 2) = projet + 1;
        }
      }
    }
  }
  return(Sol);
}