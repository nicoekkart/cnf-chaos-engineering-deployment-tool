all_hosts=(192.168.0.2)
i=4
while ping -c 1 192.168.0.$i &> /dev/null
do
        all_hosts+=(192.168.0.$i)
        i=$((i+1))
done

ssh-keygen -b 4096 -q -t rsa -N '' -f .ssh/id_rsa2 2>/dev/null <<< y >/dev/null


for node in "${all_hosts[@]}"
do
	ssh-copy-id  -o StrictHostKeyChecking=no -i .ssh/id_rsa2.pub $node
done

mv .ssh/id_rsa2.pub .ssh/id_rsa.pub
mv .ssh/id_rsa2 .ssh/id_rsa
