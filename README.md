RBNF
----
RBNF is an Extended Backus-Naur Form implementation for Ruby.
```ruby
  form  = RBNF[?a] / ?b / ?c         #=> '"a" | "b" | "c"'
  form2 = RBNF[?a].cat('b').alt('c') #=> '( "a" , "b" ) | "c"'
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
    RBNF[?(] + parens.opt + ?)
  end #=> 'parens = "(" , [ parens ] , ")" ;'

  RBNF.parens =~ '()'    #=> true
  RBNF.parens =~ '(())'  #=> true
  RBNF.parens =~ '(()))' #=> false

```

RBNFs are stored as explicit ASTs, which are walked when rendering the form as a string, or when generate a string matcher. If you don't need to in(tro)spect the form, you can just extract the matcher:
```ruby
  form     = RBNF['famine'] / 'pestilence' / 'war' / 'death'
  horseman = form.matcher
  horseman['death'] #=> true
```
RBNF currently makes no attempt whatsoever to optimize for performance. In almost any performance-sensitive application you're better off using a different solution, unless you restrict your use to simple forms on small strings.

