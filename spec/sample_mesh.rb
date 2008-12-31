require 'policy_maker'

# server definitions
rush = server_pep '192.168.1.1'
elvis = server_pep '192.168.1.2'
sinatra = server_pep '192.168.1.3'

# network set definitions
ns1 = network_set rush
ns2 = network_set elvis
ns3 = network_set sinatra
ns4 = network_set '10.10.100.1'
ns5 = network_set '10.10.101.1-5' 
ns6 = network_set '10.10.102.0/24'
ns7 = network_set '10.10.103.0/24, 10.10.104.0/24'

# policies - policy files are only generated for defined servers
policy_mesh 'encrypt',
  { :encrypt_alg => 'aes',
    :auth_alg => 'sha1',
	  :network_sets => [ns1, ns2, ns3] }

policy_mesh 'drop', { :network_sets => [ns1, ns2, ns3] }
policy_mesh 'clear', { :network_sets => [ns1, ns4] }
policy_mesh 'clear', { :network_sets => [ns2, '*'] }

