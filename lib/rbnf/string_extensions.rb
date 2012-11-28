module RBNF
  module StringExtensions
    def heads
      Enumerator.new do |y|
        y<<s=self
        while s=s.dup.chop!
          y<<s
        end
      end
    end
  end
  String.send :include, StringExtensions
end
