## Emacs, make this -*- mode: sh; -*-

FROM mambaorg/micromamba:1.5.1

LABEL image.author.name "Miguel Ramon"
LABEL image.author.email "miguel.ramon@upf.edu"

USER root

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
		ca-certificates

COPY --chown=$MAMBA_USER:$MAMBA_USER env.yml /tmp/env.yml


RUN micromamba install -y -n base -f /tmp/env.yml && \
    micromamba clean --all --yes


# Set CAASTools WD and build directory structure
WORKDIR /ct

RUN mkdir -p ./modules ./scripts
COPY --chown=$MAMBA_USER:$MAMBA_USER modules/ ./modules/
COPY --chown=$MAMBA_USER:$MAMBA_USER scripts/ ./scripts/

# Make ct executable and add to $PATH
COPY --chown=$MAMBA_USER:$MAMBA_USER ct .
RUN chmod +x ./ct

ENV PATH=/ct:$PATH
ENV PATH /opt/conda/envs/caastools/bin:$PATH

USER $MAMBA_USER