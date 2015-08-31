ELK -  Installation and Requirements
=========

Date Created: 31.08.2015

Created By: Oshik Avioz, Big Data Expert

Email: oavioz@gmail.com

How to Deploy
==========================

1. git clone https://github.com/oavioz/web-service-clients-using-ELK.git
2. change directory to folder content
 2.1 cd web-service-clients-using-ELK
3. Change mode for execute
 3.1 chmod 750 *
4. Running shell scrip
 4.1 ./elk-install.sh
5. Open Kiban web interface and start using analytis

 5.1 http://<localIP>:5601/#/dashboard/MYGAMES-2015?_g=%28time:%28from:%272012-08-31T18:35:39.050Z%27,mode:absolute,to:%272013-02-03T19:50:39.050Z%27%29%29
6. Enjoy :-)

Requirements
==========================
Operating Systems

Supported 
Ubuntu 12.4 or later


Hardware requirements
==========================

CPU
====
1 core works for under 100 users but the responsiveness might suffer
2 cores is the recommended number of cores and supports up to 100 users
4 cores supports about 1,000 users
8 cores supports up to 10,000 users

Memory
======

512MB is too little memory, GitLab will be very slow and you will need 250MB of swap
768MB is the minimal memory size but we advise against this
1GB supports up to 100 users (with individual repositories under 250MB, otherwise git memory usage necessitates using swap space)
2GB is the recommended memory size and supports up to 1,000 users
4GB supports up to 10,000 users


Supported web browsers
=======================

Chrome (Latest stable version)
Firefox (Latest released version and latest ESR version)
Safari 7+ (known problem: required fields in html5 do not work)
Opera (Latest released version)
IE 10+

ELK Configuration
====================

How can I tune Kibana configuration?
====================
The Kibana default configuration is stored in kibana/config/kibana.yml.


How can I tune Logstash configuration?
====================
The logstash configuration is stored in logstash/config/logstash.conf.

The folder logstash/config is mapped onto the container /etc/logstash/conf.d so you can create more than one file in that folder if you'd like to. 
However, you must be aware that config files will be read from the directory in alphabetical order.

How can I tune Elasticsearch configuration?
====================
The Elasticsearch container is using the shipped configuration and it is not exposed by default.

If you want to override the default configuration, create a file elasticsearch/config/elasticsearch.yml and add your configuration in it.


elasticsearch:
  build: elasticsearch/
  ports:
    - "9200:9200"
  volumes:
    - ./elasticsearch/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml
    
How can I store Elasticsearch data?
=========================================================
In order to persist Elasticsearch data, you'll have to mount a volume on your volume host. Update the elasticsearch declaration to:

elasticsearch:
  build: elasticsearch/
  ports:
    - "9200:9200"
  volumes:
    - /path/to/storage:/usr/share/elasticsearch/data
    
  

