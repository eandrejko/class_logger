require 'ruby-debug'
require File.dirname(__FILE__) << "/lib/has_own_logger.rb"
class ActiveRecord::Base
  include ClassLogger
end
