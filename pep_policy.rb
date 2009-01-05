require 'policy_rule'

class PepPolicy
  attr_accessor :rules
  
  def initialize
    @rules = []
  end
  
  def add_rule(direction, ip, ns_src, ns_dst, defs)
    ns = direction == 'from' ? ns_dst : ns_src
    if (direction == 'from')
      add_from_rule(ip, ns, defs)
    else
      add_to_rule(ip, ns, defs)
    end
  end
  
  def add_from_rule(ip, ns, defs)
    ns.host_ip_addrs.each do |hostip|
      add_ip_rule(ip, hostip, defs)
    end
  end

  def add_to_rule(ip, ns, defs)
    ns.host_ip_addrs.each do |hostip|
      add_ip_rule(hostip, ip, defs)
    end
  end
  
  def add_ip_rule(src, dst, defs)
    @rules << PolicyRule.new(src, dst, defs)
  end
  
  def drop_rules
    @rules.select { |r| r.policy_def.drop? }
  end

  def encrypt_rules
    @rules.select { |r| r.policy_def.encrypt? }
  end

  def pass_rules
    @rules.select { |r| r.policy_def.pass? }
  end
  
end
