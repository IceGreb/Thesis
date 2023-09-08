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
os.chdir(path)

def read_tsv_file(file_path, output_file):
    with open (file_path, 'r') as f, open(output_file,'a') as out_f:
        domain = f.read().strip()
        queries = (re.findall("IPR[0-9]+",domain),file)
        #print(queries)
        for query in queries:
            for id in query:
                if id in Nattokinases:
                    out_f.write(f"Found matching Nattokinases domain:\t{id}\tin tsv file:\t{file}\n")
                elif id in Feruloyl_esterases:
                    out_f.write(f"Found matching Feruloyl_esterases domain:\t{id}\tin tsv file:\t{file}\n")
                elif id in Petases_Pet_hydrolases:
                    out_f.write(f"Found matching Petases_Pet_hydrolases domain:\t{id}\tin tsv file:\t{file}\n")                
                elif id in Cocaine_esterases:
                    out_f.write(f"Found matching Cocaine_esterases domain:\t{id}\tin tsv file:\t{file}\n")
                else:
                    out_f.write("No matches found!\n")
for file in os.listdir():
    # Check whether file is in text format or not
    if file.endswith(".tsv"):
        file_path = f"{path}/{file}"

        read_tsv_file(file_path, args.output)
