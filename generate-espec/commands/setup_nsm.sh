cd
chown $(whoami) -R .
usermod -aG docker $(whoami)

cd cnf-testbed/examples/workload-infra/nsm-k8s/
curl -LO https://git.io/get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
helm init --upgrade
helm repo add nsm https://helm.nsm.dev/
helm install nsm/nsm --name=nsm --values=values.yaml
