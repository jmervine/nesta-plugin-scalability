module Nesta
  module Plugin
    module Scalability
      module Helpers
        # If your plugin needs any helper methods, add them here...
      end

      def self.init_mongodb
        # configure mongodb connection
        unless $mongodb
          mdb_params = []

          mdb_params.push Nesta::Config.mongodb["host"] if Nesta::Config.mongodb.has_key?("host")
          mdb_params.push Nesta::Config.mongodb["port"] if Nesta::Config.mongodb.has_key?("port")

          mdb_database_name   = (Nesta::Config.mongodb.has_key?("database") ? Nesta::Config.mongodb["database"] : "nestacms")
          mdb_collection_name = (Nesta::Config.mongodb.has_key?("collection") ? Nesta::Config.mongodb["collection"] : "nestacms")

          mdb = if mdb_params.empty?
                  Mongo::Connection.new.db(mdb_database_name)
                else
                  Mongo::Connection.new(*mdb_params).db(mdb_database_name)
                end

          if Nesta::Config.mongdb.has_key?("username") and Nesta::Config.mongodb.has_key?("password")
            mdb.authenticate(Nesta::Config.mongodb["username"], Nesta::Config.mongodb["password"])
          end

          $mongodb = mdb.collection(mdb_collection_name)
        end
      rescue
        $mongodb = Mongo::Connection.new.db('nestacms').collection('nestacms')
      end
    end
  end

  class App
    helpers Nesta::Plugin::Scalability::Helpers

    configure do
      Nesta::Plugin::Scalability.init_mongodb
    end
  end

  class Config
    #
    # Nesta::Config.mongodb.should eq Hash
    # Nesta::Config.mongodb.keys
    #   - host       -- default "localhost"
    #   - port       -- default 27017
    #   - database   -- default "nestacms"
    #   - collection -- default "nestacms"
    #   - username   -- optional 
    #   - password   -- optional
    #
    #   attempt auth if user && pass
    #
    @settings.push "mongodb"
  end

  class FileModel
    # using File.mtime over File.stat(file).mtime, as it's easier to 
    # override
    def last_modified
      @last_modified ||= File.last_modified(@filename)
    end
  end
end

