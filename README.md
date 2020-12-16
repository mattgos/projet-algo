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

Prenons un premier petit exemple :

On prend **3 projets** :
``` r
P=c("projet 1","projet 2","projet 3")
```

Le premier projet peut prendre 2 équipes de 2.
Le second 1 équipe de 3.
Et le dernier, une équipe de 3 et une équipe de 2.

``` r
p=list(c(2,2),c(3),c(3,2))
```

Nous avons **10 élèves** numérotés de 1 à 10.
Ils ont formé **6 groupes** :
``` r
G=list(c(1,5,3),c(2,6),c(4),c(7,10),c(8),c(9))
```

Chaque groupe a classé les projets qu'il souhaite avoir dans l'ordre de préférence.
``` r
R=list(c(1,3),c(2,3,1),c(3),c(1,2,3),c(2,1),c(1,3))
```

On peut maintenant executer les fonctions :
``` r
lotterie(P,p,G,R)
lottery_rcpp(p,G,R)
```
Les résultats ne sont pas exactement sous la même forme mais indiquent la même répartition.

Pour **R** :
``` r
[[1]]
[[1]][[1]]
[1] 6

[[1]][[2]]
[1] 4


[[2]]
[[2]][[1]]
[1] 2 5


[[3]]
[[3]][[1]]
[1] 3

[[3]][[2]]
[1] 0
```

Pour **C++** :
```r
[[1]]
[[1]][[1]]
[[1]][[1]][[1]]
[1] 4


[[1]][[2]]
[[1]][[2]][[1]]
[1] 6



[[2]]
[[2]][[1]]
[[2]][[1]][[1]]
[1] 2

[[2]][[1]][[2]]
[1] 5



[[3]]
[[3]][[1]]
[[3]][[1]][[1]]
[1] 3


[[3]][[2]]
NULL
```

Voici ce qu'il faut comprendre des résultats :
- L'équipe 4 est affectée au premier (ou second) groupe du projet 1
- L'équipe 6 est affectée au second (ou premier) groupe du projet 1
- Les équipes 2 et 5 forment l'équipe pour le seul groupe du projet 2
- L'équipe 3 est affectée au premier groupe du projet 3
- L'équipe 1 n'a pas pu être affectée

Nous voyons ici que l'équipe 1 n'a pas été affectée. Elle aurait pu prendre place dans l'équipe de capacité 3 du projet 3, cependant cette équipe de projet avait déjà commencé à être remplie par l'équipe 3, qui avait le projet 3 en premier voeu. On voit dans cet exemple une limite de l'algorithme par lotterie.



