/*
 *  discovery module
 */

params.CONTAINER = "miralnso/caastools-barebones:latest"

process RESAMPLE_FGBG {
    tag "$alignmentID"
    
    // Assign mid priority workload, edit accordingly
    // label 'process_medium'

    container = params.CONTAINER 

    // Define where to publish the output files.
    // publishDir(params.OUTPUT, mode: 'copy')

    output:
    tuple val(alignmentID), file("${alignmentID}.resampled.output")
    
    // when:
    // task.ext.when == null || task.ext.when

    script:
    // Define extra discovery arguments from params.file
    def args = task.ext.args ?: ''

    """    
    ct resample \\
        -p ${tree} \\
        --bytemp ${template} \\
        -o ${alignmentID}.resampled.output \\
        -m ${params.ali_format} \\
        ${args.replaceAll('\n', ' ')}
    """
    // IDK how to add the params, let's do it in the train and pass onto the next thingie
}

process RESAMPLE_TEMPLATE {
    tag "$alignmentID"
    
    // Assign mid priority workload, edit accordingly
    // label 'process_medium'

    container = params.CONTAINER 

    // Define where to publish the output files.
    // publishDir(params.OUTPUT, mode: 'copy')
    
    output:
    tuple val(alignmentID), file("${alignmentID}.resampled.output")
    
    // when:
    // task.ext.when == null || task.ext.when

    script:
    // Define extra discovery arguments from params.file
    def args = task.ext.args ?: ''

    """    
    ct resample \\
        -p ${tree} \\
        --bytemp ${template} \\
        -o ${alignmentID}.resampled.output \\
        -m ${params.ali_format} \\
        ${args.replaceAll('\n', ' ')}
    """
    // IDK how to add the params, let's do it in the train and pass onto the next thingie
}

process RESAMPLE_PHYLORESTRICTED {
    tag "$alignmentID"
    
    // Assign mid priority workload, edit accordingly
    // label 'process_medium'

    container = params.CONTAINER 

    // Define where to publish the output files.
    // publishDir(params.OUTPUT, mode: 'copy')
    
    output:
    tuple val(alignmentID), file("${alignmentID}.resampled.output")
    
    // when:
    // task.ext.when == null || task.ext.when

    script:
    // Define extra discovery arguments from params.file
    def args = task.ext.args ?: ''

    """    
    ct resample \\
        -p ${tree} \\
        --bytemp ${template} \\
        -o ${alignmentID}.resampled.output \\
        -m ${params.ali_format} \\
        ${args.replaceAll('\n', ' ')}
    """
    // IDK how to add the params, let's do it in the train and pass onto the next thingie
}

process RESAMPLE_BM {
    tag "$alignmentID"
    
    // Assign mid priority workload, edit accordingly
    // label 'process_medium'

    container = params.CONTAINER 

    // Define where to publish the output files.
    // publishDir(params.OUTPUT, mode: 'copy')
    
    output:
    tuple val(alignmentID), file("${alignmentID}.resampled.output")
    
    // when:
    // task.ext.when == null || task.ext.when

    script:
    // Define extra discovery arguments from params.file
    def args = task.ext.args ?: ''

    """    
    ct resample \\
        -p ${tree} \\
        --bytemp ${template} \\
        -o ${alignmentID}.resampled.output \\
        -m ${params.ali_format} \\
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