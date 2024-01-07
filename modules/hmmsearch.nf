process HMMSEARCH_LOOP {
/*
 * Requires hmmsearch - TO DO: run with docker/container 
 */
    publishDir "${params.outdir}", mode: "copy"

    debug true //process stdout shows in terminal

    input :
    path input_fasta
    

    output :
    path "*.domtblout" , emit: domtblout
    path "*.tblout" , emit: tblout
    path "*.hmmout" , emit: rawout

    script:
    """
    hmmsearch --cut_tc --tblout ${input_fasta}_results_per_sequence.tblout \
        --domtblout ${input_fasta}_results_per_domain.domtblout \
        -o ${input_fasta}_raw_output.hmmout --cpu 24 ${params.hmmlib} ${input_fasta}
    """
}
