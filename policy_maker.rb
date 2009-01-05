require 'singleton'
require File.dirname(__FILE__) + '/server_pep.rb'
require File.dirname(__FILE__) + '/network_set.rb'
require File.dirname(__FILE__) + '/policy_definition.rb'
require File.dirname(__FILE__) + '/pep_policy.rb'

class PolicyMaker
  include Singleton
  
  attr_accessor :servers, :network_sets, :policy_definitions, :policies
  
  def initialize
    @servers = []
    @network_sets = []
    @policy_definitions = []
    @policies = Hash.new
  end

  def generate_solaris_policies
    generate_policies
    write_solaris_policy_files
  end
  
  def write_solaris_policy_files
    @policies.each_pair do |server_name, policy|
      ipsecconf_filename = server_name + '.ipsecconf'
      ipseckey_filename = server_name + '.ipseckey'
      conf_file = File.new(ipsecconf_filename, File::CREAT|File::TRUNC|File::RDWR, 0644)
      key_file = File.new(ipseckey_filename, File::CREAT|File::TRUNC|File::RDWR, 0644)
    end      
  end
  
  def generate_policies
    @servers.each { |s| generate_policy_for(s) }
  end
    
  def policy_for(server_name)
    @policies[server_name]
  end
  
  protected
  
  def generate_policy_for(server)
    ip = server.ip_addr
    policy = PepPolicy.new
    defs = @policy_definitions.select { |p| p.includes_server?(server) }
    defs.each do |policy_def|
      policy_def.network_sets.each do |ns_src|
        direction = ns_src.includes_ip_addr(ip) ? 'from' : 'to'
        policy_def.network_sets.select { |ns| ns != ns_src }.each do |ns_dst|
          if ns_src.includes_ip_addr(ip) || ns_dst.includes_ip_addr(ip)
            policy.add_rule(direction, ip, ns_src, ns_dst, policy_def)
          end
        end
      end
    end
    
    @policies[server.name] = policy
  end
    
end

# dsl helpers

def server_pep(name, ipaddr)
  pep = ServerPep.new(name, ipaddr)
  PolicyMaker.instance.servers << pep
  return pep
end

def network_set(network_or_ip)
  ns = NetworkSet.new(network_or_ip)
  PolicyMaker.instance.network_sets << ns
  return ns
end

def network_set_range(start_ip, end_ip)
  ns = NetworkSet.new(start_ip, end_ip)
  PolicyMaker.instance.network_sets << ns
  return ns
end

def policy_mesh(mesh_type, options)
  PolicyMaker.instance.policy_definitions << PolicyDefinition.new('mesh', mesh_type, options)
end

def generate_solaris_policies
  PolicyMaker.instance.generate_solaris_policies
end

