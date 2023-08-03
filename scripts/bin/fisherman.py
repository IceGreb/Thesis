#!/home/nikoverg/miniconda3/envs/myenv/bin/python
from Bio import SeqIO
import os
import glob
import re
import pandas as pd
Nattokinases = ["IPR000209","IPR010259","IPR023827","IPR022398","IPR023828","IPR015500","IPR036852"]
Feruloyl_esterases = ["IPR011118","IPR010126","IPR002921","IPR043595","IPR029058"]
Petases_Pet_hydrolases = ["IPR041127"]
Cocaine_esterases = ["IPR002018","IPR000383","IPR013736","IPR005674"]
path = "/home/nikoverg/Documents/bioinformatics/projects/Thesis/interproscan_results"
os.chdir(path)
def read_tsv_file(file_path):
    with open (file_path, 'r') as f:
        domain = f.read().strip()
        queries = (re.findall("IPR[0-9]+",domain),file)
        #print(queries)
        for query in queries:
            for id in query:
                if id in Nattokinases:
                    print("Found matching Nattokinases domain:\t",id,"\tin tsv file:\t",file)
                elif id in Feruloyl_esterases:
                    print("Found matching Feruloyl_esterases domain:\t",id,"\tin tsv file:\t",file)
                elif id in Petases_Pet_hydrolases:
                    print("Found matching Petases_Pet_hydrolases domain:\t",id,"\tin tsv file:\t",file)
                elif id in Cocaine_esterases:
                    print("Found matching Cocaine_esterases domain:\t",id,"\tin tsv file:\t",file)
                else:
                    print("No matches found!")
for file in os.listdir():
    # Check whether file is in text format or not
    if file.endswith(".tsv"):
        file_path = f"{path}/{file}"

        read_tsv_file(file_path)