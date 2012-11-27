$LOAD_PATH << File.dirname(__FILE__)
module EBNF
  autoload :Matcher, 'ebnf/matcher'

  def opt
    Optate.new self
  end

  def cat(f)
    Catenate.new self, ebnify(f)
  end

  def alt(f)
    Alternate.new self, ebnify(f)
  end

  def except(f)
    Except.new self, ebnify(f)
  end

  def rep(n=nil)
    Repeat.new self
  end

  def group
    Group.new self
  end

  def match(p)
    matcher[p]
  end

  alias + cat
  alias / alt
  alias +@ rep
  alias * rep
  alias -@ opt
  alias - except
  alias =~ match

  private

  def ebnify(s)
    EBNF===s ? s : EBNF[s]
  end

  class << self
    def new(s)
      Terminal.new s
    end
    alias [] new
  end

  
  class Unary
    include EBNF
    attr_reader :a
    def initialize(a)
      @a=a
    end
  end

  class Binary
    include EBNF
    attr_reader :a,:b
    def initialize(a,b)
      @a,@b=a,b
    end
  end

  class Alternate < Binary
    def to_s
      "#{a} | #{b}"
    end
    def matcher
      a.matcher.alt b.matcher
    end
  end

  class Catenate < Binary
    def to_s
      "#{a} , #{b}"
    end
    def matcher
      a.matcher.cat b.matcher
    end
  end

  class Optate < Unary
    def to_s
      "[ #{a} ]"
    end
    def matcher
      a.matcher.opt
    end
  end

  class Group < Unary
    def to_s
      "( #{a} )"
    end
    def matcher
      a.matcher
    end
  end

  class Except < Binary
    def to_s
      "( #{a} - #{b} )"
    end
    def matcher
      a.matcher.except b.matcher
    end
  end

  class Repeat < Unary
    def to_s
      "{ #{a} }"
    end

    def matcher
      a.matcher.rep
    end
  end

  class Terminal < Unary
    def to_s
      "\"#{a}\""
    end

    def matcher
      Matcher.new {|s| s==a}
    end
  end

end
