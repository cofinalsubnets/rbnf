class StringTests
  def initialize
    @term = RBNF["string"]
  end

  def multiple_catenation
    (@term+'char'+'list').to_s
  end

  def multiple_alternation
    (@term/'char'/'list').to_s
  end

  def alternation_and_catenation
    (@term / 'opt' + @term / 'cat').to_s
  end

  def nested_repetition
    @term.rep.rep_n(3).to_s
  end

  def unary_repetition
    @term.rep.to_s
  end

  def binary_repetition
    @term.rep_n(3).to_s
  end

  def optation
    @term.opt.to_s
  end

  def a_definition
    RBNF.define(:symbol) do
      RBNF["string"]
    end.to_s
  end

  def terminal_string
    @term.to_s
  end

  def exception
    (@term/'integer' - 'float').to_s
  end

  def grouping
    (@term/@term).group.to_s
  end
  def implicit_grouping
    ((@term+@term)/@term).to_s
  end

end

Graham.pp(StringTests.new) do |that|
  that.a_definition.returns 'symbol'
  that.terminal_string.is '"string"'
  that.optation.returns '[ "string" ]'
  that.unary_repetition.returns '{ "string" }'
  that.binary_repetition.returns '3 * "string"'
  that.nested_repetition.returns '3 * { "string" }'
  that.alternation_and_catenation.returns '"string" | "opt" , "string" | "cat"'
  that.multiple_catenation.returns '"string" , "char" , "list"'
  that.multiple_alternation.returns '"string" | "char" | "list"'
  that.exception.returns '( "string" | "integer" - "float" )'
  that.grouping.returns '( "string" | "string" )'
  that.implicit_grouping.returns '( "string" , "string" ) | "string"'
end
