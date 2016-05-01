WORK_DIR=ENV["ruby_twitter_work_dir"] + "/" || "/Users/srydos/ruby/twitter/"
require 'twitter'
require 'pp'
require 'yaml'
def tweet_id2time(id)
  case id
  when Integer
    Time.at(((id >> 22) + 1288834974657) / 1000.0)
  else
    nil
  end
end
key = YAML.load_file("./user.yml")
client = Twitter::REST::Client.new(
  consumer_key:        key["consumer_key"],
  consumer_secret:     key["consumer_secret"],
  access_token:        key["access_token"],
  access_token_secret: key["access_token_secret"]
)
client.home_timeline.reverse.each do |tweet|
   puts "\n	" + tweet.user.name + "/@" + tweet.user.screen_name + "/" + tweet_id2time(tweet.id).strftime("%Y-%m-%d %H:%M:%S.%L %Z") +
   ":\n" + tweet.full_text
end
