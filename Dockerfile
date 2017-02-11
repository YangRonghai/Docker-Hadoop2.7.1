FROM ubuntu:14.04

MAINTAINER Sebastian Schoenherr <sebastian.schoenherr@i-med.ac.at>

# Install some basic tools
RUN sudo apt-get update -y
RUN sudo apt-get install wget -y

# Install Prerequistes
RUN sudo apt-get install openjdk-7-jre-headless -y
RUN sudo apt-get install openjdk-7-jdk -y
RUN sudo apt-get install openssh-server -y

# Create an User Account for Hadoop
RUN sudo addgroup hadoop
RUN sudo adduser --gecos "" --ingroup hadoop hduser

#RUN echo -e "hduser\nhduser\n" | sudo passwd hduser
RUN echo "hduser:hduser" | chpasswd

RUN sudo usermod -a -G sudo hduser


# Change to hduser
USER hduser

# Change to hduser home dir
WORKDIR /home/hduser/


# Generate ssh key pair
RUN ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 644 ~/.ssh/authorized_keys 


# Install MapReduce 2.7.1
RUN wget http://ftp.cuhk.edu.hk/pub/packages/apache.org/hadoop/common/hadoop-2.7.1/hadoop-2.7.1.tar.gz
RUN tar -zxvf hadoop-2.7.1.tar.gz
RUN mkdir -p hadoop_tmp/hdfs/namenode
RUN mkdir -p hadoop_tmp/hdfs/datanode

# Download config
RUN wget https://www.dropbox.com/s/ksb6zfoyrftwwek/hadoop-etc.tar.gz?dl=0
RUN tar xzvf hadoop-etc.tar.gz?dl=0
RUN rm -rf /home/hduser/hadoop-2.7.1/etc/hadoop
RUN mv hadoop /home/hduser/hadoop-2.7.1/etc/hadoop



RUN echo "export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64" >> ~/.bashrc
RUN echo "export HADOOP_HOME=/home/hduser/hadoop-2.7.1" >> ~/.bashrc
RUN echo "export HADOOP_MAPRED_HOME=/home/hduser/hadoop-2.7.1" >> ~/.bashrc
RUN echo "export HADOOP_COMMON_HOME=/home/hduser/hadoop-2.7.1" >> ~/.bashrc
RUN echo "export HADOOP_HDFS_HOME=/home/hduser/hadoop-2.7.1" >> ~/.bashrc
RUN echo "export YARN_HOME=/home/hduser/hadoop-2.7.1" >> ~/.bashrc
RUN echo "export HADOOP_COMMON_LIB_NATIVE_DIR=/home/hduser/hadoop-2.7.1/lib/native" >> ~/.bashrc
RUN echo 'export HADOOP_OPTS="-Djava.library.path=/home/hduser/hadoop-2.7.1/lib" ' >> ~/.bashrc
# RUN echo "export PATH=/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/sbin:/home/hduser/hadoop-2.7.1/sbin" >> ~/.bashrc
# RUN echo "export PATH=/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/sbin:/home/hduser/hadoop-2.7.1/bin" >> ~/.bashrc

RUN ["/bin/bash", "-c", "source ~/.bashrc"]

RUN echo $PATH

ENV PATH /home/hduser/hadoop-2.7.1/bin:$PATH
ENV PATH $PATH:/home/hduser/hadoop-2.7.1/sbin

RUN echo $PATH

# Start Hadoop in a script. Note that you cannot start a service in an image
RUN touch my-start-hadoop.sh
RUN echo "sudo service ssh restart" >> my-start-hadoop.sh
RUN echo "hdfs namenode -format" >> my-start-hadoop.sh
RUN echo "start-dfs.sh" >> my-start-hadoop.sh
RUN echo "start-yarn.sh" >> my-start-hadoop.sh
RUN echo "mr-jobhistory-daemon.sh start historyserver" >> my-start-hadoop.sh
RUN chmod +x my-start-hadoop.sh

#HDFS Ports
EXPOSE 50010 50020 50070 50075 50090

#MapReduce Ports
EXPOSE 8088 19888

# CMD ./my-start-hadoop.sh
