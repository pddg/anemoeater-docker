FROM perl:5.28-slim-threaded-stretch

ENV ANEMOEATER_WORKDIR /anemoeater
ENV ANEMOEATER_VERSION 698486df057733ac072aed920615f47c95f8ef98

# Clone yoku0825/anemoeater
RUN apt-get update && \
    apt-get install -y \
        git=1:2.11.0-3+deb9u4 && \
    git clone https://github.com/yoku0825/anemoeater ${ANEMOEATER_WORKDIR} && \
    cd ${ANEMOEATER_WORKDIR} && \
    git checkout ${ANEMOEATER_VERSION} && \
    apt-get remove --purge -y git && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR ${ANEMOEATER_WORKDIR}

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        default-libmysqlclient-dev \
        gcc=4:6.3.0-4 && \
    cpanm --installdeps . && \
    apt-get remove --purge -y \ 
        gcc \
        libmysqlclient-dev && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Install Percona toolkit
RUN apt-get update && \
    apt-get install -y \
        libparallel-forkmanager-perl \
        libdbd-mysql-perl=4.041-2 \
        libio-socket-ssl-perl=2.044-1 \
        libnet-ssleay-perl=1.80-1 \
        libterm-readkey-perl=2.37-1 \
        wget=1.18-5+deb9u3 && \
    wget https://www.percona.com/downloads/percona-toolkit/3.0.10/binary/debian/bionic/x86_64/percona-toolkit_3.0.10-1.bionic_amd64.deb && \
    dpkg -i percona-toolkit_3.0.10-1.bionic_amd64.deb && \
    rm percona-toolkit_3.0.10-1.bionic_amd64.deb && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

COPY ./init.sh /

RUN chmod +x /init.sh

CMD ["/bin/bash", "/init.sh"]
