master_hostname=$(hostname | sed "s/pc/master/")
master_ip=$(host -4 $master_hostname | grep "has address" | awk '{print $4}')
declare -a all_nodes
i=1
while ping -c 1 $(hostname | sed "s/pc/node$i/") &>/dev/null; do
  all_nodes+=($(hostname | sed "s/pc/node$i/"))
  i=$((i + 1))
done

cd cnf-testbed/
mkdir -p data/cnftestbed/
echo "---" >data/cnftestbed/kubernetes.env
echo "nodes:" >>data/cnftestbed/kubernetes.env

printf "  - role: master\n    addr: $master_ip\n" >>data/cnftestbed/kubernetes.env
for node in "${all_nodes[@]}"; do
  addr=$(host -4 $node | grep "has address" | awk '{print $4}')
  printf "  - role: worker\n    addr: $addr\n" >>data/cnftestbed/kubernetes.env
done

rm -rf data/cnftestbed/cluster.yml data/cnftestbed/mycluster

cat data/cnftestbed/kubernetes.env
make k8s
make vswitch