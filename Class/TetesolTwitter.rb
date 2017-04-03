#!/usr/bin/env ruby
require 'twitter'
require 'yaml'
class TetesolTwitter
  attr_accessor :client
  def initialize( key_file_path:nil )
    if key_file_path == nil then
      @key_hash = YAML.load_file( WORK_DIR + './config/user.yml' )
    else
      @key_hash = YAML.load_file( key_file_path )
    end
    @client = Twitter::REST::Client.new(
      consumer_key:        @key_hash['consumer_key'],
      consumer_secret:     @key_hash['consumer_secret'],
      access_token:        @key_hash['access_token'],
      access_token_secret: @key_hash['access_token_secret']
    )
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
    client.update(msg,{:in_reply_to_status_id => target_tweet_id})
  end
  #ホームタイムラインを取得して生jsonのまま返す
  def home_timeline( last_tweet_id )
    client.home_timeline({ :since_id => last_tweet_id })
  end
  def local_trends( locale_code = 0 )
    hash = client.local_trends ( locale_code )
  end
  def search( query = '' )
    timeline = client.search(query)
    p timeline
  end
  #mentionをgetする
  def mention_timeline
    client.mention_timeline
  end
end
