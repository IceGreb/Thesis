process FISHERMAN {
    publishDir "${params.outdir}/fisherman", mode: "copy" 
    debug true
    errorStrategy 'ignore'


    input :
    path ips_tsv

    output :
    path "*.tsv" , emit: fishes_tsv

    script:
    """
    fisherman.py -i ${ips_tsv} -o ${ips_tsv}
    """
}