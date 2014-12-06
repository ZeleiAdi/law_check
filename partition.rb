require_relative './partitions'
require_relative './path'

module LawCheck
  class Partition
    def initialize(subsets, complete)
      @subsets = {}
      subsets.each do |subset|
        @subsets[subset] = Partitions.new
      end

      @complete = complete
    end

    def complete?
      @complete
    end

    def include?(subset_name)
      @subsets.include? subset_name
    end

    def joint?(other_partition)
      @subsets.any? { |subset| other_partition.include? subset }
    end

    def [](subset_name)
      @subsets[subset_name]
    end

    def orthogonal?(other_partition)
      not joint?(other_partition)
    end

    def self.===(raw_expression)
      raw_expression.include? 'partition'
    end

    def self.parse_path(raw_expression)
      Path.parse raw_expression['partition']
    end

    def self.parse(raw_expression)
      new(raw_expression['partition']['subsets'],
          raw_expression['partition']['complete'])
    end
  end
end
