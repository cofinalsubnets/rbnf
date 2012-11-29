module RBNF
  
  class Unary
    include RBNF
    attr_reader :a
    def initialize(a)
      @a,@memo=a,{}
    end
  end

  class Binary
    include RBNF
    attr_reader :a,:b
    def initialize(a,b)
      @a,@b,@memo=a,b,{}
    end
  end

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
      a.comps(s).any? {|c| b=~c}
    end
  end

  class Opt < Unary
    def to_s
      "[ #{a} ]"
    end
    def match(s)
      s.empty? or a=~s
    end
  end

  class Group < Unary
    def to_s
      "( #{a} )"
    end
    def match(s)
      a=~s
    end
  end

  class Except < Binary
    def to_s
      "( #{a} - #{b} )"
    end
    def match(s)
      a=~s && !b=~s
    end
  end

  class Rep < Unary
    def to_s
      "{ #{a} }"
    end
    def match(s)
      s.empty? or a.comps(s).any? {|c| self=~c}
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
        (2..b).inject(a) {|r| r.cat a}=~s
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

