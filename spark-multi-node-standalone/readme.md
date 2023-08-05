# Spark Multi Node cluster setup using Docker
This repo contains spark multinode cluster in spark standalone mode.
There are three services defined in the docker-compose.yml file namely:
- master
- worker and 
- history server

We can have arbitrary number of worker nodes by scaling the workers in docker compose command as given below:

```commandline
docker-compose up --scale spark-worker=3
```

Makefile is used to build, spin-up(run), down the container and also to submit the job.
```commandline
make run-scaled
```
Spark UI can be accessed from url localhost:9090

![img.png](resources%2Fspark_ui.png)


To submit the job use below command:
```commandline
make submit app=data_analysis_book/chapter03/word_non_null.py
```
If you pay attention to makefile, you will know that the command that will execute in backgrond is

```commandline
docker exec da-spark-master spark-submit --master spark://spark-master:7077 --deploy-mode client ./apps/data_analysis_book/chapter03/word_non_null.py
```

![spark_application.png](resources%2Fspark_application.png)


To access the History Server and download logs use this url:
localhost:18080 

![history_server.png](resources%2Fhistory_server.png)


## TODO
- Add jupyter notebook to interact with spark shell.
- Add custom example code and data to cover wide variety of Spark features.
- Add volume to store logs to local machine.
- Add CI/CD unit tests, etc. 

### Additional Notes:
Drawbacks of Standalone cluster mode:
1. Standalone mode does not support cluster mode for Python applications.
2. Standalone mode only supports FIFO Scheduler.
3. 



#### Commands I used while testing the docker environment:

To build image: 
`docker build -t spark-base-image .`

To run image:
```
docker run --rm -it \
  -p 8080:8080 \
--entrypoint bash spark-base-image:latest
```

To build image using Makefile:
`make build`

To launch spark cluster using Makefile:
`make run-scaled`


There was formatting issue with entrypoint.sh due to invalid characters in the file.
In order to sanitize entrypoint.sh off invalid characters, I ran below command: 
And this reminds me n*100th times, how much windows sucks. 
```
perl -i -pe 'y|\r||d' entrypoint.sh
```

#### How to install make on windows?
1. Run powershell as administrator
2. Execute following command in powershell
   ```
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) 
    ```
3. Once above command was successful, run below command to install make
   ```
   choco install make
   ```

#### References and Credits:
- https://spark.apache.org/docs/latest/spark-standalone.html
- https://github.com/mrn-aglic/pyspark-playground
- https://medium.com/@MarinAgli1/setting-up-a-spark-standalone-cluster-on-docker-in-layman-terms-8cbdc9fdd14b 
- https://medium.com/@MarinAgli1/setting-up-hadoop-yarn-to-run-spark-applications-6ea1158287af 
- https://windowsreport.com/make-command-not-found/
- https://towardsdatascience.com/apache-spark-cluster-on-docker-ft-a-juyterlab-interface-418383c95445 (Spark with Jupyter)