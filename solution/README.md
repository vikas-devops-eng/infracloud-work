## Part I
1. Run the container image `infracloudio/csvserver:latest` in background and check if it's running.
 - docker run -d --name csvserver infracloudio/csvserver:latest

2. If it's failing then try to find the reason, once you find the reason, move to the next step.
 - docker logs csvserver
2023/10/04 15:21:15 error while reading the file "/csvserver/inputdata": open /csvserver/inputdata: no such file or directory

3. Write a bash script `gencsv.sh` to generate a file named `inputFile` whose content looks like:
vi gencsv.sh

    #!/bin/bash
    start=$1
    end=$2

    for ((i=start; i<=end; i++)); do
        rand_num=$((RANDOM % 1000))  # Generate a random number between 0 and 999
        echo "$i, $rand_num" >> inputFile
    done

save and execute script with two arguments as `./gencsv.sh 2 8`    

4. Run the container again in the background with file generated in (3) available inside the container .

-   docker rm csvserver
-   docker run -d --name csvserver -v "$(pwd)/inputFile:/csvserver/inputdata" infracloudio/csvserver:latest

5. 5. Get shell access to the container and find the port on which the application is listening. Once done, stop / delete the running container.

- docker stop csvserver
- docker rm csvserver

- docker exec -it csvserver /bin/sh
sh-4.4# netstat -ntulp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp6       0      0 :::9300                 :::*                    LISTEN      1/qemu-x86_64

6. Same as (4), run the container and make sure,
     - The application is accessible on the host at http://localhost:9393
     - Set the environment variable `CSVSERVER_BORDER` to have value `Orange`.

- docker stop csvserver
- docker rm csvserver

- docker run -p 9393:9300 --name csvserver -v "$(pwd)/inputFile:/csvserver/inputdata" -e CSVSERVER_BORDER=orange -d infracloudio/csvserver:latest

opened http://localhost:9393/ 



## Part II

  0. Delete any containers running from the last part.
    docker stop csvserver
    docker rm csvserver

  1. Create a `docker-compose.yaml` file for the setup from part I.

  2. Use an environment variable file named `csvserver.env` in `docker-compose.yaml` to pass environment variables used in part I.
- touch docker-compose.yaml csvserver.env and add required details.

  3. One should be able to run the application with `docker-compose up`.
 - verify the solution by browsing - http://localhost:9393/


## Part III

    0. Delete any containers running from the last part.
-     docker stop csvserver
-     docker rm csvserver

    1. Add Prometheus container (`prom/prometheus:v2.22.0`) to the docker-compose.yaml form part II.
    cat docker-compose.yaml

    2. Configure Prometheus to collect data from our application at `<application>:<port>/metrics` endpoint. (Where the `<port>` is the port from I.5)
    
    http://localhost:9090/metrics
    
    3. Make sure that Prometheus is accessible at http://localhost:9090 on the host.
    4. Type `csvserver_records` in the query box of Prometheus. Click on Execute and then switch to the Graph tab.
- http://localhost:9090/graph?g0.range_input=1h&g0.expr=csvserver_records&g0.tab=0