#!/usr/bin/env ruby
WORK_DIR=File.expand_path(__FILE__).sub(/[^\/]+$/,'')
require WORK_DIR + 'TetesolTwitter.rb'
#半角スペース対応
tweet_user = TetesolTwitter.new
msg = ''
ARGV.each do | text |
  msg += text + ' '
end
msg[/ $/]= ''
tweet_user.tweet(msg)
