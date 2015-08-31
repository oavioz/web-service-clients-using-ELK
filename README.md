ELK -  Installation and Requirements
=========

Date Created: 31.08.2015
Created By: Oshik Avioz, Big Data Expert
Email: oavioz@gmail.com

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
    
  

