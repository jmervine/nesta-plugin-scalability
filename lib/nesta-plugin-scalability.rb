require "nesta-plugin-scalability/version"
require 'stringio'
require "mongo"

 Nesta::Plugin.register(__FILE__)

# update to create mongo entry as file with the following fields:
#
# _id == "file path"
# mtime == created/updated at 
# body == file contents
#

module FileTest
  def self.exist? file 
    if $mongodb.find("_id" => file).size == 0
      true
    else
      super 
    end
  end

  def self.exists? file
    self.exist? file
  end
end

class File
  def self.open *args
    raise unless args.size == 1 or args[1] == 'r'
    return StringIO.new($mongodb.find("_id" => args.first).first['body']) 
  rescue
    super
  end

  def self.mtime file
    FileTest.mtime(file)
  end
end
