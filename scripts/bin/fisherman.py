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

tsv_pattern = re.compile(
    r'''
    ^                # Start of the line
    (?:[^\t]*\t){6}  # Match the first six columns, separated by tabs
    ([^\t]*)\t       # Capture the 7th column and following tab
    ([^\t]*)         # Capture the 8th column (end of line)
    ''',
    re.VERBOSE  # Allow comments and whitespace in the pattern
)

def read_tsv_file(file_path, output_file):
    with open (file_path, 'r') as f, open(output_file,'a') as out_f:
        for line in f:
        #protein = f.read().strip()
        queries = (re.findall("IPR[0-9]+",protein),file)
        print(queries)
        for query in queries:
            for id in query:
                if id in Nattokinases:
                    prot_id = re.match("\S+",protein)
                    match_sites = tsv_pattern.match(protein)
                    out_f.write(f"Found matching           Nattokinases domain: ID:\t{prot_id.group(0)}\t{id}\tstart site:{match_sites.group(1)}\tin tsv file:\t{file}\n") #match.group(0) prints only query str
                elif id in Feruloyl_esterases:
                    prot_id = re.match("\S+", protein)
                    out_f.write(f"Found matching     Feruloyl_esterases domain: ID:\t{prot_id.group(0)}\t{id}\tin tsv file:\t{file}\n")
                elif id in Petases_Pet_hydrolases:
                    prot_id = re.match("\S+", protein)
                    out_f.write(f"Found matching Petases_Pet_hydrolases domain: ID:\t{prot_id.group(0)}\t{id}\tin tsv file:\t{file}\n")                
                elif id in Cocaine_esterases:
                    prot_id = re.match("\S+", protein)
                    out_f.write(f"Found matching      Cocaine_esterases domain: ID:\t{prot_id.group(0)}\t{id}\tin tsv file:\t{file}\n")
                else:
                    out_f.write("No matches found!\n")
for file in os.listdir():
    # Check whether file is in text format or not
    if file.endswith(".tsv"):
        file_path = f"{path}/{file}"
        

        read_tsv_file(file_path, args.output)
        #print (file_path)
