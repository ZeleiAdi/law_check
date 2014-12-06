require_relative './partition'
require_relative './partitions'

# require_relative './bindings'
require_relative './binding'
# require_relative './conditionals'
# require_relative './conditional'

module LawCheck
  class Expressions
    def self.parse(raw_expressions)
      partitions = Partitions.new
      raw_expressions.each do |raw_expression|
        case raw_expression
        when Partition
          p partitions.add(Partition.parse(raw_expression), Partition.parse_path(raw_expression))
        when Binding
          p Binding.parse(raw_expression)
        end
      end
    end
  end
end
