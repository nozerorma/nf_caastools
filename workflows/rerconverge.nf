#!/usr/bin/env nextflow

/*
#
#  PPP   H   H  Y   Y  L     L   Y   Y
#  P  P  H   H   Y Y   L     L    Y Y
#  PPP   HHHHH    Y    L     L     Y
#  P     H   H    Y    L     L     Y
#  P     H   H    Y    LLLL  LLLL  Y
#
#
# A Nextflow pipeline including a complete set
# of phylogenetic comparative tools and analyses
#
# Github: https://github.com/nozerorma/caastools/nf-phylly
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
tree_tuple = Channel
                .fromPath("${params.gene_trees}/**/*") // As of now, must be in second level
                .filter { it.isFile() } // Filter out directories
                .map { file -> tuple(file.baseName, file) }

// Define the tree file channel
trait_file = file(params.rer_traits)

// Import local modules/subworkflows
include { RERCONVERGE } from "${baseDir}/subworkflows/RERCONVERGE/rerconverge" addParams(TREE_TUPLE: tree_tuple)

// Main workflow
// def toolsToRun = params.ct_tool.split(',') NOT NEEDED UNTIL OTHER STUFF FROM RERCONVERGE IS INCLUDED

workflow RER_MAIN {

    rer_out = RERCONVERGE(tree_tuple)

}

workflow.onComplete {
    println ( workflow.success ? "\RERConverge analysis was completed successfully!\n" : "Oops .. something went wrong" )
}
