#!/usr/bin/bash
echo << EOT >environment.yml "
name: openfold-env 
channels:
  - conda-forge
  - bioconda
  - pytorch
  - nvidia 
dependencies:
  - cuda==12.4.*
  - nvidia/label/cuda-12.4.0::cuda-toolkit
  - python=3.10.*
  - ipykernel
  - ipython
  - libgcc=7.2
  - setuptools=59.5.0
  - pip
  - openmm=7.7
  - pdbfixer
  - pytorch-lightning
  - biopython
  - numpy<2.0.0
  - pandas
  - PyYAML==5.4.1
  - requests
  - scipy
  - tqdm==4.62.2
  - typing-extensions
  - wandb
  - modelcif==0.7
  - awscli
  - ml-collections
  - mkl=2022.1
  - aria2
  - jupyter_client
  - jupyter_core
  - git
  - bioconda::hmmer
  - bioconda::hhsuite
  - bioconda::kalign2
  - dm-tree
  - pytorch-cuda=12.4
  - torchaudio==2.4.1
  - torchvision==0.19.1
  - pytorch==2.4.1
  - pip:
      - git+file:///scratch.global/${USER}/git/DeepSpeedgit
      - deepspeed==0.12.4
      - flash-attn 
      - git+file:///scratch.global/${USER}/git/dllogger
      - git+file:///scratch.global/${USER}/git/openfold
"
EOT
echo "running... mamba env create -f environment.yml"
mamba env create -f environment.yml
