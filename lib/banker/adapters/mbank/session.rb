# encoding: utf-8

require 'banker/session/base'
require 'mechanize'

module Banker
module Adapters
module Mbank

class Session < Banker::Session::Base
  BASE_URI = 'https://www.mbank.com.pl/'
  PATHS = {
    :login => 'logon.aspx',
    :logout => 'logout.aspx',
    :accounts_list => 'accounts_list.aspx'
  }

  
  def open(credentials)
    raise "You need to provide +:username+ parameter" unless credentials[:username]
    raise "You need to provide +:password+ parameter" unless credentials[:password]
    raise "Session already opened" if open?
    @agent = Mechanize.new
    
    authenticate(credentials[:username], credentials[:password])
  end

  def open?
    if @agent.nil? 
      false
    else
      @agent.get(BASE_URI + PATHS[:accounts_list])
      @agent.page.at('.error.noSession').nil?
    end
  end 


  def close
    @agent.get(BASE_URI + PATHS[:logout])
  end

private
  def authenticate(username, password)
    @agent.get(BASE_URI + PATHS[:login])
    login_form = @agent.page.forms.first
    login_form.customer = username
    login_form.password = password
    login_form.submit
    if @agent.page.at('.error.noSession') != nil
      raise @agent.page.at('.message')
    end
    true
  end
end

end
end
end
