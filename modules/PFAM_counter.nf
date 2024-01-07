process PFAM_COUNTER {
    /*
 * Counting unique protein hits from hmmsearch results
 * Requries .domtblout as input 
 * outputs results by category in .txt
 */
    publishDir "${params.outdir}", mode: "copy"

    debug true

    input :
    path input_tblout

    output:
    path "*.txt"

    shell:
    '''
    awk '!seen[$1]++ {
        if ($5 == "PF00082.26" || $5 == "PF05922.20") {
            natt += 1
        } else if ($5 == "PF00135.32" || $5 == "PF02129.22" || $5 == "PF08530.14") {
            cocaine += 1
        } else if ($5 == "PF01764.29" || $5 == "PF07519.15" || $5 == "PF10503.13") {
            feruloyl += 1
        } else if ($5 == "PF12740.11") {
            petases += 1
        }
    }
    END {
        print "Natt = " natt
        print "Cocaine = " cocaine
        print "Feruloyl = " feruloyl
        print "Petases = " petases
    }' !{input_tblout} > !{input_tblout}_summary.txt
    '''
}