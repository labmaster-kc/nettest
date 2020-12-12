# labmaster-kc/nettest
## A simple docker image that uses curl, and a simple shell script to monitor external network information.
### Flow of operations:
* 1: Container starts up and sleeps number of seconds specified by **NET_CHECK** (Defaults to 900 seconds, or 15 minutes if variable not provided)
* 2: Once **NET_CHECK** time has passed, container waits between 1 and 15 seconds (Randomized each time the loop runs so that you can run multiple containers and not cause an API time-out)
  * Curl makes a call to **https://api.ipify.org** to determine current external IP address of host.
* 3: Container start-up and any external IP records are logged inside container to **/tmp/nettest-log**, this directory can be exported to make the logs available outside container
  
### Notes:
* Required variables have a default set of NULL, the container looks for these and exits with a message of problem in the log file.  An easy way to trouble-shoot container is to map /tmp to an external directory (explained in the docker-compose and docker run example below)
* Only required ENV variables are **DOMAIN** and **API_KEY**, everything else has valid defaults
   * Labmaster 2020.11.05 - Added required ENV variable **API_SECRET**
* ENV variables "PUID" and "PGID" can be passed to set owner of logfile to a specific user, this is useful for mapping an external directory and setting the owner to a normal user
## Docker-compose example
* In this example I will be monitoring and updating **cool-site.example.com**, and checking for a change to DNS every 600 seconds (10 minutes)
  * **volumes** can be omitted or mapped somewhere such as a a folder under your home directory, simply change the *left* side to point to where you'd like to save DNS update logfiles
* Change "TIME_ZONE" to match your desired timezone.  A vaild list can be found at https://www.wikiwand.com/en/List_of_tz_database_time_zones under the "TZ database name" column.  Default is "America/New_York"
```
#docker-compose.yaml
version: "2.1"
services:
  nettest:
    image: labmasterkc/nettest
    container_name: nettest
    restart: unless-stopped
    environment:
      NET_CHECK: 600
      TIME_ZONE: America/New_York
    volumes:
      - /tmp:/tmp
```
## Support
* Shell access while the container is running:<br>
 `docker exec -it nettest /bin/bash`
* To see log of DNS updates:<br>
 `docker exec -it nettest cat /tmp/*-log` 
* Container version number:<br>
 `docker inspect -f '{{ index .Config.Labels "build_version" }}' nettest`
* Image version number:<br>
 `docker inspect -f '{{ index .Config.Labels "build_version" }}' labmasterkc/nettest`
