#!/usr/bin/env nextflow

/*
#                          _              _
#                         | |            | |
#      ___ __ _  __ _ ___| |_ ___   ___ | |___
#    / __/ _` |/ _` / __| __/ _ \ / _ \| / __|
#   | (_| (_| | (_| \__ \ || (_) | (_) | \__ \
#   \___\__,_|\__,_|___/\__\___/ \___/|_|___/
#
# A Convergent Amino Acid Substitution identification 
# and analysis toolbox
#
# Author:         Fabio Barteri (fabio.barteri@upf.edu)
# Contributors:   Alejandro Valenzuela (alejandro.valenzuela@upf.edu),
#                 Xavier Farré (xfarrer@igtp.cat),
#                 David de Juan (david.juan@upf.edu),
#                 Miguel Ramon (miguel.ramon@upf.edu) - Nextflow Protocol Elaboration
#
# File: ct.nf
#
*/

/*
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *  CT Workflow: This workflow integrates the discovery and resampling modules for CAAStools.
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */


// Define the output folders
align_tuple = Channel
                .fromPath("${params.alignment}/*")
                .map { file -> tuple(file.baseName, file) }

nw_tree = file(params.tree)

// Import local modules/subworkflows
include { ct_discovery } from "${baseDir}/modules/ct_discovery" addParams(ALIGN_TUPLE: align_tuple, LABEL:"twocpus")
include { ct_resample } from "${baseDir}/modules/ct_resample" addParams(NW_TREE: nw_tree, LABEL:"twocpus")
include { ct_bootstrap } from "${baseDir}/subworkflows/ct_discovery" addParams(ALIGN_TUPLE: align_tuple, LABEL:"twocpus")

// Main workflow
def toolsToRun = params.ct_tool.split(',')

workflow CT {
    if (toolsToRun.contains('discovery')) {
        discovery_out = ct_discovery(align_tuple)
    }
    if (toolsToRun.contains('resample')) {
        resample_out = ct_resample(nw_tree)
    }
    if (toolsToRun.contains('bootstrap')) {
        bootstrap_out = ct_bootstrap(discovery_out, resample_out)
    }
}

workflow.onComplete {
    println ( workflow.success ? "\nYay!\n" : "Oops .. something went wrong" )
}
