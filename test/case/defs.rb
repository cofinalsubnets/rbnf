require 'rbnf'

class DefTests
  def simple_definition
    RBNF.define :abc do
      +(RBNF[?a]/?b/?c)
    end
    RBNF.abc
  end
  def recursive_definition
    RBNF.define :parens do
      RBNF[?(] + RBNF.parens.opt + ?)
    end
    RBNF.parens
  end
end
Graham.pp(DefTests) do |that|
  that.recursive_definition.is_such_that {
    %w{() (())}.all?  {|s| match s} and
    %w{( ) (()}.none? {|s| match s}}

  that.simple_definition.is_such_that {
    (0..5).all? do |n|
      %w{a b c}.permutation(n).all? do |p|
        s = p.join
        !!(s=~/[abc]*/) == match(s)
      end
    end
  }
end

