#!/bin/sh
echo "running calico installer now...."
sleep 2
export KUBECONFIG=/home/vagrant/.kube/config
KUBECONFIG=/home/vagrant/.kube/config

kubectl create -f /var/sync/forked/calico.yaml
kubectl taint nodes --all node-role.kubernetes.io/master-

echo "waiting 20s for calico pods..."
sleep 20
# kubectl patch installation default --type=merge -p '{"spec": {"calicoNetwork": {"bgp": "Disabled"}}}'
kubectl get pods -n kube-system

curl -o calicoctl -O -L "https://github.com/projectcalico/calicoctl/releases/download/v3.19.1/calicoctl"
chmod 755 calicoctl
./calicoctl ipam configure --strictaffinity=true
