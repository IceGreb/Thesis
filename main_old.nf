params.seqs = ""
params.ips_dir = "~/interproscan-5.63-95.0"
params.outdir = "$projectDir/results/"

log.info """\
    MetaSA - S C A N   P I P E L I N E
    ===================================
    interproscan : ${params.ips_dir}
    fasta_file   : ${params.seqs}
    outdir       : ${params.outdir}
    """
    .stripIndent(true)
include { IPS            } from '../modules/IPS.nf'

/*
 * Interposcan process that performs ips analysis against databases
 * mentioned in the script code block given input sequences and
 * outputs results as .tsv
 */
process IPS {
    //executor 'local' queueSize 1
    publishDir "${params.outdir}interproscan", mode: "copy" label "ips"

    debug true //process stdout shows in terminal

    input :
    path input_seq

    output :
    path "${input_seq}.tsv"

    script:
    """
    ${params.ips_dir}/interproscan.sh -appl Pfam,PANTHER,TIGRFAM,SUPERFAMILY  -i ${input_seq} -dp -f tsv -etra -cpu 40
    """
}


process FISHERMAN {
    publishDir "${params.outdir}fisherman", mode: "copy" 
    debug true
    errorStrategy 'ignore'


    input :
    path ips_tsv

    output :
    path "*.tsv"

    script:
    """
    fisherman.py -i ${ips_tsv} -o ${params.outdir}fisherman/
    """
}

process COUNTER {
    publishDir "${params.outdir}" , mode: "copy"
    debug true 
    
    input :
    path file_names

    output :
    path "*"

    shell:
    '''
    
    coc_count=$(tail -n +2 Cocaine_*.tsv | wc -l)
    nat_count=$(tail -n +2 Nattokinases_*.tsv | wc -l)
    fer_count=$(tail -n +2 Feruloyl_*.tsv | wc -l)
    pet_count=$(tail -n +2 Petases_*.tsv | wc -l)
    echo "Sum of Cocaines: ${coc_count}\nSum of Feruloyl: ${fer_count}\nSum of Nat: ${nat_count}\nSum of Pet: ${pet_count}" > p190_summary_results.txt
    
    '''
}


process FETCHER {
    
    publishDir "${params.outdir}fetcher", mode: "copy"
    debug true
    errorStrategy 'ignore'


    input :
    path input_tsv
    
    
    output:
    path "*"

    script:
    """
    sequence_fetcher.py -t ${input_tsv} -f ${params.seqs} -o ${input_tsv}
    """
}

process MMSQ  {
    publishDir "${params.outdir}/mmseq"
    debug true

    
    input  :
    file input_fasta

    output :
    path seq_DB

    script :
    """
    mmseqs createdb ${input_fasta}  -o ${seq_DB}
    """
}
workflow {
    Channel
        .fromPath(params.seqs, checkIfExists: true)
        .flatten()
        .splitFasta(by : 160000,file : true)
        .set {sep_seqs_ch}
    

    ips_ch = IPS(sep_seqs_ch).flatten().view()
    fish_ch = FISHERMAN(ips_ch).flatten().view()
    
    fetch_ch = FETCHER(fish_ch).view()
    
    fishes = fish_ch.collect()

    COUNTER(fishes).view()
    
    
}
