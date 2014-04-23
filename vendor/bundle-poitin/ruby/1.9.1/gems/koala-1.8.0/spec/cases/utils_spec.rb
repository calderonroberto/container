require 'spec_helper'

describe Koala::Utils do
  describe ".deprecate" do    
    before :each do
      # unstub deprecate so we can test it
      Koala::Utils.unstub(:deprecate)
    end
    
    it "has a deprecation prefix that includes the words Koala and deprecation" do
      Koala::Utils::DEPRECATION_PREFIX.should =~ /koala/i
      Koala::Utils::DEPRECATION_PREFIX.should =~ /deprecation/i      
    end
    
    it "prints a warning with Kernel.warn" do
      message = Time.now.to_s + rand.to_s
      Kernel.should_receive(:warn)
      Koala::Utils.deprecate(message)
    end

    it "prints the deprecation prefix and the warning" do
      message = Time.now.to_s + rand.to_s
      Kernel.should_receive(:warn).with(Koala::Utils::DEPRECATION_PREFIX + message)
      Koala::Utils.deprecate(message)
    end
    
    it "only prints each unique message once" do
      message = Time.now.to_s + rand.to_s
      Kernel.should_receive(:warn).once
      Koala::Utils.deprecate(message)
      Koala::Utils.deprecate(message)
    end
  end
  
  describe ".logger" do
    it "has an accessor for logger" do
      Koala::Utils.methods.map(&:to_sym).should include(:logger)
      Koala::Utils.methods.map(&:to_sym).should include(:logger=)
    end
    
    it "defaults to the standard ruby logger with level set to ERROR" do |variable|
      Koala::Utils.logger.should be_kind_of(Logger)
      Koala::Utils.logger.level.should == Logger::ERROR
    end
    
    logger_methods = [:debug, :info, :warn, :error, :fatal]
    
    logger_methods.each do |logger_method|
      it "should delegate #{logger_method} to the attached logger" do
        Koala::Utils.logger.should_receive(logger_method)
        Koala::Utils.send(logger_method, "Test #{logger_method} message")
      end
    end
  end
end