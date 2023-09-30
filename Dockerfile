## Emacs, make this -*- mode: sh; -*-

# Use debian slim image with micromamba

ARG BASE_IMAGE=debian:bookworm-slim

# Mutli-stage build to keep final image small. Otherwise end up with
# curl and openssl installed
FROM --platform=$BUILDPLATFORM $BASE_IMAGE AS stage1
ARG VERSION=1.5.1

LABEL image.author.name "Miguel Ramon"
LABEL image.author.email "miguel.ramon@upf.edu"

COPY --chown=$MAMBA_USER:$MAMBA_USER env.yaml /tmp/env.yaml

RUN micromamba create -n caastools

RUN micromamba install -y -n caastools -f /tmp/env.yaml && \
    micromamba clean --all --yes

USER $MAMBA_USER

# JIC
RUN pip3 install --upgrade pip

# Set CAASTools WD and build directory structure
WORKDIR /ct
RUN mkdir -p ./requirements ./modules ./scripts
ADD requirements/requirements.txt ./requirements/
ADD modules/ ./modules/
ADD scripts/ ./scripts/

# Make ct executable and add to $PATH
ADD ct .
RUN chmod +x ./ct
ENV PATH=/ct:$PATH
ENV PATH /opt/conda/envs/nf-tutorial/bin:$PATH

# Installing Python libraries (Discovery/Bootstrap/Resample)
RUN pip3 install -r requirements/requirements.txt

CMD ["bash"]