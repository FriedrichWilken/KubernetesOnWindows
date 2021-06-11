# -*- mode: ruby -*-
# vi: set ft=ruby :

=begin
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
=end

require 'yaml'
settings = YAML.load_file 'sync/variables.yaml'

Vagrant.configure(2) do |config|

  # LINUX MASTER
  config.vm.define :master do |master|
    master.vm.host_name = "master"
    master.vm.box = "ubuntu/focal64"
    master.vm.network :private_network, ip:"10.20.30.10"
    master.vm.provider :virtualbox do |vb|
    master.vm.synced_folder "./sync", "/var/sync"
      vb.memory = 8192
      vb.cpus = 4
    end
    master.vm.provision :shell, privileged: false, path: "sync/master.sh"
  end

  # WINDOWS WORKER (win server 2019)
  config.vm.define :winw1 do |winw1|
    winw1.vm.host_name = "winw1"
    winw1.vm.box = "StefanScherer/windows_2019"  
    winw1.vm.provider :virtualbox do |vb|
    vb.memory = 8192
    vb.cpus = 4
    # use rdp to access a GUI if you need it !
    vb.gui = false
    end
    winw1.vm.network :private_network, ip:"10.20.30.11"
    winw1.vm.synced_folder ".", "/vagrant", disabled:true
    winw1.vm.synced_folder "./sync", "c:\\sync"

    ## Copy exe files into windows node

    # I think this is invalid... (jay 6/7)
    # the reason being that PrepareNode.ps1 seems to check C:/k/ for the contents of the files,
    # and so this isnt used... it always downloads them...
    winw1.vm.provision "file", source: settings['kubelet_path'] , destination: "C:/k/bin/kubelet.exe"
    winw1.vm.provision "file", source: settings['kubelet_path'] , destination: "C:/k/bin/kube-proxy.exe"

    ## uncomment the 'run' values if debugging CNI ....

    winw1.vm.provision "shell", path: "sync/hyperv.ps1", privileged: true #, run: "never"
    winw1.vm.provision :reload

    winw1.vm.provision "shell", path: "sync/containerd1.ps1", privileged: true #, run: "never"
    winw1.vm.provision :reload

    winw1.vm.provision "shell", path: "sync/containerd2.ps1", privileged: true #, run: "never"

    winw1.vm.provision "shell", path: "forked/PrepareNode.ps1", privileged: true, args: "-KubernetesVersion v1.21.0 -ContainerRuntime containerD" #, run: "never"

    winw1.vm.provision "shell", path: "sync/kubejoin.ps1", privileged: true #, run: "never"

    # Experimental at the moment...
    winw1.vm.provision "shell", path: "forked/0-antrea.ps1", privileged: true #, run: "always"
    winw1.vm.provision "shell", path: "forked/1-antrea.ps1", privileged: true #, run: "always"

  end
  
end
