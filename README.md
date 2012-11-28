RBNF
----
RBNF is an Extended Backus-Naur Form implementation for Ruby.
```ruby
  form  = RBNF[?a] / ?b / ?c         #=> "a" | "b" | "c"
  form2 = RBND[?a].cat('b').alt('c') #=> ( "a" , "b" ) | "c"
```
RBNF objects can be used to perform regex-like matches on strings. This form will match the same strings as /[abc]/ :
```ruby
  form =~ 'a'  #=> true
  form =~ 'b'  #=> true
  form =~ 'd'  #=> false
  form =~ 'ab' #=> false
```
RBNFs can also accomplish matches that regexes can't:

```ruby
  RBNF.define :parens do
    RBNF[?(] + parens.rep + ?)
  end

  RBNF.parens =~ '()'    #=> true
  RBNF.parens =~ '(())'  #=> true
  RBNF.parens =~ '(()))' #=> false

```

RBNFs are actually stored as explicit ASTs, which are walked to either produce human-readable output, or to generate a string matcher. If you don't need the in(tro)spection capabilities that this provides, you can just extract the matcher:
```ruby
  form     = RBNF['famine'] / 'pestilence' / 'war' / 'death'
  horseman = form.matcher
  horseman['death'] #=> true
```

