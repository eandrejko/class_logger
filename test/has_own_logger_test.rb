require File.dirname(__FILE__) + '/test_helper.rb'

class Email < ActiveRecord::Base
  has_own_logger :in => "vendor/plugins/class_based_logger/test/log"
end

class Bad < ActiveRecord::Base
  has_own_logger :in => "vendor/plugins/class_based_logger/test/nowhere"
end

class HasOwnLoggerTest < Test::Unit::TestCase
  
  def test_has_own_logger
    e = Email.new
    assert e.respond_to?(:log)
    assert Email.respond_to?(:class_logger)
  end
  
  def test_logging
    File.delete(File.dirname(__FILE__) + "/log/email.log")
    e = Email.new
    e.log("this is a test")
    f = IO.readlines(File.dirname(__FILE__) + "/log/email.log")[1]
    assert f =~ /this is a test/
  end
  
  def test_bad_directory
    assert_raises(RuntimeError) do
      e = Bad.new
      e.log("this is a test")
    end
  end
  
end