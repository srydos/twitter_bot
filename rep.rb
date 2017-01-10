#!/usr/bin/env ruby
WORK_DIR=ENV["ruby_twitter_work_dir"] + "/" || "/Users/srydos/ruby/twitter/"
require 'twitter'
require 'yaml'
key = YAML.load_file(WORK_DIR + "./user.yml")
client = Twitter::REST::Client.new(
  consumer_key:        key["consumer_key"],
  consumer_secret:     key["consumer_secret"],
  access_token:        key["access_token"],
  access_token_secret: key["access_token_secret"]
)
#reply対象id
tweet_id=ARGV[0].to_i
if !tweet_id.is_a?(Integer) or tweet_id==0 then
  puts 'reply対象のid不正'
  exit
end
if ARGV.length < 2 then
  puts '引数足んないよ'
  exit
end

#reply対象判定
msg=ARGV[1]
if msg==nil then
  print "input massage! : "
  msg=STDIN.gets
end
user = Twitter.status( tweet_id ).user
msg="@#{user.screen_name} " + msg
puts msg
#client.update(msg,{:in_reply_to_status_id => tweet_id})
