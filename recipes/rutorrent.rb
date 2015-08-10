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
