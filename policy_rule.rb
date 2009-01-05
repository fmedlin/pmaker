class PolicyRule
  attr_accessor :src_ip, :dst_ip, :policy_def
  
  def initialize(src_ip, dst_ip, policy_def)
    @src_ip = src_ip
    @dst_ip = dst_ip
    @policy_def = policy_def
  end
  
end