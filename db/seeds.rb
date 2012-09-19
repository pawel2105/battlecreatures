File.readlines('db/words.txt').each do |word|
  Word.create(value: word)
end
puts "words: #{Word.count}"
