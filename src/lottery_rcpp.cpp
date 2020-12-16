#include <Rcpp.h>
using namespace Rcpp;

//' Which algorithme using C++
//' 
//' @param v un vector
//' @param nombre un nombre
//' @return renvoie l'indice du vecteur où v[ind] = nombre (sinon renvoie -1)
//' @export 
// [[Rcpp::export]]
int which_is_equal(IntegerVector v, int nombre) {
  for(int i = 0; i < v.length(); i++) {
    if(v[i] == nombre) {
      return(i);
    }
  }
  return(-1);
}

//' is_element algorithme using C++
//' 
//' @param v un vector
//' @param n un nombre
//' @return renvoie si n appartient à v ou non
//' @export
// [[Rcpp::export]]
bool is_element(int n, IntegerVector v) {
  for(int i = 0; i < v.size(); i++) {
    if(v[i] == n){
      return(true);
    }
  }
  return(false);
}

//' Which algorithme using C++
//' 
//' @param P une liste de projet avec des équipes de projet
//' @param G une liste de groupe d'étudiant
//' @param R une liste de voeu classée par ordre de priorité pour chaque groupe
//' @return renvoie une liste X pour chaque équipe projet remplie ou non par des groupes
//' @export
// [[Rcpp::export]]
List lottery_rcpp(List P, List G, List R) {
  List P_copy(P.size());
  for(int p = 0; p < P.size(); p++){
    P_copy[p] = P[p];
  }
  IntegerVector numero_groupe = seq(1,G.size());
  IntegerVector numero_projet = seq(1,P.size());
  List X(P.size());
  for(int x = 0; x < X.size(); x++) {
    List pj = P[x];
    List x_pj(pj.size());
    X[x] = x_pj;
  }
  int h = 0;
  int nb_groupe = numero_groupe.length();
  while(nb_groupe != 0 && h < P.size()){
    List C(P.size());
    for(int i = 0; i < numero_projet.length(); i++) {
      int projet = numero_projet[i];
      IntegerVector c_pi;
      for(int k = 0; k < numero_groupe.length(); k++) {
        int groupe = numero_groupe[k];
        IntegerVector R_Gk = R[groupe-1];
        if (R_Gk[h] == projet) {
          c_pi.push_back(groupe);
        }
      }
      C[i] = c_pi;
    }
    for(int i = 0; i < numero_projet.length(); i++) {
      List x_pj = X[i];
      IntegerVector c = C[i];
      int taille_c = c.size();
      if (taille_c > 0) {
        c = sample(c,taille_c,false,R_NilValue);
        for(int k = 0; k < taille_c; k++) {
          int groupe_choisi = c[k];
          IntegerVector projet_equipe = P_copy[i];
          for(int j = 0; j < projet_equipe.length(); j++) {
            List equipe = x_pj[j];
            IntegerVector groupe_eleve = G[groupe_choisi - 1];
            int temporaire = projet_equipe[j] - groupe_eleve.length();
            if (temporaire >= 0) {
              projet_equipe[j] = temporaire;
              P_copy[i] = projet_equipe;
              equipe.push_back(groupe_choisi);
              x_pj[j] = equipe;
              int indice = which_is_equal(numero_groupe,groupe_choisi);
              numero_groupe.erase(indice);
              break;
            }
          }
          IntegerVector R_Gk = R[groupe_choisi-1];
          bool is_elem = is_element(groupe_choisi,R_Gk);
          if(is_elem && R_Gk.length() == h) {
            int indice = which_is_equal(numero_groupe,groupe_choisi);
            numero_groupe.erase(indice);
          }
        }
        X[i] = x_pj;
      }
    }
    nb_groupe = numero_groupe.length();
    h = h + 1;
  }
  return(X);
}
