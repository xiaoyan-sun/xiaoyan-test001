#!/opt/puppetlabs/puppet/bin/ruby
#
# Puppet ENC
# it should be placed at /etc/puppetlabs/
# changelog
# load from json file
# change log file to /var/log/enc
require 'yaml'
require 'json'
require 'logger'
require 'date'
require 'net/http'
require 'base64'
require 'open-uri'

agent = ARGV[0].split('.')[0]
agent = agent + ".hft"
# mkdir /var/log/enc
# chown puppet:puppet /var/log/enc
logger = Logger.new('/var/log/enc/enc.log',10,1024000)
logger.debug "Start time: " + DateTime.now.strftime("%F %R %N")

#yaml = "---\nparameters:\n  resources: {}\nclasses:  { }\n"
default = '{}'
default = JSON.parse(default)
# Get Java API, normal exit and put empty enc_data if can't open url or parse from json
# because puppet master will fail when ENC return fails and agent will report error.
begin
  api_json = JSON.load(open('/etc/puppetlabs/nodes.json').read.gsub('\r\n',''))
  #if api_json['status'] == 'success'
  #  yaml = api_json['content']['data']
  #else
  #  abort api_json['message']
  #end
  yaml = api_json[agent]
  if yaml == nil 
	yaml = default
  end
rescue JSON::ParserError => e
  logger.error "#{agent}: parse json error. #{e.message}"
  logger.debug e.backtrace.join("\n")
rescue Exception => e
  logger.error "#{agent}: Get conf data error. #{e.message}"
  logger.debug e.backtrace.join("\n")
ensure
  logger.debug [agent,yaml].join(":")
  logger.debug "End time: " + DateTime.now.strftime("%F %R %N")
  puts YAML.dump(yaml)
end
