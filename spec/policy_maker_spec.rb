require 'rubygems'
require 'spec'

require File.dirname(__FILE__) + '/sample_mesh.rb'

describe PolicyMaker do
  
  before(:all) do
    @pmaker = PolicyMaker.instance
    @servers = @pmaker.servers
    @network_sets = @pmaker.network_sets
    @policy_defs = @pmaker.policy_definitions
    @sinatra_policy = @pmaker.policy_for('sinatra')
    @elvis_policy = @pmaker.policy_for('elvis')
  end
  
  it "should add server peps" do
    @servers.size.should equal(3)
    ipaddrs = @servers.collect { |pep| pep.ip_addr }
    ipaddrs.include?(IPAddr.new('192.168.1.1')).should be_true
    ipaddrs.include?(IPAddr.new('192.168.1.3')).should be_true
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
  
  it "should only create policies for server peps" do
    @pmaker.policies.size.should equal(@servers.size)
    @pmaker.policy_for('unknown_server').should be_nil
  end
  
  it "should generate encrypt policies for each server pep" do
    @sinatra_policy.instance_of?(PepPolicy).should be_true
    @sinatra_policy.encrypt_rules.size.should equal(4)
    @sinatra_policy.rules.first.src_ip.should == IPAddr.new('192.168.1.1')
    @sinatra_policy.rules.first.dst_ip.should == IPAddr.new('192.168.1.3')
  end
  
  it "should generate drop policies for each server pep only" do
    @sinatra_policy.drop_rules.size.should equal(4)
    @elvis_policy.drop_rules.size.should equal(4)
  end
  
  it "should generate clear policies for each server pep only" do
    @sinatra_policy.pass_rules.size.should equal(0)
  end
    
  # network sets
  describe "network sets" do
    
    it "should be created" do
      @network_sets.size.should equal(7)
    end

    it "should be created from server peps" do
      networks = @network_sets.collect { |ns| ns.host_ip_addrs }
      networks.flatten.include?(IPAddr.new('192.168.1.3')).should be_true
    end
    
    it "should understand single host addresses" do
      @pmaker.network_sets.first.host_ip_addrs.first.should == IPAddr.new('192.168.1.1')
    end
    
    it "should understand host address ranges in network sets" do
      @pmaker.network_sets[4].host_ip_addrs.size.should equal(5)
    end

    it "should understand subnets in network sets" do
      @pmaker.network_sets[5].host_ip_addrs.size.should equal(253)
    end
    
  end
  
  # policy definitions
  describe "policy definitions" do
    
    it "should detect server peps" do
      @policy_defs.first.includes_server?(ServerPep.new('dont-care', '192.168.1.1')).should be_true
    end
    
    it "should add policy definitions" do
      @policy_defs.size.should equal(4)
    end
  end
  
  # solaris ipsecconf
  describe "solaris ipsecconf files" do
    
    it "should be created for each server"
    
    it "should have correct ipsecconf formatting"
    
  end
  
  # solaris ipseckey
  describe "solaris ipseckey files" do
    
    it "should be created for each server"
    
    it "should have correct ipseckey formatting"
    
  end
  
end

  
