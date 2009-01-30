ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..'
require 'test/unit'
require File.expand_path(File.join(ENV['RAILS_ROOT'], 'config/environment.rb'))


require 'rubygems'

begin
  require 'sqlite'
rescue MissingSourceFile
  require 'sqlite3'
end

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :dbfile => "has_own_logger.sqlite.db"
)

ActiveRecord::Schema.define(:version => 0) do
  create_table :emails, :force => true do |t|
    t.string :subject
  end
  create_table :bads, :force => true do |t|
    t.string :subject
  end
end
