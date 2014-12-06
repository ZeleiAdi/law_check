module LawCheck
  class Path
    def initialize(path)
      @path = path
    end
    
    def first_name
      first, *_ = @path
      first
    end

    def rest_names
      _, *rest = @path
      Path.new(rest)
    end

    def toplevel?
      rest_names.empty?
    end

    def empty?
      @path.empty?
    end

    def to_s
      @path.map { |name| '"' + name.to_s + '"' }.join(' ')
    end

    def self.parse(raw_expression)
      new(raw_expression['path'])
    end
  end
end
