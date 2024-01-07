/* Metagenomics Sequence Analysis Pipeling written in nextflow
 *  utilizing hmmer toolkit
 * In its current state it searches for 4 major domain categories
 *  against a major db (like UniParc) with output results in:
 *  unique protein hits - a summary for each category - a .fasta output of resulting 
 * hits and its sequences to be further utilized for clustering and modeling
  */
  
log.info """\
    M e t a S A - hmmer S C A N   P I P E L I N E
    ===================================
    hmm_library  : ${params.hmmlib}
    fasta_file   : ${params.fasta_folder}
    outdir       : ${params.outdir}
    """
    .stripIndent(true)

/*
    ~~~~~~~~~~~~~~~~
        Imports
    ~~~~~~~~~~~~~~~~
*/
include { HMMSEARCH_LOOP } from '../MetaSA-scan/modules/hmmsearch'
include { PFAM_COUNTER   } from '../MetaSA-scan/modules/PFAM_counter'
include { HMMER_PARSER   } from '../MetaSA-scan/modules/hmmer_parser'
include { HMMER_FETCHER  } from '../MetaSA-scan/modules/sequence_fetcher'

/*
    ~~~~~~~~~~~~~~~~~~
       Run workflow
    ~~~~~~~~~~~~~~~~~~
*/

workflow {
    Channel
        .fromPath(params.fasta_folder, checkIfExists: true)
        .flatten()
        .set {query_fasta_ch}
    Channel
        .fromPath(params.hmmlib)
        .set {hmmlib_ch} 
        
    HMMSEARCH_LOOP(query_fasta_ch)
    PFAM_COUNTER(HMMSEARCH_LOOP.out.domtblout)
    HMMER_PARSER(HMMSEARCH_LOOP.out.domtblout)
    HMMER_FETCHER(HMMER_PARSER.out.hmmer_tsv, query_fasta_ch)
    
}