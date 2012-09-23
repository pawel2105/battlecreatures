File.readlines('db/words.txt').each do |words|
  words.split(/\s/).each do |word|
    Dictionary.add(word)
  end
end