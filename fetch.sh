#!/bin/bash
: '
Copyright 2021 The Kubernetes Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
'
set -e
variables_file="sync/shared/variables.yaml"

# kubernetes version can be passed as param, otherwise it will be read from variables_file, otherwise it uses the default "1.21.0"
kubernetes_sha=$1
if [ -z ${kubernetes_sha} ]; then
  if [ -f ${variables_file} ]; then
    kubernetes_sha=$(awk '/kubernetes_sha/ {print $2}' ${variables_file} | sed -e 's/^"//' -e 's/"$//'); #read param from file
    echo "using kubernetes version $kubernetes_version (read from ${variables_file})"
  else
    kubernetes_sha="cb303e613a121a29364f75cc67d3d580833a7479"
    echo "using kubernetes version ${kubernetes_sha} (using default)"
  fi
else
  echo "using kubernetes version ${kubernetes_sha} (passed as parameter)"
fi

if [[ -d "kubernetes" ]] ; then
  echo "kubernetes/ exists, not cloning..."
  pushd kubernetes
    git checkout $kubernetes_sha
  popd
else
  git clone https://github.com/kubernetes/kubernetes.git
  pushd kubernetes
    git checkout $kubernetes_sha
  popd
fi


# BELOW THIS LINE ADD YOUR CUSTOM BUILD LOGIC #########
# FOR EXAMPLE
# pushd kubernetes
# git fetch origin refs/pull/97812/head:antonio
# git checkout -b antonio
# rm -rf _output
# pop
