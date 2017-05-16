#! /bin/bash
.PHONY:	RFclust  Rscexv  Stefans_Lib_Esentials  ZIFA  SCExV
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
else
	git -C SCExV pull
	git -C SCExV checkout master
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
	sudo perl SCExV/SCExV/script/install.pl -install_path /srv/SCExV/newest/ -perlLibPath /srv/SCExV/newest/perl/lib/ -options randomForest 1 ncore 2 -server_user www-data -nginx_web_path SCExV
	git -C SCExV stash
	git -C SCExV checkout OldVersion
	sudo perl SCExV/SCExV/script/install.pl -install_path /srv/SCExV/published/ -perlLibPath /srv/SCExV/published /perl/lib/ -options ncore 2 -server_user www-data -nginx_web_path SCExV_old
	git -C SCExV stash
ngnix:	#set up the server and copy the required files.

all:	get_git RFclust Rscexv Stefans_Lib_Esentials SCExV ZIFA ngnix
