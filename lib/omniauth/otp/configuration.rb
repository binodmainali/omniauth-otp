module OmniAuth
  module Otp
    class Configuration
      attr_accessor :application_key, :secret_key, :interval

      def initialize
        @application_key = nil
        @secret_key = nil
        @interval = nil
      end
    end
  end
end