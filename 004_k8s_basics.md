<!-- сартанути/створити кластер   -->
minikube start --vm-driver=docker  

<!-- информація про компоненти   -->
kubectl get componentstatuses  

<!-- информація про кластер -->
kubectl cluster-info  

<!-- про сервери (вузли/ноди)   -->
kubectl get nodes  

<!-- старт з параметрами -->
minikube start --cpus=4 --memory=8gb --disk-size=25gb

<!-- логін всередину контейнера -->
minikube ssh

<!-- зупинити кластер -->
minikube stop

<!-- подивитись існуючі профілі -->
minikybe profile list

<!-- вбити кластер профіля -->
minikube delete -p myCluster



tabtest 
