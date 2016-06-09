#
# Cookbook Name:: test_nginx
# Recipe:: java
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

url=node['java']['source_url']
tar_filename=url[url.rindex("/")+1..-1]

# Download java
bash "Download tar.gz for Oracle Java" do
  cwd node['downloads']['base_directory']
  code <<-EOH
    curl -L -b \"oraclelicense=a\" #{url} -O
    tar xzf #{tar_filename}
    rm -rf #{tar_filename}
  EOH
  not_if do
    ::File.directory?(node['java']['home_directory'])
  end
end

template "/etc/profile.d/jdk.sh" do
  source 'jdk.sh.erb'
  mode "00755"
  backup false
  variables(
    :java_home => node['java']['home_directory'],
    :jre_home => node['java']['jre_home_directory'],
    :java_path => "#{node['java']['home_directory']}/bin"
  )
end