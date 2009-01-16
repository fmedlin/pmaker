require 'rubygems'
require 'spec'

require File.dirname(__FILE__) + '/spec_helper.rb'
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
    ipaddrs.include?(IPAddr.new('192.168.2.76')).should be_true
    ipaddrs.include?(IPAddr.new('192.168.2.121')).should be_true
  end  
  
  it "should create encrypt, drop and clear policies" do
    @policy_defs.select { |p| p.encrypt? }.size.should equal(1)
    @policy_defs.select { |p| p.drop? }.size.should equal(2)
    @policy_defs.select { |p| p.pass? }.size.should equal(2)
  end
  
  it "should create the correct encrypt options" do
    policy = @policy_defs.first
    policy.topology.should == 'mesh'
    policy.encrypt_alg.should == 'aes'
    policy.auth_alg.should == 'hmac-sha1'
  end
  
  it "should only generate policies for server peps" do
    @pmaker.policies.size.should equal(@servers.size)
    @pmaker.policy_for('unknown_server').should be_nil
  end
  
  it "should generate encrypt policies for server peps" do
    @sinatra_policy.instance_of?(PepPolicy).should be_true
    @sinatra_policy.encrypt_rules.size.should equal(4)
    @sinatra_policy.rules.first.src_ip.should == IPAddr.new('192.168.2.76')
    @sinatra_policy.rules.first.dst_ip.should == IPAddr.new('192.168.2.122')
  end
  
  it "should generate drop policies for server peps" do
    @sinatra_policy.drop_rules.size.should equal(2)
    @elvis_policy.drop_rules.size.should equal(10)
  end
  
  it "should generate clear policies for server peps" do
    @sinatra_policy.pass_rules.size.should equal(0)
  end
    
  # network sets
  describe "network sets" do
    
    it "should be created" do
      @network_sets.size.should equal(7)
    end

    it "should be created from server peps" do
      networks = @network_sets.collect { |ns| ns.host_ip_addrs }
      networks.flatten.include?(IPAddr.new('192.168.2.122')).should be_true
    end
    
    it "should understand single host addresses" do
      @pmaker.network_sets.first.host_ip_addrs.first.should == IPAddr.new('192.168.2.76')
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
    
    it "should be created" do
      @policy_defs.size.should equal(5)
    end

    it "should detect server peps" do
      @policy_defs.first.includes_server?(ServerPep.new('dont-care', '192.168.2.76')).should be_true
    end
    
  end
  
  # solaris ipsecconf
  describe "solaris ipsecconf files" do
    
    it "should be created for each server" do
      @servers.each do |s|
        File.exist?(s.name + '.ipsecconf').should be_true
      end
    end
    
    it "should have correct ipsecconf formatting" do
      contents_of_file('elvis.ipsecconf').length.should_not == 0
    end
    
  end
  
  # solaris ipseckey
  describe "solaris ipseckey files" do
    
    before(:all) do
      @elvis_ipseckey = contents_of_file('elvis.ipseckey')
    end
    
    it "should be created for each server" do
      @servers.each do |s|
        File.exist?(s.name + '.ipseckey').should be_true
      end
    end
    
    it "should have correct ipseckey formatting" do
      @elvis_ipseckey.length.should_not == 0
    end
    
    it "should generate spis" do
      @elvis_ipseckey.should include_match(/spi\s+0(x|X)(\d|[a-f])+/)
    end
        
  end
  
end

  
