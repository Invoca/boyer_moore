# BoyerMoore

## Custom Fork
This Invoca custom fork updates the gem to return multiple matches of the same phrase in the search text instead of only the first match.

## Details

Inspired by https://github.com/jashmenn/boyermoore

BoyerMoore is the fastest substring search strategy.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'boyer_moore'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install boyer_moore

## Usage

```ruby
BoyerMoore.search("foobarbazbar", "bar") # => [3, 9]
BoyerMoore.search("foobar", "oof")       # => []
BoyerMoore.search("foobar", "foo")       # => [0]

```
