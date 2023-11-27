#!/usr/bin/env nextflow

/*
#
#
#  ██████╗ ██╗  ██╗██╗   ██╗██╗      ██████╗ ██████╗ ██╗  ██╗███████╗██████╗ ███████╗
#  ██╔══██╗██║  ██║╚██╗ ██╔╝██║     ██╔═══██╗██╔══██╗██║  ██║██╔════╝██╔══██╗██╔════╝
#  ██████╔╝███████║ ╚████╔╝ ██║     ██║   ██║██████╔╝███████║█████╗  ██████╔╝█████╗  
#  ██╔═══╝ ██╔══██║  ╚██╔╝  ██║     ██║   ██║██╔═══╝ ██╔══██║██╔══╝  ██╔══██╗██╔══╝  
#  ██║     ██║  ██║   ██║   ███████╗╚██████╔╝██║     ██║  ██║███████╗██║  ██║███████╗
#  ╚═╝     ╚═╝  ╚═╝   ╚═╝   ╚══════╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝
#                                                                                    
#                                      
# PHYLOPHERE: A Nextflow pipeline including a complete set
# of phylogenetic comparative tools and analyses for Phenome-Genome studies
#
# Github: https://github.com/nozerorma/caastools/nf-phylophere
#
# Author:         Miguel Ramon (miguel.ramon@upf.edu)
#
# File: rer_cont.R
#
*/

/*
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *  DISCOVERY module: This module is responsible for the discovery process based on input alignments.
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */
process RER_CONT {
    tag "$rer_matrix"

    // Uncomment the following lines to assign workload priority.
    // label 'big_mem'


    input:
    path trait_file
    path rer_master_tree
    path rer_matrix


    output:
    file(${ rer_matrix }.continuous.output )
    file(${ rer_matrix }.pval.output )
    file(${ rer_matrix }.lfc.output )



    script:
    // Define extra discovery arguments from params.file
    def args = task.ext.args ?: ''

    """
        /usr/local/bin/_entrypoint.sh Rscript \\
        '$baseDir/scripts/continuous_rer.R' \\
        ${ trait_file } \\
        ${ rer_master_tree } \\
        ${ rer_matrix } \\
        ${ rer_matrix }.output \\
        ${ rer_matrix }.pval.output \\
        ${ rer_matrix }.lfc.output \\
        $args
    """
}
