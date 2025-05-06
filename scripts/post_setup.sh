#!/usr/bin/bash
set -e
if [ "openfold-env" != "$(basename $CONDA_PREFIX)" ] ; then
    echo "The conda environment is set to $(basename $CONDA_PREFIX)"
    echo "Run conda activate openfold-env"
    exit
fi

# Get the absolute path of the script's directory
export script_dir=$(realpath $(dirname "${BASH_SOURCE[0]}"))
echo "Script directory: $script_dir"

if [ -e $(dirname $(dirname ${script_dir}))/cutlass ]; then
    export CUTLASS=$(dirname $(dirname ${script_dir}))/cutlass
    echo ${CUTLASS}
else
    exit
fi

if [ -z ${OPENFOLD_HOME} ]; then
        export OPENFOLD_HOME=$(dirname $(dirname $(which python3)))
fi

if [ -z ${DATA_BASENAME} ]; then
    export DATA_BASENAME=/scratch.global/${USER}/.data
    mkdir -p ${DATA_BASENAME}
fi

if [ -z ${OPENFOLD_DATA_DIR} ]; then
    export OPENFOLD_DATA_DIR=${DATA_BASENAME}/openfold/data_dir
    mkdir -p ${OPENFOLD_DATA_DIR}
fi

if [ -z ${RESOURCES_DIR} ]; then
    X=$(find /scratch.global/rayma017/.conda/envs/openfold-env/lib -name openfold)
    export RESOURCES_DIR=${X}/resources
fi

if [ -z ${CUTLASS_PATH} ]; then
    export CUTLASS_PATH=$(dirname $(dirname ${script_dir}))/cutlass
fi








if [ -e $OPENFOLD_HOME ] && [ -e $DATA_BASENAME ] && [ -e $OPENFOLD_DATA_DIR ] && [ -e $RESOURCES_DIR ] && [ -e $CUTLASS_PATH ];then
    conda env config vars set OPENFOLD_HOME=$OPENFOLD_HOME
    conda env config vars set DATA_BASENAME=$DATA_BASENAME
    conda env config vars set OPENFOLD_DATA_DIR=$OPENFOLD_DATA_DIR
    conda env config vars set RESOURCES_DIR=$RESOURCES_DIR
    echo "Set $CUTLASS_PATH is $CUTLASS_PATH, required for Deepspeed Evoformer attention kernel"
    conda env config vars set CUTLASS_PATH=$CUTLASS_PATH
    
    conda env config vars set CUDA_HOME=$(which $(which nvcc))

    # This setting is used to fix a worker assignment issue during data loading
    conda env config vars set KMP_AFFINITY=none
    
    # Set the project directory to current location
    conda env config vars set OPENFOLD_PRJ_DIR=$(dirname $script_dir)
    
    $script_dir/download_openfold_params.sh ${RESOURCES_DIR}
    
    $script_dir/download_openfold_soloseq_params.sh ${RESOURCES_DIR}
    $script_dir/download_alphafold_params.sh ${RESOURCES_DIR}

    wget -N --no-check-certificate -P   ${RESOURCES_DIR}\
        https://git.scicore.unibas.ch/schwede/openstructure/-/raw/7102c63615b64735c4941278d92b554ec94415f8/modules/mol/alg/src/stereo_chemical_props.txt

    # Certain tests need access to this file
    mkdir -p tests/test_data/alphafold/common
    if [ ! -h "tests/test_data/alphafold/common" ];then
        ln -rs ${RESOURCES_DIR}/stereo_chemical_props.txt tests/test_data/alphafold/common
    fi

    # Decompress test data
    gunzip -c tests/test_data/sample_feats.pickle.gz > tests/test_data/sample_feats.pickle
    
    echo "Post setup complete"
    
else
    echo "Check path:\n $OPENFOLD_HOME\n $DATA_BASENAME\n $OPENFOLD_DATA_DIR\n $RESOURCES_DIR\n $CUTLASS_PATH"
fi

    

conda env config vars set OPENFOLD_WORKSPACE=/scratch.global/rayma017/Workspace/openfold
