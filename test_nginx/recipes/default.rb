#
# Cookbook Name:: test_nginx
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'test_nginx::install_oracle_jdk'
include_recipe 'test_nginx::install_tomcat'
include_recipe 'test_nginx::install_certificates'
include_recipe 'test_nginx::install_nginx'