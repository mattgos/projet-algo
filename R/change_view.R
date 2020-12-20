change_view<-function(res){
  proj<-sort(unique(res[,"Projet"][res[,"Projet"]!=0]))
  nb_equip<-c()
  for (i in proj){
    nb_equip<-c(nb_equip,max(res[,"Equipe-projet"][res[,"Projet"]==i]))
  }
  col_proj<-rep(proj,nb_equip)
  col_equip<-c()
  for (i in nb_equip){
    col_equip<-c(col_equip,1:i)
  }
  nb_etu<-length(res[,"Eleve"])
  v<-matrix(rep(0,(nb_etu+2)*length(col_proj)),ncol=nb_etu+2)
  v[,1]<-col_proj
  v[,2]<-col_equip
  for (i in 1:length(col_proj)){
    eleves<-res[,"Eleve"][res[,"Projet"]==v[i,1] & res[,"Equipe-projet"]==v[i,2]]
    v[i,3:(length(eleves)+2)]<-eleves
  }
  
  v<-v[,!(colSums(v)==0)]
  
  nam<-c("Projet","Equipe-projet")
  nb_ele_max<-length(v[1,])-2
  for (i in 1:nb_ele_max){
    nam<-c(nam,paste("Eleve",i))
  }
  
  colnames(v)<-nam
 
  return(v)
}