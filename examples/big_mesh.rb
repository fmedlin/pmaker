require 'policy_maker'

# server definitions
elvis = server_pep 'elvis', '192.168.2.121'
sinatra = server_pep 'sinatra', '192.168.2.122'

# network set definitions
ns1 = network_set elvis
ns2 = network_set sinatra
ns3 = network_set '10.10.102.0/24'                   # 253 hosts
ns4 = network_set '10.10.103.0/24'                   # 253 hosts
ns5 = network_set '10.10.104.0/24'                   # 253 hosts
ns6 = network_set '10.10.105.0/24'                   # 253 hosts

policy_mesh 'encrypt',
  { :encrypt_alg => 'aes',
    :encrypt_key => '29dc32fad62af71e99e730b4115cb563',
    :auth_alg => 'hmac-sha1',
    :auth_key => 'c9cd510dced1aa66fede4481eb5e62f60596fd85',
	  :network_sets => [ns1, ns2, ns3, ns4, ns5, ns6] }

generate_solaris_policies # policy files are only generated for defined server peps
