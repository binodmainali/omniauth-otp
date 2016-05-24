require 'omniauth/otp'
require 'omniauth/otp/configuration'
require 'omniauth/otp/phone_number'
require 'omniauth/otp/otp_generator'

module OmniAuth
  module Otp
    extend OmniAuth::Otp::OtpGenerator

    class << self
      attr_accessor :configuration, :phone_number
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.reset
      @configuration = Configuration.new
    end

    def self.configure
      yield(configuration)
    end

    def self.phone_number
      @phone ||= PhoneNumber.new
    end

    def self.reset_phone
      @phone = PhoneNumber.new
    end

    def self.setup
      yield(phone_number)
    end

    def self.generate_otp
      build_otp_code @phone.phone
    end

    def self.verify
      phone = @phone.phone
      otp = @phone.otp
      verify_otp_code phone, otp
    end
  end
end
