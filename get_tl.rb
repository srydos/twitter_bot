#!/usr/bin/env ruby
WORK_DIR=File.expand_path(__FILE__).sub(/[^\/]+$/,'')
require WORK_DIR + './class/TetesolTwitter.rb'
#ツイートIDから時刻を計算して返す
def tweetId2Time(tweet_id)
  case tweet_id
  when Integer
    Time.at(((tweet_id >> 22) + 1288834974657) / 1000.0)
  else
    nil
  end
end
#timelineのtweet_id以降のタイムラインをコンソールに表示して、最後のtweet_idを返す
def tweetPrintConsole(timeline_arr, tweet_id)
  @tweet_id = tweet_id
  timeline_arr.reverse.each do |tweet|
     #タイムラインを表示
     puts "	#{tweet.user.name} /@#{tweet.user.screen_name} /#{tweetId2Time(tweet.id).strftime("%Y-%m-%d %H:%M:%S.%L %Z")} : ( #{tweet.id.to_s} )\n #{tweet.full_text}\n"
     @tweet_id = tweet.id.to_s
  end
  last_tweet_id = @tweet_id
end

tweet_user = TetesolTwitter.new
#最後に取得したツイートid取得
last_tweet_id = "1"
args = ARGV
case args.length
when 0
  if File.exist? (WORK_DIR + "/config/.last_tweet_id")
    File.open(WORK_DIR + "/config/.last_tweet_id","r") do |file|
      file.each do |line|
        last_tweet_id = "#{line.chomp}"
      end
    end
  else
    File.open(WORK_DIR + "/config/.last_tweet_id","w")
  end
  timeline = tweet_user.home_timeline( last_tweet_id )
  last_tweet_id = tweetPrintConsole(timeline, last_tweet_id) #見え方悪いけど合理的　直す？
  File.open(WORK_DIR + "/config/.last_tweet_id","r+") do |file|
    file.puts(last_tweet_id)
  end
when 1..2
#args.find('@')
  puts "wait a little..."
  exit
else
  puts "too many args!"
  exit
end
