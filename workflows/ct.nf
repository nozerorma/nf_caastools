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


// Define the alignment channel align_tuple
align_tuple = Channel
                .fromPath("${params.alignment}/**/*")
                .filter { it.isFile() } // Filter out directories
                .map { file -> tuple(file.baseName, file) }

// Define the tree file channel (maybe these could be transformed in to a tuple fashion as the alignments)
// The logic behind this should be checked. Are we using different traitfiles, trees, templates, **groupings**, or traitvalues?
nw_tree = file(params.tree)

// Import local modules/subworkflows
include { DISCOVERY } from "${baseDir}/subworkflows/ct_discovery" addParams(ALIGN_TUPLE: align_tuple, LABEL:"twocpus")
include { RESAMPLE } from "${baseDir}/subworkflows/ct_resample" addParams(NW_TREE: nw_tree, LABEL:"twocpus")
include { BOOTSTRAP } from "${baseDir}/subworkflows/ct_bootstrap" addParams(ALIGN_TUPLE: align_tuple, LABEL:"twocpus")

// Main workflow
def toolsToRun = params.ct_tool.split(',')

workflow CT {
    if (toolsToRun.contains('discovery')) {
        discovery_out = DISCOVERY(align_tuple)
        aggregate_out = AGGREGATE(discovery_out)
    }
    if (toolsToRun.contains('resample')) {
        resample_out = RESAMPLE(nw_tree)
    }
    if (toolsToRun.contains('bootstrap')) {
        boostrap_out = BOOTSTRAP(align_tuple, resample_out)
    }
}

workflow.onComplete {
    println ( workflow.success ? "\nYay!\n" : "Oops .. something went wrong" )
}
