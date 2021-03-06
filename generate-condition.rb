#!/usr/bin/env ruby
require 'yaml'
require 'pp'
WORK_DIR=File.expand_path(__FILE__).sub(/[^\/]+$/,'')

DESCRIPTION =<<__EOT__
 botが反応する条件を書く
 必須でない項目は項目自体省略可能ですぞ
 
 - client:      使用するクライアント名 あらかじめConfig配下に設定ファイルを置く 必須
   description: この設定時の説明用エリア
   condition:
   - category: timeline mention delete等反応する条件配列 *必須*
     condition_text: 反応するテキスト配列 *必須*
     probability:   反応する確率 1で100% 0で反応しない 1がデフォ
     client:   反応しても良いクライアント配列
     user:     指定されたidのユーザーのみ反応する
     ng_user:  このユーザには反応しない '@'不要
   reaction:
     category: tweet reply follow fav等反応する動作の配列 *必須*
     reply: replyの場合は必須 それ以外は省略可
     - reaction_text: 返答するテキスト 配列可 *必須*
       weight: 重み付け整数 数字が大きいほど上記テキストを返す可能性が高い 1がデフォ
       prefix: 接頭語 0..5でランダムについて重複投稿を回避 
       suffix: 接尾語 0..5でランダムについて重複投稿を回避 
__EOT__
#インデックスを選ぶ対話
def select_index(enum, elem, category="")
  enum.each_index do |index| 
   puts "#{index} #{category}--> #{enum[index][elem]}"
  end
  puts "#{enum.length} --> [新規作成]"
  select_index = STDIN.gets.chomp.to_i
  if select_index > enum.length
    puts '範囲外です'
    exit
  end  
  return select_index
end
#初期可
@comment = ""
DESCRIPTION.each_line { |line| @comment << '# ' << line }
 print @comment 
file_path = WORK_DIR + 'Config/reaction-condition.yml'
if File.exist?(file_path) then
  file = File.open(file_path, "r+")
  @conditions = YAML.load_file(file_path)
  unless @conditions.hash
    puts 'not hash file!' 
    exit
  end
else
  file = File.open(file_path, "w")
  file.write(@comment) 
  @conditions = []
end

#pp @conditions

print '使用させたいクライアント名称を入力 : '
client_name = STDIN.gets.chomp

unless File.exist?(WORK_DIR + "Config/#{client_name}.yml")
  pp WORK_DIR + "Config/#{client_name}.yml"
  puts "その名称のクライアント設定ファイルは存在しません。"
  exit
end

=begin
@conditions.each do |obj| 
  pp obj["reaction"]
  pp obj["reaction"]["category"]
puts '*****************'
  pp obj["condition"]
puts '---'
end
=end
puts '設定する条件の番号を以下より選んでください'
edit_index = select_index(@conditions, "description", "category")
if edit_index < @conditions.length
  edit_condition = @conditions[edit_index]
else
  edit_condition = []
end
pp edit_condition
pp edit_condition.class

puts '編集する条件の番号を以下より選んでください'
select_index(edit_condition, "reaction")



#出力
#data = @comment + @conditions.to_s
#pp data
#YAML.dump(file_path, data)
