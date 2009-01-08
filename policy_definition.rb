require 'server_pep'

class PolicyDefinition
  attr_accessor :topology, :action
  attr_accessor :encrypt_alg, :auth_alg
  attr_accessor :network_sets
  
  @@spi = 1
  
  def initialize(topology, action, options)
    @topology = topology
    @action = action
    options.each_pair { |k, v| instance_variable_set "@#{k}", v }
  end
  
  def encrypt?
    @action == 'encrypt'
  end

  def drop?
    @action == 'drop'
  end
  
  def pass?
    @action == 'pass'
  end

  def includes_server?(server)
    @network_sets.each do |ns|
      if ns.host_ip_addrs.include?(server.ip_addr)
        return true
      end
    end
    return false
  end
  
  def spi
    spi = (@@spi += 1).to_s(base=16)
    "0x#{spi}"
  end
  
  def auth_key
    'authkey'
  end

  def encrypt_key
    'encrkey'
  end
  
end