require 'twitter'
require 'pp'
client = Twitter::REST::Client.new do |config|
  file = File.open(".twitter_keys.secret","r")
    lines = file.readlines
    config.consumer_key = lines[0].chomp
    config.consumer_secret = lines[1].chomp
    config.access_token = lines[2].chomp
    config.access_token_secret  = lines[3].chomp
  file.close
end
client.home_timeline.each do |tweet|
  puts tweet.full_text
  puts #{tweet.friends_timeline}
# puts "FAVORITE: #{tweet.favorite_count}"
# puts "RETWEET : #{tweet.retweet_count}"
end
