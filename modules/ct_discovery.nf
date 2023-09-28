/*
 *  discovery module
 */

params.CONTAINER = "miralnso/caastools-barebones:latest"
params.OUTPUT = "results/${nextflow.timestamp}/discovery_output"

process DISCOVERY {
    tag "$alignmentID"
    
    // Assign low priority workload, edit accordingly
    label 'process_medium'

    container = params.CONTAINER 

    // Define where to publish the output files.
    publishDir(params.OUTPUT, mode: 'copy')

    input:
    tuple val(alignmentID), file(alignmentFile)
    file traitfile

    output:
    tuple val(alignmentID), file("${alignmentID}.output")
    
    // when:
    // task.ext.when == null || task.ext.when

    script:
    // Define extra discovery arguments from params.file
    def args = task.ext.args ?: ''
    def config = traitfile ? "--config $traitfile" : ''

    """    
    ct discovery \\
        -a ${alignmentFile} \\
        -t ${traitfile} \\
        -o ${alignmentID}.output \\
        --fmt ${params.ali_format} \\
        ${args.replaceAll('\n', ' ')}
    """
    // IDK how to add the params, let's do it in the train and pass onto the next thingie
}

workflow ct_discovery {
    take: 
        align_tuple
        traitfile
    main:
        DISCOVERY(align_tuple, traitfile)
    emit:
        disc_out = DISCOVERY.out
}