#!/usr/bin/env ruby
WORK_DIR=Dir.getwd
require 'twitter'
require 'pp'
require 'yaml'
#ツイート時刻取得
def tweet_id2time(id)
  case id
  when Integer
    Time.at(((id >> 22) + 1288834974657) / 1000.0)
  else
    nil
  end
end
#ツイートアカウント取得
key = YAML.load_file(WORK_DIR + "/user.yml")
client = Twitter::REST::Client.new(
  consumer_key:        key["consumer_key"],
  consumer_secret:     key["consumer_secret"],
  access_token:        key["access_token"],
  access_token_secret: key["access_token_secret"]
)
#最後に取得したツイートid取得
last_tweet_id = "0"
if File.exist? (WORK_DIR + ".last_tweet_id")
  File.open(WORK_DIR + ".last_tweet_id","r") do |file|
    file.each do |line|
      last_tweet_id = "#{line.chomp}"
    end
  end
else
  File.open(WORK_DIR + ".last_tweet_id","w")
end
#タイムラインを表示
if last_tweet_id == "0"
  client.home_timeline().reverse.each do |tweet|
     puts "\n	#{tweet.user.name} /@#{tweet.user.screen_name} /#{tweet_id2time(tweet.id).strftime("%Y-%m-%d %H:%M:%S.%L %Z")} : ( #{tweet.id.to_s} )\n #{tweet.full_text}"
     last_tweet_id = tweet.id.to_s
  end
end
client.home_timeline({:since_id => last_tweet_id}).reverse.each do |tweet|
   puts "\n	#{tweet.user.name} /@#{tweet.user.screen_name} /#{tweet_id2time(tweet.id).strftime("%Y-%m-%d %H:%M:%S.%L %Z")} : ( #{tweet.id.to_s} )\n #{tweet.full_text}"
   last_tweet_id = tweet.id.to_s
end
File.open(WORK_DIR + ".last_tweet_id","r+") do |file|
  file.puts(last_tweet_id)
end
