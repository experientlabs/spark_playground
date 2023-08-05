

In the spark default settings, we put `spark.master` to `yarn`
- file name spark-multinode-yarn/yarn/spark-defaults.conf


In the Mapred site (mapred-site.xml) yarn is set as job scheduler
```yaml
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
```

https://medium.com/@MarinAgli1/setting-up-hadoop-yarn-to-run-spark-applications-6ea1158287af