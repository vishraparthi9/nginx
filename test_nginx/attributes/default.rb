default['downloads']['base_directory']='/opt'
# Java specific attributes

default['java']['source_url']='http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz'
default['java']['version']='1.7.0_79'
default['java']['home_directory']='/opt/jdk1.7.0_79'
default['java']['jre_home_directory']='/opt/jdk1.7.0_79/jre'

# Tomcat specific attributes

default['tomcat']['group']='tomcat'
default['tomcat']['group_id']=1000
default['tomcat']['user']='tomcat'
default['tomcat']['user_id']=1000
default['tomcat']['base_directory']='/opt/tomcat'
default['tomcat']['source_url']='https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.67/bin/apache-tomcat-7.0.67.tar.gz'
default['tomcat']['instance']='server-8080'
default['tomcat']['default_instance']='apache-tomcat-7.0.67'

# Nginx specific attributes

default['nginx']['openssl_dependency_source_url']='http://www.openssl.org/source/openssl-1.0.2f.tar.gz'
default['nginx']['source_url']='http://nginx.org/download/nginx-1.9.9.tar.gz'
default['nginx']['options']=["--prefix=/opt/nginx", "--with-http_ssl_module", "--without-http_gzip_module", "--with-openssl=/opt/openssl-1.0.2f"]
default['nginx']['start_cmd']='sudo ./nginx'