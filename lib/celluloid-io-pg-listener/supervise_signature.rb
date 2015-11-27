module CelluloidIOPGListener
  # Usage:
  #
  #   Given a yaml config file of this format:
  #
  #     listening_group:
  #     -
  #       listener_active: <%= ENV["LISTENER_ACTIVE"] || false %>
  #       type: HerokuConnectListener::SalesforceAccountClient
  #       as: insert_client
  #       args:
  #         database_url: <%= ENV["DATABASE_URL"] %>
  #           redis_url: <%= ENV["REDISTOGO_URL"] || "redis://localhost:6379/" %>
  #         callback_method: notify_callback
  #         channel: <%= ENV["SCHEMA_NAME"] %>_account_insert
  #
  #   Create a Supervision Container such as:
  #
  #     class ListeningGroup < Celluloid::Supervision::Container
  #       config_path = options[:config_path] || "config/settings.yml"
  #       config      = YAML::load(ERB.new(File.read(config_path)).result)
  #       supervise CelluloidIOPGListener::SuperviseSignature.new(
  #                     type: config["type"],
  #                     as: config["as"],
  #                     args: config["args"]
  #                 ).signature
  #     end
  #
  #     ListeningGroup.run
  #
  class SuperviseSignature
    KEYS_WITH_SYMBOL_VALUES = %( callback_method )
    attr_reader :type
    attr_reader :as
    attr_reader :args

    def initialize(type:, as:, args:)
      @type = Kernel.const_get(type)
      @as = as.to_sym
      if has_database_url?(args)
        args.merge!(convert_database_url_to_hash(db_url: args.delete("database_url")))
      end
      @args = []
      @args << symbolize_keys(args)
    end

    def signature
      {
          type: type,
          as: as,
          args: args
      }
    end

    private

    def symbolize_key(key, value, hash)
      if KEYS_WITH_SYMBOL_VALUES.include?(key)
        hash[key.to_sym] = value.to_sym
      else
        hash[key.to_sym] = value
      end
    end
    def symbolize_keys(args)
      args.inject({}) do |memo, (key, value)|
        symbolize_key(key, value, memo)
        memo
      end
    end
    def has_database_url?(args)
      args.is_a?(Hash) && !args["database_url"].nil?
    end

    # returns a hash of connection info extracted from the database url (as on Heroku)
    def convert_database_url_to_hash(db_url:)
      uri = URI.parse(db_url)
      connection_info = {}
      connection_info["dbname"]   = (uri.path || "").split("/")[1]
      connection_info["user"]     = uri.user
      connection_info["password"] = uri.password
      connection_info["host"]     = uri.host
      connection_info["port"]     = uri.port
      connection_info
    end
  end
end
