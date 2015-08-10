#
# Cookbook Name: rtorrent
# Recipe: default
#

packages.each do |p|
    package p do
    action :upgrade
  end
end

user node[:rtorrent][:user] do
  home "/home/#{node[:rtorrent][:user]}"
  supports manage_home: true
  system true
end

service "rtorrent-#{node[:rtorrent][:user]}" do
  action :nothing
  provider Chef::Provider::Service::Upstart
end


dirs.each do |d|
  directory "/home/#{node[:rtorrent][:user]}/#{d}" do
    owner node[:rtorrent][:user]
    group node[:rtorrent][:user]
  end
end

template "/etc/init/rtorrent-#{node[:rtorrent][:user]}.conf" do
  cookbook "rtorrent"
  source "rtorrent.init.erb"
  notifies :restart, "service[rtorrent-#{node[:rtorrent][:user]}]", :delayed
end

template "/home/#{node[:rtorrent][:user]}/.rtorrent.rc" do
  cookbook "rtorrent"
  source "rtorrent.rc.erb"
  owner node[:rtorrent][:user]
  group node[:rtorrent][:user]
end

service "rtorrent-#{node[:rtorrent][:user]}" do
  action [:enable, :start]
  provider Chef::Provider::Service::Upstart
end
