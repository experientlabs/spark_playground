# Spark Multi Node cluster setup using Docker




https://github.com/mrn-aglic/pyspark-playground
https://medium.com/@MarinAgli1/setting-up-a-spark-standalone-cluster-on-docker-in-layman-terms-8cbdc9fdd14b


https://medium.com/@MarinAgli1/setting-up-hadoop-yarn-to-run-spark-applications-6ea1158287af





How to install make on windows?
1. Run powershell as administrator
2. Execute following command in powershell
   ```commandline
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) 
    ```
3. Once above command was successful, run below command to install make
   ```
   choco install make
   ```

https://windowsreport.com/make-command-not-found/