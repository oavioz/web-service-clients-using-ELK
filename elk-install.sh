#!/bin/bash

INSTALL_DIR=$HOME/elkpackage
LOGSTASH_PATH=logstash_1.5.0-1_all
LOGSTASH_BINARY=$LOGSTASH_PATH.deb
ES_PATH=elasticsearch-1.5.2
ES_BINARY=$ES_PATH.deb
DATA_FILE_NAME=game_data.csv
DATA_BINARY=game_data.csv.gz
KIBANA_VERSION=kibana-4.0.2
KIBANA_OS=darwin-x64
KIBANA_BINARY=/opt/kibana/bin
IP_ADDR=$(/sbin/ifconfig | grep -e "inet:" -e "addr:" | grep -v "inet6" | grep -v "127.0.0.1" | head -n 1 | awk '{print $2}' | cut -c6-)


echo Install git
sudo apt-get -y install git


echo Installing ELK stack into $INSTALL_DIR
mkdir -p $INSTALL_DIR
cp mydb.conf $INSTALL_DIR
cp week-by-week.json $INSTALL_DIR
cp $DATA_BINARY $INSTALL_DIR
cp kibana_default_data.sh $INSTALL_DIR

cd $INSTALL_DIR


# Install Oracle Java 8
	
	sudo add-apt-repository -y ppa:webupd8team/java
	sudo apt-get update
	echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
	echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
	sudo apt-get -y install oracle-java8-installer
	
	
if test -s $ES_BINARY
then
    echo Elasticsearch already Downloaded
else
		cd /var/cache/apt/archives
        echo Downloading $ES_PATH
        sudo wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.5.2.deb
		sudo dpkg -i elasticsearch-1.5.2.deb
		sudo update-rc.d elasticsearch defaults 95 10
		sudo /etc/init.d/elasticsearch restart
fi


#cd $INSTALL_DIR
if test -s $LOGSTASH_BINARY
then
    echo Logstash already Downloaded
else
        echo Downloading logstash logstash_1.5.0-1_all
		cd /var/cache/apt/archives
        sudo wget http://download.elastic.co/logstash/logstash/packages/debian/logstash_1.5.0-1_all.deb
		sudo dpkg -i logstash_1.5.0-1_all.deb
		sudo update-rc.d logstash defaults 95 10
		sudo /etc/init.d/logstash restart
fi


cd $INSTALL_DIR
echo Unpacking dataset
gunzip -f $DATA_BINARY

# Elasticsearch marvel Plugin

#cd $ES_PATH
cd /usr/share/elasticsearch
if [ -d "plugins/marvel" ];
then
    echo Marvel already installed
else
        echo Installing Marvel latest
        sudo bin/plugin -i elasticsearch/marvel/latest
fi

#  head Plugin for elasticsearch cluster management

if [ -d "plugins/head" ];
then
    echo head already installed
else
        echo Installing head plugin
        sudo bin/plugin --install mobz/elasticsearch-head
fi

if test -s $KIBANA_BINARY
then
    echo Kibana already Downloaded
else
        echo Downloading Kibana Latest
		cd /opt
        sudo wget https://download.elasticsearch.org/kibana/kibana/kibana-4.0.2-linux-x64.tar.gz
		sudo tar xvfz kibana-4.0.2-linux-x64.tar.gz
		sudo ln -s kibana-4.0.2-linux-x64 kibana
fi

	# Start Kibana Via Startup Script
	cd /etc/init.d
	sudo wget https://raw.githubusercontent.com/akabdog/scripts/master/kibana4_init
	sudo chmod 755 kibana4_init
	sudo update-rc.d kibana4_init defaults 95 10
	sudo /etc/init.d/kibana4_init restart
	
cd $INSTALL_DIR
./kibana_default_data.sh
	
#cd $LOGSTASH_PATH
cd /opt/logstash
echo loading game data using logstash
bin/logstash -f $INSTALL_DIR/mydb.conf < $INSTALL_DIR/$DATA_FILE_NAME

echo Now browse to ELK Services:

echo Elasticsearch Lucene Query Editor
echo  http://$IP_ADDR:9200/_plugin/marvel/sense

echo or Elasticsearch Cluster
echo http://$IP_ADDR:9200/_plugin/head

echo or Kibana UI Visualization
echo http://$IP_ADDR:5601

echo or Kibana default dashboard samnple
echo http://$IP_ADDR:5601/#/dashboard/MYGAMES-2015?_g=%28time:%28from:%272012-08-31T18:35:39.050Z%27,mode:absolute,to:%272013-02-03T19:50:39.050Z%27%29%29
exit
