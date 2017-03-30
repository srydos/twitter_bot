#!/usr/bin/env ruby
require 'twitter'
require 'yaml'
class TetesolTwitter
  attr_accessor :client
  def initialize
    @key = YAML.load_file(WORK_DIR + '/user.yml')
    @client = Twitter::REST::Client.new(
      consumer_key:        @key['consumer_key'],
      consumer_secret:     @key['consumer_secret'],
      access_token:        @key['access_token'],
      access_token_secret: @key['access_token_secret']
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
      #exit
      return
    end
    msg = "@#{target_user.screen_name} " + text
    client.update(msg,{:in_reply_to_status_id => target_tweet_id})
  end
  def home_timeline( last_tweet_id )
    client.home_timeline({ :since_id => last_tweet_id })
  end
end
