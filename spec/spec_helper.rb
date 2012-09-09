require 'mongo'
require 'nesta'

require File.join File.dirname(__FILE__), "..", "lib", "nesta-plugin-scalability"

START_TIME = Time.now

# create a file without using File
# no in mongo
%x{
  test -e /tmp/rspec || mkdir /tmp/rspec;
  test -e /tmp/rspec/file1.mdown && rm -rf /tmp/rspec/file1.mdown; \
  echo "file1.mdown" > /tmp/rspec/file1.mdown
}

# configure mongodb connection
$mongodb = Mongo::Connection.new.db('rspec').collection('rspec')
$mongodb.remove

# setup some defaults in mongo
$mongodb.insert( { '_id' => '/tmp/rspec/mongo1.mdown', 'mtime' => Time.now, 'body' => 'mongo1.mdown body' } )

