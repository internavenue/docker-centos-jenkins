FROM internavenue/centos-base:centos7

MAINTAINER Intern Avenue Dev Team <dev@internavenue.com>

RUN wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
RUN rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key

RUN yum -y install \
  java-1.7.0-openjdk \
  jenkins

# Clean up YUM when done.
RUN yum clean all

ADD scripts /scripts
RUN chmod +x /scripts/start.sh
RUN touch /first_run

# The --deaemon removed from the init file.
ADD etc/jenkins /etc/init.d/jenkins
RUN chmod +x /etc/init.d/jenkins

EXPOSE 8080 22

# Vagrant directory can be used for Vagrant-based scenarios,
# but you can use it for general filesystem-share with the
# host, e.g. you can place your Puppet manifests and execute
# puppet apply inside the container.
VOLUME ["/vagrant", "/run", "/var/lib/jenkins", "/var/log" "/var/cache/jenkins/war]

# Kicking in
CMD ["/scripts/start.sh"]

