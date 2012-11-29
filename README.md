RBNF
----
RBNF is an Extended Backus-Naur Form implementation for Ruby.

Installation
------------
```shell
  gem install rbnf
```

Usage
-----
```ruby
  form  = RBNF[?a] / ?b / ?c         #=> '"a" | "b" | "c"'
  form2 = RBNF[?a].cat('b').alt('c') #=> '( "a" , "b" ) | "c"'
```
RBNF objects can be used to perform regex-like matches on strings. The first form will match the same strings as /[abc]/ :
```ruby
  form =~ 'a'  #=> true
  form =~ 'b'  #=> true
  form =~ 'd'  #=> false
  form =~ 'ab' #=> false
```
RBNFs can also accomplish matches that regexes can't:

```ruby
  RBNF.define :parens do
    RBNF[?(] + RBNF.parens.opt + ?)
  end

  RBNF.parens =~ '()'    #=> true
  RBNF.parens =~ '(())'  #=> true
  RBNF.parens =~ '(()))' #=> false

```
RBNF objects memoize matches, but otherwise make no attempt at optimizing for performance.

