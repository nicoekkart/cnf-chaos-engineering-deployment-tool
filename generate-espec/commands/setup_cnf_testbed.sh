master_ip=192.168.0.2
declare -a all_nodes
i=4
while ping -c 1 192.168.0.$i &>/dev/null; do
  all_nodes+=(192.168.0.$i)
  i=$((i + 1))
done

cd cnf-testbed/
mkdir -p data/cnftestbed/
echo "---" >data/cnftestbed/kubernetes.env
echo "nodes:" >>data/cnftestbed/kubernetes.env

printf "  - role: master\n    addr: $master_ip\n" >>data/cnftestbed/kubernetes.env
for node in "${all_nodes[@]}"; do
  printf "  - role: worker\n    addr: $node\n" >>data/cnftestbed/kubernetes.env
done

cat data/cnftestbed/kubernetes.env
make k8s
make vswitch

