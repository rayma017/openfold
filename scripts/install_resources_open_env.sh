#!/bin/bash
set -e
#
# Copyright 2021 DeepMind Technologies Limited
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# Download folding resources
wget -N --no-check-certificate -P ${OPENFOLD_HOME}/resources \
    https://git.scicore.unibas.ch/schwede/openstructure/-/raw/7102c63615b64735c4941278d92b554ec94415f8/modules/mol/alg/src/stereo_chemical_props.txt
aws s3 cp --no-sign-request --region us-east-1 s3://openfold/openfold_params/ "${OPENFOLD_HOME}/resources/openfold_params" --recursive
aws s3 cp --no-sign-request --region us-east-1 s3://openfold/openfold_soloseq_params/ "${OPENFOLD_HOME}/resources/openfold_soloseq_params" --recursive

SOURCE_URL="https://storage.googleapis.com/alphafold/alphafold_params_2022-12-06.tar"
BASENAME=$(basename "${SOURCE_URL}")

mkdir --parents "${OPENFOLD_HOME}/resources/params"
aria2c "${SOURCE_URL}" --dir="${OPENFOLD_HOME}/resources/params"
tar --extract --verbose --file="${OPENFOLD_HOME}/resources/params/${BASENAME}" \
  --directory="${OPENFOLD_HOME}/resources/params" --preserve-permissions
rm "${OPENFOLD_HOME}/resources/params/${BASENAME}"



conda env config vars set OPENFOLD_PARAMS_DIR=${OPENFOLD_HOME}/resources/openfold_params

conda env config vars set OPENFOLD_SOLOSEQ_PARAMS_DIR=${OPENFOLD_HOME}/resources/openfold_soloseq_params

conda env config vars set ALPHAFOLD_PARAMS_DIR=${OPENFOLD_HOME}/resources/params

