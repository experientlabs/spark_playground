# Spark One Node setup in Docker

This is apache spark one node setup to test Apache spark and for learning purpose. This is an alternative to VM's that 
are big in volume and take too much resources. 

To build the docker image run below command
```
    docker-compose build
```

To run the docker run the `docker-compose up` command as given below. 
```
    docker-compose up -d
```

In order to launch pyspark you can go to the container and type pyspark as given below

![pyspark_terminal](resources/terminal.png)


Test if spark is setup properly and working file by running below code

```
import pyspark.sql.functions as f

textfile_df = spark.read.text("textfile.txt")
textfile_df.show()
df = textfile_df.withColumn('wordCount', f.size(f.split(f.col('value'), ' ')))
df.show()
wc_df = textfile_df.withColumn('word', f.explode(f.split(f.col('value'), ' '))).groupBy('word').count().sort('count', ascending=False).show()
wc_df.show()
```

![word_count](resources/word_count.png)


![word_frequency_count](resources/word_frequency_count.png)


In order to launch SparkUI you can go to localhost:4040
Spark UI screenshot given below

![spark_ui](resources/spark_ui.png)





### Start Container using start.sh:
To use the script, make sure it has executable permissions (chmod +x start.sh). Then you can run the script with the desired command-line argument.

Examples:

```./start.sh build ```: will build the Docker image using docker-compose build.
```./start.sh run``` will run the container using docker-compose up -d.
```./start.sh build_and_run``` will both build the Docker image and run the container using the respective functions.


### Start Container using start.bat (Windows):
```start.bat build```: Executes the :build function to build the Docker image.
```start.bat run```: Executes the :run function to run the Docker container.
```start.bat build_and_run```: Executes the :build_and_run function to build the image and run the container.



For Windows:

```
set hostfolder=%cd%
set dockerfolder=/home/sam/app

echo %hostfolder%
echo %dockerfolder%

```

