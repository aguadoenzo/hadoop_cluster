FROM sequenceiq/hadoop-docker:latest

WORKDIR /root/


# Configuration files
ENV HADOOP_HOME=/usr/local/hadoop
ENV PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin

COPY ./config /tmp

RUN mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/ &&\
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/ &&\
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/


# Starting application
COPY entrypoint.sh .

RUN $HADOOP_HOME/bin/hdfs namenode -format

RUN chmod 755 entrypoint.sh

EXPOSE 9000

CMD ["sh", "-c", "service sshd start && ./entrypoint.sh ; bash"]