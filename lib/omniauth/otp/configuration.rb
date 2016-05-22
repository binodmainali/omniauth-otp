module OmniAuth
  module Otp
    class Configuration
      attr_accessor :application_key, :secret_key

      def initialize
        @application_key = nil
        @secret_key = nil
      end
    end
  end
end