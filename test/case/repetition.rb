require 'rbnf'
class Repetition
  def binary_repetition
    RBNF[?A]*3+?G
  end
end

Graham.pp(Repetition) do |that|
  that.binary_repetition.is_such_that {
    self =~ 'G' and
    self =~ 'AAAG' and
    self =~ 'AAAAAAG'
  }.and_such_that {
    not self =~ '' and
    not self =~ 'AG' and
    not self =~ 'AAG'
  }
end
