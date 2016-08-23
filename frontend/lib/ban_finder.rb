require 'sinatra/activerecord'
require_relative '../models/badwords'

module BanFinder
  def BanFinder.find_bannable(text, group_id)
    words_db = Badwords.find_by(group_id: group_id)
    banned_words = Array.new
    words_db.each do |i|
      banned_words.push(i.word)
    end
    tokens = text.split(' ')
    tokens.each do |t|
      banned_words.each do |b|
        if b.eql?(t)
          # Found a banned word
          return b
        end
      end
    end
    return 'NOWORDSFOUND'
  end
end