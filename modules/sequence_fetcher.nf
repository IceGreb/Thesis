process HMMER_FETCHER {
    publishDir "${params.outdir}", mode: "copy"

    debug true //process stdout shows in terminal

    input :
    path input_table
    path input_fasta

    output :
    path "*.fasta", emit: hmmer_SeqCatches

    script:
    """
    sequence_fetcher.py -t ${input_table} -f ${input_fasta}
    """

}

process IPS_FETCHER {
    publishDir "${params.outdir}", mode: "copy"

    debug true

    input :
    path input_table
    path input_fasta

    output :
    path "*.fasta", emit: IPS_SeqCatches

    script:
    """
    sequence_fetcher.py -t ${input_table} -f ${input_fasta}
    """

}