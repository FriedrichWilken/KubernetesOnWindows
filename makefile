# Copyright 2021 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

path ?= kubernetes

all: 0-fetch-k8s 1-build-binaries 2-vagrant-up 3-smoke-test

0: 0-fetch-k8s
1: 1-build-binaries
2: 2-vagrant-up

0-fetch-k8s:
	chmod +x fetch.sh
	./fetch.sh

1-build-binaries:
	chmod +x build.sh
	./build.sh $(path)

2-vagrant-up:
	echo "cleaning up semaphores..."
	rm -f joined
	rm -f cni
	echo "<- done"

	vagrant plugin install vagrant-vbguest
	# vagrant destroy -f
	echo "######################################"
	echo "######################################"
	echo "######################################"
	echo "######################################"
	echo "Retry vagrant up if the first time the windows node failed"

	u=0
	j=0
	c=0

	vagrant up # try to bring up both nodes
	echo "*********************************************"
	vagrant status
	echo "*********** vagrant up first run done ~~~~ ENTERING WINDOWS BRINGUP LOOP ***"
	until `vagrant status | grep winw1 | grep -q "running"` ; do echo "uuu `date` -> join try $u " ; let "u+=1" ; vagrant up winw1 ; done
	until [ -f joined ] ; do echo "jjj `date` -> join try $j" ; let "j+=1" ; vagrant provision winw1 && touch joined ; done
	until [ -f cni ] ; do echo "ccc `date` -> join try $c" ; let "c+=1" ; vagrant provision winw1 && touch cni ; done

3-smoke-test:
	vagrant ssh controlplane -c "kubectl scale deployment windows-server-iis --replicas 0"
	vagrant ssh controlplane -c "kubectl scale deployment windows-server-iis --replicas 1"
	vagrant ssh controlplane -c "kubectl get pods"
	

# TODO
#3-e2e-test:
#	sonobuoy run --e2e-focus=...
