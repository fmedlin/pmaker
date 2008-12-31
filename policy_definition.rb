class PolicyDefinition
  attr_accessor :topology, :action
  attr_accessor :encrypt_alg, :encrypt_key, :auth_alg, :auth_key
  
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
  
end