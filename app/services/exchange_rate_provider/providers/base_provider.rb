module ExchangeRateProvider
  module Providers
    class BaseProvider
      include Singleton

      def call(date: nil)
        raise NotImplementedError, "#{self.class} must implement #call"
      end
    end
  end
end
