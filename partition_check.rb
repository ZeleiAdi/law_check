class Partition
  def initialize(set: set, subsets: subsets, complete: complete)
    @set = set
    @subsets = subsets
    @complete = complete
  end

  def self.parse(raw_expression)
    self.new(set: raw_expression['partition']['set'], subsets: raw_expression['partition']['subsets'], complete: raw_expression['partition']['complete'])
  end

  def self.===(raw_expression)
    raw_expression['partition']
  end
end

def parse(raw_expressions)
  raw_expressions.each do |raw_expression|
    case raw_expression
    when Partition
      Partition.parse(raw_expression)
    end
  end
end

require 'json'

expressions = parse(JSON.parse(File.read(ARGV[0])))
