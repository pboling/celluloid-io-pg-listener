require "celluloid-io-pg-listener/supervise_signature"

module CelluloidIOPGListener
  #
  # Usage:
  #
  #     config_path = options[:config_path] || "config/settings.yml"
  #     config_signature = CelluloidIOPGListener::SupervisionConfigurationSignature.new(path_to_yaml: config_path).signature
  #     supervision_config = Celluloid::Supervision::Configuration.define(*config_signature)
  #     supervision_config.deploy
  #
  class SupervisionConfigurationSignature
    include Celluloid::Internals::Logger

    attr_reader :yaml_config
    attr_reader :supervision_config

    def initialize(path_to_yaml: nil, yaml_hash: nil)
      @yaml_config = yaml_hash || YAML::load(ERB.new(File.read(path_to_yaml)).result)
      # config may be the whole yaml / hash, or it may be nested.
      # If nested it is value of the key "listening_group".
      @yaml_config = @yaml_config["listening_group"] if @yaml_config["listening_group"]
      unless @yaml_config.nil?
        @yaml_config = @yaml_config.dup # Don't want to mutate anything that was passed in
        @supervision_config = process_yaml_config
      end
    end

    # Returns an array like this:
    #   [
    #     {
    #         type: MyActor,
    #         as: :my_actor,
    #         args: []
    #     },
    #     {
    #         type: MyActor,
    #         as: :my_actor_with_args,
    #         args: [
    #                 :one_arg,
    #                 :two_args
    #               ]
    #     },
    #   ]
    def signature
      supervision_config
    end

    private

    def process_yaml_config
      yaml_config.inject([]) do |config_array, listener_config|
        debug "listener_config: #{listener_config}"
        if listener_config.delete("listener_active")
          config_array << CelluloidIOPGListener::SuperviseSignature.new(
              type: listener_config["type"],
              as: listener_config["as"],
              args: listener_config["args"]
          ).signature
          info "Listening to channel '#{listener_config["args"]["channel"]}' on database '#{listener_config["args"]["dbname"]}'..."
        else
          info "Listener not active for channel '#{listener_config["args"]["channel"]}' on database '#{listener_config["args"]["dbname"]}'..."
        end
        config_array
      end
    end
  end
end
