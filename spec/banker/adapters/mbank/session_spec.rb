require 'spec_helper'

describe Banker::Adapters::Mbank::Session do
  subject { Banker::Adapters::Mbank::Session.new }
  it { should respond_to(:open) }
  it { should respond_to(:close) }
  
  describe "#open" do
    before :all do
      @valid_credentials = {:username => 'JohnDoe', :password => 'secret666'}
    end

    it "requires username parameter to be set" do
      invalid_credentials = @valid_credentials.dup.delete(:username)
      expect {
        subject.open(invalid_credentials)
      }.to raise_error
    end
    it "requires password parameter to be set" do
      invalid_credentials = @valid_credentials.dup.delete(:password)
      expect {
        subject.open(invalid_credentials)
      }.to raise_error
    end

    it "raises an error if already opened" do
      subject.should_receive(:open?).and_return(true)
      expect {
        subject.open(@valid_credentials)
      }.to raise_error
    end

    context "credentials are well formed and session not opened" do
      before(:each) do
        subject.stub(:open?).and_return(true)
        @agent = stub('Mechanize')
        Mechanize.stub(:new).and_return(@agent)
        @agent.stub_chain(:page, :forms, :first)
        @login_form = stub('login_form')
        
      end


      it "raises an exception with message from mbank when credentials are invalid" do
        expect {
          subject.open(@valid_credentials)
        }.to raise_error
      end
    end
  end

end
