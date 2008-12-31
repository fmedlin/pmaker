require File.dirname(__FILE__) + '/sample_mesh.rb'

require 'rubygems'
require 'spec'

describe PolicyMaker do
  
  before(:all) do
    @pmaker = PolicyMaker.instance
    @servers = @pmaker.servers
    @network_sets = @pmaker.network_sets
  end
  
  it "should add server peps" do
    @servers.size.should equal(3)
    ipaddrs = @servers.collect { |pep| pep.ip_addr }
    ipaddrs.include?('192.168.1.1').should be_true
    ipaddrs.include?('192.168.1.3').should be_true
  end

  it "should add network sets" do
    @network_sets.size.should equal(7)
  end
  
  it "should create network sets from server peps" do
    networks = @network_sets.collect { |ns| ns.network }
    networks.include?('192.168.1.3').should be_true
  end
    
end

  
