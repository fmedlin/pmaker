require 'ipaddr'

class ServerPep
  attr_accessor :name, :ip_addr
  
  def initialize(name, ip_addr)
    @name = name
    @ip_addr = IPAddr.new(ip_addr)
  end
end