require 'singleton'
require File.dirname(__FILE__) + '/server_pep.rb'
require File.dirname(__FILE__) + '/network_set.rb'
require File.dirname(__FILE__) + '/policy_definition.rb'
require File.dirname(__FILE__) + '/pep_policy.rb'

class PolicyMaker
  include Singleton
  
  attr_accessor :servers, :network_sets, :policy_definitions, :policies
  
  def initialize
    @servers = []
    @network_sets = []
    @policy_definitions = []
    @policies = Hash.new
  end

  def generate_solaris_policies
    generate_policies
    write_solaris_files
  end
  
  def write_solaris_files
  end
  
  def generate_policies
    @servers.each { |s| create_policy_for(s) }
  end
    
  def policy_for(server_name)
    @policies[server_name]
  end
  
  protected
  
  def create_policy_for(server)
    @policies[server.name] = PepPolicy.new
  end
    
end

# dsl helpers

def server_pep(name, ipaddr)
  pep = ServerPep.new(name, ipaddr)
  PolicyMaker.instance.servers << pep
  return pep
end

def network_set(network_or_ip)
  ns = NetworkSet.new(network_or_ip)
  PolicyMaker.instance.network_sets << ns
  return ns
end

def network_set_range(start_ip, end_ip)
  ns = NetworkSet.new(start_ip, end_ip)
  PolicyMaker.instance.network_sets << ns
  return ns
end

def policy_mesh(mesh_type, options)
  PolicyMaker.instance.policy_definitions << PolicyDefinition.new('mesh', mesh_type, options)
end

def generate_solaris_policies
  PolicyMaker.instance.generate_solaris_policies
end

