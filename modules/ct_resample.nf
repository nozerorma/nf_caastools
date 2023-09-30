/*
 *  discovery module
 */

//params.CONTAINER = "miralnso/caastools-micromamba:latest"

process RESAMPLE {
    tag "$nw_tree"
    
    //container = params.CONTAINER 
    
    input:
    path nw_tree

    output:
    tuple val(nw_tree), file("${nw_tree}.resampled.output")
    
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