# SCExV_installation_scripts
This repository contains my list of working SCExV installation scripts and an expample of how to use them.

## There are some steps you need to take manually:

(1) Install a fresh Ubuntu 16.04 minimal server

(2) install git using

	sudo apt install git

and configure it:

	git config --global user.email "you@example.com"

	git config --global user.name "Your Name"

You need to do that as we need to stash away some local changes during the install process.

## The scripted part

Clone this repository

	git clone https://github.com/stela2502/SCExV_installation_scripts.git

run the Ubuntu_16.04_apt.sh script to add the R repository and install all required packages.

	cd SCExV_installation_scripts
	sudo Ubuntu_16.04_apt.sh

And finally install all packages

	make all


Now you should get a webpage delivered from this server that gives you access to both the actual and the published SCExV installations. 
