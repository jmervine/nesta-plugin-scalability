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
    if args[1] and args[1] == 'w' and block_given?
      data = StringIO.new
      yield data

      if $mongodb.find("_id" => args.first).to_a.size == 1
        $mongodb.update( { "_id" => args.first }, { "$set" => { "body" => data.string, "mtime" => Time.now } } )
      else
        $mongodb.insert( { "_id" => args.first, "body" => data.string, "mtime" => Time.now } ) 
      end

      super

    else
      raise unless args.size == 1 or args[1] == 'r'
      return StringIO.new($mongodb.find("_id" => args.first).first['body']) 
    end
  rescue
    super
  end

  def self.delete file
    $mongodb.remove( { "_id" => file } )
  ensure
    # wow this is ugly, no "super" for File.delete
    # TODO: windows support, maybe?
    raise Errno::ENOENT.new(file) unless system("rm #{file}")
  end

  def self.last_modified file
    $mongodb.find("_id" => file).first['mtime']
  rescue
    File.mtime(file)
  end

end

