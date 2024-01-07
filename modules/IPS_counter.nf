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
    echo "Sum of Cocaines: ${coc_count}\nSum of Feruloyl: ${fer_count}\nSum of Nat: ${nat_count}\nSum of Pet: ${pet_count}" > !{file_names.baseName}_summary_results.txt
    
    '''
}