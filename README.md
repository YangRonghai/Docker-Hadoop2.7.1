# Docker-Hadoop2.7.1
Setup a single-node cluster of Hadoop 2.7.1. with Docker

## Prequisite
Make sure Docker is well installed.

## Steps to setup Hadoop
1. Pull the image
```
docker pull ronghaiyang/hadoop2.7.1
```

2. Launch container
```
docker run -i -t ronghaiyang/hadoop2.7.1
```

3. Start Hadoop cluster
```
./my-start-hadoop.sh
```
Note that we create a sudo-user `hduser` to run Hadoop. The password for `hduser` is `hduser`.

Now you have a ready-to-run cluster.

If you would like to build it from scratch, check the Dockerfile.

