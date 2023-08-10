

This setup is to expose docker hostname to the host machine so that hostname becomes accessible.


# Running Cluster
- `make run-ag n=3`
- `make dns-modify o=true n=3`

If we visit [my.master.org:8088/cluster/nodes](my.master.org:8088/cluster/nodes) or [localhost:8088/cluster/nodes](localhost:8088/cluster/nodes) we’ll get the following web interface:

![img.png](resources/img.png)


We can now click on a node and the link will work.

![img_1.png](resources/img_1.png)

We can also go to the NameNode web interface (port 9870) and click on one of the links there:

![img_2.png](resources/img_2.png)


![img_3.png](resources/img_3.png)


## Restoring your /etc/hosts file from backup
I also prepared a shell script to restore your original file to /etc/hosts from one of the backups. You can start the script:

sudo make dns-restore
Which in the background executes the command:

`sh ./dns_scripts/restore_hosts_from_backup.sh`



https://medium.com/@MarinAgli1/using-hostnames-to-access-hadoop-resources-running-on-docker-5860cd7aeec1
