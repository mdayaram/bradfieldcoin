require "sinatra/base"
require "json"

module BradfieldCoin
  class Server < Sinatra::Base
    get "/peers/:client_id" do
      result = settings.chain_gossiper.peers_handler(client_id: params[:client_id])
      JSON.generate(result)
    end

    post "/gossip" do
      msg = JSON.parse(request.body.read, symbolize_names: true)
      result = settings.chain_gossiper.gossip_handler(msg)
      JSON.generate(result)
    end

    post "/transfer" do
      msg = JSON.parse(request.body.read, symbolize_names: true)
      result = settings.chain_gossiper.world_state.transfer(msg)

      # Blockchain changed, so add a new message to the gossiper
      settings.chain_gossiper.add_payload(settings.chain_gossiper.world_state.to_json)

      JSON.generate(result)
    end

    get "/public_key" do
      content_type "text/plain"
      settings.chain_gossiper.world_state.public_key
    end

    get "/" do
      content_type "text/plain"
      settings.chain_gossiper.to_s
    end
  end
end
