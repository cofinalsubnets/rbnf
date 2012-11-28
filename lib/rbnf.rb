require 'rbnf/version'
module RBNF
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
    RepN.new self, n
  end

  def group
    Group.new self
  end

  def =~(s)
    match s
  end

  def parts(s)
    (0..s.size-1).map {|i| s[0..i]}.push('').select {|h| match h}
  end

  def comps(s)
    parts(s).map {|p| s.sub p, ''}
  end

  alias + cat
  alias / alt
  alias +@ rep
  alias * rep_n
  alias -@ opt
  alias - except

  private

  def ebnify(s)
    RBNF===s ? s : RBNF[s]
  end

  class << self
    def [](s)
      Term.new s
    end

    def define(sym,&b)
      DEFS[sym] = Def.new sym, ->(s){b.call =~ s}
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
    def match(s)
      a.match(s) or b.match(s)
    end
  end

  class Def < Binary
    def to_s
      "#{a}"
    end
    def match(s)
      b[s]
    end
  end

  class Cat < Binary
    def to_s
      "#{a} , #{b}"
    end
    def match(s)
      a.comps(s).any? {|c| b.match c}
    end
  end

  class Opt < Unary
    def to_s
      "[ #{a} ]"
    end
    def match(s)
      s.empty? or a.match(s)
    end
  end

  class Group < Unary
    def to_s
      "( #{a} )"
    end
    def match(s)
      a.match s
    end
  end

  class Except < Binary
    def to_s
      "( #{a} - #{b} )"
    end
    def match(s)
      a.match(s) and not b.match(s)
    end
  end

  class Rep < Unary
    def to_s
      "{ #{a} }"
    end
    def match(s)
      s.empty? or a.comps(s).select {|c| match c}.any?
    end
  end

  class RepN < Binary
    def to_s
      "#{b} * #{a}"
    end
    def match(s)
      if b==0
        s.empty?
      elsif Integer===b and b>0
        (2..b).inject(a) {|r| r.cat a}.match s
      else
        raise ArgumentError, "can't repeat #{a} #{b} times"
      end
    end
  end

  class Term < Unary
    def to_s
      "\"#{a}\""
    end
    def match(s)
      s==a
    end
  end
end

