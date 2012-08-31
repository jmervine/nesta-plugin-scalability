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
  end
end
