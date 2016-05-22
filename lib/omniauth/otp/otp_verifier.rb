module OmniAuth
  module Otp
    class Verifier

      attr_reader :otp

      def initialize otp
        @otp = otp
      end

      def verify(otp)
        response = get_response(otp)
        Result.new(otp, response)
      end

      def verify!(otp)
        result = verify(otp)
        raise OtpError, "Received error: #{result.status}" unless result.valid?
        result
      end

      private

      def get_response(otp)
        response = {success: true, otp: otp, status: "success"}
        response
      end

    end
  end
end