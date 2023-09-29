/*
 *  discovery module
 */

params.CONTAINER = "miralnso/caastools-barebones:latest"

process DISCOVERY {
    tag "$alignmentID"
    
    // Assign mid priority workload, edit accordingly
    // label 'process_medium'

    container = params.CONTAINER 

    // Define where to publish the output files.
    // publishDir(params.OUTPUT, mode: 'copy')

    input:
    tuple val(alignmentID), file(alignmentFile)

    output:
    tuple val(alignmentID), file("${alignmentID}.output")
    
    // when:
    // task.ext.when == null || task.ext.when

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
    // IDK how to add the params, let's do it in the train and pass onto the next thingie
}

workflow ct_discovery {
    take: 
        align_tuple
    main:
        DISCOVERY(align_tuple)
    emit:
        disc_out = DISCOVERY.out
}