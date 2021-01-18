change_view<-function(res){
  proj<-sort(unique(res[,"Projet"][res[,"Projet"]!=0]))
  nb_etu<-length(res[,"Eleve"])
  v<-matrix(rep(0,(nb_etu+1)*length(proj)),ncol=nb_etu+1)
  v[,1]<-proj
  for (i in 1:length(proj)){
    eleves<-res[,"Eleve"][res[,"Projet"]==v[i,1]]
    v[i,2:(length(eleves)+1)]<-eleves
  }
  
  v<-v[,!(colSums(v)==0)]
  
  nam<-c("Projet")
  nb_ele_max<-length(v[1,])-1
  for (i in 1:nb_ele_max){
    nam<-c(nam,paste("Eleve",i))
  }
  
  colnames(v)<-nam
 
  return(v)
}