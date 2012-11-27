require 'ebnf'

class DefTests
  def simple_definition
    EBNF.define :abc do
      +(EBNF[?a]/?b/?c)
    end
    EBNF.abc
  end
  def recursive_definition
    EBNF.define :parens do
      EBNF[?(] + parens.opt + ?)
    end
    EBNF.parens
  end
end

Graham.pp(DefTests) do |that|
  that.recursive_definition.is_such_that {
    self=~'()' and
    self=~'(())' and not
    self=~ '( )' and not
    self=~ '(()'
  }

  that.simple_definition.is_such_that {
    (0..5).all? do |n|
      %w{a b c}.permutation(n).all? do |p|
        s = p.join
        !!(s=~/[abc]*/) == (self=~s)
      end
    end
  }
end

