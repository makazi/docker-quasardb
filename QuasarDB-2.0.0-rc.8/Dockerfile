FROM ubuntu:16.04

RUN	apt-get update && apt-get install -y wget dnsutils iproute2 gawk && \
	wget https://download.quasardb.net/quasardb/2.0/2.0.0-rc.8/web-bridge/qdb-web-bridge_2.0.0-1.deb && \
	wget http://download.quasardb.net/quasardb/2.0/2.0.0-rc.8/utils/qdb-utils_2.0.0-1.deb && \
	wget http://download.quasardb.net/quasardb/2.0/2.0.0-rc.8/server/qdb-server_2.0.0-1.deb && \
	locale-gen en_US.UTF-8 && \
	dpkg -i qdb-web-bridge_2.0.0-1.deb qdb-utils_2.0.0-1.deb qdb-server_2.0.0-1.deb

ADD	start.sh /start.sh
CMD	/start.sh
