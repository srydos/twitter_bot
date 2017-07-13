require 'oauth'
require 'oauth/consumer'
require 'yaml'

if (ARGV.length != 2) then
  puts "require args (consumer_key) (consumer_secret_key)\'"
  exit
end

consumer_key = ARGV[0]
consumer_secret = ARGV[1]
yaml_name = ARGV[2] || "user"

consumer = OAuth::Consumer.new(consumer_key, @consumer_secret, {site: "https://api.twitter.com"})
request_token = consumer.get_request_token

puts "get pin in this url"
puts  request_token.authorize_url
#urlにアクセスしてから
print "input PIN : "
pin = STDIN.gets

access_token = request_token.get_access_token(:oauth_verifier => pin)

key_hash = { 
  consumer_key:		consumer_key,
  consumer_secret:	consumer_secret,
  access_token:		access_token.token,
  access_token_secret:	access_token.secret
}

# Configディレクトリ準備
current_path = File.expand_path(File.dirname(__FILE__) + '../')
FileUtil.mkdir_p("#{current_path}/Config") if File.exist?(current_path)

open("#{current_path}/Config/#{yaml_name}.yml","w+") do |yml|
  YAML.dump(key_hash, yml)
end

puts "#{current_path}/Config/#{yaml_name}.yml"
