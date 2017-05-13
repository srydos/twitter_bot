#!/usr/bin/env ruby
WORK_DIR=File.expand_path(__FILE__).sub(/[^\/]+$/,'')
require WORK_DIR + 'Class/TetesolTwitter.rb'
#require WORK_DIR + 'reply.rb'
#require WORK_DIR + 'get_tl.rb'
tweet_user   = TetesolTwitter.new(WORK_DIR + 'Config/user.yml')
monitored_tl = tweet_user.mentions_timeline
monitored_tl.each do |tweet|
  if File.exist? (WORK_DIR + "/Config/.last_replyed_id")
    File.open(WORK_DIR + "/Config/.last_replyed_id","r") do |file|
      file.each do |line|
        last_replyed_id = "#{line.chomp}"
      end
    end
    File.open(WORK_DIR + "/Config/.last_replyed_id","w")
  end
  @text = tweet.full_text
  if @text.match("うんこ") then
    @str=""
    #内容重複よけ　それでも被ったら流さないでいい
    rand(15).times{ @str += "…"}
    #なぜ人は排便時に水を流すのか
    last_replyed_id = tweet_user.reply(tweet.id ,"ジャーッ" + @str)
  end
  if File.exist? (WORK_DIR + "/Config/.last_replyed_id")
    File.open(WORK_DIR + "/Config/.last_replyed_id","r+") do |file|
      file.puts(last_replyed_id)
    end
  end
end
