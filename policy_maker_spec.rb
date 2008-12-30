require File.dirname(__FILE__) + '/sample_mesh.rb'

describe PolicyMaker do
  
  it "should add server peps" do
    PolicyMaker.instance.servers.size.should eql(3)
    names = PolicyMaker.instance.servers.collect { |pep| pep.name }
    names.include?('rush').should be_true
    names.include?('sinatra').should be_true
  end

  it "should add network sets"
  
end

  
