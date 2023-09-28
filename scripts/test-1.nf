params.seqs = "$projectDir/testing/"
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
    debug true


    input :
    path ips_tsv

    output :
    path "${ips_tsv}"

    script:
    """
    fisherman.py -i ${ips_tsv} -o ${params.outdir}${ips_tsv}.tsv
    """
}

workflow {
    Channel
        .fromPath(params.seqs) //not working atm
        .flatten()
        .splitFasta(by : 150000 , file: true)
        .set {sep_seqs_ch}

    ips_ch = IPS(sep_seqs_ch).view()
    fish_ch= FISHERMAN(ips_ch).view()
}