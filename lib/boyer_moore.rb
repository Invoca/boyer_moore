require_relative "./boyer_moore/version"

class RichHash
  def initialize
    @regexps = {}
    @regular = {}
  end

  def [](k)
    @regular[k] ||
      @regexps.find do |regex,v|
        regex.match(k) and break v
      end
  end

  def []=(k,v)
    if k.kind_of?(Regexp)
      @regexps[k] = v
    else
      @regular[k] = v
    end
  end
end

module BoyerMoore
  def self.search(haystack, needle)
    needle_len = needle.size
    haystack_len = haystack.size
    return nil if haystack_len == 0
    return haystack if needle_len == 0
    badcharacter = prepare_badcharacter_heuristic(needle)
    goodsuffix   = prepare_goodsuffix_heuristic(needle)
    s = 0
    while s <= haystack_len - needle_len
      j = needle_len
      while (j > 0) && needle_matches?(needle[j-1], haystack[s+j-1])
        j -= 1
      end
      if j > 0
        k = badcharacter[haystack[s+j-1]] || -1
        if (k < j) && (m = j-k-1) > goodsuffix[j]
          s += m
        else
          s += goodsuffix[j]
        end
      else
        return s
      end
    end
    nil
  end

  def self.prepare_badcharacter_heuristic(str)
    result = RichHash.new
    0.upto(str.length - 1) do |i|
      result[str[i]] = i
    end
    result
  end

  def self.prepare_goodsuffix_heuristic(normal)
    size = normal.size
    reversed = normal.reverse
    prefix_normal = compute_prefix(normal)
    prefix_reversed = compute_prefix(reversed)
    result = []
    0.upto(size) do |i|
      result[i] = size - prefix_normal[size-1]
    end
    0.upto(size-1) do |i|
      j = size - prefix_reversed[i]
      k = i - prefix_reversed[i]+1
      result[j] = k if result[j] > k
    end
    result
  end

  def self.needle_matches?(needle, haystack)
    if needle.kind_of?(Regexp)
      needle.match(haystack)
    else
      needle == haystack
    end
  end

  def self.compute_prefix(str)
    size = str.length
    k = 0
    result = [0]
    1.upto(size - 1) do |q|
      while (k > 0) && (str[k] != str[q])
        k = result[k-1]
      end
      k += 1 if str[k] == str[q]
      result[q] = k
    end
    result
  end
end
