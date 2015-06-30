FROM sumpfgottheit/centos7
MAINTAINER Florian Sachs "florian.sachs@gmx.at"

RUN yum -y install python-pip gcc python-devel
RUN pip install gunicorn logstash_formatter
RUN yum clean all

RUN mkdir /pub 

ADD logstash.conf /etc/logstash.conf
ADD gunicorn.logging.conf /gunicorn.logging.conf
ADD inject-logging-into-gunicorn.sh /docker-entrypoint.d/inject-logging-into-gunicorn.sh
ADD pip-install-requirements.sh /docker-entrypoint.d/pip-install-requirements.sh

EXPOSE 5000

CMD /usr/bin/gunicorn --config /docker-entrypoint-ext.d/gunicorn.ini $(</docker-entrypoint-ext.d/gunicorn.app)
