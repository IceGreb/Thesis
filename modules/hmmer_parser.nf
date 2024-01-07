process HMMER_PARSER {
    publishDir "${params.outdir}", mode: "copy"

    debug true //process stdout shows in terminal

    input :
    path input_table

    output :
    path "*.tsv", emit: hmmer_tsv

    script:
    """
    hmmer_parser.py -t ${input_table}
    """

}