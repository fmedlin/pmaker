require 'server_pep'

class NetworkSet
  attr_accessor :network
  
  def initialize(network)
    if network.instance_of?(ServerPep)
      @network = network.ip_addr
    else
      @network = network
    end
  end
end