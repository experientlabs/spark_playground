# Spark Multinode Cluster on YARN
Hadoop Yarn is basically a component of Hadoop which provides resource management and job scheduling. Let’s try to put it simply. You have a global resource manager (called ResourceManager) running on a master node. The ResourceManager assigns resources to a running application. Each worker node runs a NodeManager. The NodeManager is responsible for the node’s containers and reporting their resource usage back to the ResourceManager [5]. A container in YARN is just an abstract notion that represents resources.


In the spark default settings, we put `spark.master` to `yarn`
- file name spark-multinode-yarn/yarn/spark-defaults.conf

In the Mapred site (mapred-site.xml) yarn is set as job scheduler
```yaml
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
```


NameNode web UI on `localhost:9870`

![data_node.png](resources%2Fdata_node.png)

HDFS Data:

![browse_hdfs.png](resources%2Fbrowse_hdfs.png)

https://medium.com/@MarinAgli1/setting-up-hadoop-yarn-to-run-spark-applications-6ea1158287af