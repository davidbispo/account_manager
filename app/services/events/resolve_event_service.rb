module Services
  module Domain
    class ResolveEventService
      attr_reader :event_type, :params

      def initialize(params)
        @event_type = params["event_type"]
        @params = params.except("event_type")
      end

      def resolve
        Strategies::EventProcessorStrategy.descendants.each do |strategy|
          if strategy.should_run_for?(event_type)
            return strategy.new(params).resolve.response
          end
        end
      end
      
    end
  end
end