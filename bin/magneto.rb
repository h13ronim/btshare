#!/usr/bin/env ruby
# source: https://gist.githubusercontent.com/Burgestrand/1733611/raw/91fe8ceed569fc30cc2d001eb32422606577d148/magneto.rb

require 'rubygems'
require 'cgi'
require 'openssl'

require 'bencode'
require 'base32'
require 'rack/utils'

# We cannot trust .torrent file data
ARGF.set_encoding 'BINARY'

# Read torrent from STDIN / ARGV filepath
torrent_data = ARGF.read

# Parse the torrent data
torrent = BEncode.load(torrent_data)

# Calculate the info_hash (actually, info_sha1 *is* the info_hash)
info_hash = torrent["info"].bencode
info_sha1 = OpenSSL::Digest::SHA1.digest(info_hash)

# Build the magnet link
params = {}
params[:xt] = "urn:btih:" << Base32.encode(info_sha1)
params[:dn] = CGI.escape(torrent["info"]["name"])

params[:tr] = torrent['announce']
Array(torrent["announce-list"]).each do |(tracker, _)|
  params[:tr] ||= []
  params[:tr] << tracker
end

unless params[:tr]
  puts "[WARN] There are no trackers on the torrent. It’s recommended you add at least one."
  puts "       Here are a few public free trackers that don’t require registration:"
  puts
  puts "         udp://tracker.publicbt.com:80/announce"
  puts "         udp://tracker.openbittorrent.com:80/announce"
  puts
end

# params[:tr] = [] << to complement DHT we can add trackers too
magnet_uri  = "magnet:?xt=#{params.delete(:xt)}"
magnet_uri << "&" << Rack::Utils.build_query(params)

puts magnet_uri
