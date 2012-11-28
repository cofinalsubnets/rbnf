class MatchTests
  def a_long_match
    +(RBNF[?a]*3)+?g =~ 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaag'
  end
end

Graham.pp(MatchTests) do |that|
#  that.a_long_match.is true
end
