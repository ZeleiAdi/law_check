require_relative './partition'
require_relative './path'
module LawCheck
  # a consistent set of partitions
  class Partitions
    def initialize
      @partitions = []
    end

    def partition_of_subset(subset_name)
      @partitions.find { |partition| partition.include? subset_name }
    end

    def partitions_of_subset(subset_name)
      partition_of_subset(subset_name)[subset_name]
    end

    def include?(subset_name)
      @partitions.any? { |partition| partition.include? subset_name }
    end

    private def create_toplevel(partition_name)
      @partitions += [Partition.new([partition_name], true)]
    end

    def create(partition, path)
      if path.empty?
        if @partitions.all? { |other_partition| partition.orthogonal? other_partition }
          @partitions += [partition]
        else
          warn("Nonorthogonal partition: #{partition}")
        end
      else
        subset = partition_of_subset(path.first_name)
        if subset.nil?
          warn("Invalid path component: #{path}")
        else
          subset[path.first_name].create(partition, path.rest_names)
        end
      end
    end

    def add(partition, path)
      if path.toplevel?
        if not include? path.first_name
          create_toplevel(path.first_name)
        end
      end

      create(partition, path)

      self
    end
  end
end
