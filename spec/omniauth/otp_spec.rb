require 'spec_helper'

describe OmniAuth::Otp do

  before(:all) do
    OmniAuth::Otp.configure { |config| config.interval = 60 }
  end

  it 'has a version number' do
    expect(OmniAuth::Otp::VERSION).not_to be nil
  end

  describe "#configure" do

    it "should return the interval as 60" do
      interval = OmniAuth::Otp.configuration.interval
      expect(interval).to eq(60)
    end

    it "should take the new config for interval and set it" do
      OmniAuth::Otp.configure { |config| config.interval = 120 }
      interval = OmniAuth::Otp.configuration.interval
      expect(interval).to eq(120)
    end

    it "should return nil when phone is not set" do
      phone = OmniAuth::Otp.phone_number.phone
      expect(phone).to be_nil
    end

    it "should return nil when otp is not set" do
      phone = OmniAuth::Otp.phone_number.otp
      expect(phone).to be_nil
    end

    it "should return phone when phone is set" do
      number = "1234567890"
      OmniAuth::Otp.setup { |config| config.phone = number }
      phone = OmniAuth::Otp.phone_number.phone
      expect(phone).to_not be_nil
      expect(phone).to eq(number)
    end

    it "should return OTP when otp is set" do
      number = "123456"
      OmniAuth::Otp.setup { |config| config.otp = number }
      otp = OmniAuth::Otp.phone_number.otp
      expect(otp).to_not be_nil
      expect(otp).to eq(number)
    end

    it "should throw and error if secret key is nil" do
      expect{OmniAuth::Otp.generate_otp}.to raise_error(TypeError, "no implicit conversion of nil into String")
    end

    it "should return OTP when phone is set" do
       OmniAuth::Otp.configure { |config| config.secret_key = ROTP::Base32.random_base32 }
       number = "1234567890"
       OmniAuth::Otp.setup { |config| config.phone = number }
       otp = OmniAuth::Otp.generate_otp
       otp_length = otp.size
       expect(otp).to_not be_nil
       expect(otp_length).to eq(6)
    end
  end

  describe "#verify" do
    before(:each) do
      OmniAuth::Otp.configure { |config| config.secret_key = ROTP::Base32.random_base32 }
      number = "1234567890"
      OmniAuth::Otp.setup { |config| config.phone = number }
    end

    it "should verify OTP with correct phone number" do
      otp = OmniAuth::Otp.generate_otp
      OmniAuth::Otp.setup { |config| config.otp = otp }
      result = OmniAuth::Otp.verify
      expect(result).to eq(true)
    end

    it "should return false with different phone number" do
      otp = OmniAuth::Otp.generate_otp
      OmniAuth::Otp.setup { |config| config.otp = otp }
      OmniAuth::Otp.setup { |config| config.phone = "0987654321" }
      result = OmniAuth::Otp.verify
      expect(result).to eq(false)
    end
  end

end
