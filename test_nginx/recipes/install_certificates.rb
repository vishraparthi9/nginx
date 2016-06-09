#
# Cookbook Name:: test_nginx
# Recipe:: install_certificates
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

ssl_path="#{node['downloads']['base_directory']}/ssl"

# Generate ssl cert and keys
directory ssl_path do
  action :create
  mode "00755"
end

# The same keys can be used for nginx and tomcat
bash "Create cert and key" do
  cwd ssl_path
  code <<-EOH
    sudo openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.testnginx.com" -keyout testnginx.key -out testnginx.cert
    sudo openssl pkcs12 -inkey testnginx.key -in testnginx.cert -export -out testnginx.pfx -password pass:nginxtest
    sudo chmod 755 *
  EOH
end