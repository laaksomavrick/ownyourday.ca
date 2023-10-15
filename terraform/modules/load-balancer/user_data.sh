#!/bin/bash
set -x

# TODO: set up config file for nginx
# /etc/nginx/nginx.conf

# Install and start nginx
sudo yum install nginx
sudo /etc/init.d/nginx start
