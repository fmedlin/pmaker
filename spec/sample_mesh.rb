require 'policy_maker'

# server definitions
rush = server_pep 'rush', '192.168.2.76'
elvis = server_pep 'elvis', '192.168.2.121'
sinatra = server_pep 'sinatra', '192.168.2.122'

# network set definitions
ns1 = network_set rush
ns2 = network_set elvis
ns3 = network_set sinatra
ns4 = network_set '10.10.100.1'                      # 1 host
ns5 = network_set_range '10.10.101.1', '10.10.101.5' # 4 hosts
ns6 = network_set '10.10.102.0/24'                   # 253 hosts
ns_all = network_set '*'

policy_mesh 'encrypt',
  { :encrypt_alg => 'aes',
    :encrypt_key => '29dc32fad62af71e99e730b4115cb563',
    :auth_alg => 'hmac-sha1',
    :auth_key => 'c9cd510dced1aa66fede4481eb5e62f60596fd85',
	  :network_sets => [ns1, ns2, ns3] }

policy_mesh 'drop', { :network_sets => [ns1, ns2, ns3] }
policy_mesh 'pass', { :network_sets => [ns1, ns4] }
policy_mesh 'pass', { :network_sets => [ns2, ns_all] }

generate_solaris_policies # policy files are only generated for defined server peps


