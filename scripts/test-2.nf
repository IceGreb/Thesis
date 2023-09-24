//First implement of nextflow tsv parsing for easy access to pattern matching with python in following step
params.seqs = "$projectDir/separated_seqs/"
params.ips_dir = "~/interproscan-5.63-95.0"
params.outdir = "$projectDir/results/"

log.info """\
    MG - N F   P I P E L I N E
    ===================================
    interproscan : ${params.ips_dir}
    sequences        : ${params.seqs}
    outdir       : ${params.outdir}
    """
    .stripIndent(true)


/*
 * define Interposcan process that performs ips analysis against databases
 * mentioned in the script code block given input sequences and
 * outputs results as .tsv
 */
process IPS {

    publishDir "${params.outdir}/annotations/interproscan", mode: "copy" label "ips"

    debug true //process stdout shows in terminal

    input :
    path input_seq

    output :
    path "${input_seq}.tsv"

    script:
    """
    ${params.ips_dir}/interproscan.sh -appl Pfam,PANTHER,TIGRFAM,SUPERFAMILY -dp -i ${input_seq}  -f tsv -etra -cpu 16
    """
}

workflow {
    Channel
        .fromPath('/home/nvergoulidis/scripts/separated_secs/separated_secs.test2.txt') //not working atm
        .flatten()
        .splitFasta(by : 1 , file: true)
        .set {sep_seqs_ch}

    ips_ch = IPS(sep_seqs_ch).view()

        .splitCsv(sep: '\t', header: ['prot_asc','seqMD5digest','SeqLength','Analysis','SignAscen','SignDescr','Start','End','Score','Status','Date','IPRacc'])
        .view { row-> "${row.prot_asc}, ${row.Start}"}
}
