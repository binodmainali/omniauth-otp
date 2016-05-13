require 'omniauth'

module OmniAuth
  module Strategies
    class Otp
      include OmniAuth::Strategy
      option :fields, [:otp]
      option :uid_field, :otp

      attr_accessor :otp

      def request_phase
        if env["REQUEST_METHOD"] == "GET"
          get_credentials
        else
          perform
        end
      end

      private

      def get_credentials
        form = OmniAuth::Form.new(:title => "User Info", :url => callback_path)
        options.fields.each do |field|
          form.text_field field.to_s.capitalize.gsub("_", " "), field.to_s
        end
        form.button "Sign In"
        form.to_response
      end

      def otp
        request["otp"]
      end

      def perform
        verifier = OmniAuth::Otp::Verifier.new(options.otp)
        result = verifier.verify!(otp)

        self.otp = result.id

        env["omniauth.auth"] = auth_hash
        env["omniauth.otp"] = result
        env["REQUEST_METHOD"] = "GET"
        env["PATH_INFO"] = "#{OmniAuth.config.path_prefix}/#{name.to_s}/callback"

        call_app!
      rescue OmniAuth::Otp::OtpError => e
        fail!(:invalid_credentials, e)
      end

      def callback_phase
        fail!(:invalid_credentials)
      end

      uid do
        otp
      end

    end
  end
end