###------------
# This script is used for BIOME-BGC result read and process
## -----------------


rm(list =ls())

data_directory="J:/Github/BIOMEBGC/test_data/"
name_ann<-"qh_out.annout.ascii"
name_month<-"qh_out.monavgout.ascii"

num_blocks<-1

num_ID<-24/num_blocks
name_ID<-c(1:num_ID)
year_start<-1995
year_end<-2012
num_year<-year_end-year_start+1

for (num_block in 1:num_blocks) {
  
  input_name_ann<-paste(data_directory,name_ann,sep='')
  input_name_month<-paste(data_directory,name_month,sep='')
  
  num_line<-num_ID*num_year
  num_line_mon<-num_ID*num_year*12
  
  if (num_block==1) {
    num_line_pre<-num_ID*num_year*(num_block-1) 
    num_line_pre_mon<-num_ID*num_year*(num_block-1)*12 
    
    data_ann<-read.csv(input_name_ann, header = TRUE, sep = "",nrows=num_line,skip =num_line_pre )
    data_month<-read.csv(input_name_month, header = FALSE, sep = "",nrows=num_line_mon,skip =num_line_pre_mon )
    
  } else {
    num_line_pre<-num_ID*num_year*(num_block-1)+1
    data_ann<-read.csv(input_name_ann, header = FALSE, sep = "", nrows=num_line,skip =num_line_pre )
    data_month<-read.csv(input_name_month, header = FALSE, sep = "",nrows=num_line_mon,skip =num_line_pre_mon )
    
  }

  lable_year<-c(1:num_line)
  lable_month<-c(1:num_line)
  name_cols_ann<-c(year_start:year_end)
  name_cols_mon<-c("","")
  
  a<-1
  b<-1
  for (I in 1:num_ID) {
    c<-1
      for (Y in year_start:year_end) {
    
        lable_year[a]<-Y
        
        a<-a+1
        
        for (M in 1:12){
          
          lable_month[b]<-M
          
          name_cols_mon[c]<-paste(as.character(Y),"_",as.character(M),sep='')
          b<-b+1
          c<-c+1
        }
        
      }
  }
  
  data_linshi_ann<-as.matrix(data_ann)
  data_linshi_month<-as.matrix(data_month)
  
  data_final_mon<-array(0,c(12,num_ID,num_year*12))
  data_final_ann<-array(0,c(16,num_ID,num_year))
  
  a<-1  
  for (ID in 1:num_ID) {
  
    for (Y in 1:num_year) {
      
      
      name_ID[ID]<-data_ann[a,1]
      
   #   print(data_ann[a,1])
      
      #       for (M in 1:12){
      #         
      #         data_final_mon[n_var,ID,a]<-data_linshi_mon[a,n_var+1]
      #         
      #       }
     a<-a+1 
    }
  
  
  }
  
  rm(data_ann,data_month)
  gc()
  
 
  for (n_var in 1:12 ){
    
   a<-1
   b<-1
    for (ID in 1:num_ID) {
      c<-1
      
      for (Y in 1:num_year) {
        
        
        data_final_ann[n_var,ID,Y]<-as.double(data_linshi_ann[b,n_var+1])
  
        for (M in 1:12){
          
          data_final_mon[n_var,ID,c]<-data_linshi_month[a,n_var]
          a<-a+1 
          c<-c+1
          
        }
        b<-b+1
        
      }
    }
   print(n_var)
  }
 
  for (n_var in 13:16 ){
    
    a<-1
    for (ID in 1:num_ID) {
      
      for (Y in 1:num_year) {
        
        
        data_final_ann[n_var,ID,Y]<-as.double(data_linshi_ann[a,n_var+1])
        
        a=a+1
      }
    }
  }  
   
  
  out_name_ann<-c("soilWater","soilSnow","LAI","vegC","litrC","soilC","totalC","leafC_sum","leafC_max","leafC","stemC","crootC","cwdc","FSM_soilw","FSM_icew","FSM_snoww")
  output_name_ann<-c("0")
  
  for (n_var in 1:16 ){
    
  output_name_ann[n_var]<-paste(data_directory,out_name_ann[n_var],"_ANN","_",as.character(num_block),".csv",sep='')
  
  write.table(data.frame(name_ID,data_final_ann[n_var,,]),file=output_name_ann[n_var],sep = ",", row.names =FALSE,col.names = c("ID",as.character(name_cols_ann)) ) #col.names = "as.character(c(1:1))",
  
  }

  
  out_name_mon<-c("soilWater","soilSnow","LAI","vegC","litrC","soilC","totalC","leafC_sum","leafC_max","leafC","stemC","crootC","cwdc","FSM_soilw","FSM_icew","FSM_snoww")
  output_name_mon<-c("0")
  
  for (n_var in 1:12 ){
  
  output_name_mon[n_var]<-paste(data_directory,out_name_mon[n_var],"_MONTH","_",as.character(num_block),".csv",sep='')
  
  write.table(data.frame(name_ID,data_final_mon[n_var,,]),file=output_name_mon[n_var],sep = ",", row.names =FALSE,col.names =c("ID",name_cols_mon) ) #col.names = "as.character(c(1:1))",
  }
  
}  
  
  
  

