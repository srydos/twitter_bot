#!/usr/bin/env ruby
WORK_DIR=File.expand_path(__FILE__).sub(/[^\/]+$/,'')
require WORK_DIR + './Class/TetesolTwitter.rb'

search_user = TetesolTwitter.new
#最後に取得したツイートid取得
args = ARGV
case args.length
when 0
  puts 'what should i search...?'
  exit
when 1
  @count = 15
  query = args[0]
  begin
    timeline = search_user.popular_search( query, @count )
  rescue
    puts 'search request error...?'
  end
  search_user.tweetPrintConsole( timeline )
  exit
else
  msg = ''
  if (args.delete("-h")) then
    msg +='#'
  end
  args.each do | text |
    msg += text + ' '
  end
  msg[/ $/] = ''
  @count = 15
  query = msg.to_s
  begin
    timeline = search_user.popular_search( query, @count )
  rescue
    puts 'search request error...?'
  end
  search_user.tweetPrintConsole( timeline )
exit
  search_user.tweetPrintYAML( timeline.to_h )
end
