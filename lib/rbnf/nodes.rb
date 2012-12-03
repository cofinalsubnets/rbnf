module RBNF
  
  # Unary AST node
  class Unary
    include RBNF
    attr_reader :a
    def initialize(a)
      @a,@memo=a,{}
    end
  end

  # Binary AST node
  class Binary
    include RBNF
    attr_reader :a,:b
    def initialize(a,b)
      @a,@b,@memo=a,b,{}
    end
  end

  # Alternation node
  class Alt < Binary
    def to_s
      "#{a} | #{b}"
    end
    def initialize(a,b)
      @memo={}
      @a,@b=[a,b].map {|e| Cat===e ? e.group : e}
    end
    def match(s)
      a=~s or b=~s
    end
  end

  # Node that encapsulates a defined (with RBNF::def or ::define) form.
  class Def < Binary
    def to_s
      "#{a}"
    end
    def match(s)
      b[s]
    end
  end

  # Catenation node
  class Cat < Binary
    def to_s
      "#{a} , #{b}"
    end
    def match(s)
      a.comps(s).any? {|c| b=~c}
    end
  end

  # Optation node
  class Opt < Unary
    def to_s
      "[ #{a} ]"
    end
    def match(s)
      s.empty? or a=~s
    end
  end

  # Grouping node. Semantically identical to its child, but greatly simplifies
  # stringification.
  class Group < Unary
    def to_s
      "( #{a} )"
    end
    def match(s)
      a=~s
    end
  end

  # Exception node
  class Except < Binary
    def to_s
      "( #{a} - #{b} )"
    end
    def match(s)
      a=~s && !b=~s
    end
  end

  # Repetition (0 or more times) node
  class Rep < Unary
    def to_s
      "{ #{a} }"
    end
    def match(s)
      s.empty? or a.comps(s).any? {|c| self=~c}
    end
  end

  # Repetition (n times) node
  class RepN < Binary
    def to_s
      "#{b} * #{a}"
    end
    def match(s)
      if b==0
        s.empty?
      elsif Integer===b and b>0
        (2..b).inject(a) {|r| r.cat a}=~s
      else
        raise ArgumentError, "can't repeat #{a} #{b} times"
      end
    end
  end

  # Terminal node
  class Term < Unary
    def to_s
      "\"#{a}\""
    end
    def match(s)
      s==a
    end
  end

end

