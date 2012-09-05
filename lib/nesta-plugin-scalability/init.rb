module Nesta
  module Plugin
    module Scalability
      module Helpers
        # If your plugin needs any helper methods, add them here...
      end
    end
  end

  class App
    helpers Nesta::Plugin::Scalability::Helpers

    configure do
      # configure mongodb connection
      mdb_params = []

      mdb_params.push Config.mongodb["host"] if Config.mongodb.has_key? "host"
      mdb_params.push Config.mongodb["port"] if Config.mongodb.has_key? "port"

      mdb_database_name   = (Config.mongodb.has_key?("database") ? Config.mongodb["database"] : "nestacms")
      mdb_collection_name = (Config.mongodb.has_key?("collection") ? Config.mongodb["collection"] : "nestacms")

      mdb = if mdb_params.empty?
              Mongo::Connection.new.db(mdb_database_name)
            else
              Mongo::Connection.new(*mdb_params).db(mdb_database_name)
            end

      if Config.mongdb.has_key?("username") and Config.mongodb.has_key?("password")
        mdb.authenticate(Config.mongodb["username"], Config.mongodb["password"])
      end

      $mongodb = mdb.collection(mdb_collection_name)
    end
  end

  class Config
    #
    # Config.mongodb.should eq Hash
    # Config.mongodb.keys
    #   - host       -- default "localhost"
    #   - port       -- default 27017
    #   - database   -- default "nestacms"
    #   - collection -- default "nestacms"
    #   - username   -- optional 
    #   - password   -- optional
    #
    #   attempt auth if user && pass
    #
    @settings += %w[ mongodb ]
  end

  class FileModel
    # using File.mtime over File.stat(file).mtime, as it's easier to 
    # override
    def last_modified
      @last_modified ||= $mongodb.find("_id" => @filename).first['mtime']
    rescue
      @last_modified ||= File.mtime(@filename)
    end
  end
end

