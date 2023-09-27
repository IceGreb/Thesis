#!/home/nikoverg/miniconda3/envs/myenv/bin/python
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
path = args.input
os.chdir(path) #input command must pass a directory here
for file in os.listdir():
    # Check whether file is in text format or not
    if file.endswith(".tsv"):   #the name of the tsv file
        file_path = f"{path}/{file}" 
        table1 = pd.read_csv(file_path,header=None, sep="\t")   
        table1 = table1.rename(columns={0:"Protein", 6:"Start", 7:"Stop", 11:"IPR"})
        for value in table1.index:
            if table1["IPR"][value] in Nattokinases:
                data1 = [[table1["Protein"][value], table1["IPR"][value], table1["Start"][value], table1["Stop"][value]]]
                Nattokinases_Hits= pd.DataFrame(data1, columns=["Protein", "Domain", "Start", "Stop"])
            elif table1["IPR"][value] in Feruloyl_esterases:
                data2 = [[table1["Protein"][value], table1["IPR"][value], table1["Start"][value], table1["Stop"][value]]]
                Feruloyl_esterases_Hits = pd.DataFrame(data2, columns=["Protein", "Domain", "Start", "Stop"])
            elif table1["IPR"][value] in Petases_Pet_hydrolases:
                data3 = [[table1["Protein"][value], table1["IPR"][value], table1["Start"][value], table1["Stop"][value]]]
                Petases_Pet_hydrolases_Hits = pd.DataFrame(data3, columns=["Protein", "Domain", "Start", "Stop"])
            elif table1["IPR"][value] in Cocaine_esterases:
                data4 = [[table1["Protein"][value], table1["IPR"][value], table1["Start"][value], table1["Stop"][value]]]
                Cocaine_esterases_Hits = pd.DataFrame(data4, columns=["Protein", "Domain", "Start", "Stop"])
    if (Nattokinases_Hits.empty and Feruloyl_esterases_Hits.empty and Petases_Pet_hydrolases_Hits.empty and Cocaine_esterases_Hits.empty):
            print ("No Hits Found in ",file,"!")
    elif (Nattokinases_Hits.any or Feruloyl_esterases_Hits.any or Petases_Pet_hydrolases_Hits.any or Cocaine_esterases_Hits.any):
                print("\n Nattokinases_Hits of ",file," :\n ",Nattokinases_Hits,
            "\n Feruloyl_esterases_Hits of ",file," :\n ",Feruloyl_esterases_Hits,
            "\n Petases_Pet_hydrolases_Hits of ",file," :\n ",Petases_Pet_hydrolases_Hits,
            "\n Cocaine_esterases_Hits of ",file," :\n ",Cocaine_esterases_Hits )
    
                
        


