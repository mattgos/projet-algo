#' Simulation de l'échantillon
#'
#' @description fonction de simulation d'un échantillon d'élèves par groupe et de projets
#' @param nb_eleve nombre d'élèves devant choisir un projet
#' @param nb_proj nombre de projets total
#' @return une liste contenant : la liste des projets, la liste des groupes d'élèves et la liste de leurs voeux respectifs
simu<-function(nb_eleve,nb_proj){
  
  if (nb_eleve<nb_proj){
    print("Le nombre d'eleves doit etre egal ou superieur au nombre de projets")
    return(NULL);
  }
  
  cap_proj<-nb_eleve%/%nb_proj
  reste<-nb_eleve%%nb_proj
  P<-rep(cap_proj,nb_proj)
  ind_aj<-sample(1:nb_proj,size=reste)
  P[ind_aj]=P[ind_aj]+1
  
  P_rem=P
  
  repart_eleve=1:nb_eleve
  
  G=list()
  
  for (i in 1:nb_proj){
    while(P_rem[i]!=0){
      if (P_rem[i]==1){
        if (length(repart_eleve)==1){
          G=append(G,c(repart_eleve))
          repart_eleve=repart_eleve[!(repart_eleve==eleve)]
          P_rem[i]=P_rem[i]-1
        }
        else{
          eleve=sample(repart_eleve,1)
          G=append(G,c(eleve))
          repart_eleve=repart_eleve[!(repart_eleve==eleve)]
          P_rem[i]=P_rem[i]-1
        }
      }
      else{
        if(length(repart_eleve)==1){
          G=append(G,c(repart_eleve))
          repart_eleve=repart_eleve[!(repart_eleve==eleve)]
          P_rem[i]=P_rem[i]-1
        }
        else{
          nb_eleve_groupe=sample(1:P_rem[i],1)
          gr=sample(repart_eleve,nb_eleve_groupe)
          repart_eleve=repart_eleve[!(repart_eleve %in% gr)]
          G=append(G,list(gr))
          P_rem[i]=P_rem[i]-length(gr)
        }
      }
    }
  }
  
  
  # nb_group=sample(nb_proj:nb_eleve,1)
  # prem=sample(repart_eleve,nb_group)
  # G=list()
  # for (i in prem){
  #   G=append(G,i)
  #   
  # }
  # repart_eleve=repart_eleve[!(repart_eleve %in% prem)]
  # 
  # while (length(repart_eleve)>reste){
  #   if(length(repart_eleve)>1){
  #     eleve=sample(repart_eleve,1)
  #   }
  #   if(length(repart_eleve)==1){
  #     eleve=repart_eleve[1]
  #   }
  #   groupe=sample(1:nb_group,1)
  #   if (length(G[[groupe]])<cap_proj){
  #     G[[groupe]]=c(G[[groupe]],eleve)
  #     repart_eleve=repart_eleve[!(repart_eleve==eleve)]
  #   }
  # }
  # ind_aj<-sample(1:nb_group,size=reste)
  # j=1
  # for (i in repart_eleve){
  #   G[[ind_aj[j]]]=c(G[[ind_aj[j]]],i)
  #   j=j+1
  # }
  
  nb_group=length(G)
  
  t_gr=c()
  for (i in 1:nb_group){
    t_gr=c(t_gr,length(G[[i]]))
  }
  
  ordre<-rev(sort(t_gr,index.return=T)$ix)
  G_sort=vector("list",nb_group)
  j=1
  for (i in ordre){
    G_sort[[j]]=G[[i]]
    j=j+1
  }
  
  R=matrix(0,ncol=nb_proj,nrow=nb_group)
  for (i in 1:nb_group){
    R[i,]=sample(1:nb_proj)
  }
  
  return(list(P=P,G=G_sort,R=R))
}