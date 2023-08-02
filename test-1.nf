params.seqs = "/home/nikoverg/Documents/bioinformatics/projects/Thesis/scripts/bin/query_seqs.txt"
params.separated_seqs = "/home/nikoverg/Documents/bioinformatics/projects/Thesis/seperated_secs/"
params.seqs_for_interpro = '/home/nikoverg/Documents/bioinformatics/projects/Thesis/seperated_secs/Sequence_*.fasta'
params.outdir = "/home/nikoverg/Documents/bioinformatics/projects/Thesis/interproscan_results/"
params.outdir_results = "/home/nikoverg/Documents/bioinformatics/projects/Thesis/interproscan_results/"
params.outdir_tsv = "/home/nikoverg/Documents/bioinformatics/projects/Thesis/interproscan_results/Sequence_*.tsv"


process Seq_Sep {
    publishDir params.separated_seqs, mode:'copy'
    input :
    path seqs

    output :
    path 'Sequence_*.fasta'

    script:
    """
    Seqs_Separator.py  
    """
}

process INTERPROSCAN {
    publishDir params.outdir_results, mode:'copy'
    input :
    path input_seq

    output :
    path "$input_seq"
    
    script:
    """
    interproscan.sh -i ${input_seq} -b ${params.outdir_results}
    """

}

process FISHERMAN {
    input :
    path input_seq

    output :
    path "match_results.txt"

    script:
    """
    fisherman.py > match_results.txt
    """
}

workflow {
    Seq_Sep_ch = Seq_Sep(params.seqs)
    sep_seqs = Seq_Sep_ch.flatMap()
    interproscan_ch = INTERPROSCAN(sep_seqs)
    FISHERMAN(interproscan_ch)




}
