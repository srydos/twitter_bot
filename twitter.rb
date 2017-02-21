#!/usr/bin/env ruby
WORK_DIR=Dir.getwd
require 'twitter'
require 'pp'
require 'yaml'
key = YAML.load_file(WORK_DIR + "/user.yml")
client = Twitter::REST::Client.new(
  consumer_key:        key["consumer_key"],
  consumer_secret:     key["consumer_secret"],
  access_token:        key["access_token"],
  access_token_secret: key["access_token_secret"]
)
msg=ARGV[0] 
if msg==nil then
  print "input massage! : "
  msg=STDIN.gets
end
client.update(msg)
