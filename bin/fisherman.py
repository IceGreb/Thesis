#!/bin/python
from Bio import SeqIO
import os
import glob
import re
import argparse
import pandas as pd

Nattokinases = ["IPR000209","IPR010259","IPR023827","IPR022398","IPR023828","IPR015500","IPR036852"]
Feruloyl_esterases = ["IPR011118","IPR010126","IPR002921","IPR043595","IPR029058"]
Petases_Pet_hydrolases = ["IPR041127"]
Cocaine_esterases = ["IPR002018","IPR000383","IPR013736","IPR005674"]
parser = argparse.ArgumentParser()
parser.add_argument("-i","--input", help = "Input directory containing tsv files to fish")
parser.add_argument("-o","--output", help = "Output file to write results")
args = parser.parse_args()
file  = args.input
Nattokinases_sum=0
Feruloyl_sum=0
Petases_sum=0
Cocaine_sum=0
#os.chdir(path) #input command must pass a directory here


if file.endswith(".tsv"):
    #the name of the tsv file
    #file_path = f"{path}/{file}" 
    table1 = pd.read_csv(file,header=None, sep="\t")   
    table1 = table1.rename(columns={0:"Protein", 6:"Start", 7:"Stop", 8:"Score", 11:"IPR"})
    data1=[]
    data2=[]
    data3=[]
    data4=[]
    for value in table1.index:
        if table1["IPR"][value] in Nattokinases:
            data1.append([table1["Protein"][value], table1["IPR"][value], table1["Start"][value], table1["Stop"][value], table1["Score"][value]])
            
        elif table1["IPR"][value] in Feruloyl_esterases:
            data2.append([table1["Protein"][value], table1["IPR"][value], table1["Start"][value], table1["Stop"][value], table1["Score"][value]])
                
        elif table1["IPR"][value] in Petases_Pet_hydrolases:
            data3.append([table1["Protein"][value], table1["IPR"][value], table1["Start"][value], table1["Stop"][value], table1["Score"][value]])
                
        elif table1["IPR"][value] in Cocaine_esterases:
            data4.append([table1["Protein"][value], table1["IPR"][value], table1["Start"][value], table1["Stop"][value], table1["Score"][value]])
                
        
    Nattokinases_Hits = pd.DataFrame(data1, columns=["Protein", "Domain", "Start", "Stop", "Score"])
    Nattokinases_Hits.index += 1
    
    Feruloyl_esterases_Hits = pd.DataFrame(data2, columns=["Protein", "Domain", "Start", "Stop", "Score"])
    Feruloyl_esterases_Hits.index +=1
    
    Petases_Pet_hydrolases_Hits = pd.DataFrame(data3, columns=["Protein", "Domain", "Start", "Stop", "Score"])
    Petases_Pet_hydrolases_Hits.index += 1
    
    Cocaine_esterases_Hits = pd.DataFrame(data4, columns=["Protein", "Domain", "Start", "Stop", "Score"])
    Cocaine_esterases_Hits.index += 1
        
    Nattokinases_Hits.to_csv(f"Nattokinases_Hits_{file}", sep="\t", index=True, encoding = "utf-8")
    Feruloyl_esterases_Hits.to_csv(f"Feruloyl_esterases_Hits_{file}", sep="\t", index=True, encoding = "utf-8")
    Petases_Pet_hydrolases_Hits.to_csv(f"Petases_Pet_hydrolases_Hits_{file}", sep="\t", index=True, encoding = "utf-8")
    Cocaine_esterases_Hits.to_csv(f"Cocaine_esterases_Hits_{file}", sep="\t", index=True, encoding = "utf-8")    
            
    Nattokinases_results = pd.read_csv(f"Nattokinases_Hits_{file}")
    Feruloyl_esterases_results = pd.read_csv(f"Feruloyl_esterases_Hits_{file}")
    Petases_Pet_hydrolases_results = pd.read_csv(f"Petases_Pet_hydrolases_Hits_{file}")
    Cocaine_esterases_results = pd.read_csv(f"Cocaine_esterases_Hits_{file}")

    Nattokinases_sum += len(Nattokinases_results)
    Feruloyl_sum += len(Feruloyl_esterases_results)
    Petases_sum += len(Petases_Pet_hydrolases_results)
    Cocaine_sum += len(Cocaine_esterases_results)
    
with open(f"Results.txt", "w") as results_txt:
    print(" Number of Nattokinases hits: " , Nattokinases_sum,"\n Number of Feruloyl hits: ", Feruloyl_sum, "\n Number of Petases hits: ", 
        Petases_sum, "\n Number of Cocaine hits: ", Cocaine_sum, file= results_txt) 
                
        


