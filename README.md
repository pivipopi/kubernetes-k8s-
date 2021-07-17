## 쿠버네티스-k8s
2021-07-16 과제 제출 내용
[https://pivipopi.notion.site/kubeadm-147cffb1b55f46b59a41b85cfff83945]


# kubeadm 설치 문서

- [kubeadm으로 kubernetes 클러스터 배포]()
- [노드 추가]()
- [버전 업그레이드]()
- 애드온

    1) [metallb]()

    2) [ingress]()

    3) [rook]()

    4) [metrics-server]()

### kubeadm, kubectl, kubelet 설치

- kubeadm : 클러스터를 부트 스트랩하는 명령입니다.
- kubectl : 클러스터와 통신하기위한 명령 줄 유틸리티
- kubelet : 클러스터의 모든 머신에서 실행되는 구성 요소 포드 및 컨테이너 시작과 같은 작업을 수행

- 쿠버네티스 설치를 위한 도구를 설치한다 =kubeadm
- 특정 포트들 개방 = 방화벽을 연다
- 스왑을 사용하면 느려져서 쿠버네티스에서는 스왑을 사용하지 않는다.

- 모든 노드에 설치
- 버전을 지정할 수 있다.
- apt-mark hold : 자동 패키지 업그레이드를 막아준다. (=업데이트 블럭)

```bash
# 업데이트 aptKubernetes를 사용하는 데 필요한 패키지 색인 및 설치 패키지 apt저장소
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

# Google Cloud 공개 서명 키를 다운로드
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

# Kubernetes 추가 apt저장소
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# 최신 정보 apt패키지 색인
# kubelet, kubeadm 및 kubectl을 설치하고 해당 버전을 고정
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# 버전 확인
kubeadm version
kubectl version
kubelet --version
```

- 버전을 지정하는 방법
- 안정성의 문제로 최신 버전은 사용하지 않는다. → 18/19/20 정도 사용

```bash
# 버전 찾기
vagrant@k-control:~$ sudo apt-cache madison kubeadm
kubeadm | 1.18.19-00 | https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages

vagrant@k-control:~$ sudo apt install kubeadm=1.18.19-00 kubectl=1.18.19-00 kubelet=1.18.19-00
```

### kubeadm을 사용하여 클러스터 생성

> 단일 제어 플레인 Kubernetes 클러스터 설치

> Pod가 서로 통신 할 수 있도록 클러스터에 Pod 네트워크를 설치

### 컨트롤 플레인 노드 초기화

- --control-plane-endpoint <API 서버>
- --pod-network-cidr <파드에 연결할 네트워크> : 컨테이너=파드
- --apiserver-advertise-address <IP주소> : 다른 노드에게 API 주소를 알려준다.

    → 컨테이너를 실행 = 컨테이너 생성

- 루트가 아닌 사용자에 대해 kubectl이 작동하도록 하려면 권한을 바꿔줘야 한다.

```bash
# [control-plane]
# Your Kubernetes control-plane has initialized successfully!가 떠야한다.
sudo kubeadm init --control-plane-endpoint 192.168.200.50 --pod-network-cidr 192.168.0.0/16 --apiserver-advertise-address 192.168.200.50

# 루트 사용자가 아니면 아래 내용 추가 작업하기
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 권한 확인
ls -l ~/.kube/config 
-rw------- 1 vagrant vagrant 5598 Jul  6 06:44 /home/vagrant/.kube/config
```

### Pod 네트워크 추가 기능 설치

> kubectl apply -f <add-on.yaml>

[Install Calico networking and network policy for on-premises deployments](https://docs.projectcalico.org/getting-started/kubernetes/self-managed-onprem/onpremises)

→ 우리는 칼리코파일 사용

- 컨테이너 네트워크 인터페이스 (CNI) 기반 Pod 네트워크 추가 기능으로 Pod가 서로 통신 할 수 있다.
- 네트워크가 설치되기 전에 클러스터 DNS (CoreDNS)가 시작되지 않는다.

- Pod 네트워크가 호스트 네트워크와 겹치지 않아야 한다.
- 클러스터 당 하나의 포드 네트워크 만 설치

```bash
# 네트워크 추가
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# 연결 확인
# NotReady면 위에 네트워크 설치가 잘 안된거다. (시간이 좀 흘러야 한다.)
kubectl get nodes
```

- 오류 : 이미지 받기에 실패해서 NotReady인 상태가 유지 될 때
    - 오류 원인

        하루에 다운 받을 수 있는 횟수에 제한이 걸려있기 때문이다.

    - 해결 방법

        도커 허브에서 이미지들을 다운 받는다. 

        ```bash
        sudo docker login

        sudo docker pull calico/node:v3.19.1
        sudo docker pull calico/pod2daemon-flexvol:v3.19.1
        sudo docker pull calico/cni:v3.19.1
        sudo docker pull calico/kube-controllers:v3.19.1
        ```

    - 문제가 해결된 모습

        ```bash
        vagrant@k-control:~$ kubectl get nodes
        NAME        STATUS   ROLES    AGE   VERSION
        k-control   Ready    master   36m   v1.18.19
        k-node1     Ready    <none>   15m   v1.18.19
        k-node2     Ready    <none>   15m   v1.18.19
        k-node3     Ready    <none>   15m   v1.18.19
        ```

### 노드 가입

> kubeadm join --token <token> <control-plane-host>:<control-plane-port> --discovery-token-ca-cert-hash sha256:<hash>

- <token>과 <hash>값은 control-plane에서 알 수 있으며 방법은 아래와 같다.

[토큰 리스트가 보이지 않는 경우](https://www.notion.so/0811d33422fe4d2eb0e974b3a0baeba6)

```bash
vagrant@k-control:~$ sudo kubeadm token list
TOKEN                     TTL         EXPIRES                USAGES                   DESCRIPTION                                                EXTRA GROUPS
fdbpfh.amr65yetqqfribub   23h         2021-07-07T07:55:46Z   authentication,signing   The default bootstrap token generated by 'kubeadm init'.   system:bootstrappers:kubeadm:default-node-token

vagrant@k-control:~$ sudo openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | \
>    openssl dgst -sha256 -hex | sed 's/^.* //'
0bc6e5f51837d13ae57a28086e02030f1ead72cf3fbc2aeac15754cc90605274
```

- 알아온 값을 대입해 클러스터에 새 노드를 추가

```bash
sudo kubeadm join 192.168.200.50:6443 --token fdbpfh.amr65yetqqfribub --discovery-token-ca-cert-hash sha256:0bc6e5f51837d13ae57a28086e02030f1ead72cf3fbc2aeac15754cc90605274
```

- 확인 시 모든 노드들이 Ready로 올라와 있다.

```bash
vagrant@k-control:~$ kubectl get nodes
NAME        STATUS   ROLES    AGE   VERSION
k-control   Ready    master   36m   v1.18.19
k-node1     Ready    <none>   15m   v1.18.19
k-node2     Ready    <none>   15m   v1.18.19
k-node3     Ready    <none>   15m   v1.18.19
```

- calico - 네트워크
- coredns - dns
- apiserver
- controller : 컨트롤러 관리자
- proxy가 4개인 이유 : 노드가 4개이기 때문
- scheduler 빼고 전부 컨테이너가 실행

```bash
vagrant@k-control:~$ kubectl get pods -A
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-5978c5f6b5-2k8tv   1/1     Running   7          16h
kube-system   calico-node-96fl5                          1/1     Running   1          16h
kube-system   calico-node-f58x6                          1/1     Running   1          16h
kube-system   calico-node-fbt49                          1/1     Running   1          16h
kube-system   calico-node-m6swp                          1/1     Running   1          16h
kube-system   coredns-66bff467f8-85xb2                   1/1     Running   1          16h
kube-system   coredns-66bff467f8-s7ddq                   1/1     Running   1          16h
kube-system   etcd-k-control                             1/1     Running   1          16h
kube-system   kube-apiserver-k-control                   1/1     Running   1          16h
kube-system   kube-controller-manager-k-control          1/1     Running   1          16h
kube-system   kube-proxy-98ljp                           1/1     Running   1          16h
kube-system   kube-proxy-bsrlz                           1/1     Running   1          16h
kube-system   kube-proxy-v5vmg                           1/1     Running   1          16h
kube-system   kube-proxy-xgvbk                           1/1     Running   1          16h
kube-system   kube-scheduler-k-control                   1/1     Running   1
```

### 버전 업그레이드 1.18.19 → 1.18.20

[kubeadm 클러스터 업그레이드](https://kubernetes.io/ko/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)

### 1.18.19 → 1.18.20 패치만 업그레이드 해보기

- 업그레이드 절차

    1) 기본 컨트롤 플레인 노드를 업그레이드

    2) 추가 컨트롤 플레인 노드를 업그레이드

    3) 워커(worker) 노드를 업그레이드


### k-control

1 . kubeadm upgrade

- 마크 홀드해서 업그레이드가 안된다.

    마크홀드한 이유는 자동으로 업그레이드가 되면 버전이 맞지 않아서 클러스트 오류가 나기 때문이다.

- 홀드된 패키지를 바꾸는 방법

    나는 위에 방법을 사용했다. → 루트권한이 없다면 sudo 붙일 것

```bash
# 1.21.x-00에서 x를 최신 패치 버전으로 바꾼다.
# 홀드를 풀고 패치 버전을 바꾼 뒤 다시 홀드를 해주는 방법
apt-mark unhold kubeadm && \
apt-get update && apt-get install -y kubeadm=1.21.x-00 && \
apt-mark hold kubeadm

# apt-get 버전 1.1부터 다음 방법을 사용할 수도 있다방법.
# 언홀드를 하지 않고 바꾸는 방법
# 홀드 된 패키지를 바로 업그레이드 하는 방법이다.
apt-get update && \
apt-get install -y --allow-change-held-packages kubeadm=1.21.x-00
```

```bash
sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm=1.18.20-00 && \
sudo apt-mark hold kubeadm
```

- 다운로드 하려는 버전이 잘 받아졌는지 확인

```bash
sudo kubeadm version
```

- 업그레이드 계획을 확인 → 실제로 업그레이드 된 것은 아니다.

```bash
sudo kubeadm upgrade plan
```


- 업그레이드 진행

    → 진행 후 성공적이라는 문구가 나와야 한다.

    → 다른 컨트롤이 있다면 추가 업그레이드를 해줘야 한다.

    (칼리코 네트워크 필요하면 업그레이드)

```bash
sudo kubeadm upgrade apply v1.18.20
.
.

[upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.18.20". Enjoy!

[upgrade/kubelet] Now that your control plane is upgraded, please proceed with upgrading your kubelets if you haven't already done so.
```

2 . kubelet과 kubectl 업그레이드

- k-control과 마찬가지로 홀드를 풀고 업그레이드를 진행한다.

```bash
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo apt-get install -y kubelet=1.18.20-00 kubectl=1.18.20-00 && \
sudo apt-mark hold kubelet kubectl
```

- 참고 : kubelet는 유일하게 패키지로 설치된 것이다. = 서비스


- kubelet을 다시 시작

```bash
vagrant@k-control:~$ sudo systemctl daemon-reload
vagrant@k-control:~$ sudo systemctl restart kubelet
```

3 . 확인

- Ready 상태에 k-control의 버전이 올라간 것을 볼 수 있다.

```bash
vagrant@k-control:~$ kubectl get nodes
NAME        STATUS   ROLES    AGE   VERSION
k-control   Ready    master   17h   v1.18.20
k-node1     Ready    <none>   17h   v1.18.19
k-node2     Ready    <none>   17h   v1.18.19
k-node3     Ready    <none>   17h   v1.18.19
```

- 실습 : kubectl version

    ```bash
    vagrant@k-control:~$ kubectl version
    Client Version: version.Info{Major:"1", Minor:"18", GitVersion:"v1.18.20", GitCommit:"1f3e19b7beb1cc0110255668c4238ed63dadb7ad", GitTreeState:"clean", BuildDate:"2021-06-16T12:58:51Z", GoVersion:"go1.13.15", Compiler:"gc", Platform:"linux/amd64"}
    Server Version: version.Info{Major:"1", Minor:"18", GitVersion:"v1.18.20", GitCommit:"1f3e19b7beb1cc0110255668c4238ed63dadb7ad", GitTreeState:"clean", BuildDate:"2021-06-16T12:51:17Z", GoVersion:"go1.13.15", Compiler:"gc", Platform:"linux/amd64"}
    ```

- 실습 : kubelet --version

    ```bash
    vagrant@k-control:~$ kubelet --version
    Kubernetes v1.18.20
    ```

### k-node

> node1 | node2 | node3 반복

1 . kubeadm 업그레이드

- 홀드를 풀고 kubeadm의 버전을 업그레이드한 뒤 다시 홀드해준다.
- k-control의 구성으로 업그레이드 한다.

```bash
# 업그레이드 버전
sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm=1.18.20-00 && \
sudo apt-mark hold kubeadm

# k-control의 구성으로 업그레이드
sudo kubeadm upgrade node
```

2 . kubelet과 kubectl 업그레이드

- 마크 홀드 풀고 버전을 업그레이드를 하고 다시 홀드를 한다.

```bash
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo apt-get install -y kubelet=1.18.20-00 kubectl=1.18.20-00 && \
sudo apt-mark hold kubelet kubectl
```

- kubelet을 다시 시작

```bash
vagrant@k-node1:~$ sudo systemctl daemon-reload
vagrant@k-node1:~$ sudo systemctl restart kubelet
```

3 . 확인 → k-control에서 확인

- Ready 상태에 k-node1의 버전이 올라간 것을 볼 수 있다.

```bash
vagrant@k-control:~$ kubectl get nodes
NAME        STATUS   ROLES    AGE   VERSION
k-control   Ready    master   18h   v1.18.20
k-node1     Ready    <none>   17h   v1.18.20
k-node2     Ready    <none>   17h   v1.18.19
k-node3     Ready    <none>   17h   v1.18.19
```

- 실습 : kubectl version

    ```bash
    vagrant@k-node1:~$ kubectl version
    Client Version: version.Info{Major:"1", Minor:"18", GitVersion:"v1.18.20", GitCommit:"1f3e19b7beb1cc0110255668c4238ed63dadb7ad", GitTreeState:"clean", BuildDate:"2021-06-16T12:58:51Z", GoVersion:"go1.13.15", Compiler:"gc", Platform:"linux/amd64"}
    The connection to the server localhost:8080 was refused - did you specify the right host or port?
    ```

- 실습 : kubelet --version

    ```bash
    vagrant@k-node1:~$ kubelet --version
    Kubernetes v1.18.20
    ```

### 최종 확인

```bash
vagrant@k-control:~$ kubectl get nodes
NAME        STATUS   ROLES    AGE   VERSION
k-control   Ready    master   18h   v1.18.20
k-node1     Ready    <none>   17h   v1.18.20
k-node2     Ready    <none>   17h   v1.18.20
k-node3     Ready    <none>   17h   v1.18.20

vagrant@k-control:~$ kubectl get pods -A
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-5978c5f6b5-2k8tv   1/1     Running   7          17h
kube-system   calico-node-96fl5                          1/1     Running   1          17h
kube-system   calico-node-f58x6                          1/1     Running   1          17h
kube-system   calico-node-fbt49                          1/1     Running   1          17h
kube-system   calico-node-m6swp                          0/1     Running   1          17h
kube-system   coredns-66bff467f8-85xb2                   1/1     Running   1          18h
kube-system   coredns-66bff467f8-s7ddq                   1/1     Running   1          18h
kube-system   etcd-k-control                             1/1     Running   1          18h
kube-system   kube-apiserver-k-control                   1/1     Running   1          18h
kube-system   kube-controller-manager-k-control          1/1     Running   1          18h
kube-system   kube-proxy-98ljp                           1/1     Running   1          17h
kube-system   kube-proxy-bsrlz                           1/1     Running   1          17h
kube-system   kube-proxy-v5vmg                           1/1     Running   1          17h
kube-system   kube-proxy-xgvbk                           1/1     Running   1          18h
kube-system   kube-scheduler-k-control                   1/1     Running   1          18h
```

### MetalLB - LoadBalancer

[MetalLB, bare metal load-balancer for Kubernetes](https://metallb.universe.tf/installation/)

온프레미스(On-Premise)의 베어메탈 또는 가상머신에 배포하거나, 퍼블릭 클라우드의 관리형 쿠버네티스가 아닌 가상머신에 직접 설치한 경우.

MetalLB 오픈소스를 이용해 쿠버네티스 리소스로 로드 밸런서 기능을 제공

- 클라우드 인프라에서LoadBalancer 서비스를 생성하면 클라우드 인프라의 로드 밸런서를 자동으로 프로비저닝 하게 되며, 이 로드 밸런서를 통해 서비스와 파드에 접근 가능

1 . MetalLB를 설치하려면 매니페스트를 적용

- metallb-system 네임스페이스 아래의 클러스터에 MetalLB가 배포
- 설치 매니페스트에는 구성 파일이 포함x → 직접 추가 생성

- 매니페스트의 구성 요소

    1) metallb-system/controller : 배포. IP 주소 할당을 처리하는 클러스터 전체 컨트롤러

    2) metallb-system/speakerdaemonset : 서비스에 도달할 수 있도록 선택한 프로토콜을 말함

    3) 서비스는 구성 요소가 작동하는 데 필요한 RBAC 권한과 함께 컨트롤러 및 스피커에 대한 계정

```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/metallb.yaml
```

2 . MetalLB 구성 파일 설정

- 하나의 파일에 여러 스트링을 넣을 수 있다. 단, 반드시 ---를 넣어서 구분
- 대부분의 경우 프로토콜 별 구성이 필요하지 않고 IP 주소만 필요
- MetalLB가 192.168.200.200에서 192.168.200.210까지의 IP에 대한 제어를 제공

    → 로드 밸런서 IP 대역을 써야한다.

```bash
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 192.168.200.200-192.168.200.210
```

### 인그레스 컨드롤 설치

[Installation Guide - NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/deploy/)

→ 미리 만들어져 있는 yaml 파일을 적용

→ 바로 실행해 버리면 안된다. 실행하고 파일을 수정을 할 것이다.

1 .  컨트롤러 설치

- 베어 메탈로 들어가서 가이드 참고

```jsx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.47.0/deploy/static/provider/baremetal/deploy.yaml
```

- 확인
```jsx
kubectl get ns
```
    → 네임 스페이스 확인

    - 인그레스 리소스가 만들어 진다

 
    → 파드 확인

    - 2개의 잡 파드와 1개의 컨트롤러가 있다.
    - 컨트롤은 반드시 1/1 레디 상태여야 한다.


    → 서비스 확인

    - 수정 작업이 필요하다.

 

2 . 서비스 수정

- 스펙의 적장한 위치에

    eternalIPs: 외부에서 접근할 수 있도록 등록 → 워커 노드의 목록만 적으면 된다.

    ```bash
    kubectl edit svc -n ingress-nginx ingress-nginx-controller
    ```


3 . 컨트롤러 정상 저장 및 확인

- 서비스를 봤을 때 EXTERNAL-IP가 나오면 된다.
  

  
### rook - 쿠버네티스 가상 스토리지 구현

[Rook Docs](https://rook.io/docs/rook/v1.6/ceph-quickstart.html)

1 . 모든 리소스 지우기

- 아무것도 없는 지 꼭 확인 하고 진행할 것


2 . Vagrantfile.txt 파일 수정

[Vagrantfile](kubeadm%20%E1%84%89%E1%85%A5%E1%86%AF%E1%84%8E%E1%85%B5%20%E1%84%86%E1%85%AE%E1%86%AB%E1%84%89%E1%85%A5%20166631d975614ed983e9085d03bee607/Vagrantfile.txt)

- 각 노드에 VM에 크기가 10G인 비어있는 디스크 할당

    → 오타가 나면 실행이 안되므로 각별히 주의 할 것


3 . vagrant reload

- vagrant halt 후 reload 할 것

4 . 빈 디스크가 붙었는지 확인

- 파티션도 없고 파일 시스템도 없는 빈 디스크 → sdc
- node1, node2, node3 전부 있어야 한다.

```bash
vagrant ssh k-nodex -- lsblk -f
```


5 . [ceph cluster] 생성

[Rook Docs](https://rook.io/docs/rook/v1.6/ceph-quickstart.html)

```bash
# Ceph 소스 다운로드
git clone --single-branch --branch v1.6.7 [https://github.com/rook/rook.git](https://github.com/rook/rook.git)
cd rook/cluster/examples/kubernetes/ceph

# crds, common, operator 설치
kubectl create -f crds.yaml -f common.yaml -f operator.yaml

# cluster 생성
kubectl create -f cluster.yaml (3 worker)
또는
kubectl create -f cluster-test.yaml (1 worker)
```

- 실습 : cluster 생성
| watch kubectl -n rook-ceph get pod 로 실시간 확인해 보기
    - 생성

    - 꼭! 다 설치되고 Running 상태인 거 확인하고 다음 단계로 넘어 갈 것

        → 생성하면 뒤에서 계속 생성되는 중이기 때문에

        → 5분 정도 걸린다.

  

6 . 블록 스토리지 만들기

[Rook Docs](https://rook.io/docs/rook/v1.6/ceph-block.html)

- 블럭 장치용 스토리지 클래스 생성

```bash
kubectl create -f csi/rbd/storageclass.yaml
```


7 . 파일 스토리지 만들기

[Rook Docs](https://rook.io/docs/rook/v1.6/ceph-filesystem.html)

```bash
# 파일 시스템 생성
kubectl create -f filesystem.yaml (3 worker)
또는
kubectl create -f filesystem-test.yaml (1 worker)

# 파일 스토리지 생성
kubectl create -f csi/cephfs/storageclass.yaml
```


8 . ceph status → 잘 됐는지 최종 확인

```bash
# toolbox 생성
kubectl create -f toolbox.yaml

# exec로 ceph를 실행
# health: HEALTH_WARN / HEALTH_OK 둘중 하나의 상태여야 한다.
kubectl -n rook-ceph exec deploy/rook-ceph-tools -- ceph -s
```


### metrics-server

[Release v0.5.0 · kubernetes-sigs/metrics-server](https://github.com/kubernetes-sigs/metrics-server/releases/tag/v0.5.0)

→ 모니터링 도구

→ cpu와 메모리를 실시간으로 사용 용량을 보여준다.

1 . metrics-server 설치 순서

```bash
# 깃허브에서 파일 다운로드
wget https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.5.0/components.yaml

# 디렉토리 생성후 파일 이동
mkdir -f addon/metrics-server
mv components.yaml addon/metrics-server
cd addon/metrics-server/

# metrics-server 파일 수정
# Deployment.spec.template.spec에 추가
vi components.yaml

- --kubelet-insecure-tls

# 리소스 생성
kubectl create -f components.yaml

# 확인
kubectl get po -n kube-system
kubectl describe po -n kube-system metrics-server-766c9b8df-nmwlj

# 노드와 파드의 용량 확인
kubectl top nodes
kubectl top pods
```
