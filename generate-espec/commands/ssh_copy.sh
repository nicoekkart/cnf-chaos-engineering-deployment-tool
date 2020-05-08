all_hosts=($(hostname | sed 's/pc/master/'))
i=1
while ping -c 1 $(hostname | sed "s/pc/node$i/") &> /dev/null
do
        all_hosts+=($(hostname | sed "s/pc/node$i/"))
        i=$((i+1))
done

ssh-keygen -b 4096 -q -t rsa -N '' -f .ssh/id_rsa2 2>/dev/null <<< y >/dev/null


for node in "${all_hosts[@]}"
do
	ssh-copy-id  -o StrictHostKeyChecking=no -i .ssh/id_rsa2.pub $node
done

mv .ssh/id_rsa2.pub .ssh/id_rsa.pub
mv .ssh/id_rsa2 .ssh/id_rsa