#!/home/nvergoulidis/miniconda3/bin/python
import csv
import os
import argparse
from Bio import SearchIO

parser = argparse.ArgumentParser()
parser.add_argument("-t","--table", help = "Input domtblout hits")    # Directory containing your .domtblout files
parser.add_argument("-o","--output", help = "Output file to print results")
args = parser.parse_args()
file_name = args.table #  your directory path passed through the argparser using "-t"

if file_name.endswith('.domtblout'):
        output_file = f"{file_name.split('.')[0]}_output.tsv"  # Use the file name for output
        
        with open(output_file, 'w', newline='') as csvfile:
            writer = csv.writer(csvfile, delimiter='\t')
            writer.writerow(['Index', 'Protein', 'Bit_Score', 'E-value', 'Start', 'Stop'])
            line_count = 1
            for result in SearchIO.parse(file_name, 'hmmsearch3-domtab'):
                for hit in result.hits:
                    for hsp in hit:
                        writer.writerow([line_count, hit.id,  hit.bitscore, hit.evalue, hsp.hit_start, hsp.hit_end])
                        line_count += 1