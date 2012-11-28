require 'rbnf'
class Repetition
  def a_binary_repetition
    RBNF[?A]*3+?G
  end

  def a_unary_repetition
    +(RBNF[?x]+?y+?z)
  end

  def binary_repetition_one_time
    RBNF[?q]*1
  end

  def binary_repetition_zero_times
    RBNF[?q]*0
  end
end

Graham.pp(Repetition) do |that|
  that.a_binary_repetition.is_such_that {
    match('AAAG') and
    [?g,'AG','AAAAAAG'].none?  {|s| match s}}

  that.a_unary_repetition.is_such_that {
    ['','xyz','xyzxyz'].all? {|s| match s} and
    [?x,?y,?z,'zyx'].none? {|s| match s}}

  that.binary_repetition_one_time.is_such_that {
    match('q') and !match('') and !match('qq')}

  that.binary_repetition_zero_times.is_such_that {
    match('') and !match('q') }

end
