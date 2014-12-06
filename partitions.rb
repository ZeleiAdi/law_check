require_relative './partition'
require_relative './path'

require_relative './warning'

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

    def create_toplevel(partition_name)
      @partitions += [Partition.new([partition_name], true)]
    end

    def create(partition, path)
      if path.empty?
        if @partitions.all? { |other_partition| partition.orthogonal? other_partition }
          @partitions += [partition]
        else
          warning('Nonorthogonal partition:', partition)
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

    def valid_path?(path)
      if path.empty?
        true
      else
        subset = partition_of_subset(path.first_name)
        if subset.nil?
          false
        else
          subset[path.first_name].valid_path?(path.rest_names)
        end
      end
    end

    # relies on the fact that path1 and path2 are both valid paths
    def contradict?(path1, path2)
      if path1.empty? or path2.empty?
        false
      else
        if path1.first_name == path2.first_name
          partitions_of_subset(path1.first_name).contradict?(path1.rest_names, path2.rest_names)
        else
          if partition_of_subset(path1.first_name) != partition_of_subset(path2.first_name)
            false
          else
            true
          end
        end
      end
    end

    # relies on the fact that superset_path and set_path are both valid paths
    def superset?(superset_path: superset_path, set_path: set_path)
      if set_path.empty?
        true
      else
        if superset_path.empty?
          false
        else
          if superset_path.first_name == set_path.first_name
            partitions_of_subset(superset_path.first_name).superset?(superset_path: superset_path.rest_names, set_path: set_path.rest_names)
          else
            false
          end
        end
      end
    end
  end
end
