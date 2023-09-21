params.seqs = "/home/nvergoulidis/scripts/separated_secs/separated_secs.test1"
params.separated_seqs = "/home/nikoverg/Documents/bioinformatics/projects/Thesis/separated_secs/separated_secs.fasta"
params.interproscan_dir = "/home/nvergoulidis/interproscan-5.63-95.0"
params.outdir = "/home/nvergoulidis/scripts/results"






process INTERPROSCAN {
    publishDir "${params.outdir}/annotations/interproscan", mode: "copy" label "ips"

    input :
    path input_seq

    output :
    path "${input_seq}.tsv"
    
    script:
    """
    ${params.interproscan_dir}/interproscan.sh -dp -i ${input_seq}  -f tsv -etra
    """

}

process FISHERMAN {

    
    input :
    path "${input_seq}.tsv"

    output :
    path "${params.outdir}"

    script:
    """
    fisherman.py -i ${input_seq}.tsv -o ${params.outdir}
    """
}

workflow {
    Channel
        .fromPath(params.seqs)
        .flatten()
        .splitFasta(by : 50 , file: true)
        .set {sep_seqs_ch}
    
    ips_ch = INTERPROSCAN(sep_seqs_ch)
    fish_ch = FISHERMAN(ips_ch)
    
}
