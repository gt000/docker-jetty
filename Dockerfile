FROM java:8-jdk
MAINTAINER Nicholas Iaquinto <nickiaq@gmail.com>

# In case someone loses the Dockerfile
RUN rm -rf /etc/Dockerfile
ADD Dockerfile /etc/Dockerfile

# Install packages
RUN apt-get update && \ 
    apt-get update --fix-missing && \ 
    apt-get install -y wget

# Download and install jetty
ENV JETTY_VERSION 9.3.14
ENV RELEASE_DATE v20161028
LABEL io.openshift.expose-services="8080:http"

# http://central.maven.org/maven2/org/eclipse/jetty/jetty-distribution/9.3.14.v20161028/jetty-distribution-9.3.14.v20161028.tar.gz
RUN wget http://central.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${JETTY_VERSION}.${RELEASE_DATE}/jetty-distribution-${JETTY_VERSION}.${RELEASE_DATE}.tar.gz && \
    tar -xzvf jetty-distribution-${JETTY_VERSION}.${RELEASE_DATE}.tar.gz && \
    rm -rf jetty-distribution-${JETTY_VERSION}.${RELEASE_DATE}.tar.gz && \
    mv jetty-distribution-${JETTY_VERSION}.${RELEASE_DATE}/ /opt/jetty

# Configure Jetty user and clean up install
RUN useradd jetty && \
    chown -R jetty:jetty /opt/jetty && \
    rm -rf /opt/jetty/webapps.demo

# Set defaults for docker run
WORKDIR /opt/jetty
CMD ["java", "-jar", "start.jar", "jetty.home=/opt/jetty"]
