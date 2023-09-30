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
# File: ct_discovery.nf
#
*/

/*
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *  DISCOVERY module: This module is responsible for the discovery process based on input alignments.
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */

// Uncomment the following line if you want to use a specific container.
// params.CONTAINER = "miralnso/caastools-micromamba:latest"

process DISCOVERY {
    tag "$alignmentID"
    
    // Uncomment the following lines to assign workload priority, container, and output directory.
    // label 'process_medium'
    // container = params.CONTAINER 
    // publishDir(params.OUTPUT, mode: 'copy')

    input:
    tuple val(alignmentID), file(alignmentFile)

    output:
    tuple val(alignmentID), file("${alignmentID}.output")

    script:
    // Define extra discovery arguments from params.file
    def args = task.ext.args ?: ''

    """    
    ct discovery \\
        -a ${alignmentFile} \\
        -t ${params.traitfile} \\
        -o ${alignmentID}.output \\
        --fmt ${params.ali_format} \\
        ${args.replaceAll('\n', ' ')}
    """
    // Note: If unsure about how to add params, consider defining them in a separate config or parameters file.
}

workflow ct_discovery {
    take: 
        align_tuple
    main:
        DISCOVERY(align_tuple)
    emit:
        disc_out = DISCOVERY.out
}
