#
# Cookbook Name: rtorrent
# Libraries: helpers
#
def packages
  %w(dtach rtorrent)
end

def dirs
  %w(.session watch downloads)
end

def rutorrent_packages 
  %w(php5-cli)
end

def rutorrent_plugin_packages
  %w(curl unzip unrar)
end