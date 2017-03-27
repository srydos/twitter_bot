#!/usr/bin/env ruby
WORK_DIR=File.expand_path(__FILE__).sub(/[^\/]+$/,'')
require 'twitter'
require 'yaml'
key = YAML.load_file(WORK_DIR + "/user.yml")
client = Twitter::REST::Client.new(
  consumer_key:        key["consumer_key"],
  consumer_secret:     key["consumer_secret"],
  access_token:        key["access_token"],
  access_token_secret: key["access_token_secret"]
)
msg = ''
if ARGV.length < 1 then
  puts 'args:(reply target tweet_id)(text)'
  exit
end

#reply対象id
tweet_id=ARGV[0].to_i
if !tweet_id.is_a?(Integer) or tweet_id == 0 then
  puts 'tweet_id invalid!'
  exit
end

#reply対象判定
reply_id = ARGV[0]
begin
  target_user = client.status( reply_id ).user
rescue
  puts 'reply_idが不正です'
  exit
end

#replyIDだけが設定されていた場合は標準入力を受け取る
if ARGV[1] == nil or ARGV[1] == '' then
  print "input massage! : "
  msg=STDIN.gets
elsif ARGV.length > 2 then
  #半角スペース対応
  tweet_text = ARGV
  tweet_text.shift.each do | text |
    msg += text + ' '
  end
  msg[/ $/]= ''
else 
  msg = ARGV[1]
end


msg="@#{target_user.screen_name} " + msg
puts msg
client.update(msg,{:in_reply_to_status_id => tweet_id})
