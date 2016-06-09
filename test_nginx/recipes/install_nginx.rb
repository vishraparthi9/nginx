#
# Cookbook Name:: test_nginx
# Recipe:: install_nginx
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

url=node['nginx']['source_url']
tar_filename=url[url.rindex("/")+1..-1]
filename=tar_filename[0..tar_filename.index(".tar")-1]

openssl_url=node['nginx']['openssl_dependency_source_url']
openssl_tar_filename=openssl_url[openssl_url.rindex("/")+1..-1]
openssl_filename=openssl_tar_filename[0..openssl_tar_filename.index(".tar")-1]

nginx_options=node['nginx']['options'].join(' ')
nginx_start_path="#{node['downloads']['base_directory']}/nginx/sbin"
nginx_conf_path="#{node['downloads']['base_directory']}/nginx/conf"

package "gcc" do
  action :install
end

package "pcre-devel" do
  action :install
end

package "perl" do
  action :install
end

# Openssl library dependency
bash "Openssl library install" do
  cwd node['downloads']['base_directory']
  code <<-EOH
    wget #{openssl_url}
    tar -zxf #{openssl_tar_filename}
    cd #{openssl_filename}
    sudo ./config --prefix=#{node['downloads']['base_directory']}
    sudo make
    sudo make install
  EOH
end

# Download nginx
bash "Download tar.gx for nginx" do
  cwd node['downloads']['base_directory']
  code <<-EOH
    wget #{url}
    tar zxf #{tar_filename}
    rm -rf #{tar_filename}
  EOH
  not_if do
    ::File.exists?(filename)
  end
end

# Install and configure nginx
bash "Install nginx" do
  cwd "#{node['downloads']['base_directory']}/#{filename}"
  code <<-EOH
    ./configure #{nginx_options}
    make
    make install
  EOH
  not_if do
    ::File.exists?("nginx")
  end
end

# Replace nginx conf file
template "#{nginx_conf_path}/nginx.conf" do
  source 'nginx.conf.erb'
  backup false
  mode "00644"
end

# Start nginix
execute "Start nginix" do
  cwd nginx_start_path
  command "#{node['nginx']['start_cmd']}"
end