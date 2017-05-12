.PHONY:	RFclust  Rscexv  Stefans_Lib_Esentials  ZIFA  SCExV
get_git: 
	git clone https://github.com/stela2502/Stefans_Lib_Esentials.git
	git clone https://github.com/stela2502/RFclust.SGE.git
	git clone https://github.com/stela2502/Rscexv.git
	git clone https://github.com/epierson9/ZIFA.git
	git clone https://github.com/stela2502/SCExV.git
RFclust:
	sudo make -C RFclust.SGE/
Rscexv:
	sudo make -C Rscexv/
Stefans_Lib_Esentials:
	sudo cpanm Module::Install
	sudo make -C Stefans_Lib_Esentials/
	sudo make -C Stefans_Lib_Esentials/ install
ZIFA:
	(cd ZIFA && sudo python setup.py install)
SCExV:
	cpanm Sub::Uplevel 
	cpanm Test::Fatal
	cpanm Pod::Coverage
	cpanm Data::OptList
	cpanm Test::Exception
	cpanm Class::Load
	cpanm namespace::autoclean
	cpanm Catalyst::Action::REST
	cpanm Catalyst::Plugin::FormBuilder
	cpanm HTTP::Request
	cpanm Moose
	cpanm Catalyst::Runtime
	sudo make -C SCExV # installs all dependencies
	perl SCExV/SCExV/script/install.pl -install_path /srv/SCExV/newest/ -perlLibPath /srv/SCExV/newest/perl/lib/ -options randomForest 1 ncore 2 -server_user www-data -nginx_web_path SCExV
	( cd SCExV && git checkout OldVersion )
	perl SCExV/SCExV/script/install.pl -install_path /srv/SCExV/published/ -perlLibPath /srv/SCExV/published /perl/lib/ -options ncore 2 -server_user www-data -nginx_web_path SCExV_old
ngnix:	#set up the server and copy the required files.

all:	get_git RFclust Rscexv Stefans_Lib_Esentials SCExV ZIFA ngnix
