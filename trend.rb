WORK_DIR=ENV["ruby_twitter_work_dir"] + "/" || "/Users/srydos/ruby/twitter/"
require 'twitter'
require 'pp'
require 'yaml'
require 'date' #そのうちいらなくなる
#ツイート時刻取得
def tweet_id2time(id)
  case id
  when Integer
    Time.at(((id >> 22) + 1288834974657) / 1000.0)
  else
    nil
  end
end
#ツイートアカウント取得
key = YAML.load_file(WORK_DIR + "./user.yml")
client = Twitter::REST::Client.new(
  consumer_key:        key["consumer_key"],
  consumer_secret:     key["consumer_secret"],
  access_token:        key["access_token"],
  access_token_secret: key["access_token_secret"]
)
#トレンドを表示 日本2345896 
trends_local_plane = client.local_trends(23424856)
trends_hash = {}
trends_hash["data"] = trends_local_plane.map{ |i| i.to_hash }
trends_hash["Time"] = Time.now
open("./data_trend.yml","a+") do |e|
  YAML.dump(trends_hash,e)
end
#trends_local_plane.map{ |i| i.to_hash[:name] }
=begin
trends_json = JSON.parse(trends_local)
 
#json parse
trends_json[0]["trends"].each do |trend|
  puts "==============="
  puts "name : " + trend["name"]
  puts "url  : " + trend["url"]
  puts "query: " + trend["query"]
end
=end
