Swagger is a format for describing an API, and for then generating
clients and documentation from that description. But the information in
the Swagger schema also maps quite well to Puppet's concept of types, a
least for APIs which are well modelled on resources. This project allows
for autogenerating Puppet types and providers from a Swagger schema.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'puppet-swagger-generator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install puppet-swagger-generator

## Usage

```
puppet-swagger-generator --help
Usage:
    puppet-swagger-generator [OPTIONS]

Options:
    --namespace STRING            Namespace for the generated types
(default: $PUPPET_SWAGGER_NAMESPACE)
    --schema PATH                 Swagger Schema file (default:
$PUPPET_SWAGGER_SCHEMA)
    -h, --help                    print help
```

For generating types in the current folder you first need to download a
Swagger schema file. Once you have the json document you can point the
generator at it. The namespace attribute is used as the first part of
the type. For example:

    $ puppet-swagger-generator --namespace kubernetes --schema v1.json


## Notes

This has not been tested against many Swagger specifications, and is
unlikely to work unmodified (yet) in many cases. It's mainly been
developed around the
[garethr-kubernetes](https://github.com/garethr/garethr-kubernetes)
module which is probably the best place at the moment to see it in
action.


