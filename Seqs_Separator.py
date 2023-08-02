#!/home/nikoverg/miniconda3/envs/myenv/bin/python
from Bio import SeqIO

in_handle = open("/home/nikoverg/Documents/bioinformatics/projects/Thesis/scripts/bin/query_seqs.txt", "r")
records = SeqIO.parse(in_handle, "fasta")

for i, record in enumerate(records, start=1):
    out_handle = open("Sequence_"+ record.id + ".fasta", "w")
    seq = SeqIO.write(record, out_handle, "fasta")
    
    out_handle.close()
in_handle.close()

