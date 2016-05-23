require 'omniauth/otp/otp_error'
require 'rotp'
require 'base32'

module OmniAuth
  module Otp
    module OtpGenerator

      def build_otp_code phone
        @interval = OmniAuth::Otp.configuration.interval
        @secret = OmniAuth::Otp.configuration.secret_key
        b32 = Base32.encode(phone + @secret).tr("=", "")
        otp = ROTP::TOTP.new(b32, {interval: @interval})
        otp.now
      end

      def verify_otp_code phone, otp
        return build_otp_code(phone) == otp
      end

    end
  end
end