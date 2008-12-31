require 'singleton'
require File.dirname(__FILE__) + '/server_pep.rb'
require File.dirname(__FILE__) + '/network_set.rb'

class PolicyMaker
  include Singleton
  
  attr_accessor :servers, :network_sets
  
  def initialize
    @servers = []
    @network_sets = []
  end
    
end

# dsl helpers

def server_pep(ipaddr)
  pep = ServerPep.new(ipaddr)
  PolicyMaker.instance.servers << pep
  return pep
end

def network_set(network)
  PolicyMaker.instance.network_sets << NetworkSet.new(network)
end

def policy_mesh(mesh_type, options)
  mesh_type
end

