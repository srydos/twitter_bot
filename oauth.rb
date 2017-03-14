#!/usr/bin/env ruby
WORK_DIR=Dir.getwd
require 'oauth'
require 'oauth/consumer'
print "input consumer_key : "
consumer_key = STDIN.gets.chomp
print "input consumer_secret : "
consumer_secret = STDIN.gets.chomp
@consumer = OAuth::Consumer.new( consumer_key.to_s, consumer_secret.to_s, {
    :site=>"https://api.twitter.com"
    })
@request_token = @consumer.get_request_token
puts "access this url."
puts @request_token.authorize_url
#urlにアクセスしてから
print "input PIN : "
pin = STDIN.gets
@access_token = @request_token.get_access_token(:oauth_verifier => pin)
print "access_token : "
puts @access_token.token
print "access_token_secret : "
puts @access_token.secret     
