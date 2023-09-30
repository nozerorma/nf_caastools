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
# File: ct_resample.nf
#
*/

/*
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *  RESAMPLE module: This module is responsible for resampling based on different strategies.
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */

// Uncomment the following line if you want to use a specific container.
// params.CONTAINER = "miralnso/caastools-micromamba:latest"

process RESAMPLE {
    tag "$nw_tree"

    // Uncomment the following lines to assign workload priority, container, and output directory.
    // label 'process_medium'
    // container = params.CONTAINER 
    // publishDir(params.OUTPUT, mode: 'copy')


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
        strategyCommand = "--bytemp ${params.template} --mode bm"
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
