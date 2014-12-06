require_relative './path'

module LawCheck
  class Binding
    def initialize(name, path)
      @name = name
      @path = path
    end
    
    attr_reader :name, :path
    
    def contradict?(other_binding, partitions)
      true
    end
    
    def to_s
      "#{@name}: #{@path}"
    end

    def self.===(raw_expression)
      raw_expression['binding']
    end

    def self.parse(raw_expression)
      new(raw_expression['binding']['name'], Path.parse(raw_expression['binding']))
    end
  end
end
