# KubernetesOnWindows
## Prerequisites
You need the `reload` plugin for vagrant.
```
vagrant plugin install vagrant-reload
```
## How to run
Finally, no more need for a makefile:
```
vagrant up
```
will set up everything.

IMPORTANT: do not log into the VMs until the provisioning is done. That is especially true for Windows because it will prevent the reboots.

If you still have an old instance of these VMs running for the same dir:
```
vagrant destroy -f && vagrant up
```
after everything is done (can take 10 min+) ssh' into the linux vm:
```
vagrant ssh master
```
and get an overview of the nodes:
```
kubectl get nodes
```
The win node might stay 'NotReady' for a while, because it takes some time to download the flannel image.
```
vagrant@master:~$ kubectl get nodes
NAME     STATUS     ROLES                  AGE    VERSION
master   Ready      control-plane,master   8m4s   v1.20.4
winw1    NotReady   <none>                 64s    v1.20.4
```
...
```
NAME     STATUS   ROLES                  AGE     VERSION
master   Ready    control-plane,master   16m     v1.20.4
winw1    Ready    <none>                 9m11s   v1.20.4
```

I have only tested this on one machine so if you run into trouble creating new issues (with info about your system) are very welcome. 


## Where did I steal all the stuff?
This guide is based on [this very nice Vagrantfile](https://gist.github.com/danielepolencic/ef4ddb763fd9a18bf2f1eaaa2e337544) and this very good [guide on how install Kubernetes on Ubuntu Focal (20.04)](https://github.com/mialeevs/kubernetes_installation). 
For the Windows part is used this [guide on how to install Docker on Win Server 2019](https://www.hostafrica.co.za/blog/new-technologies/how-to-install-docker-on-linux-and-windows/#win))  and another [this](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/adding-windows-nodes/) [~~this~~](https://www.hostafrica.co.za/blog/new-technologies/install-kubernetes-cluster-windows-server-worker-nodes/) guide on how to install Kubernetes on Win Server 2019 .
