require 'policy_rule'

class PepPolicy
  attr_accessor :rules
  
  def initialize
    @rules = []
  end
  
  def add_rule(direction, ip, ns_src, ns_dst, defs)
    @rules << PolicyRule.new
  end
end
