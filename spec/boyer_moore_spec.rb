require 'boyer_moore'

describe BoyerMoore do
  describe BoyerMoore::Needle do
    it "should compute prefixes" do
      expect(BoyerMoore::Needle::prefix(%w[A N P A N M A N])).to eq [0, 0, 0, 1, 2, 0, 1, 2]
      expect(BoyerMoore::Needle::prefix(%w[f o o b a r])).to eq [0, 0, 0, 0, 0, 0]
    end

    it "should compute character_indexes" do
      expect(BoyerMoore::Needle.new(%w[A N P A N M A N]).send(:character_indexes)).to eq("A"=>6, "M"=>5, "N"=>7, "P"=>2)
      expect(BoyerMoore::Needle.new(%w[f o o b a r]).send(:character_indexes)).to eq("a"=>4, "b"=>3, "o"=>2, "f"=>0, "r"=>5)
    end

    it "should implement good_suffixes" do
      expect(BoyerMoore::Needle.new(%w[A N P A N M A N]).send(:good_suffixes)).to eq [6, 6, 6, 6, 6, 6, 3, 3, 1]
      expect(BoyerMoore::Needle.new(%w[f o o b a r]).send(:good_suffixes)).to eq [6, 6, 6, 6, 6, 6, 1]
    end
  end

  it "should implement find" do
    expect(BoyerMoore.find("ANPANMAN", "ANP")).to eq 0
    expect(BoyerMoore.find("ANPANMAN", "ANPXX")).to eq nil
    expect(BoyerMoore.find("ANPANMAN", "MAN")).to eq 5
    expect(BoyerMoore.find("foobar", "bar")).to eq 3
    expect(BoyerMoore.find("foobar", "zar")).to eq nil
  end

  it "should implement each" do
    yielded = []
    BoyerMoore.each("ANPANMAN", "AN") { |index| yielded << index }
    expect(yielded).to eq [0, 3, 6]
    yielded = []
    BoyerMoore.each("ANANAN", "AN") { |index| yielded << index }
    expect(yielded).to eq [0, 2, 4]
    yielded = []
    BoyerMoore.each("AAAB", "A") { |index| yielded << index }
    expect(yielded).to eq [0, 1, 2]
    yielded = []
    BoyerMoore.each("ANPANMAN", "MAN") { |index| yielded << index }
    expect(yielded).to eq [5]
    yielded = []
    BoyerMoore.each("foobar", "zar") { |index| yielded << index }
    expect(yielded).to eq []
  end

  it "should implement each with a starting index" do
    yielded = []
    BoyerMoore.each("ANPANMAN", "AN", 0) { |index| yielded << index }
    expect(yielded).to eq [0, 3, 6]
    yielded = []
    BoyerMoore.each("ANPANMAN", "AN", 1) { |index| yielded << index }
    expect(yielded).to eq [3, 6]
  end

  it "should return an enumerator from each with no block" do
    yielded = []
    enumerator = BoyerMoore.each("ANPANMAN", "AN")
    enumerator.each.with_index { |match_index, index| yielded[index] = match_index }
    expect(yielded).to eq [0, 3, 6]
  end

  it "should match ruby's #index for basic strings" do
    needle = 'abcab'
    ['12abcabc', 'abcgghhhaabcabccccc', '123456789abc123abc', 'aabbcc'].each do |haystack|
      expect(BoyerMoore.find(haystack, needle)).to eq haystack.index(needle)
    end
  end
  
  it "should match characters" do
    {
      %w[a b c] => 0,
      %w[b c d] => nil,
      %w[e f g] => nil,
      %w[m y _ d o g _ a b c] => 7
    }.each do |haystack, position|
      expect(BoyerMoore.find(haystack, ['a', 'b', 'c'])).to eq position
    end
  end

  it "should match in the middle of a string" do
    expect(BoyerMoore.find("xxxfoobarbazxxx".split(''), "foobar".split(''))).to eq 3
  end

  it "should match words" do
    {
      ["foo", "bar", "baz"] => 0,
      ["bam", "bar", "bang"] => nil,
      ["put", "foo", "bar", "bar"] => 1,
      ["put", "foo", "bar", "foo", "bar"] => 1
    }.each do |haystack, position|
      expect(BoyerMoore.find(haystack, ["foo", "bar"])).to eq position
    end
  end
end
