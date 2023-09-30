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

nextflow.enable.dsl=2

version = "0.0.1"
params.help = false  // Prevents a warning of undefined parameter

// Display input parameters
log.info """
BIOCORE@CRG - N F TESTPIPE  ~  version ${version}
=============================================
alignment                   : ${params.alignment}
fmt                         : ${params.ali_format}
config                      : ${params.traitfile}
"""

// Display help message if --help parameter is used in the command line
// Display help message if --help parameter is used in the command line
if (params.help) {
    log.info """
CAASTOOLS version 0.9 (beta)
Convergent Amino Acid Substitution detection and analysis TOOLbox

General usage:          > ct [tool] [options]
Help for single tool:   > ct [tool] --help

Tools           Description
--------        -------------------------------------------------
discovery       Detects Convergent Amino Acid Substitutions (CAAS) from
                a single Multiple Sequence Alignment (MSA).

resample        Resamples virtual phenotypes for CAAS bootstrap analysis.

bootstrap       Runs CAAS bootstrap analysis on a on a single MSA.
    """
    exit 1
}

// Define the output folders
align_tuple = Channel
                .fromPath("${params.alignment}/*")
                .map { file -> tuple(file.baseName, file) }

nw_tree = file(params.tree)

// Import local modules/subworkflows
include { ct_discovery } from "${baseDir}/modules/ct_discovery" addParams(ALIGN_TUPLE: align_tuple, LABEL:"twocpus")
include { ct_resample } from "${baseDir}/modules/ct_resample" addParams(NW_TREE: nw_tree, LABEL:"twocpus")
// include { ct_bootstrap } from "${baseDir}/subworkflows/ct_discovery" addParams(ALIGN_TUPLE: align_tuple, LABEL:"twocpus")
// Include other modules as needed

// Main workflow
workflow CT {
    discovery_out = ct_discovery(align_tuple)
    resample_out = ct_resample(nw_tree)
}

workflow.onComplete {
    println ( workflow.success ? "\nYay!\n" : "Oops .. something went wrong" )
}
