module Strategies
  class EventProcessorStrategy

    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    def resolve
      raise NotImplementedError
    end

    def response
      raise NotImplementedError
    end
  end
end