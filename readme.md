# Apache Spark Playground

This repository contains docker setup of Apache Spark for the purpose of learning, experimenting and hands-on. 
It contains various setups like:

1. Spark Single Node Setup Using Docker
2. Spark Standalone Cluster  (1 Master and scalable Worker Nodes)
3. Spark Yarn Cluster (1 Master and scalable Worker Nodes)
4. Spark Yarn Cluster with Hostname (1 Master and scalable Worker Nodes, each worker node is accessible through ui link)
5. Spark cluster with Kubernetes. 

To know, how to use it, refer the readme file inside each folder. 


![spark_in_docker](spark-single-node/resources/spark_in_docker.jpg)



#### ToDo:
- Add Airflow to the spark cluster.
- Add Jupyter notebook to Spark Cluster.
- Add CI tests using github actions. 
=======
# Apache Spark Playground

This repository contains docker seup of Apache Spark for the purpose of learning, experimenting and hands-on. 
It contains various setups like:

1. Spark Single Node Setup Using Docker
2. Spark Standalone Cluster  (1 Master and scalable Worker Nodes)
3. Spark Yarn Cluster (1 Master and scalable Worker Nodes)
4. Spark Yarn Cluster with Hostname (1 Master and scalable Worker Nodes, each worker node is accessible through ui link)
5. Spark cluster with Kubernetes. 

To know, how to use it, refer the readme file inside each folder. 


![spark_in_docker](spark-single-node/resources/spark_in_docker.jpg)



#### ToDo:
- Add Airflow to the spark cluster.
- Add Jupyter notebook to Spark Cluster.
- Add CI tests using github actions. 
- Spark images can also be built using Alpine linux, rather than debian images which are bit heavy.
