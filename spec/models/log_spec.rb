require 'spec_helper'

describe Log do

  before do
    @log = Log.new(  controller: 'controller', 
                     method: 'method',                      
                     display_id: '1',
	 	     user_id: '2',
		     params: {one: "hello", two: "world" })
  end

  subject { @log }

  it { should respond_to(:controller) }
  it { should respond_to(:display_id) }
  it { should respond_to(:method) }
  it { should respond_to(:user_id) }
  it { should respond_to(:params) }
  it { should respond_to(:app_id) }
  it { should respond_to(:remote_ip) }

  it { should be_valid }

end
