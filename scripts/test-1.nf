params.seqs = "/home/nikoverg/Documents/bioinformatics/projects/Thesis/separated_secs/separated_secs.test1"
params.separated_seqs = "/home/nikoverg/Documents/bioinformatics/projects/Thesis/separated_secs/separated_secs.fasta"
params.interproscan_dir = "/home/nikoverg/my_interproscan/interproscan-5.63-95.0/"
params.outdir = "/home/nikoverg/Documents/bioinformatics/projects/Thesis/results"
params.outdir_results = "/home/nikoverg/Documents/bioinformatics/projects/Thesis/interproscan_results/"





process INTERPROSCAN {
    publishDir "${params.outDir}annotations/interproscan", mode: "copy" label "ips"

    input :
    path input_seq

    output :
    path "${input_seq}.tsv"
    
    script:
    """
    ${params.interproscan_dir}interproscan.sh -dp -i ${input_seq}  -f tsv
    """

}

process FISHERMAN {

    
    input :
    path "${input_seq}.tsv"

    output :
    path "${params.outdir}"

    script:
    """
    fisherman.py -i ${fasta}.tsv -o ${params.outdir}
    """
}

workflow {
    Channel
        .fromPath(params.seqs)
        .splitFasta(by : 10 , file: params.separated_seqs)
        .set {sep_seqs_ch}
    INTERPROSCAN(sep_seqs_ch)
    
}
