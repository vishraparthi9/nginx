#
# Cookbook Name:: test_nginix
# Recipe:: install_tomcat
#
#
# All rights reserved - Do Not Redistribute
#

# Install tomcat
install_dir="#{node['tomcat']['base_directory']}/#{node['tomcat']['instance']}"
url=node['tomcat']['source_url']
tar_filename=url[url.rindex("/")+1..-1]

# Create tomcat user group
group node['tomcat']['group'] do
  gid node['tomcat']['group_id']
  action :create
end

# Create tomcat user
user node['tomcat']['user'] do
  gid node['tomcat']['group_id']
  uid node['tomcat']['user_id']
  action :create
end

# Create base directory
directory node['tomcat']['base_directory'] do
  owner node['tomcat']['user']
  group node['tomcat']['group']
  mode "00755"
  recursive true
end

# Download tomcat
remote_file "#{node['downloads']['base_directory']}/#{tar_filename}" do
  source url
  owner node['tomcat']['user']
  group node['tomcat']['group']
  mode "00755"
  backup false
end

bash "Install tomcat" do
  cwd node['tomcat']['base_directory']
  user node['tomcat']['user']
  group node['tomcat']['group']
  code <<-EOH
    tar zxf #{node['downloads']['base_directory']}/#{tar_filename}
    mv #{node['tomcat']['default_instance']} #{node['tomcat']['instance']}
    rm -rf #{node['downloads']['base_directory']}/#{tar_filename}
    rm -rf #{node['tomcat']['instance']}/webapps/*
  EOH
  not_if do
    ::File.exists?(install_dir)
  end
end

catalina_home=::File.join(node['tomcat']['base_directory'], node['tomcat']['instance'])

template "#{catalina_home}/bin/setenv.sh" do
  source 'setenv.sh.erb'
  mode "00755"
  user node['tomcat']['user']
  group node['tomcat']['group']
  backup false
  variables(
    :java_home => node['java']['home_directory']
  ) 
end

# Create tomcat init script
template "/etc/init.d/tomcat_#{node['tomcat']['instance']}" do
  source 'tomcat_init.sh.erb'
  mode "00755"
  backup false
  variables(
    :catalina_home => catalina_home
  )
end

# Create a sample web page
directory "#{install_dir}/webapps/MyApp" do
  action :create
  user node['tomcat']['user']
  group node['tomcat']['group']
  mode "00755"
end

template "#{install_dir}/webapps/MyApp/index.html" do
  source 'sample.html.erb'
  user node['tomcat']['user']
  group node['tomcat']['group']
  mode "00755"
  backup false
end

# Setup the custom https server.xml
template "#{catalina_home}/conf/server.xml" do
  source 'server.xml.erb'
  user node['tomcat']['user']
  group node['tomcat']['group']
  mode "00755"
  backup false
end

# Start the service
execute "tomcat_#{node['tomcat']['instance']}" do
  command "service tomcat_#{node['tomcat']['instance']} start"
end