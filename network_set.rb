require 'server_pep'

class IPAddr
  def succ()
    return self.clone.set(@addr + 1)
  end
  
  def <=>(other)
    return @addr <=> other.to_i
  end
end

class NetworkSet
  attr_accessor :host_ip_addrs
  
  def initialize(start_ip, end_ip=nil)
    @host_ip_addrs = []
    
    if end_ip
      init_range(start_ip, end_ip)
    elsif is_subnet?(start_ip)
      init_subnet(start_ip)
    else
      if start_ip.instance_of?(ServerPep)
        @host_ip_addrs << start_ip.ip_addr
      else
        @host_ip_addrs << IPAddr.new(start_ip)
      end
    end
  end
  
  def init_range(start_ip, end_ip)
    @host_ip_addrs = []
    (start_ip..end_ip).each do |ip|
      @host_ip_addrs << ip
    end
  end
  
  def init_subnet(subnet)
    mask = subnet.split('.')
    mask.delete_at(3)
    
    (1..253).each do |i|
      @host_ip_addrs << IPAddr.new(mask.join('.') + '.' + i.to_s)
    end
  end
  
  def is_subnet?(ip_addr)
    ip_addr.instance_of?(String) && ip_addr.split('/')[1].to_i == 24
  end
end