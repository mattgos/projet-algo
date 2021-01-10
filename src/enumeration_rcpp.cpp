#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
int which_equal(IntegerVector v, int nombre) {
  for(int i = 0; i < v.length(); i++) {
    if(v[i] == nombre) {
      return(i);
    }
  }
  return(-1);
}

// [[Rcpp::export]]
int objectif_rcpp(IntegerMatrix X, List G, IntegerMatrix R){
  int s = 0;
  for(int i = 0; i < X.nrow(); i++){
    IntegerVector v = G[i];
    int coef = v.size();
    IntegerVector L = R(i,_);
    for(int j = 0; j < X.ncol(); j++){
      int poids = (which_equal(L,j+1) + 1);
      s += coef*X(i,j)*poids;
    }
  }
  return(s);
}

// [[Rcpp::export]]
IntegerVector taille_groupe_rcpp(List G){
  IntegerVector res;
  for(int i = 0; i < G.size(); i++){
    IntegerVector v = G[i];
    res.push_back(v.size());
  }
  return(res);
}

// [[Rcpp::export]]
IntegerVector binarise_rcpp(int i,int n,int m){
  IntegerVector res(n*m,0);
  int cpt = 0;
  while(i != 0){
    int r = i%2;
    res[cpt] = r;
    i = (i-r)/2;
    cpt += 1;
  }
  return(res);
}

// [[Rcpp::export]]
int produit_scalaire_rcpp(IntegerVector U, IntegerVector V) {
  int s = 0;
  for(int i = 0; i < U.size(); i++){
    s += U[i]*V[i];
  }
  return(s);
}

// [[Rcpp::export]]
IntegerVector produit_vecteur_matrice(IntegerVector V, IntegerMatrix M) {
  IntegerVector res(V.size());
  for(int i = 0; i < V.size(); i++){
    IntegerVector m = M(_,i);
    int p = produit_scalaire_rcpp(V,m);
    res[i] = p;
  }
  return(res);
}

// [[Rcpp::export]]
IntegerMatrix enumeration_rcpp(List G, IntegerVector P,IntegerMatrix R){
  int n = G.size();
  int m = P.size();
  IntegerVector t = taille_groupe_rcpp(G);
  IntegerVector condition_projet(n,1);
  IntegerMatrix sol(n,m);
  IntegerMatrix X(n,m);
  int f = m*sum(t);
  int fin =  pow(2,n*m);
  for(int i = 0; i < fin; i++){
    if (i == 0){
      X = IntegerMatrix(n,m);
    }
    else{
      IntegerVector b = binarise_rcpp(i,n,m);
      X = IntegerMatrix(n,m, b.begin() );
    }
    IntegerVector S = rowSums(X);
    if(sum(S) == G.size() && setequal(S,condition_projet) && setequal(produit_vecteur_matrice(t,X),P)){
      int new_f = objectif_rcpp(X,G,R);
      if(new_f < f){
        sol = X;
        f = new_f;
      }
    }
  }
  IntegerVector taille_groupe(G.size());
  for(int j = 0; j < G.size(); j++){
    IntegerVector v = G[j];
    taille_groupe[j] = v.size();
  }
  int nb_eleve = sum(taille_groupe);
  IntegerMatrix Sol(nb_eleve,3);
  CharacterVector nom_colonnes = CharacterVector::create("Eleve","Groupe","Projet");
  colnames(Sol) = nom_colonnes;
  for(int groupe = 0; groupe < G.size(); groupe ++){
    IntegerVector individu = G[groupe];
    for(int projet = 0; projet < P.size(); projet ++){
      for(int k = 0; k < individu.size(); k++){
        Sol(individu[k] - 1, 0) = individu[k];
        Sol(individu[k] - 1, 1) = groupe + 1;
        Sol(individu[k] - 1, 2) = projet + 1;
      }
    }
  }
  return(Sol);
}
