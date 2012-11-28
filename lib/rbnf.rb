require 'rbnf/version'
module RBNF
  autoload :Matcher, 'rbnf/matcher'
  DEFS = {}

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

  def rep
    Rep.new self
  end

  def rep_n(n)
    RepN.new(self, n).tap {|r| r.matcher}
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
  alias * rep_n
  alias -@ opt
  alias - except
  alias =~ match

  private

  def ebnify(s)
    RBNF===s ? s : RBNF[s]
  end

  class << self
    def [](s)
      Term.new s
    end

    def define(sym,&b)
      DEFS[sym] = Def.new(sym, Matcher.new {|s| b.call =~s})
      DEFS[sym].tap{|d| d.instance_variable_set :@a, "#{sym} = #{b.call} ;"}
    end

    def method_missing(sym,*as)
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
    def initialize(a,b)
      @a,@b=[a,b].map {|e| Cat===e ? e.group : e}
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

  class RepN < Binary
    def to_s
      "#{b} * #{a}"
    end
    def matcher
      a.matcher.rep_ b
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

