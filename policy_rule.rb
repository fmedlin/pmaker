class PolicyRule
  attr_accessor :src_ip, :dst_ip, :policy_def
  
  def initialize(src_ip, dst_ip, policy_def)
    @src_ip = src_ip
    @dst_ip = dst_ip
    @policy_def = policy_def
  end
  
  def print_solaris_conf
    if (policy_def.encrypt?)
      "{ local #{src_ip} remote #{dst_ip} } ipsec { encr_algs #{@policy_def.encrypt_alg} encr_auth_algs #{@policy_def.auth_alg} }\n"
    elsif (policy_def.drop?)
      "{ src #{src_ip} dst #{dst_ip} } drop {}\n"
    elsif (policy_def.pass?)
      "{ src #{src_ip} dst #{dst_ip} } permit {}\n"
    else
    end
  end
end