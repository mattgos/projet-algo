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

//' comptage élève algorithme using C++
//' 
//' @param G une liste de groupe d'étudiant
//' @return le nombre d'étudiant total
//' @export
// [[Rcpp::export]]
int comptage_eleve(List groupe) {
  int res = 0;
  for(int g = 0; g < groupe.size(); g++) {
    IntegerVector v = groupe[g];
    res += v.size();
  }
  return(res);
}

//' Méthode lottery algorithm using C++
//' 
//' @param P une liste de projet avec des équipes de projet
//' @param G une liste de groupe d'étudiant
//' @param R une liste de voeu classée par ordre de priorité pour chaque groupe
//' @return renvoie une matrice X de taille (nb eleves,4) telle que chaque colonne correspond à l'élève, son groupe, son projet et son équipe-projet
//' @export
// [[Rcpp::export]]
IntegerMatrix lottery_rcpp(List P, List G, List R) {
  List P_copy(P.size());
  for(int p = 0; p < P.size(); p++){
    P_copy[p] = P[p];
  }
  int nb_eleve = comptage_eleve(G);
  IntegerVector numero_groupe = seq(1,G.size());
  IntegerVector numero_projet = seq(1,P.size());
  IntegerMatrix X(nb_eleve,4);
  CharacterVector nom_colonnes = CharacterVector::create("Eleve","Groupe","Projet","Equipe-projet");
  colnames(X) = nom_colonnes;
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
      IntegerVector c = C[i];
      int taille_c = c.size();
      if (taille_c > 0) {
        c = sample(c,taille_c,false,R_NilValue);
        for(int k = 0; k < taille_c; k++) {
          int projet = numero_projet[k];
          int groupe_choisi = c[k];
          IntegerVector projet_equipe = P_copy[i];
          IntegerVector groupe_eleve = G[groupe_choisi - 1];
          for(int j = 0; j < projet_equipe.length(); j++) {
            int equipe_projet = j+1;
            int temporaire = projet_equipe[j] - groupe_eleve.length();
            if (temporaire >= 0) {
              projet_equipe[j] = temporaire;
              P_copy[i] = projet_equipe;
              for(int eleve = 0; eleve < groupe_eleve.length(); eleve++) {
                int individu = groupe_eleve[eleve];
                X(individu - 1,0) = individu;
                X(individu - 1,1) = groupe_choisi;
                X(individu - 1,2) = projet;
                X(individu - 1,3) = equipe_projet;
              }
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
          for(int eleve = 0; eleve < groupe_eleve.size(); eleve++) {
            int individu = groupe_eleve[eleve];
            X(individu - 1,0) = individu;
            X(individu - 1,1) = groupe_choisi;
          }
        }
      }
    }
    nb_groupe = numero_groupe.length();
    h = h + 1;
  }
  return(X);
}