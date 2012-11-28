module RBNF
  class Matcher < Proc

    def cat(form)
      Matcher.new {|s| comps(s).any? {|c| form[c]}}
    end

    def except(form)
      Matcher.new {|s| self[s] && !form[s]}
    end

    def alt(form)
      Matcher.new {|s| self[s] || form[s]}
    end

    def opt
      Matcher.new {|s| s.empty? || self[s]}
    end

    def rep
      Matcher.new do |s|
        s.empty?  || self[s] || comps(s).select { |c| rep[c] }.any?
      end
    end

    def rep_(n)
      if    n == 0
        Matcher.new {|s| s.empty? }
      elsif n == 1
        self
      elsif Integer===n and n>1
        Matcher.new do |s|
          (2..n).inject(self) {|m| m.cat self}[s]
        end
      else
        raise ArgumentError, "can't repeat #{self} #{n} times"
      end
    end

    private

    def parts(s)
      (0..s.size-1).map {|i| s[0..i]}.push('').select {|h| self[h]}
    end

    def comps(s)
      parts(s).map {|p| s.sub p, ''}
    end
  end
end

