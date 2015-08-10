rtorrent
=======

Yet another chef recipe to install rtorrent.

## Usage
The nginx and php5-fpm cookbooks should come before this in the node's runlist, to install nginx and php-fpm. This cookbook is designed to work with the default values for both (notably, php5-fpm listening on 127.0.0.1:5000 and the nginx sites-enabled dir being in /etc/nginx/sites-enabled) 

## Configuration
There are two recipes:

### rtorrent
This recipe will create a new user (`rtorrent`) by default, install the rtorrent package (via aptÂ) and configure an upstart script to run it inside of dtach. There are lots of knobs that can be tweaked in node attributes as far as .rtorrent.rc config goes, but this exercise is left to the reader.

### rutorrent
This recipe will download+install the latest (at the time of writing, 3.6) version of rutorrent to the same user's home directory, and set up an nginx site to point to it. It configures basic auth to sit in front of rtorrent, so make sure you check the attributes/rutorrent.rb to figure out how to configure all of that. 

PRs are welcome, this is very much a rough WIP for personal use, but there was nothing else that configured rutorrent and was newer than two years old.
