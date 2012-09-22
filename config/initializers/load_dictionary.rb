File.readlines('db/words.txt').each do |word|
  Dictionary.add(word)
end