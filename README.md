# SCExV_installation_scripts
This repository contains my list of woring SCExV installation scripts and a expample of how to use them.

There are some steps you need to take manually:

(1) Install a fresh Ubuntu 16.04 minimal server
(2) install git using

	sudo apt install git

and configure it:

git config --global user.email "you@example.com"
git config --global user.name "Your Name"

as we need to stash away some local changes during the install process.

run the Ubuntu_16.04_apt.sh script to add the R repository and install all required packages.

run make.

Now you should get a webpage delivered from this server that gives you access to both the actual and the published SCExV installations. 
