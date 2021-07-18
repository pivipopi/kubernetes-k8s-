sudo apt-get update
sudo apt-get install > apt-transport-https > ca-certificates > curl > gnupg > lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo   "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt install kubeadm=1.19.12-00 kubectl=1.19.12-00 kubelet=1.19.12-00
kubeadm version
sudo kubeadm init --control-plane-endpoint 192.168.200.50 --pod-network-cidr 192.168.0.0/16 --apiserver-advertise-address 192.168.200.50
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
ls -l ~/.kube/config 
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
kubectl get nodes
sudo docker login
sudo docker pull calico/node:v3.19.1
sudo docker pull calico/pod2daemon-flexvol:v3.19.1
sudo docker pull calico/cni:v3.19.1
sudo docker pull calico/kube-controllers:v3.19.1
kubectl get nodes
sudo kubeadm token list
sudo openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
kubectl get nodes
kubectl get pod -A
kubectl get nodes
kubectl get pods -A
kubectl get nodes -o wide
echo "KUBELET_EXTRA_ARGS='--node-ip 192.168.200.50'" | sudo tee /etc/default/kubelet
sudo systemctl daemon-reload
sudo systemctl restart kubelet
kubectl get nodes -o wide
vi myapp-rs.yaml
vi .vimrc
kubectl create -f myapp-rs.yaml
kubectml get re
kubectml get replicasets.apps
kubectl get pods
vi myapp-svc-np.yaml
kubectl create -f myapp-svc-np.yaml 
vi myapp-svc-np.yaml
kubectl create -f myapp-svc-np.yaml 
vi myapp-svc-np.yaml
kubectl create -f myapp-svc-np.yaml 
kubectl get svc myapp-svc-np.yaml 
kubectl get svc myapp-svc-np
kubectl get svc,ep myapp-svc-np
curl 192.168.200.50:31111
curl 192.168.200.53:31111
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/metallb.yaml
vi config.yaml
cp myapp-svc-np.yaml myapp-svc-lb.yaml
vi myapp-svc-lb.yaml 
kubectl create -f myapp-svc-lb.yaml 
kubectl get svc myapp-svc-lb
kubectl get svc
kubectl run nettool -it --image=ghcr.io/c1t1d0s7/network-multitool --rm bash
kubectl get scv,po,ep
kubectl get svc,po,ep
curl http://10.97.163.15
exit
kubectl get all,pvc,pv
kubectl delete rs -all
kubectl delete replicationcontrollers mapp-rc
kubectl delete replicationcontrollers myapp-rc
kubectl delete replicasets.apps myapp-rs
kubectl get all,pvc,pv
kubectl delete replicasets.app,svc --all
kubectl get all,pvc,pv
exit
git clone --single-branch --branch v1.6.7 https://github.com/rook/rook.git
cd rook/cluster/examples/kubernetes/ceph/
pwd
ls
kubectl create -f crds.yaml -f common.yaml -f operator.yaml
kubectl create -f cluster.yaml (3 worker)
kubectl create -f cluster.yaml
kubectl -n rook-ceph get pod
watch kubectl -n rook-ceph get pod
kubetl describe rook-ceph
kubectl describe rook-ceph
kubectl describe rook-ceph get pod
kubectl describe -n rook-ceph get pod
kubectl describe rook-ceph-operator-6b78888745-j5k6r
kubectl describe cluster.yaml
kubectl -n rook-ceph get pod
watch kubectl -n rook-ceph get pod
kubectl -n rook-ceph get pod
kubectl create -f csi/rbd/storageclass.yaml
kubectl get sc
ls
kubectl create -f filesystem.yaml
kubectl -n rook-ceph get pod -l app=rook-ceph-mds
kubectl create -f csi/cephfs/storageclass.yaml
kubectl get sc
kubectl create -f toolbox.yaml
kubectl -n rook-ceph exec deploy/rook-ceph-tools -- ceph -s
exit
kubectl get ns
kubectl -n rook-ceph exec deploy/rook-ceph-tools -- ceph -s
kubectl get sc
cat myapp-pvc-dynamic.yaml
vi myapp-pvc-dynamic.yaml
cp myapp-pvc-dynamic.yaml myapp-pvc-dynamic-bk.yaml
vi myapp-pvc-dynamic-bk.yaml 
cat myapp-pvc-dynamic.yaml
cat myapp-pvc-dynamic-bk.yaml 
kubectl create -f myapp-pvc-dynamic.yaml
vi myapp-pvc-dynamic.yaml
vi myapp-pvc-dynamic-bk.yaml 
cat myapp-pvc-dynamic.yaml
cat myapp-pvc-dynamic-bk.yaml 
kubectl create -f myapp-pvc-dynamic.yaml
kubectl create -f myapp-pvc-dynamic-bk.yaml 
vi myapp-pvc-dynamic-bk.yaml 
kubectl create -f myapp-pvc-dynamic-bk.yaml 
cat myapp-pvc-dynamic-bk.yaml 
kubectl get persistentvolumeclaims
vi myapp-rs-dynamic.yaml
kubectl create -f myapp-rs-dynamic.yaml 
kubectl get replicasets.apps
kubectl get persistentvolumeclaims
kubectl delete -f myapp-pvc-dynamic-bk.yaml
kubectl get replicasets.apps
kubectl get pods
kubectl delete -f myapp-pvc-dynamic.yaml
sudo apt bash-completion
kubectl
kubectl completion bash
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl
kubectl api-resources | grep ^configmap
vi nginx-pod-compress.yaml
mkdir conf
cd conf
vi nginx-gzip.conf
ls
vim nginx-gzip.conf
cd .
cd..
cd ..
kubectl create configmap nginx-gzip-config --from-file=conf/nginx-gzip.conf
kubectl describe configmaps nginx-gzip-config
kubectl create -f nginx-pod-compress.yaml 
kubectl describe pod nginx-pod-compress
kubectl port-forward nginx-pod-compress 8080:80
kubectl exec -it nginx-pod-compress --rm bash
kubectl exec -it nginx-pod-compress -rm bash
kubectl exec -it nginx-pod-compress bash
exit
kubectl get pods
kubectl exec myapp-deploy-hpa-5b86745678-22jrn -- sha256sum /dev/zero
kubectl exec myapp-deploy-hpa-5b86745678-22jrn --sha256sum /dev/zero
kubectl exec myapp-deploy-hpa-5b86745678-m6pm6 -- sha256sum /dev/zero
kubectl exec myapp-deploy-hpa-5b86745678-m6pm6 --pkill -9 sha256sum
kubectl exec myapp-deploy-hpa-5b86745678-zq8l9 --pkill -9 sha256sum
kubectl exec myapp-deploy-hpa-5b86745678-zq8l9 -- pkill -9 sha256sum
kubectl delete horizontalpodautoscalers.autoscaling myapp-hpa-cpu
kubectl delete deployments.apps myapp-deploy-hpa 
ls
exit
watch -n1 -d kubectl get horizontalpodautoscalers.autoscaling 
kubectl get pods
exit
wgep https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.5.0/components.yaml
wget https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.5.0/components.yaml
ls
mkdir addon/metrics-server
mkdir -f addon/metrics-server
mkdir -p addon/metrics-server
ls
mv components.yaml addon/metrics-server
cd addon/metrics-server/
ls
vi components.yaml 
kubecl create -f components.yaml 
kubectl create -f components.yaml 
kubectl get po -n kub-system
kubectl top nodes
kubectl get po -n kube-system
kubectl describe po -n kube-system metrics-server-766c9b8df-nmwlj 
kubectl get po -n kube-system
kubectl top nodes
kubectl top pods
history 
kubectl top pods
kubectl top nodes
lscpu
kubectl top nodes
kuvectl describe nodes k-control
kubectl describe nodes k-control
kubectl describe nodes k-node3
kubectl describe nodes k-control
vi myapp-pod-req.yaml
kubectl create -f myapp-pod-req.yaml 
vi myapp-pod-req.yaml 
kubectl create -f myapp-pod-req.yaml 
kubectl top pod myapp-pod-req 
kubectl top pods
kubectl top pod myapp-pod-req 
kubectl descibe pods myapp-pod-req
kubectl describe pods myapp-pod-req
kubectl delete -f myapp-pod-req.yaml 
vi myapp-pod-req.yaml 
kubectl create -f myapp-pod-req.yaml 
kubectl top pod myapp-pod-req 
kubectl describe pods myapp-pod-req
kubectl create -f myapp-pod-req.yaml 
kubectl pods
kubectl get pods
kubectl get node
kubectl get pod -o wide
vi myapp-pod-req.yaml 
kubectl create -f myapp-pod-req.yaml 
kubectl top pod myapp-pod-req 
kubectl describe pods myapp-pod-req
kubectl top pod myapp-pod-req 
kubectl describe pods myapp-pod-req
kubectl top pod myapp-pod-req 
vi myapp-pod-huge-req.yaml
kubectl create -f myapp-pod-huge-req.yaml 
kubectl get pod
kubectl descrie pod myapp-pod-huge-req
kubectl describe pod myapp-pod-huge-req
kubectl delete pods --all
kubectl delete po --all
ls
cd
ls
pwd
mv /addon/metrics-server/myapp-pod-huge-req.yaml /home/vagrant
mv myapp-pod-huge-req.yaml /home/vagrant
mv myapp-pod-huge-req.yaml /
mv myapp-pod-huge-req.yaml ~/
ls
cd addon/metrics-server/
ls
mv myapp-pod-huge-req.yaml /home/vagrant
mv myapp-pod-req.yaml /home/vagrant
cd
ls
cp myapp-pod-req.yaml myapp-pod-limits.yaml
vi myapp-pod-limits.yaml 
kubectl creat -f myapp-pod-limits.yaml 
kubectl create -f myapp-pod-limits.yaml 
kubectl get pod myapp-pod-lim 
kubectl delete pod myapp-pod-lim 
vi myapp-limitrange.yaml
kubectl create -f myapp-limitrange.yaml 
vi myapp-limitrange.yaml
kubectl create -f myapp-limitrange.yaml 
vi myapp-limitrange.yaml
kubectl create -f myapp-limitrange.yaml 
cat myapp-limitrange.yaml
kubectl get limitranges
kubectl describe limitranges myapp-limitrange 
vi myapp-pod-no-reqlim.yaml
kubectl crete -f myapp-pod-no-reqlim.yaml 
kubectl create -f myapp-pod-no-reqlim.yaml 
cat myapp-pod-no-reqlim.yaml 
kubectl delete pod --all
kubectl delete limitranges myapp-limitrange 
ls
kubectl get pods
kubectl describe pod myapp-rs-dynamic-2kpcx 
kubectl delete ReplicaSet --all
kubectl get pods
vi myapp-quota-cpumem.yaml
vi myapp-quota-object.yaml
vi myapp-quota-storage.yaml
kubectl create -f myapp-quota-cpumem.yaml -f myapp-quota-object.yaml -f myapp-quota-storage.yaml 
vi myapp-quota-object.yaml
kubectl create -f myapp-quota-object.yaml 
cat myapp-quota-cpumem.yaml 
cat myapp-quota-object.yaml 
cat myapp-quota-storage.yaml 
kubectl delete resourcequotas --all
ls
vi myapp-deploy-hpa.yaml
kubectl create -f myapp-deploy-hpa.yaml 
kubectl get deployments.apps,replicasets.app,po
vi myapp-hpa-cpu.yaml
kubectl create -f myapp-hpa-cpu.yaml 
kubectl autoscale deployment myapp-deploy-hpa --min 2 --max 10 --cpu-percent 70
kubectl get horizontalpodautoscalers.autoscaling 
kubectl get pods
tumx
tmux
vi myapp-svc-headless.yaml
code myapp-svc-headless.yaml
sudo code myapp-svc-headless.yaml
vi myapp-svc-headless.yaml
vi myapp-sts.yaml
vi myapp-sts-vol.yaml
cp myapp-deploy-hpa.yaml myapp-deploy-hpa-vb2.yaml 
ci myapp-deploy-hpa-vb2.yaml 
vi myapp-deploy-hpa-vb2.yaml 
rm -rf myapp-deploy-hpa-vb2.yaml 
ls
cp myapp-hpa-cpu.yaml myapp-hpa-cpu-vb2.yaml 
vi myapp-hpa-cpu-vb2.yaml 

vi myapp-sts-vol-vb2.yaml 
kubectl create -f myapp-hpa-cpu-vb2.yaml 
vi myapp-hpa-cpu-vb2.yaml 
cp myapp-deploy-hpa.yaml myapp-deploy-hpa-vb2.yaml 
vi myapp-deploy-hpa-vb2.yaml 
kubectl create -f myapp-deploy-hpa-vb2.yaml 
kubectl create -f myapp-hpa-cpu-vb2.yaml 
kubectl explain pods
kubectl explain pod.spec
kubectl explain hpa.spec
kubectl explain hpa.spec.targetCPUUtilizationPercentage
kubectl explain hpa.
kubectl api-versions | 
kubectl api-versions
kubectl explain --api-version=autos
kubectl get pods
kubectl delete deployments --all
kubectl get pods
kubectl explain --api-version=autoscaling/v2beta2
kubectl explain --api-version=autoscaling/v2beta2 hpa
kubectl get deploy, po
vi myapp-hpa-cpu-vb2.yaml 
kubectl create -f myapp-hpa-cpu-vb2.yaml 
vi myapp-hpa-cpu-vb2.yaml 
kubectl create -f myapp-hpa-cpu-vb2.yaml 
kubectl delete -f myapp-hpa-cpu-vb2.yaml 
kubectl explain pod.spec.nodeName
kubectl explain --api-version=autoscaling/v2beta2 hpa
kubectl explain --api-version=autoscaling/v2beta2 hpa.spec
kubectl explain --api-version=autoscaling/v2beta2 hpa.spec.scaleTargetRef
cat myapp-hpa-cpu-vb2.yaml 
kubectl explain --api-version=autoscaling/v2beta2 hpa.specmetrics
kubectl explain --api-version=autoscaling/v2beta2 hpa.spec.metrics
kubectl explain --api-version=autoscaling/v2beta2 hpa.spec.metrics.resource
kubectl explain --api-version=autoscaling/v2beta2 hpa.spec.metrics.resource.target
cat myapp-hpa-cpu-vb2.yaml 
ls
rm -rf myapp-sts-vol-vb2.yaml 
rm -rf myapp-deploy-hpa-vb2.yaml 
ls
vi myapp-rs-nn.yaml
kubectl create -f myapp-rs-nn.yaml
vi myapp-rs-nn.yaml
kubectl create -f myapp-rs-nn.yaml
vi myapp-rs-nn.yaml
kubectl create -f myapp-rs-nn.yaml
vi myapp-rs-nn.yaml
kubectl create -f myapp-rs-nn.yaml
kubectl get po
kubectl get po -o wid
kubectl scale replicaset myapp-rs-nn --replicas 3
kubectl get po -o wide
kubectl delete -f myapp-rs-nn.yaml 
ls
kubectl label nodes k-node1 gpu=highend
kubectl label nodes k-node2 gpu=midrange

kubectl get nodes --show-labels
cp myapp-rs-nn.yaml myapp-rs-ns.yaml
vi myapp-rs-ns.yaml
kubectl create -f myapp-rs-ns.yaml
kubectl get pod -o wide
kubectl scale replicaset myapp-rs-ns --replicas 3
kubectl get pod -o wide
kubectl describe pod myapp-rs-nn-d2qj6
kubectl get pod -o wide
kubectl describe pod myapp-rs-ns-wf2v7
kubectl get pod -o wide
kubectls get nodes -L gpu
kubectl get nodes -L gpu
cat myapp-rs-ns-yaml
kubectl describe pod myapp-rs-ns-wf2v7
cat myapp-rs-ns.yaml
kubectl get pod -o wide
kubectl get nodes -L gpu
kubectl describe pod myapp-rs-nn-d2qj6
kubectl get pod -o wide
kubectl get pod 
kubectl get nodes
kubectl describe nodes k-node1
kubectl get pod 
kubectl get nodes -L gpu
kubectl describe nodes k-node1
kubectl hpa
kubectl get hpa
kubectl delete deployments.apps myapp-deploy-hpa
kubectl delete -f myapp-deploy-hpa
kubectl delete deployments.apps myapp-deploy-hpa
kubectl get pods
kubectl delete replicasets.apps myapp-rs-ns
kubectl get pods
kubectl delete -f myapp-rs-nn.yalml
kubectl delete -f myapp-rs-nn.yaml
kubectl get pods
kubectl get deploy,po
kubectl get nodes
kubectl get hpa
kubectl delete deployments.apps myapp-deploy-hpa
kubectl describe hpa myapp-deploy-hpa
kubectl delete -f myapp-deploy-hpa.yaml
ls
kubectl delete -f .
ls
kubectl get hpa
kubectl delete .
ls
kubectl describe hpa myapp-deploy-hpa
kubectl get pods
kubectl delete -f myapp-rs-nn.yaml
kubectl delete -f myapp-rs-nn
kubectl describe myapp-rs-nn-d2qj6
kubectl describe pod myapp-rs-nn-d2qj6
kubectl delete hpa --all
kubectl get pods
kubectl get hpa
kubectl get nodes
kubectl delete pods --all
kubectl get pods
kubectl get nodes

kubectl delete replicasets.apps myapp-rs-nn
kubectl get nodes
exit
kubectl get nodes
kubectl describe nodes k-node1
kubectl describe nodes k-node2
kubectl describe nodes k-node1
kubectl get pods -o wide
kubectl delete -f myapp-rs-nn.yaml
history
kubectl get pods -o wide
kubectl delete -f myapp-rs-nn.yaml
kubectl delete replicasets.apps myapp-rs-nn
kubectl describe pods myapp-rs-nn-pf7nx
kubectl delete replicasets.apps .
kubectl delete replicasets.apps myapp-rs-nn
kubectl get pods -o wide
kubectl get nodes
ls
Remove-AzResourceGroup -myapp-rs-nn ExampleResourceGroup
kubectl get nodes
kubectl get pods -o wide
kubectl delete -f myapp-rs-nn.yaml
kubectl create -f myapp-rs-nn.yaml
kubectl get pods -o wide
kubectl delete -f myapp-rs-nn.yaml
kubectl get pods -o wide
vi 
clear
kubectl get po
kubectl get po -A
kubectl delete po -n rook-ceph rook-ceph-tools-656b876c47-2bxl4 
clear
kubectl get po -A
kubeclt get all
kubectl get all
kubectl describe po myapp-rs-nn-9v9rx 
kubectl describe po myapp-rs-nn-9v9rx -o yaml
kubectl get po myapp-rs-nn-9v9rx -o yaml
kubectl patch po myapp-rs-nn-9v9rx -p '{"metadata":{"finalizers":"null}}'
kubectl patch po myapp-rs-nn-9v9rx -p '{"metadata":{"finalizers":"null"}}'
kubectl patch po myapp-rs-nn-9v9rx -p '{"metadata":{"finalizers":null}}'
kubectl get po
kubectl delete po myapp-rs-nn-9v9rx --force
kubectl get po
kubectl delete po all --force
kubectl delete po --all --force
kubectl get po
kubectl get po -n rook-ceph
kubectl delete po -n rook-ceph rook-ceph-tools-656b876c47-2bxl4 --force
kubectl get po -n rook-ceph rook-ceph-mgr-a-8599845f65-rnwsn 
kubectl describe po -n rook-ceph rook-ceph-mgr-a-8599845f65-rnwsn 
kubectl delete po -n rook-ceph rook-ceph-mgr-a-8599845f65-rnwsn --force
kubectl get po -A
kubectl delete po -n rook-ceph rook-ceph-mon-c-5b7bccb684-fwcgn  --force
kubectl get po -A
kubectl get nodes
kubectl describe node k-node1
kubectl get nodes
kubectl get po -A
kubectl get po -n rootk-ceph -o wide
kubectl get po -n rook-ceph -o wide
kubectl get limits
kubectl get quota
exit
kubectl get nodes
kubectl get po -A
vi myapp-rs-notol.yaml
history 
exit
kubectl describe nodes | grep Taint
kubectl taint nodes k-control node-role.kubernetes.io/master:NoSchedule
kubectl describe nodes | grep Taint
kubectl explain pod spec.tolerations
kubectl explain spec.tolerations
kubectl explain pod spec.tolerations
kubectl explain pods spec.tolerations
ls
cp myapp-rs.yaml myapp-rs-podaff-cache.yaml
vi myapp-rs-podaff-cache.yaml 
cp myapp-rs-podaff-cache.yaml myapp-rs-podaff-front.yaml 
vi myapp-rs-podaff-front.yaml 
vi myapp-rs-podaff-cache.yaml 
vi myapp-rs-podaff-front.yaml 
cat myapp-rs-podaff-front.yaml 
kubectl create -f myapp-rs-podaff-cache.yaml -f myapp-rs-podaff-front.yaml 
vi myapp-rs-podaff-cache.yaml 
vi myapp-rs-podaff-front.yaml 
kubectl create -f myapp-rs-podaff-cache.yaml -f myapp-rs-podaff-front.yaml 
vi myapp-rs-podaff-cache.yaml 
vi myapp-rs-podaff-front.yaml 
kubectl create -f myapp-rs-podaff-cache.yaml -f myapp-rs-podaff-front.yaml 
kubectl get pods -o wide
vi myapp-rs-podaff-cache.yaml 
kubectl create -f myapp-rs-podaff-cache.yaml -f myapp-rs-podaff-front.yaml 
vi myapp-rs-podaff-cache.yaml 
vi myapp-rs-podaff-front.yaml 
kubectl create -f myapp-rs-podaff-cache.yaml -f myapp-rs-podaff-front.yaml 
vi myapp-rs-podaff-cache.yaml 
kubectl ge nodes --show-labels
kubectl get nodes --show-labels
vi myapp-rs-podaff-cache.yaml 
vi myapp-rs-podaff-front.yaml 
vi myapp-rs-podaff-cache.yaml 
vi myapp-rs-podaff-front.yaml 
kubectl create -f myapp-rs-podaff-cache.yaml -f myapp-rs-podaff-front.yaml 
kubectl get pods -o wide
cp myapp-rs-notol.yaml myapp-rs-tol.yaml
vi myapp-rs-tol.yaml 
kubectl get pods -o wide
kubectl create -f myapp-rs-tol.yaml 
vi myapp-rs-tol.yaml 
kubectl taint node k-node3 env=production:NoSchedule
kubectl describe nodes | grep Taint
kubectl create -f myapp-rs-tol.yaml 
vi myapp-rs-tol.yaml 
kubectl get po -n kube-system -o wide | grep k-control
tumx

kubectl get po -n kube-system -o wide | grep k-control
kubectl descrive pod -n kube-system kube-controller-manager-k-control
cd /etc/kubernetes/manifests/
ls
vi kube-scheduler.yaml 
cat kube-scheduler.yaml 
exit
cd /etc/kubernetes/manifests/
ls
sudo vi kube-scheduler.yaml 
sudo vi hello.yaml
ls
cd ..
cd 
kubectl get po
sudo i
sudo -i
kubectl get po
kubectl get pods
kubectl get pods -o wide
sudo -i
kubectl get po
systemctl status kubelet
kubectl get po
ls
vi myapp-rs-tol.yaml 
kubectl create -f myapp-rs-tol.yaml 
vi myapp-rs-tol.yaml 
ls
kubectl describe nodes | grep Taints
kubectl taint node k-node3 env-
kubectl describe nodes | grep Taints
kubectl get po
kubectl delete -f myapp-rs-aff-cache.yaml
kubectl delete -f replicasets.apps --all
kubectl delete replicasets.apps --all
kubectl get po
exit
