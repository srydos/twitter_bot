#!/usr/bin/env ruby
WORK_DIR=File.expand_path(__FILE__).sub(/[^\/]+$/,'')
require WORK_DIR + 'Class/TetesolTwitter.rb'
#require WORK_DIR + 'reply.rb'
#require WORK_DIR + 'get_tl.rb'
tweet_user   = TetesolTwitter.new(WORK_DIR + 'Config/user.yml')
last_reply_id = 1
read_or_make_text_file(WORK_DIR + "Config/.last_reply_id")
monitored_tl = tweet_user.mentions_timeline_bot(last_reply_id.to_i)
monitored_tl.reverse.each do |tweet|
  @text = tweet.full_text
  if @text.match("うんこ") or @text.match("クソ") then
    @str=""
    #内容重複よけ　それでも被ったら流さないでいい
    rand(15).times{ @str += "…"}
    #なぜ人は排便時に水を流すのか
    tweet_user.reply(tweet.id ,"ジャーッ" + @str).id
    last_reply_id = tweet.id
  end
end
write_text_to_file(WORK_DIR + "Config/.last_reply_id", last_reply_id)
