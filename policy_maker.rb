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
  
  def generate_policies
    @servers.each { |s| @policies[s.name] = [] }
  end
  
  def policy_for(server_name)
    @policies[server_name]
  end
    
end

# dsl helpers

def server_pep(name, ipaddr)
  pep = ServerPep.new(name, ipaddr)
  PolicyMaker.instance.servers << pep
  return pep
end

def network_set(network)
  ns = NetworkSet.new(network)
  PolicyMaker.instance.network_sets << ns
  return ns
end

def policy_mesh(mesh_type, options)
  PolicyMaker.instance.policy_definitions << PolicyDefinition.new('mesh', mesh_type, options)
end

def generate_policies
  PolicyMaker.instance.generate_policies
end

