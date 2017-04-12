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
  end end
#timelineのtweet_id以降のタイムラインをコンソールに表示して、最後のtweet_idを返す
def tweetPrintConsole(timeline_arr)
  timeline_arr.each do |tweet|
     #タイムラインを表示
     puts "	#{tweet.user.name} /@#{tweet.user.screen_name} /#{tweetId2Time(tweet.id).strftime("%Y-%m-%d %H:%M:%S.%L %Z")} : ( #{tweet.id.to_s} ) ❤️ :#{tweet.favorite_count} 🔁 :#{tweet.retweet_count}\n #{tweet.full_text}\n"
  end
end
def tweetPrintYAML(timeline_hash)
  timeline_hash.each do |tweet|
    #タイムラインを表示
    open("./popular_tweet.yml","a+") do |e|
      YAML.dump( timeline_hash, e )
    end
  end
end

search_user = TetesolTwitter.new
#最後に取得したツイートid取得
args = ARGV
case args.length
when 0
  puts 'what should i search...?'
  exit
when 1
  @count = 15
  query = args[0]
  begin
    timeline = search_user.popular_search( query, @count )
  rescue
    puts 'search request error...?'
  end
  tweetPrintConsole( timeline )
  exit
else
  msg = ''
  if (args.delete("-h")) then
    msg +='#'
  end
  args.each do | text |
    msg += text + ' '
  end
  msg[/ $/] = ''
  @count = 15
  query = msg.to_s
  begin
    timeline = search_user.popular_search( query, @count )
  rescue
    puts 'search request error...?'
  end
  tweetPrintConsole( timeline )
exit
  tweetPrintYAML( timeline.to_h )
end
