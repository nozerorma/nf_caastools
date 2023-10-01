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
# File: ct_bootstrap.nf
#
*/

/*
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *  RESAMPLE module: This module is responsible for bootstraping on different discovery groups.
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */


process RESAMPLE {
    tag "$nw_tree"

    // Uncomment the following lines to assign workload priority.
    // label 'process_medium'


    input:
    path nw_tree

    output:
    tuple val(nw_tree), file("${nw_tree}.resampled.output")
    
    script:
    def args = task.ext.args ?: ''
    def strategyCommand = ""
    
    // Determine the strategy command based on the provided strategy
    if (params.strategy == "FGBG") {
        strategyCommand = "-f ${params.fgsize} -b ${params.bgsize} -m random"
    } else if (params.strategy == "TEMPLATE") {
        strategyCommand = "--bytemp ${params.template} -m random"
    } else if (params.strategy == "PHYLORESTRICTED") {
        strategyCommand = "--bytemp ${params.template} --limit_by_group ${params.group}"
    } else if (params.strategy == "BM") {
        strategyCommand = "--bytemp ${params.template} --traitvalues ${params.traitvalues} --mode bm"
    } else {
        exit 1, "Invalid strategy: ${params.strategy}"
    }

    """
    ct resample \\
        -p ${nw_tree} \\
        -o ${nw_tree}.resampled.output \\
        ${strategyCommand} \\
        $args
    """
}

workflow ct_resample {
    take:
        nw_tree
    main:
        RESAMPLE(nw_tree)
    emit:
        resamp_out = RESAMPLE.out
}
