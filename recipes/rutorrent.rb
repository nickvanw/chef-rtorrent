#
# Cookbook Name: rtorrent
# Recipe: rutorrent
#
# This cookbook should be placed after the installation of nginx

rutorrent_packages.each do |p|
    package p do
    action :upgrade
  end
end

rutorrent_dir = "/home/#{node[:rtorrent][:user]}/#{node[:rutorrent][:download_version]}"
rutorrent_url = "#{node[:rutorrent][:base_url]}/rutorrent-#{node[:rutorrent][:download_version]}.tar.gz"
rutorrent_download_file = "#{Chef::Config[:file_cache_path]}/rutorrent-#{node[:rutorrent][:download_version]}.tar.gz"

remote_file rutorrent_download_file do
  source rutorrent_url
  not_if { ::File.exists?(rutorrent_download_file) }
end

bash 'unpack rutorrent' do
  cwd ::File.dirname("/home/#{node[:rtorrent][:user]}")
  code <<-EOH
    mkdir -p #{rutorrent_dir}
    tar xzf #{rutorrent_download_file} -C #{rutorrent_dir}
  EOH
  not_if { ::File.exists?(rutorrent_dir) }
end

cookbook_file '/etc/nginx/php-inner.conf' do
  source 'php-inner.conf'
  action :create
end

cookbook_file '/etc/nginx/php.conf' do
  source 'php.conf'
  action :create
end

cookbook_file '/etc/nginx/rutorrent.conf' do
  source 'rutorrent.conf'
  action :create
end

template "/etc/nginx/sites-enabled/rutorrent-#{node[:rtorrent][:user]}.conf" do
  source 'nginx.conf.erb'
  variables({
    :rutorrent_dir => rutorrent_dir
  })
  notifies :reload, "service[nginx]", :delayed
end

template '/etc/nginx/htpasswd' do
  source 'htpasswd.erb'
  variables ({
    :users => node[:rutorrent][:users]
  })
  notifies :reload, "service[nginx]", :delayed
end

template "#{rutorrent_dir}/rutorrent/conf/config.php" do
  source 'config.php.erb'
end

if node[:rutorrent][:install_plugins]
  rutorrent_plugin_packages.each do |p|
    package p do 
      action :upgrade
    end
  end
  
  rutorrent_plugins = "#{node[:rutorrent][:base_url]}/plugins-#{node[:rutorrent][:download_version]}.tar.gz"
  rutorrent_plugin_file = "#{Chef::Config[:file_cache_path]}/plugins-#{node[:rutorrent][:download_version]}.tar.gz"
  remote_file rutorrent_plugin_file do
    source rutorrent_plugins
    not_if { ::File.exists?(rutorrent_plugin_file) }
  end

  plugin_dir = "#{rutorrent_dir}/rutorrent"
  bash 'unpack rutorrent plugins' do
    cwd ::File.dirname("/home/#{node[:rtorrent][:user]}")
    code <<-EOH
      tar xzf #{rutorrent_plugin_file} -C #{plugin_dir}
    EOH
    not_if { ::Dir.entries("#{plugin_dir}/plugins").length > 2 }
  end
end
