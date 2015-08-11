# General config options
default[:rtorrent][:encryption]   = "allow_incoming,enable_retry,prefer_plaintext"
default[:rtorrent][:index]        = "00"
default[:rtorrent][:ipaddress]    = node[:ipaddress]
default[:rtorrent][:ratio_upload] = "200M"

# Throttling
default[:rtorrent][:upload_rate]            = 0
default[:rtorrent][:download_rate]          = 0
default[:rtorrent][:min_peers]              = 4096
default[:rtorrent][:max_peers]              = 16384
default[:rtorrent][:min_peers_seed]         = -1
default[:rtorrent][:max_peers_seed]         = -1
default[:rtorrent][:max_uploads]            = 16384

# Tracker
default[:rtorrent][:port_random]      = "yes"
default[:rtorrent][:peer_exchange]    = "no"
default[:rtorrent][:use_udp_trackers] = "yes"
default[:rtorrent][:dht]              = "disable"
default[:rtorrent][:tracker_numwant]  = "-1"

# User
default[:rtorrent][:user] = 'rtorrent'
