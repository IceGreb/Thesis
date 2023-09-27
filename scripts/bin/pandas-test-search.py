#!/home/nikoverg/miniconda3/envs/myenv/bin/python
from Bio import SeqIO
import os
import glob
import re
import argparse
import pandas as pd
from IPython.display import display
Nattokinases = ["IPR000209","IPR010259","IPR023827","IPR022398","IPR023828","IPR015500","IPR036852"]
Feruloyl_esterases = ["IPR011118","IPR010126","IPR002921","IPR043595","IPR029058"]
Petases_Pet_hydrolases = ["IPR041127"]
Cocaine_esterases = ["IPR002018","IPR000383","IPR013736","IPR005674"]
parser = argparse.ArgumentParser()
parser.add_argument("-i","--input", help = "Input directory containing tsv files to fish")
parser.add_argument("-o","--output", help = "Output file to write results")
args = parser.parse_args()
path = args.input
os.chdir(path) #input command must pass a directory here

for file in os.listdir(): #loop through directory
    # Check whether file is in text format or not
    if file.endswith(".tsv"):   #the name of the tsv file
        file_path = f"{path}/{file}" 
        table1 = pd.read_csv(file_path,header=None, sep="\t")   
        table1 = table1.rename(columns={0:"Protein", 6:"Start", 7:"Stop", 11:"IPR"})
        data1=[]
        data2=[]
        data3=[]
        data4=[]
        for value in table1.index:
            if table1["IPR"][value] in Nattokinases:
                data1.append([table1["Protein"][value], table1["IPR"][value], table1["Start"][value], table1["Stop"][value]])
                
            elif table1["IPR"][value] in Feruloyl_esterases:
                data2.append([table1["Protein"][value], table1["IPR"][value], table1["Start"][value], table1["Stop"][value]])
                
            elif table1["IPR"][value] in Petases_Pet_hydrolases:
                data3.append([table1["Protein"][value], table1["IPR"][value], table1["Start"][value], table1["Stop"][value]])
                
            elif table1["IPR"][value] in Cocaine_esterases:
                data4.append([table1["Protein"][value], table1["IPR"][value], table1["Start"][value], table1["Stop"][value]])
                
        
        Nattokinases_Hits = pd.DataFrame(data1, columns=["Protein", "Domain", "Start", "Stop"])
        Nattokinases_Hits.index += 1
        Feruloyl_esterases_Hits = pd.DataFrame(data2, columns=["Protein", "Domain", "Start", "Stop"])
        Feruloyl_esterases_Hits.index +=1
        Petases_Pet_hydrolases_Hits = pd.DataFrame(data3, columns=["Protein", "Domain", "Start", "Stop"])
        Petases_Pet_hydrolases_Hits.index += 1
        Cocaine_esterases_Hits = pd.DataFrame(data4, columns=["Protein", "Domain", "Start", "Stop"])
        Cocaine_esterases_Hits.index += 1
        
        Nattokinases_Hits.to_csv(f"Nattokinases_Hits_{file}.tsv", sep="\t", index=True, encoding = "utf-8")
        Feruloyl_esterases_Hits.to_csv(f"Feruloyl_esterases_Hits_{file}.tsv", sep="\t", index=True, encoding = "utf-8")
        Petases_Pet_hydrolases_Hits.to_csv(f"Petases_Pet_hydrolases_{file}.tsv", sep="\t", index=True, encoding = "utf-8")
        Cocaine_esterases_Hits.to_csv(f"Cocaine_esterases_Hits_{file}.tsv", sep="\t", index=True, encoding = "utf-8")
            
    
                
        

