module Trb
  module Step
    class SanitizeParams
      def self.call(options, params:, **)
        options[:params] = params.to_unsafe_h.symbolize_keys

        true
      end
    end
  end
end
