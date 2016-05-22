module OmniAuth
  module Otp
    class PhoneNumber
      attr_accessor :phone, :otp

      def initialize
        @phone = nil
        @otp = nil
      end
    end
  end
end