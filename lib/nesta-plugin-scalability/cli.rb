require 'mongo'
require 'date'
class CLI
  def initialize args
    confs = load_configuration(verify_args(args))
    files = get_file_list(confs[:content])
    mongo = get_mongo_connection(confs[:mongodb])

    files.each do |f|
      entry = mongo.find("_id" => f).to_a
      if entry.size == 0
        puts "[ import ] creating:: #{f}"
        mongo.insert( { "_id" => f, "body" => File.read(f), "mtime" => File.mtime(f) } )
      #else
        #unless entry.first["mtime"] > File.mtime(f)
          #puts "[ import ] updating:: #{f}"
          #mongo.update( { "_id" => f }, { "$set" => { "body" => File.read(f), "mtime" => File.mtime(f).utc } } )
        #end
      end
    end
  end

  private
  def verify_args args
    return "./config/config.yml" if args.nil? or args.empty?
    return args.first if File.exists?(args)
    usage
  rescue
    usage
  end

  def load_configuration file
    conf = YAML.load_file(file)
    {
      :content => (conf.has_key?("content") ? conf["content"] : "./content"),
      :mongodb => (conf.has_key?("mongodb") ? conf["mongodb"] : nil) 
    }
  end

  def get_file_list content
    files = Dir[ File.join( content, "**", "*" ) ].select do |f|
      (f =~ /mdown$/ or f =~ /haml$/ or f =~ /textile$/ or f =~ /txt$/)
    end
  end

  def get_mongo_connection conf
    begin
      # configure mongodb connection
      mdb_params = []

      mdb_params.push conf["host"] if conf.has_key?("host")
      mdb_params.push conf["port"] if conf.has_key?("port")

      mdb_database_name   = (conf.has_key?("database") ? conf["database"] : "nestacms")
      mdb_collection_name = (conf.has_key?("collection") ? conf["collection"] : "nestacms")

      mdb = if mdb_params.empty?
              Mongo::Connection.new.db(mdb_database_name)
            else
              Mongo::Connection.new(*mdb_params).db(mdb_database_name)
            end

      if Nesta::Config.mongdb.has_key?("username") and conf.has_key?("password")
        mdb.authenticate(conf["username"], conf["password"])
      end

      mongodb = mdb.collection(mdb_collection_name)
    rescue
      begin
        mongodb = Mongo::Connection.new.db('nestacms').collection('nestacms') 
      rescue
        puts "ERROR: could not open mongodb connection"
        exit 1
      end
    end
  end

  def usage
    puts "Usage: #{File.basename(__FILE__)} [CONFIG_FILE]"
    exit 0
  end
end
