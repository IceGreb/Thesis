#!/bin/bash
folder_path="/home/nvergoulidis/MetaSA-scan/testing_results"
for file in "$folder_path"/uniparc_active_p*.domtblout; do
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
    }' "$file" > "${file}_output.txt"
done
