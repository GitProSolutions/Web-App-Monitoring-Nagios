#!/bin/bash

# Step 1: Install Nagios on your server

sudo apt-get update
sudo apt-get install -y nagios3 nagios-plugins

# Step 2: Configure Nagios

sudo cp /etc/nagios3/nagios.cfg /etc/nagios3/nagios.cfg.bak
sudo sed -i 's/check_external_commands=0/check_external_commands=1/g' /etc/nagios3/nagios.cfg
sudo service nagios3 restart

# Step 3: Configure Nagios plugins

sudo apt-get install -y nagios-plugins-basic nagios-plugins-extra

# Step 4: Add a new command to Nagios

sudo echo "define command{
    command_name check_http
    command_line /usr/lib/nagios/plugins/check_http -I $HOSTADDRESS$
}" >> /etc/nagios3/commands.cfg

# Step 5: Add a new host to Nagios

sudo echo "define host{
    use                     linux-server
    host_name               web-app-server
    alias                   Web Application Server
    address                 [WEB_APP_SERVER_IP]
    }

# Step 6: Add a new service to Nagios

define service{
    use                             generic-service
    host_name                       web-app-server
    service_description             HTTP
    check_command                   check_http
    }" >> /etc/nagios3/conf.d/web-app-server.cfg

# Step 7: Restart Nagios

sudo service nagios3 restart
