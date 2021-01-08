simu<-function(nb_eleve,nb_proj){
  
  if (nb_eleve<nb_proj){
    print("Le nombre d'élèves doit être égal ou supérieur au nombre de projets")
    return(NULL);
  }
  
  cap_proj<-nb_eleve%/%nb_proj
  reste<-nb_eleve%%nb_proj
  P<-rep(cap_proj,nb_proj)
  ind_aj<-sample(1:nb_proj,size=reste)
  P[ind_aj]=P[ind_aj]+1
  
  repart_eleve=1:nb_eleve
  nb_group=sample(nb_proj:nb_eleve,1)
  prem=sample(repart_eleve,nb_group)
  G=list()
  for (i in prem){
    G=append(G,i)
    
  }
  
  repart_eleve=repart_eleve[!(repart_eleve %in% prem)]
  
  while (length(repart_eleve)>reste){
    eleve=sample(repart_eleve,1)
    groupe=sample(1:nb_group,1)
    if (length(G[[groupe]])<cap_proj){
      G[[groupe]]=c(G[[groupe]],eleve)
    }
    repart_eleve=repart_eleve[!(repart_eleve==eleve)]
  }
  ind_aj<-sample(1:nb_group,size=reste)
  j=1
  for (i in repart_eleve){
    G[[ind_aj[j]]]=c(G[[ind_aj[j]]],i)
    j=j+1
  }
  
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