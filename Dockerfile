FROM robers97/centos7ppc64le
MAINTAINER Nimbix, Inc.

RUN yum -y update

ADD https://github.com/nimbix/image-common/archive/master.zip /tmp/nimbix.zip
WORKDIR /tmp
RUN yum -y install zip unzip xz tar file sudo openssh-server openssh-clients infiniband-diags openmpi perftest libibverbs-utils libmthca libcxgb4 libmlx4 libmlx5 dapl compat-dapl && yum clean all
RUN unzip nimbix.zip && rm -f nimbix.zip
RUN /tmp/image-common-master/setup-nimbix.sh

RUN curl -OL https://developer.nvidia.com/compute/cuda/8.0/prod/local_installers/cuda-repo-rhel7-8-0-local-ga2-8.0.54-1.ppc64le-rpm && rpm -ivh cuda-repo-rhel7-8-0-local-ga2-8.0.54-1.ppc64le-rpm && rm -f cuda-repo-rhel7-8-0-local-ga2-8.0.54-1.ppc64le-rpm && yum -y install cuda-toolkit-8-0 && yum clean all && rpm -e cuda-repo-rhel7-8-0-local-ga2

# Nimbix JARVICE emulation
EXPOSE 22
RUN mkdir -p /usr/lib/JARVICE && cp -a /tmp/image-common-master/tools /usr/lib/JARVICE
RUN ln -s /usr/lib/JARVICE/tools/noVNC/images/favicon.png /usr/lib/JARVICE/tools/noVNC/favicon.png && ln -s /usr/lib/JARVICE/tools/noVNC/images/favicon.png /usr/lib/JARVICE/tools/noVNC/favicon.ico
WORKDIR /usr/lib/JARVICE/tools/noVNC/utils
RUN ln -s websockify /usr/lib/JARVICE/tools/noVNC/utils/websockify.py && ln -s websockify /usr/lib/JARVICE/tools/noVNC/utils/wsproxy.py
WORKDIR /tmp
RUN cp -a /tmp/image-common-master/etc /etc/JARVICE && chmod 755 /etc/JARVICE && rm -rf /tmp/image-common-master && mkdir -m 0755 /data && chown nimbix:nimbix /data

RUN ln -s /usr/local/cuda-8.0/targets/ppc64le-linux/lib /usr/lib/powerpc64le-linux-gnu
RUN yum -y install passwd && yum clean all

