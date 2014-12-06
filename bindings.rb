require_relative './binding'
require_relative './partitions'
require_relative './warning'

module LawCheck
  # a consistent set of bindings
  class Bindings
    def initialize(partitions)
      @bindings = []
      @partitions = partitions
    end

    def binding_by_name(binding_name)
      @bindings.find { |binding| binding.name == binding_name }
    end

    def replace(old_binding, new_binding)
      @bindings = @bindings - [old_binding] + [new_binding]
    end

    def add(binding)
      if @partitions.valid_path?(binding.path)
        current_binding = binding_by_name(binding.name)
        if current_binding.nil?
          @bindings += [binding]
        else
          if @partitions.contradict?(binding.path, current_binding.path)
            warning('Contradiction between bindings',
                    "current: #{current_binding.path}",
                    "new: #{binding.path}")
          else
            if @partitions.superset?(superset_path: binding.path, set_path: current_binding.path)
              replace(current_binding, binding)
            else
              warning('The new binding is a superset of the current binding',
                      "current: #{current_binding.path}",
                      "new: #{binding.path}")
            end
          end
        end
      else
        warning('Invalid path:',
                binding.path)
      end

      self
    end
  end
end
