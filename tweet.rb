#!/usr/bin/env ruby
#require 'twitter'
#require 'yaml'
require './TetesolTwitter.rb'
#半角スペース対応
tweet_user = TetesolTwitter.new
msg = ''
ARGV.each do | text |
  msg += text + ' '
end
msg[/ $/]= ''
puts tweet_user.tweet(msg)
