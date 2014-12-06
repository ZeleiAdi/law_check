module LawCheck
  class Binding
    def initialize(name, path)
      @name = name
      @path = path
    end

    def self.===(raw_expression)
      raw_expression['binding']
    end

    def self.parse(raw_expression)
      new(raw_expression['binding']['name'], raw_expression['binding']['path'])
    end
  end
end
