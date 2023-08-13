# Spark YARN Cluster in Docker
This project is based on Spark Yarn cluster plus ability to browser datanode through hostname url. 
In general when we setup Spark yarn cluster, the url in web interface don't work. 
Because host names are randomly assigned by docker and DNS resolver does not know about it. 
So in this setup we expose docker hostname to the host machine so that hostname becomes accessible.


# Running Cluster
Run `make run-ag n=3` and wait untill cluster starts, then run the script to modify the dns `make dns-modify o=true n=3`
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


Issues
The issue with this solution is that all of the hostnames point to localhost. This means that if you were, e.g. yarn.worker1.org:8042 and changed only the port number so you end up with this: yarn.worker1.org:18080 you will see the spark history server, despite being on the yarn worker hostname. However, I don’t honestly know how to solve this since everything is actually pointing to localhost.

https://medium.com/@MarinAgli1/using-hostnames-to-access-hadoop-resources-running-on-docker-5860cd7aeec1


TODO:
To add Airflow container
Explore container orchestration tools
    1. Kubernetes
    2. Docker Swarm