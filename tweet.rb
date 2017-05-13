#!/usr/bin/env ruby
WORK_DIR=File.expand_path(__FILE__).sub(/[^\/]+$/,'')
require WORK_DIR + 'Class/TetesolTwitter.rb'
#半角スペース対応
tweet_user = TetesolTwitter.new(WORK_DIR + 'Config/user.yml')

msg = ''
ARGV.each do | text |
  msg += text + ' '
end
msg[/ $/]= ''
begin
  tweet_user.tweet(msg)
rescue
  puts 'tweet error!'
  exit
end
