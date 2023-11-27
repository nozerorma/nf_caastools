#!/usr/bin/env nextflow

/*
##
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
# File: ct.nf
#
*/

/*
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *  CT Workflow: This workflow integrates the discovery and resampling modules for CAAStools.
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */


// Define the alignment channel align_tuple
align_tuple = Channel
                .fromPath("${params.alignment}/**/*")
                .filter { it.isFile() } // Filter out directories
                .map { file -> tuple(file.baseName, file) }

// Import local modules/subworkflows
include { DISCOVERY } from "${baseDir}/subworkflows/CT/ct_discovery"
include { RESAMPLE } from "${baseDir}/subworkflows/CT/ct_resample"
include { BOOTSTRAP } from "${baseDir}/subworkflows/CT/ct_bootstrap"


// Main workflow

workflow CT {
    if (params.rer_tool) {

        def toolsToRun = params.ct_tool.split(',')

        if (toolsToRun.contains('discovery')) {
            discovery_out = DISCOVERY(align_tuple)
        }
        if (toolsToRun.contains('resample')) {
            resample_out = RESAMPLE()
        }
        if (toolsToRun.contains('bootstrap')) {
            boostrap_out = BOOTSTRAP(align_tuple, resample_out)
        }
    }    
}

workflow.onComplete {
    println ( workflow.success ? "\nYay CT!\n" : "Oops .. something went wrong" )
}
