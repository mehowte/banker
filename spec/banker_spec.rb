require 'spec_helper'

describe Banker, "#start_session" do

  it "creates session of appropriate bank module and passes credentials to its constructor" do
    credentials = { :sample => 'credentials' }
    valid_bank_module_name = :valid_bank_module

    session_class_name, session_class, session_instance = stub, stub, stub

    ActiveSupport::Inflector::should_receive(:camelize).with("banker/adapters/#{valid_bank_module_name}/session").and_return(session_class_name)
    ActiveSupport::Inflector::should_receive(:constantize).with(session_class_name).and_return(session_class)

    session_class.should_receive(:new).with(credentials).and_return(session_instance)

    Banker.start_session(:valid_bank_module, credentials).should == session_instance
  end

  it "raises an error when nonexisting bank module name given" do
    ActiveSupport::Inflector::should_receive(:constantize).and_raise(NameError)
    expect { 
      Banker.start_session(:invalid_bank_module, {})
    }.to raise_error(NameError)
  end

end
