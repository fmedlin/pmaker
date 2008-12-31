require 'rubygems'
require 'spec'

require File.dirname(__FILE__) + '/sample_mesh.rb'

describe PolicyMaker, "with sample mesh policy" do
  
  before(:all) do
    @pmaker = PolicyMaker.instance
    @servers = @pmaker.servers
    @network_sets = @pmaker.network_sets
    @policy_defs = @pmaker.policy_definitions
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
  
  it "should understand subnet definition in network sets"
  
  it "should add policy definitions" do
    @policy_defs.size.should equal(4)
  end
  
  it "should create encrypt, drop and clear policies" do
    encrypt_policy = @policy_defs.select { |p| p.encrypt? }
    encrypt_policy.size.should equal(1)

    drop_policy = @policy_defs.select { |p| p.drop? }
    drop_policy.size.should equal(1)

    pass_policy = @policy_defs.select { |p| p.pass? }
    pass_policy.size.should equal(2)
  end
  
  it "should create server pep encryption policies" do
    pep_policy = @policy_defs.first
    pep_policy.topology.should == 'mesh'
    pep_policy.encrypt_alg.should == 'aes'
    pep_policy.auth_alg.should == 'sha1'
  end
  
  it "should generate encrypt policies for each server pep only" do
    policy = @pmaker.policy_for('rush')
    policy.should_not be_nil
    policy.instance_of?(PepPolicy).should be_true
  end
  
  it "should generate drop policies for each server pep only"
  
  it "should generate clear policies for each server pep only"
  
  it "should create policy files for each server pep"
  
end

  
