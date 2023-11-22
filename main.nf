#!/usr/bin/env nextflow

/*
#
#  PPP   H   H  Y   Y  L     L   Y   Y
#  P  P  H   H   Y Y   L     L    Y Y
#  PPP   HHHHH    Y    L     L     Y
#  P     H   H    Y    L     L     Y
#  P     H   H    Y    LLLL  LLLL  Y
#
#
# A Nextflow pipeline including a complete set
# of phylogenetic comparative tools and analyses
#
# Github: https://github.com/nozerorma/caastools/nf-phylly
#
# Author:         Miguel Ramon (miguel.ramon@upf.edu)
#
# File: main.nf
#
*/

/*
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *
 * Unlock the secrets of evolutionary relationships with Phylly! 🌳🔍 This Nextflow pipeline
 * packs a powerful punch, offering a comprehensive suite of phylogenetic comparative tools
 * and analyses. Dive into the world of evolutionary biology like never before and elevate
 * your research to new heights! 🚀🧬 #Phylly #EvolutionaryInsights #NextflowPipeline
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */

nextflow.enable.dsl = 2

version = "0.0.1"

// Display input parameters
log.info """

CAASTOOL - N F PIPELINE  ~  version ${version}
=============================================

 A Convergent Amino Acid Substitution identification
 and analysis toolbox

 Author:         Fabio Barteri (fabio.barteri@upf.edu)
 Contributors:   Alejandro Valenzuela (alejandro.valenzuela@upf.edu),
                 Xavier Farré (xfarrer@igtp.cat),
                 David de Juan (david.juan@upf.edu),
                 Miguel Ramon (miguel.ramon@upf.edu) - Nextflow Protocol Elaboration

"""

/*
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *  NAMED WORKFLOW FOR PIPELINE: This section includes the main CT workflow from the ct.nf file.
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */

include {HELP} from './workflows/help.nf'
include {CT} from './workflows/ct.nf'
include {RERCONVERGE} from './workflows/rerconverge.nf'
include {ORA} from './workflows/ora.nf'

/*
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *  RUN CAASTOOLS ANALYSIS: This section initiates the main CT workflow.
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */

workflow {

    // Check if --help is provided
    if (params.help) {
        HELP ()
    } elif {
        CT ()
    } elif {
        RERCONVERGE()
    } elif {
        ORA
    }
}


/*
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *  THE END: End of the main.nf file.
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */
