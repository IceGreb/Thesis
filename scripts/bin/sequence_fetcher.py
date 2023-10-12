#!/home/nikoverg/miniconda3/envs/myenv/bin/python
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
output_file = args.output

table_hits = pd.read_csv(tsv_hits,header=0, sep="\t")
#print (table_hits)
queries = []
for q in table_hits.index:
    #print(table_hits[q])
    queries.append(table_hits["Protein"][q])
#queries = [table_hits[q] for q in table_hits]
#print (queries)
#print (table_hits)

#records = [record.id for record in SeqIO.parse(fa_query, "fasta")]
#for query in queries:
#    if query in records:
#        print(record)
catches=[]
for prot_record in SeqIO.parse(fa_query, "fasta"):
    if prot_record.id in queries:
        catches.append(prot_record)
SeqIO.write(catches, f"{output_file}_SeqCatches.fasta", "fasta")
        #with open(f"{output_file}_SeqCatches", "w") as results:
        #    print (prot_record.id)
        #    print (prot_record.seq)