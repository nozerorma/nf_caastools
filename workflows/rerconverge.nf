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
# File: rerconverge.nf
#
*/

/*
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *
 * Unlock the secrets of evolutionary relationships with Phylly! 🌳🔍 This Nextflow pipeline
 * packs a powerful punch, offering a comprehensive suite of phylogenetic comparative tools
 * and analyses. Dive into the world of evolutionary biology like never before and elevate
 * your research to new heights! 🚀🧬 #Phylly #EvolutionaryInsights #NextflowPipeline
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */


// Define the gene tree channel tree_tuple
gene_trees_file = file( params.gene_trees )

// Define the trait file channel
cancer_traitfile = file( params.cancer_traits )
trait_file = file( params.rer_traits )
rer_matrix_file = file( params.rer_matrix )
rer_results_file = file( params.rer_rds )

// Import local modules/subworkflows
include { RER_TRAIT } from "${baseDir}/subworkflows/RERCONVERGE/rer_trait"
include { RER_OBJ } from "${baseDir}/subworkflows/RERCONVERGE/rer_obj" 
include { RER_CONT } from "${baseDir}/subworkflows/RERCONVERGE/rer_cont"
//include { RER_ENRICH } from "${baseDir}/subworkflows/RERCONVERGE/rer_enrich" addParams(TREE_TUPLE: tree_tuple)

// Main workflow
// def toolsToRun = params.ct_tool.split(',') NOT NEEDED UNTIL OTHER STUFF FROM RERCONVERGE IS INCLUDED

workflow RER_MAIN {
    if (params.rer_tool) {
        def toolsToRun = params.rer_tool.split(',')
        if (toolsToRun.contains('build_trait')) {
            RER_TRAIT(cancer_traitfile)
            RER_OBJ(gene_trees_file, RER_TRAIT.out)
        }
        if (toolsToRun.contains('continuous')) {
            continuous_out = RER_CONT(trait_file, rer_matrix_file, rer_results_file)
        }
    /*     if (toolsToRun.contains('enrichment')) {
            enrichment_out = RER_ENRICH()
        } */
    }
}

workflow.onComplete {
    println ( workflow.success ? "\nYay RER!\n" : "Oops .. something went wrong" )
}
