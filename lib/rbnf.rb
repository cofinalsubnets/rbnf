require 'rbnf/version'
require 'rbnf/nodes'
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
    @memo.has_key?(s) ? @memo[s] : (@memo[s] = match s)
  end

  def comps(s, e=heads(s))
    Enumerator.new {|y| e.each {|h| self=~h ? (y<<s.slice(h.size..-1)) : next}}
  end

  alias + cat
  alias / alt
  alias +@ rep
  alias * rep_n
  alias -@ opt
  alias - except
  alias [] =~

  private

  def ebnify(s)
    RBNF===s ? s : RBNF[s]
  end

  def heads(s)
    Enumerator.new {|y| (0..s.size).each {|i| y<<s.slice(0,i)}}
  end

  class << self
    def [](s)
      Term.new s
    end

    def define(sym,&b)
      DEFS[sym] = Def.new sym, (b.call rescue ->(s){b.call=~s})
    end

    def method_missing(sym,*as)
      DEFS.has_key?(sym) ? DEFS[sym] : super
    end
  end
end

