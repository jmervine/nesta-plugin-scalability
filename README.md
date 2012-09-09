# Nesta::Plugin::Scalability

Updates Nesta to save to both to Mongodb and the filesystem, so that Nesta can scale beyond a single server without NFS.

## Installation

Add this line to your application's Gemfile:

    gem 'nesta-plugin-scalability'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nesta-plugin-scalability

## Usage

This will work out of the box with a default mongodb install on the same machine. See below for advanced configuration.

        # file: config/config.yml
        # defaults are shown and used with configuration
        # is not present
        mongodb
          host: localhost
          port: 27017     
          database: nestacms 
          collection: nestacms
          # username: <USERNAME>
          # password: <PASSWORD>

#### Import CLI

Import is queued off of your mongo and content configurations in your config file. By default it uses 'config/config.yml', however, if you pass a file to it, it will use that for configuration instead.

    $ import 

    $ import ./config/custom_config.yml

> Note: This will only import files that don't exist and bypass anything that does. If you need to do a fresh import of all files, be sure to blow away your database first. 


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
