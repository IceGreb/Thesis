params.seqs = ""
params.ips_dir = "~/interproscan-5.63-95.0"
params.outdir = "$projectDir/results/"

log.info """\
    MG - N F   P I P E L I N E
    ===================================
    interproscan : ${params.ips_dir}
    fasta_file   : ${params.seqs}
    outdir       : ${params.outdir}
    """
    .stripIndent(true)


/*
 * define Interposcan process that performs ips analysis against databases
 * mentioned in the script code block given input sequences and
 * outputs results as .tsv
 */
process IPS {

    publishDir "${params.outdir}/interproscan", mode: "copy" label "ips"

    debug true //process stdout shows in terminal

    input :
    path input_seq

    output :
    path "${input_seq}.tsv"

    script:
    """
    ${params.ips_dir}/interproscan.sh -appl Pfam,PANTHER,TIGRFAM,SUPERFAMILY -dp -i ${input_seq}  -f tsv -etra -cpu 8
    """
}


process FISHERMAN {
    publishDir "${params.outdir}fisherman/${ips_tsv}_catches", mode: "copy" 
    debug true


    input :
    path ips_tsv

    output :
    path "*"

    script:
    """
    fisherman.py -i ${ips_tsv} -o ${params.outdir}/fisherman
    """
}


process FETCHER {
    publishDir "${params.outdir}"
    debug true


    input :
    path input_seq
    path input_tsv

    output:
    path "*_catches.fasta"

    script:
    """
    sequence_fetcher.py -t ${input_tsv} -f ${input_seq} -o ${input_seq}_catches.fasta
    """
}
workflow {
    Channel
        .fromPath(params.seqs, checkIfExists: true) //not working atm
        .flatten()
        .splitFasta(by : 150000 , file: true)
        .set {sep_seqs_ch}
    

    ips_ch = IPS(sep_seqs_ch).view()
    fish_ch = FISHERMAN(ips_ch).view()
    catches_ch = FETCHER(fish_ch).view()
}