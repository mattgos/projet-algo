# Projet d'Alogrithmique
### Dorian Manouvriez
### Matthieu Gosset
### Clément Bernard
#### M2DS SAF
### 16 décembre 2020

>[Introduction](#intro)

>[Premier exemple : solution naïve](#prex)

<a id="intro"></a>

## Introduction

Le `projet-algo` R package est un package créé dans le cadre du projet d'algorithmique du M2 Data Science SAF de l'Université Paris-Saclay. Il implémente **deux solutions** qui permettent d'**attribuer des équipes d'élèves à des projets** qui ont une certaine capacité selon l'ordre de préférence des élèves. Les deux méthodes implémentés sont : la méthode de **lotterie naïve** et la méthode **MILP optimisée**.

### Installation du package

Il faut d'abord avoir installer le package `devtools` puis utiliser l'installation depuis github :
``` r
devtools::install_github("mattgos/projet-algo")
library(projet)
```
Les fonctions `lotterie`et `lottery_rcpp`permettent de faire marcher la méthode de lotterie en R et en C++.
Voyons comment elles fonctionnent avec un exemple.

<a id="prex"></a>


