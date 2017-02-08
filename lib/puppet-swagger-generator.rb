require 'json'
require 'erb'
require 'ostruct'
require 'fileutils'
require 'clamp'

require "puppet-swagger-generator/utils"
require "puppet-swagger-generator/case"

EXCLUDE_TYPES = []

ALWAYS_EXCLUDE_PROPERTIES = %w(kind apiVersion)
EXCLUDE_PROPERTIES = OpenStruct.new()

def format_for_type(name)
  name.gsub(/::/, '/').
  gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
  gsub(/([a-z\d])([A-Z])/,'\1_\2').
  tr("-", "_").
  downcase.split('.')[1]
end

def generate_type(name, model, namespace)
  generate(name, model, namespace, 'type')
end

def generate_provider(name, model, namespace)
  generate(name, model, namespace, 'provider')
end

def generate(name, model, namespace, thing)
  path = Puppet::Swagger::Generator::Utils.gem_libdir + "/templates/#{thing}.erb"
  template = ERB.new File.new(path).read
  vars = binding
  vars.local_variable_set(:name, name)
  vars.local_variable_set(:model, model)
  vars.local_variable_set(:type_exclusions, EXCLUDE_PROPERTIES)
  vars.local_variable_set(:all_exclusions, ALWAYS_EXCLUDE_PROPERTIES)
  vars.local_variable_set(:namespace, namespace)
  path = thing == 'provider' ? "lib/puppet/#{thing}/#{namespace}_#{name}" : "lib/puppet/#{thing}"
  FileUtils::mkdir_p path
  file = thing == 'provider' ? "#{path}/swagger.rb" : "#{path}/#{namespace}_#{name}.rb"
  begin
    File.write(file, template.result(vars))
  rescue NoMethodError => e
    puts "issue with processing #{file}: #{e.message}"
  end
end

def copy_helpers
  path = 'lib/puppet_x/puppetlabs/'
  FileUtils::mkdir_p path
  FileUtils::cp_r(
    Puppet::Swagger::Generator::Utils.gem_libdir + '/files/swagger/',
    path
  )
end

module Puppet
  module Swagger
    module Generator
      class Command < Clamp::Command
        option "--namespace", "STRING", "Namespace for the generated types", :environment_variable => "PUPPET_SWAGGER_NAMESPACE"
        option "--schema", "PATH", "Swagger Schema file", :environment_variable => "PUPPET_SWAGGER_SCHEMA"
        def execute
          signal_usage_error "Namespace is required" unless namespace
          signal_usage_error "Schema is required" unless schema
          signal_usage_error "Schema file must exist" unless File.file?(schema)
          file = File.read(schema)
          data = JSON.parse(file)

          data['models'].each do |name, model|
            formatted_name = format_for_type(name)
            unless EXCLUDE_TYPES.include? formatted_name
              generate_type(formatted_name, model, namespace)
              generate_provider(formatted_name, model, namespace)
            end
          end
        end
        copy_helpers
      end
    end
  end
end
