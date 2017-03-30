#!/usr/bin/env ruby
WORK_DIR=File.expand_path(__FILE__).sub(/[^\/]+$/,'')
require WORK_DIR + 'TetesolTwitter.rb'
retweet_user = TetesolTwitter.new
if ARGV[0] == nil or ARGV[0] == '' then
  print "arg : (retweet_target_id)"
  exit
end
retweet_id = ARGV[0]
retweet_user.retweet(retweet_id)
