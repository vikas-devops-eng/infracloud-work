Part 1.

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

    > inputFile  # Clear the contents of the file or create it if it doesn't exist

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

