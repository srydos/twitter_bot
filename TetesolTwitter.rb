#!/usr/bin/env ruby
WORK_DIR=File.expand_path(__FILE__).sub(/[^\/]+$/,'')
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
  #リプライを送る機能。リプライ対象を読み取って、@(userid) (text)の形でpostする
  #target_tweet_id :リプライを送るツイートのid
  #text            :ツイートの内容
  def reply ( target_tweet_id = 0, text = '' )
    #reply対象idをチェック
    if !target_tweet_id.is_a?(Integer) or target_tweet_id == 0 then
      puts 'target_tweet_id is invalid!'
      #exit
      return
    end
    #リプライ対象のユーザを取得
    begin
      target_user = client.status( target_tweet_id ).user
    rescue
      puts 'target_tweet_id is invalid!'
      #exit
      return
    end
    #テキストが空なら標準入力に対応する
    if text == '' then
      print 'input massage! : '
      text = STDIN.gets
    end
    msg = "@#{target_user.screen_name} " + text
    client.update(msg,{:in_reply_to_status_id => target_tweet_id})
  end
end
