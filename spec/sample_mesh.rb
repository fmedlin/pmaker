require 'policy_maker'

# server definitions
rush = server_pep 'rush', '192.168.1.1'
elvis = server_pep 'elvis', '192.168.1.2'
sinatra = server_pep 'sinatra', '192.168.1.3'

# network set definitions
ns1 = network_set rush
ns2 = network_set elvis
ns3 = network_set sinatra
ns4 = network_set '10.10.100.1'
ns5 = network_set_range '10.10.101.1', '10.10.101.5'
ns6 = network_set '10.10.102.0/24' #only /24 networks are supported
ns_all = network_set '*'

# policies - policy files are only generated for defined servers
policy_mesh 'encrypt',
  { :encrypt_alg => 'aes',
    :encrypt_key => '0123456',
    :auth_alg => 'sha1',
    :auth_key => '987654',
	  :network_sets => [ns1, ns2, ns3] }

policy_mesh 'drop', { :network_sets => [ns1, ns2] }
policy_mesh 'pass', { :network_sets => [ns1, ns4] }
policy_mesh 'pass', { :network_sets => [ns2, ns_all] }

generate_solaris_policies

