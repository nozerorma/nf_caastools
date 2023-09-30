/*
 *  discovery module
 */

params.CONTAINER = "miralnso/caastools-barebones:latest"

process RESAMPLE {
    service:
    image 'wem26/rerconverge:latest'
    
    tag "$tree"

    container = params.CONTAINER 

    output:
    tuple val(tree), file("${tree}.resampled.output")
    
    script:
    def args = task.ext.args ?: ''
    def strategyCommand = ""
    
    if (params.strategy == "FGBG") {
        strategyCommand = "-f ${params.fgsize} -b ${params.bgsize} -m random"  // replace with actual command for this strategy
    } else if (params.strategy == "TEMPLATE") {
        strategyCommand = "--bytemp ${params.template} -m random"  // replace with actual command for this strategy
    } else if (params.strategy == "PHYLORESTRICTED") {
        strategyCommand = "--bytemp ${params.template} --limit_by_group ${params.group}"  // replace with actual command for this strategy
    } else if (params.strategy == "BM") {
        conda 
        strategyCommand = "--bytemp ${params.template} --mode bm"
    } else {
        exit 1, "Invalid strategy: ${params.strategy}"
    }

    """
    ct resample \\
        -p ${tree} \\
        -o ${alignmentID}.resampled.output \\
        ${strategyCommand} \\
        $args
    """
}

workflow ct_resample {
    take:
        tree
    main:
        RESAMPLE(tree)
    emit:
        resamp_out = RESAMPLE.out
}