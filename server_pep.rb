class ServerPep
  attr_accessor :name, :ip_addr
  
  def initialize(name, ip_addr)
    @name = name
    @ip_addr = ip_addr
  end
end