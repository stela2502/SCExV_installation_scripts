#! /bin/bash
.PHONY:	RFclust  Rscexv  Stefans_Lib_Esentials  ZIFA  SCExV systemd
get_git: get_Stefans_Lib_Esentials get_RFclust.SGE get_Rscexv get_SCExV git_ZIFA

get_Stefans_Lib_Esentials:
ifeq ("$(wildcard Stefans_Lib_Esentials/.*)","")
	git clone https://github.com/stela2502/Stefans_Lib_Esentials.git
else
	git -C Stefans_Lib_Esentials pull
endif
get_RFclust.SGE:
ifeq ("$(wildcard RFclust.SGE/.)","")
	git clone https://github.com/stela2502/RFclust.SGE.git
else
	git -C RFclust.SGE pull
endif
get_Rscexv:
ifeq ("$(wildcard Rscexv/.)","")
	git clone https://github.com/stela2502/Rscexv.git
else
	git -C Rscexv pull
endif
get_SCExV:
ifeq ("$(wildcard SCExV/.)","")
	git clone https://github.com/stela2502/SCExV.git
	git -C SCExV checkout testing
else
	git -C SCExV pull
	git -C SCExV checkout testing
endif
git_ZIFA:
ifeq ("$(wildcard ZIFA/.*)","")
	git clone https://github.com/epierson9/ZIFA.git
else
	git -C ZIFA pull
endif
RFclust:
	sudo make -C RFclust.SGE/
Rscexv:
	sudo make -C Rscexv/
Stefans_Lib_Esentials:
	sudo cpanm Module::Install
	sudo rm -Rf Stefans_Lib_Esentials/Stefans_Libs_Essentials/inc
	sudo make -C Stefans_Lib_Esentials/
	sudo make -C Stefans_Lib_Esentials/ install
ZIFA:
	(cd ZIFA && sudo python setup.py install)
SCExV:
	sudo cpanm Sub::Uplevel 
	sudo cpanm Test::Fatal
	sudo cpanm Pod::Coverage
	sudo cpanm Data::OptList
	sudo cpanm Test::Exception
	sudo cpanm Class::Load
	sudo cpanm namespace::autoclean
	sudo cpanm Catalyst::Action::REST
	sudo cpanm Catalyst::Plugin::FormBuilder
	sudo cpanm HTTP::Request
	sudo cpanm Moose
	sudo cpanm Catalyst::Runtime
	sudo make -C SCExV # installs all dependencies
	sudo perl SCExV/SCExV/script/install.pl -install_path /srv/SCExV_newest/ -perlLibPath /srv/SCExV_newest/perl/lib/ -options randomForest 1 ncore 2 -server_user www-data
	git -C SCExV stash
	#git -C SCExV checkout OldVersion
	#sudo perl SCExV/SCExV/script/install.pl -install_path /srv/SCExV_published/ -perlLibPath /srv/SCExV_published /perl/lib/ -options ncore 2 -server_user www-data -nginx_web_path SCExV_old
	#git -C SCExV stash
ngnix:	
	sudo cp nginx_files/SCExV.nginx /etc/nginx/sites-available/
	sudo cp nginx_files/index.html /var/www/html/
ifneq ("$(wildcard /etc/nginx/sites-enabled/default)","") 
	sudo rm /etc/nginx/sites-enabled/default
endif
ifeq ("$(wildcard /etc/nginx/sites-enabled/SCExV.nginx)","") 
	sudo ln -s /etc/nginx/sites-available/SCExV.nginx /etc/nginx/sites-enabled/
endif
systemd:
	sudo cp  systemd/SCExV_new.service /lib/systemd/system/
	sudo cp  systemd/SCExV_published.service /lib/systemd/system/

all:	get_git RFclust Rscexv Stefans_Lib_Esentials SCExV ZIFA ngnix systemd
