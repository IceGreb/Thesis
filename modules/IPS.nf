process IPS {
    //executor 'local' queueSize 1
    publishDir "${params.outdir}/interproscan_results", mode: "copy" label "ips"

    debug true //process stdout shows in terminal

    input :
    path input_seq

    output :
    path "*.tsv", emit: ips_results_tsv

    script:
    """
    ${params.ips_dir}/interproscan.sh -appl Pfam,PANTHER,TIGRFAM,SUPERFAMILY  -i ${input_seq} -o ${input_seq.baseName}.tsv -dp -f tsv -etra -cpu 40
    """
}