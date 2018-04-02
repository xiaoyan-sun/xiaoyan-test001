#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'yaml'

enc = {}
File.readlines('./nodes.csv').each do |line|
  next if line.start_with? "#"
  host,domain,model,res_type,res_name,attribute,value = line.strip.split("\t")
  if value and value.match(/^[\{\[].*[\}\]]$/)
    value = JSON.load value
  end
  host=host+"."+domain
  enc[host] ||= {
      'parameters'	=>	{
          'resources'	=>	{}
      },
      'classes'	=>	{

      }
  }
  if model == 'class'
    enc[host]['classes'][res_name] ||= {}
    if not attribute.is_a? NilClass and attribute != ''
      enc[host]['classes'][res_name][attribute] = value
    end
    if res_name == 'base' and not enc[host]['classes'][res_name].has_key? 'full_fqdn'
      enc[host]['classes'][res_name]['full_fqdn'] = host 
    end
  else
    enc[host]['parameters']['resources'][res_type] ||= {}
    enc[host]['parameters']['resources'][res_type][res_name] ||= {}
    enc[host]['parameters']['resources'][res_type][res_name][attribute] = value
  end
end

File.open('./nodes.json','w') do |f|
  f.write enc.to_json
end
puts enc.keys.map{|host| "#{host} generated"}.join("\n")
