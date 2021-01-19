#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
int which_equal_bis(IntegerVector v, int nombre) {
  for(int i = 0; i < v.length(); i++) {
    if(v[i] == nombre) {
      return(i);
    }
  }
  return(-1);
}

// [[Rcpp::export]]
List Init_b_and_b_rcpp(List G, IntegerVector P,IntegerMatrix R) {
  List SP;
  int cout_ideal = 0;
  for(int i = 1; i < G.size(); i++){
    IntegerVector g = G[i];
    cout_ideal = cout_ideal + g.length();
  }
  IntegerVector new_P(P.size());
  for(int k = 0; k < P.size(); k ++) {
    new_P[k] = P[k];
  }
  IntegerVector g1 = G[0];
  for(int j = 0; j < P.size(); j++){
    if(new_P[j] - g1.length() >= 0){
      IntegerVector V = R(0,_);
      int voeu = which_equal_bis(V,j+1) + 1;
      int new_cout = voeu*g1.length() + cout_ideal;
      IntegerVector chemin;
      chemin.push_back(j+1);
      chemin.push_back(new_cout);
      SP.push_back(chemin);
    }
  }
  return(SP);
}

// [[Rcpp::export]]
IntegerVector cout_min_rcpp(List SP) {
  IntegerVector cout;
  for(int i = 0; i < SP.size(); i++) {
    IntegerVector chemin = SP[i];
    int cout_chemin = tail(chemin,1)[0];
    cout.push_back(cout_chemin);
  }
  int indice = which_min(cout);
  return(SP[indice]);
}

// [[Rcpp::export]]
int test_chemin_trouve_rcpp(List SP, List G) {
  for(int i = 0; i < SP.size(); i++) {
    IntegerVector chemin = SP[i];
    int taille = chemin.length();
    if(taille == G.size()+1) {
      return(i);
    }
  }
  return(-1);
}

// [[Rcpp::export]]
List elagage_rcpp(int cout_opti, List SP) {
  List new_SP;
  for(int i = 0; i < SP.size(); i++) {
    IntegerVector chemin = SP[i];
    int cout_chemin = tail(chemin,1)[0];
    if(cout_chemin < cout_opti) {
      new_SP.push_back(chemin);
    }
  }
  return(new_SP);
}

// [[Rcpp::export]]
List delete_chemin_rcpp(IntegerVector chemin,List SP) {
  List new_SP;
  for(int i = 0; i < SP.size(); i++) {
    IntegerVector chemin_pot = SP[i];
    if(!setequal(chemin_pot,chemin)) {
      new_SP.push_back(chemin_pot);
    }
  }
  return(new_SP);
}

// [[Rcpp::export]]
IntegerVector projet_dispo_rcpp(IntegerVector chemin,List G,IntegerVector P) {
  IntegerVector liste_projet_dispo;
  IntegerVector new_P(P.size());
  for(int k = 0; k < P.size(); k ++) {
    new_P[k] = P[k];
  }
  int nb_groupe_designe = (chemin.length()-1);
  IntegerVector groupe = G[nb_groupe_designe];
  int taille_g = groupe.length();
  for(int i = 0; i < nb_groupe_designe; i++) {
    int p = chemin[i];
    IntegerVector g = G[i];
    new_P[p-1] = new_P[p-1] - g.length();
  }
  for(int j = 0; j < new_P.size(); j++) {
    if(new_P[j] - taille_g >= 0) {
      liste_projet_dispo.push_back(j+1);
    }
  }
  return(liste_projet_dispo);
}

// [[Rcpp::export]]
List branch_rcpp(IntegerVector chemin,List G,IntegerVector P, IntegerMatrix R) {
  List SP;
  int nb_groupe_designe = chemin.length() - 1;
  IntegerVector g = G[nb_groupe_designe];
  int cout_ideal = tail(chemin,1)[0] - g.length();
  IntegerVector projet = seq_len(P.size());
  IntegerVector liste_projet_dispo = projet_dispo_rcpp(chemin, G, P);
  IntegerVector chemin_suivi = head(chemin,nb_groupe_designe);
  for(int j = 0; j < liste_projet_dispo.length(); j++) {
    IntegerVector new_chemin = head(chemin,nb_groupe_designe);
    IntegerVector V = R(nb_groupe_designe,_);
    int voeu = which_equal_bis(V,liste_projet_dispo[j]) + 1;
    int new_cout = g.length()*voeu + cout_ideal;
    new_chemin.push_back(liste_projet_dispo[j]);
    new_chemin.push_back(new_cout);
    SP.push_back(new_chemin);
  }
  return(SP);
}

//'Affectation par méthode branch and bound
//'
//' @description fonction de simulation d'une attribution avec la méthode du branch and bound
//' @param G contient les groupes d'élèves
//' @param P contient les projets et leurs capacités maximales
//' @param R matrice qui contient l'ordre de préférence de chaque groupe
//' @return une attribution d'élèves à des projets optimisée
//' @export
// [[Rcpp::export]]
IntegerMatrix branch_and_bound_rcpp(List G,IntegerVector P,IntegerMatrix R) {
  List SP = Init_b_and_b_rcpp(G,P,R);
  IntegerVector taille_g(G.size());
  for(int j = 0; j < G.size(); j++){
    IntegerVector v = G[j];
    taille_g[j] = v.size();
  }
  int nb_eleve = sum(taille_g);
  int U = P.size()*nb_eleve+1;
  IntegerVector chemin_pot;
  List branche;
  IntegerVector opti;
  IntegerVector chemin_opti;
  while(SP.length() != 0) {
    chemin_pot = cout_min_rcpp(SP);
    SP = delete_chemin_rcpp(chemin_pot, SP);
    branche = branch_rcpp(chemin_pot, G, P, R);
    for(int i = 0; i < branche.length(); i++){
      IntegerVector v = branche[i];
      SP.push_front(v);
    }
    SP = elagage_rcpp(U,SP);
    int t = test_chemin_trouve_rcpp(SP,G);
    if(t != -1) {
      opti = SP[t];
      U = tail(opti,1)[0];
      chemin_opti = head(opti,opti.size()-1);
      SP = elagage_rcpp(U,SP);
    }
  }
  List res;
  res.push_back(chemin_opti);
  res.push_back(U);
  IntegerMatrix Sol(nb_eleve,3);
  CharacterVector nom_colonnes = CharacterVector::create("Eleve","Groupe","Projet");
  colnames(Sol) = nom_colonnes;
  for(int i = 0; i < chemin_opti.length(); i++) {
    IntegerVector individu = G[i];
    for(int k = 0; k < individu.size(); k++){
      Sol(individu[k] - 1, 0) = individu[k];
      Sol(individu[k] - 1, 1) = i + 1;
      Sol(individu[k] - 1, 2) = chemin_opti[i];
    }
  }
  return(Sol);
}
