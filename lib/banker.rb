require 'rubygems'
require 'bundler'

Bundler.setup

require 'active_support'
Dir["#{File.dirname(__FILE__)}/banker/adapters/*"].sort.each do |path|
  require "banker/adapters/#{File.basename(path)}/session"
end


module Banker

  def self.start_session(bank_name, credentials = nil)
    session_class_name = ActiveSupport::Inflector::camelize("banker/adapters/#{bank_name}/session")
    session_class = ActiveSupport::Inflector::constantize(session_class_name)
    session_class.new(credentials)
  end

end
