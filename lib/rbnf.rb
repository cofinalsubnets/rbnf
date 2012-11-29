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

  def comps(s, e=heads(s)) #:nodoc:
    Enumerator.new {|y| e.each {|h| self=~h ? (y<<s.slice(h.size..-1)) : next}}
  end

  alias + cat
  alias / alt
  alias +@ rep
  alias * rep_n
  alias -@ opt
  alias - except
  alias [] =~ #:nodoc:

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

    # Takes a symbol <name> and a block and defines a new form <name> to be
    # the contents of the block. Note that this method can't handle recursive
    # form definition; use ::define for that instead.
    def def(name)
      DEFS[name] = Def.new(name, yield)
    end

    # Takes a symbol <name> and a block and defines a new form <name> to be
    # the contents of the block. In contrast to ::def this method can handle
    # recursive definition, at the cost of building a new AST each time a
    # match is attempted on the new form.
    def define(name,&b)
      DEFS[name] = Def.new name, ->(s){b.call=~s}
    end

    # Empties the memos of all defined (with ::def or ::define) forms.
    def dememoize
      DEFS.values.each {|v| v.instance_variable_set :@memo, {}}
    end

    def method_missing(sym,*as)
      DEFS.has_key?(sym) ? DEFS[sym] : super
    end
  end
end

