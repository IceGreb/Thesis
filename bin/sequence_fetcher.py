#!/home/nvergoulidis/miniconda3/bin/python
from Bio import SeqIO
import argparse
from numpy import rec
import pandas as pd

parser = argparse.ArgumentParser()
parser.add_argument("-t","--table", help = "Input tsv hits")
parser.add_argument("-f","--fa", help = "Input FASTA query")
parser.add_argument("-o","--output", help = "Output file to print results")
args = parser.parse_args()
tsv_hits = args.table
fa_query = args.fa
output_file = f"{fa_query.split('.')[0]}_SeqCatches.fasta"

table_hits = pd.read_csv(tsv_hits,header=0, sep="\t")
queries = []
for q in table_hits.index:
     queries.append(table_hits["Protein"][q])



catches=[]
for prot_record in SeqIO.parse(fa_query, "fasta"):
    if prot_record.id in queries:
        catches.append(prot_record)
SeqIO.write(catches, f"{output_file}", "fasta")
        
