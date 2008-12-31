require 'singleton'
require File.dirname(__FILE__) + '/server_pep.rb'
require File.dirname(__FILE__) + '/network_set.rb'
require File.dirname(__FILE__) + '/policy.rb'

class PolicyMaker
  include Singleton
  
  attr_accessor :servers, :network_sets, :policies
  
  def initialize
    @servers = []
    @network_sets = []
    @policies = []
  end
    
end

# dsl helpers

def server_pep(ipaddr)
  pep = ServerPep.new(ipaddr)
  PolicyMaker.instance.servers << pep
  return pep
end

def network_set(network)
  ns = NetworkSet.new(network)
  PolicyMaker.instance.network_sets << ns
  return ns
end

def policy_mesh(mesh_type, options)
  PolicyMaker.instance.policies << Policy.new('mesh', mesh_type, options)
end

