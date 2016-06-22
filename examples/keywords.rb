require './lib/boyer_moore'

transcript = "i was wondering if you require a credit check to open an account ? i'm not sure i would pass a credit check right now .".split(' ')

phrases = {
  ["credit", "check"]     => 1,
  ["make", "appointment"] => 2,
  ["now"]                 => 1
}

results = phrases.map do |phrase, count|
  found_count = 0
  found = BoyerMoore.search(transcript, phrase) { |index| (found_count += 1) >= count and break true } # stop searching as soon as we hit the count
  [phrase, found]
end



results.each { |phrase, found| puts "#{phrase} => #{!!found}"}

# =>
# ["credit", "check"] => true
# ["make", "appointment"] => false
# ["now"] => true
