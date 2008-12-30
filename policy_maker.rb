require 'singleton'
require File.dirname(__FILE__) + '/server_pep.rb'

class PolicyMaker
  include Singleton
  
  attr_accessor :servers
  
  def initialize
    @servers = []
  end
    
end

# dsl helpers

def server_pep(name_or_ip)
  PolicyMaker.instance.servers << ServerPep.new(name_or_ip)
end

def network_set(network)
  network
end

def policy_mesh(mesh_type, options)
  mesh_type
end

