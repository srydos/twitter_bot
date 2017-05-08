#!/usr/bin/env ruby
require 'twitter'
require 'yaml'
require 'pp'
class TetesolTwitter
  attr_accessor :client
  def initialize( key_file_path = "" )
    if not key_file_path.empty? then
      @key_hash = YAML.load_file( key_file_path )
      @client = Twitter::REST::Client.new(
        consumer_key:        @key_hash['consumer_key'],
        consumer_secret:     @key_hash['consumer_secret'],
        access_token:        @key_hash['access_token'],
        access_token_secret: @key_hash['access_token_secret']
      )
    else
      puts 'cannot read key_file_path...'
      exit
    end
  end
  #ツイートする機能
  #text :ツイートの内容
  def tweet( text = '' )
    if text == '' then
      print 'input massage! : '
      text = STDIN.gets
    end
    msg = text
    puts msg
    client.update( msg )
  end
  #リプライ機能。リプライ対象のidを読み取って、@(userid) (text)の形でpostする
  #target_tweet_id :リプライを送るツイートのid
  #text            :ツイートの内容
  def reply ( target_tweet_id = 0, text = '' )
    #リプライ対象のユーザを取得
    begin
      target_user = client.status( target_tweet_id ).user
    rescue
      puts 'target_user was not found...'
      return
    end
    msg = "@#{target_user.screen_name} " + text
#    msg = text #replyに@いらなくなる日が来る
    puts msg
    client.update(msg,{:in_reply_to_status_id => target_tweet_id})
  end
  #ホームタイムラインを取得して生jsonのまま返す
  def home_timeline( last_tweet_id )
    client.home_timeline({ :since_id => last_tweet_id })
  end
  def local_trends( locale_code = 0 )
    hash = client.local_trends ( locale_code )
  end
  def search( query = '', count = 15 )
    timeline = client.search(query, :count => count )
  end
  def popular_search( query = '', count = 15 )
    timeline = client.search(query, :count => 100, :result_type => "popular" )
  end
  #mentionをgetする
  def mention_timeline
    client.mention_timeline
  end
  #tweet_idに対してのreaction
  def retweet(id)
    client.retweet(id)
  end
  def favorite(id)
    client.favorite(id)
  end
  def favorite_delete(id)
    client.favorite_delete(id)
  end
  def status(id) #発言の詳細をゲットする
    tweet = client.status(id)
    puts "	#{tweet.user.name} /@#{tweet.user.screen_name} /#{tweetId2Time(tweet.id).strftime("%Y-%m-%d %H:%M:%S.%L %Z")} : ( #{tweet.id.to_s} )❤️ :#{tweet.favorite_count} 🔁 :#{tweet.retweet_count}\n #{tweet.full_text}\n"
pp tweet.user_mentions.class
tweet.user_mentions.each do |item|
  pp item
  pp item.class
  pp item.to_s
end
    tweetPrintConsole(tweet.user_mentions, 1)
  end
  def status_destroy(id) #発言削除
    client.status_destroy(id)
  end
  #####
  # 関連メソッド
  #####
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
       puts "	#{tweet.user.name} /@#{tweet.user.screen_name} /#{tweetId2Time(tweet.id).strftime("%Y-%m-%d %H:%M:%S.%L %Z")} : ( #{tweet.id.to_s} )❤️ :#{tweet.favorite_count} 🔁 :#{tweet.retweet_count}\n #{tweet.full_text}\n"
       @tweet_id = tweet.id.to_s
    end
    last_tweet_id = @tweet_id
  end
  #YAMLに吐き出す機能？
  def tweetPrintYAML(timeline_hash, export_dir="./")
    timeline_hash.each do |tweet|
      #タイムラインを表示
      open(export_dir + "popular_tweet.yml","a+") do |e|
        YAML.dump( timeline_hash, e )
      end
    end
  end
end
