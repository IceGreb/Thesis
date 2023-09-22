params.seqs = "/home/nvergoulidis/scripts/uniprot_sprot.fasta"
params.interproscan_dir = "/home/nvergoulidis/interproscan-5.63-95.0"
params.outdir = "/home/nvergoulidis/scripts/results/"



process INTERPROSCAN {

    publishDir "${params.outdir}/annotations/interproscan", mode: "copy" label "ips"

    debug true

    input :
    path input_seq

    output :
    path "${input_seq}.tsv"

    script:
    """
    ${params.interproscan_dir}/interproscan.sh -appl Pfam,PANTHER,TIGRFAM,SUPERFAMILY -dp -i ${input_seq}  -f tsv -etra -cpu 16
    """
}


process FISHERMAN {


    input :
    path ips_tsv

    output :
    path "${ips_tsv}"

    script:
    """
    fisherman.py -i ${ips_tsv} -o ${params.outdir}${ips_tsv}.txt
    """
}

workflow {
    Channel
        .fromPath(params.seqs)
        .flatten()
        .splitFasta(by : 80000 , file: true)
        .set {sep_seqs_ch}

    ips_ch = INTERPROSCAN(sep_seqs_ch).view()
    FISHERMAN(ips_ch).view()
