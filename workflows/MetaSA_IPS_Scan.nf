
/* Metagenomics Sequence Analysis Pipeline written in nextflow
 *  utilizing InterproScan toolkit
 * In its current state it searches for 4 major domain categories
 *  against a major db (like UniParc) with output results in:
 *  unique protein hits - a summary for each category - a .fasta output of resulting 
 * hits and its sequences to be further utilized for clustering and modeling
  */
log.info """\
    M e t a S A - InterPro S C A N   P I P E L I N E
    ===================================
    interproscan : ${params.ips_dir}
    fasta_file   : ${params.fasta_folder}
    outdir       : ${params.outdir}
    """
    .stripIndent(true)
include { IPS         } from '../MetaSA-scan/modules/IPS'
include { FISHERMAN   } from '../MetaSA-scan/modules/fisherman'
include { COUNTER     } from '../MetaSA-scan/modules/IPS_counter'
include { IPS_FETCHER } from '../MetaSA-scan/modules/sequence_fetcher'



workflow MetaSA_IPS_Scan {
    Channel
        .fromPath(params.fasta_folder, checkIfExists: true)
        .splitFasta(by : 1,file : true)
        .set {query_fasta_ch}
        
        

    IPS(query_fasta_ch)
    FISHERMAN(IPS.out.ips_results_tsv)
    IPS_FETCHER(FISHERMAN.out.fishes_tsv.flatten(), query_fasta_ch).view()
    COUNTER(FISHERMAN.out.fishes_tsv.flatten())
    
            
    
}
