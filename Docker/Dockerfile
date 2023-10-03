#                          _              _
#                         | |            | |
#      ___ __ _  __ _ ___| |_ ___   ___ | |___
#    / __/ _` |/ _` / __| __/ _ \ / _ \| / __|
#   | (_| (_| | (_| \__ \ || (_) | (_) | \__ \
#   \___\__,_|\__,_|___/\__\___/ \___/|_|___/
#
# A Convergent Amino Acid Substitution identification 
# and analysis toolbox - Nextflow edition
#
# Github: https://github.com/nozerorma/caastools/blob/nextflow-rize
#
# Author:         Fabio Barteri (fabio.barteri@upf.edu)
# Contributors:   Alejandro Valenzuela (alejandro.valenzuela@upf.edu),
#                 Xavier Farré (xfarrer@igtp.cat),
#                 David de Juan (david.juan@upf.edu),
#                 Miguel Ramon (miguel.ramon@upf.edu) - Nextflow Protocol Elaboration
#
# File: Dockerfile
#

# Set image origin to micromamba for a stripped down, immutable Debian-Conda environment.
FROM mambaorg/micromamba:1.5.1

LABEL image.author.name "Miguel Ramon"
LABEL image.author.email "miguel.ramon@upf.edu"

# Set root as default user due to some funky behavour when using $MAMBA_USER.
USER root

# Download some basic debian tools + procps (Nextflow dependency).
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get install -qq -y --no-install-recommends \
        software-properties-common \
        dirmngr \
        ed \
        gpg-agent \
		less \
		locales \
		vim-tiny \
		ca-certificates \
        procps

# Add environment file to the Docker image.
COPY env.yml /tmp/env.yml

# Create micromamba environment with the specifics from env.yml.
RUN micromamba install -y -n base -f /tmp/env.yml && \
    micromamba clean --all --yes

# Add RERconverge package manually to the R library of the newly created environment
## I could not find the culprit to this. Both BioConda and BioContainers RERConverge images fail to
## properly add the package to the library. RERConverge was still specified in the conda env.yml
## as I'm pretty confident it does install its requirements, as the image stayed pretty the same
## size-wise. This should be furtherly inspected though.

COPY RERconverge /opt/conda/lib/R/library/RERconverge


# Set CAASTools as WD and create build directory structure.
# Add all the requirements for CAAStools.
WORKDIR /ct

RUN mkdir -p ./modules ./scripts

ADD  modules/ ./modules/
ADD  scripts/ ./scripts/

# permulations.r is added to workDir due to how ct is configured.
ADD  scripts/permulations.r .
ADD ct .

# Make ct and permulations.r executable and 
RUN chmod +x ./ct
RUN chmod +x ./permulations.r

# Add ct and conda binary to $PATH
ENV PATH=/ct:$PATH
ENV PATH /opt/conda/envs/base/bin:$PATH

# Set the image to be run inside base environment directly
ENTRYPOINT ["/usr/local/bin/_entrypoint.sh"]