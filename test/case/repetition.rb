require 'rbnf'
class Repetition
  def a_binary_repetition
    RBNF[?A]*3+?G
  end

  def a_unary_repetition
    +(RBNF[?x]+?y+?z)
  end
end

Graham.pp(Repetition) do |that|
  that.a_binary_repetition.is_such_that {
    match('AAAG') and
    [?g,'AG','AAAAAAG'].none?  {|s| match s}}

  that.a_unary_repetition.is_such_that {
    ['','xyz','xyzxyz'].all? {|s| match s} and
    [?x,?y,?z,'zyx'].none? {|s| match s}}
end
