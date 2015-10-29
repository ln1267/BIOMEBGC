###------------
# This script is used for BIOME-BGC result read and process
## -----------------


rm(list =ls())

data_directory="J:/Github/BIOMEBGC/test_data/"
name_ann<-"qh_out.annout.ascii"
name_month<-"qh_out.monavgout.ascii"

year_start<-1
year_end<-18
num_ID<-24
num_year<-year_end-year_start+1
num_line_pre<-0
num_line<-num_ID*num_year

input_name_ann<-paste(data_directory,name_ann,sep='')
input_name_month<-paste(data_directory,name_month,sep='')

data_ann<-read.csv(input_name_ann, header = TRUE, sep = "",nrows=num_line,skip =num_line_pre )
data_month<-read.csv(input_name_ann, header = TRUE, sep = "",nrows=num_line,skip =num_line_pre )

lable_year<-c(1:num_line)
lable_month<-c(1:num_line)
a<-1
b<-1
for (I in 1:num_ID) {
  
    for (Y in year_start:year_end) {
  
      lable_year[a]<-Y
      
      a<-a+1
      
      for (M in 1:12){
        
        lable_month[b]<-M
        
        b<-b+1
      }
      
    }
}

data_linshi_ann<-as.matrix(data_ann)
data_linshi_month<-as.matrix(data_month)

data_final_mon<-array(0,c(16,num_ID,num_year*12))
data_final_ann<-array(0,c(16,num_ID,num_year))


for (n_var in 14:16 ){
  
 
  for (ID in 1:num_ID) {
    a<-1
    for (Y in year_start:year_end) {
      
      
      data_final_ann[n_var,ID,Y]<-as.double(data_linshi_ann[a,n_var+1])
      
#       for (M in 1:12){
#         
#         data_final_mon[n_var,ID,a]<-data_linshi_mon[a,n_var+1]
#         
#       }
      
    }
  }
 
}


out_name<-c("soilWater","soilSnow","LAI","vegC","litrC","soilC","totalC","leafC_sum","leafC_max","leafC","stemC","crootC","cwdc","FSM_soilw","FSM_icew","FSM_snoww")
output_name_ann<-c("0")

for (n_var in 1:16 ){
  
output_name_ann[n_var]<-paste(data_directory,out_name[n_var],"_ANN.csv",sep='')

write.table(data_final_ann[n_var,,],file=output_name_ann[n_var],sep = ",", row.names =FALSE ) #col.names = "as.character(c(1:1))",
}

for (n_var in 1:16 ){
  
  output_name_mon[n_var]<-paste(data_directory,out_name[n_var],"_MONTH.csv",sep='')
  
  write.table(data_final_mon[n_var,,],file=output_name_mon[n_var],sep = ",", row.names =FALSE ) #col.names = "as.character(c(1:1))",
}
