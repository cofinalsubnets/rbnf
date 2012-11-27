$LOAD_PATH << File.dirname(__FILE__)
module RBNF
  autoload :Matcher, 'rbnf/matcher'
  DEFS = {}
  F = self

  def opt
    Opt.new self
  end

  def cat(f)
    Cat.new self, ebnify(f)
  end

  def alt(f)
    Alt.new self, ebnify(f)
  end

  def except(f)
    Except.new self, ebnify(f)
  end

  def rep(n=nil)
    Rep.new self
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
    RBNF===s ? s : RBNF[s]
  end

  class << self
    def new(s)
      Term.new s
    end
    alias [] new

    def define(sym,&b)
      DEFS[sym] = Def.new(sym, Matcher.new {|s| RBNF.instance_exec(&b) =~s})
    end

    def method_missing(sym)
      DEFS.has_key?(sym) ? DEFS[sym] : super
    end
  end
  
  class Unary
    include RBNF
    attr_reader :a
    def initialize(a)
      @a=a
    end
  end

  class Binary
    include RBNF
    attr_reader :a,:b
    def initialize(a,b)
      @a,@b=a,b
    end
  end

  class Alt < Binary
    def to_s
      "#{a} | #{b}"
    end
    def matcher
      a.matcher.alt b.matcher
    end
  end

  class Def < Binary
    def to_s
      "#{a}"
    end
    def matcher
      b
    end
  end

  class Cat < Binary
    def to_s
      "#{a} , #{b}"
    end
    def matcher
      a.matcher.cat b.matcher
    end
  end

  class Opt < Unary
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

  class Rep < Unary
    def to_s
      "{ #{a} }"
    end

    def matcher
      a.matcher.rep
    end
  end

  class Term < Unary
    def to_s
      "\"#{a}\""
    end

    def matcher
      Matcher.new {|s| s==a}
    end
  end

end
